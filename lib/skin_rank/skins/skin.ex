defmodule SkinRank.Skins.Skin do
  use Ecto.Schema
  alias Ecto.Changeset

  schema "skins" do
    field :name, :string
    field :image_url, :string
    field :event, :string
    field :cost, :string
    belongs_to :character, SkinRank.Characters.Character
    has_many :votes, SkinRank.Skins.Vote
  end

  def create_changeset(skin, attrs) do
    skin
    |> Changeset.cast(attrs, [:name, :image_url, :event, :cost])
  end
end
