defmodule SkinRank.Characters.Character do
  use Ecto.Schema
  alias SkinRank.Skins.Skin
  alias Ecto.Changeset

  schema "characters" do
    field :name, :string
    has_many :skins, Skin
  end

  def create_changeset(character, attrs) do
    character
    |> Changeset.cast(attrs, [:name])
    |> Changeset.cast_assoc(:skins, with: &Skin.create_changeset/2)
  end
end
