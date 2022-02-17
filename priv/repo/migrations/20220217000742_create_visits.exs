defmodule PalMart.Repo.Migrations.CreateVisits do
  use Ecto.Migration

  def change do
    create table(:visits) do
      add :date, :date, null: false
      add :minutes, :integer, null: false
      add :tasks, :text, null: false
      add :member_id, references(:users, on_delete: :nothing)
      add :pal_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:visits, [:member_id])
    create index(:visits, [:pal_id])
  end
end
