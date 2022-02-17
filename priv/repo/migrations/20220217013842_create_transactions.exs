defmodule PalMart.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :type, :string
      add :minutes, :integer
      add :user_id, references(:users, on_delete: :nothing)
      add :visit_id, references(:visits, on_delete: :nothing)

      timestamps()
    end

    create index(:transactions, [:user_id])
    create index(:transactions, [:visit_id])
  end
end
