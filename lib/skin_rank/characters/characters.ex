defmodule SkinRank.Characters do
  alias SkinRank.Characters.Character
  alias SkinRank.Repo
  import Ecto.Query

  def all do
    from(c in Character, order_by: c.name)
    |> Repo.all()
    |> Repo.preload(skins: [votes: :skin])
    |> Enum.map(fn character ->
      skins = Enum.sort_by(character.skins, fn skin -> Enum.count(skin.votes) end, :desc)
      Map.put(character, :skins, skins)
    end)
  end
end
