defmodule PalMart.Visit do
  @doc """
  A visit to a member from a pal.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias PalMart.User

  @derive {Jason.Encoder, only: [:id, :member_id, :pal_id, :date, :minutes, :tasks]}
  schema "visits" do
    field :date, :date, null: false
    field :minutes, :integer, null: false
    field :tasks, :string, null: false
    belongs_to :member, User
    belongs_to :pal, User

    timestamps()
  end

  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [:date, :minutes, :tasks, :member_id, :pal_id])
    |> validate_required([:date, :minutes, :tasks, :member_id])
  end

  def update(visit, attrs) do
    visit
    |> cast(attrs, [:pal_id])
    |> validate_required([:pal_id])
  end
end
