defmodule SkinRank.Repo.Migrations.AddVotingTable do
  use Ecto.Migration

  def change do
    create table(:votes) do
      add :skin_id, references(:skins, on_delete: :nothing)
      timestamps()
    end
  end
end
