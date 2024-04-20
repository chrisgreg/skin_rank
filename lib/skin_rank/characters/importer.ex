defmodule SkinRank.Characters.Importer do
  import Mogrify
  alias SkinRank.Characters.Character
  alias SkinRank.Repo

  defp read_json do
    path = "#{:code.priv_dir(:skin_rank)}/static/data/overwatch_character_skins.json"

    File.read!(path)
    |> Jason.decode!()
  end

  defp download_and_convert_image(url, name) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        png_file_path_to_save = "#{:code.priv_dir(:skin_rank)}/static/images/skins/#{name}.png"
        File.write(png_file_path_to_save, body)

        %Mogrify.Image{path: dir_to_save} =
          Mogrify.open(png_file_path_to_save)
          |> format("webp")
          |> save(in_place: true)

        File.rm(png_file_path_to_save)

        {:ok, dir_to_save}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def populate_db() do
    File.mkdir_p!("#{:code.priv_dir(:skin_rank)}/static/images/skins")

    read_json()
    |> Flow.from_enumerable()
    |> Flow.partition()
    |> Flow.map(fn {name, skins} ->
      skins = skins |> Map.get("skins")

      params = %{
        name: name,
        skins:
          Flow.from_enumerable(skins)
          |> Flow.partition()
          |> Flow.map(fn skin ->
            image_result =
              download_and_convert_image(skin["image"], "#{name}_#{skin["description"]}")

            case image_result do
              {:ok, file_path} ->
                %{
                  name: skin["description"],
                  image_url:
                    file_path
                    |> Path.relative_to(:code.priv_dir(:skin_rank))
                    |> String.replace_leading("static", ""),
                  event: skin["event"],
                  cost: skin["cost"]
                }

              {:error, _reason} ->
                %{
                  name: skin["description"],
                  image_url: nil,
                  event: skin["event"],
                  cost: skin["cost"]
                }
            end
          end)
          |> Enum.to_list()
      }

      Character.create_changeset(%Character{}, params)
      |> Repo.insert()
    end)
    |> Enum.to_list()
  end
end
