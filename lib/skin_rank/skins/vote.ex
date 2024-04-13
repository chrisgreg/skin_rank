defmodule SkinRank.Skins.Vote do
  use Ecto.Schema
  alias Ecto.Changeset

  schema "votes" do
    belongs_to :skin, SkinRank.Skins.Skin
    timestamps(type: :utc_datetime)
  end

  def create_changeset(params) do
    %__MODULE__{}
    |> Changeset.cast(params, [:skin_id])
  end
end
