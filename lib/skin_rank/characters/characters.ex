defmodule SkinRank.Characters do
  alias SkinRank.Characters.Character
  alias SkinRank.Repo

  def all do
    Repo.all(Character)
    |> Repo.preload(skins: [votes: :skin])
  end
end
