defmodule SkinRank.Characters.Importer do
  alias SkinRank.Characters.Character
  alias SkinRank.Repo

  defp read_json do
    path = "#{:code.priv_dir(:skin_rank)}/static/data/overwatch_character_skins.json"

    File.read!(path)
    |> Jason.decode!()
  end

  def populate_db() do
    read_json()
    |> Enum.map(fn {name, skins} ->
      skins = skins |> Map.get("skins")

      params = %{
        name: name,
        skins:
          Enum.map(skins, fn skin ->
            %{
              name: skin["description"],
              image_url: skin["image"],
              event: skin["event"],
              cost: skin["cost"]
            }
          end)
      }

      Character.create_changeset(%Character{}, params)
    end)
    |> Enum.each(&Repo.insert!/1)
  end
end
