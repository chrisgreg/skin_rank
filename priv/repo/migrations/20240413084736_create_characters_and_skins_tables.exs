defmodule SkinRank.Repo.Migrations.CreateCharactersAndSkinsTables do
  use Ecto.Migration

  def change do
    create table(:characters) do
      add :name, :string
    end

    create table(:skins) do
      add :name, :string
      add :image_url, :string
      add :event, :string
      add :cost, :string
      add :character_id, references(:characters, on_delete: :nothing)
    end
  end
end
