defmodule SkinRank.Characters.Importer do
  alias SkinRank.Characters.Character
  alias SkinRank.Repo

  defp read_json do
    path = "#{:code.priv_dir(:skin_rank)}/static/data/overwatch_character_skins.json"

    File.read!(path)
    |> Jason.decode!()
  end

  defp download_image(url, name) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        dir_to_save = "#{:code.priv_dir(:skin_rank)}/static/images/skins/#{name}"
        File.write(dir_to_save, body)
        {:ok, dir_to_save}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, reason}
    end
  end

  def populate_db() do
    read_json()
    |> Enum.map(fn {name, skins} ->
      skins = skins |> Map.get("skins")

      # TODO: Parallelise
      params = %{
        name: name,
        skins:
          Enum.map(skins, fn skin ->
            image_result =
              download_image(skin["image"], "#{name}_#{skin["description"]}.png")

            case image_result do
              {:ok, file_path} ->
                %{
                  name: skin["description"],
                  image_url: file_path |> Path.relative_to(:code.priv_dir(:skin_rank)),
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
      }

      Character.create_changeset(%Character{}, params)
    end)
    |> Enum.each(&Repo.insert!/1)
  end

  # def remove_poor_path do
  #   import Ecto.Query

  #   query =
  #     from(c in SkinRank.Skins.Skin,
  #       update: [
  #         set: [
  #           image_url:
  #             fragment(
  #               "replace(?, '/Users/chris/projects/skin_rank/_build/dev/lib/skin_rank/priv/static', '')",
  #               c.image_url
  #             )
  #         ]
  #       ]
  #     )

  #   Repo.update_all(query, [])
  # end
end
