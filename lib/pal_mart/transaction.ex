defmodule PalMart.Transaction do
  @moduledoc """
  A record of a credit or debit, possibly related to a visit.
  """

  use Ecto.Schema

  alias __MODULE__
  alias PalMart.User
  alias PalMart.Visit

  @sign_up_credit_minutes 100

  schema "transactions" do
    field :minutes, :integer
    field :type, :string
    belongs_to :user, User
    belongs_to :visit, Visit

    timestamps()
  end

  @doc """
  Credit for signing up with the service.
  """
  def credit_for_sign_up(user) do
    %Transaction{user: user, minutes: @sign_up_credit_minutes, type: "sign up"}
  end

  @doc """
  Credit for a pal visit, which is the number of minutes minus a 15% overhead
  fee.
  """
  def credit_for_pal_visit(user, visit) do
    %Transaction{
      user: user,
      visit: visit,
      minutes: trunc(round(visit.minutes * (1 - 0.15))),
      type: "pal credit"
    }
  end

  @doc """
  A debit for a requested visit for the number of minutes.
  """
  def debit_for_member_visit(user, visit) do
    %Transaction{user: user, visit: visit, minutes: -visit.minutes, type: "member debit"}
  end
end
