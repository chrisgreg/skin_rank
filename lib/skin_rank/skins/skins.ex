defmodule SkinRank.Skins do
  alias SkinRank.Skins.{Vote}
  alias SkinRank.Repo

  def new_vote(skin_id) do
    Vote.create_changeset(%{skin_id: skin_id})
    |> Repo.insert()
  end
end
