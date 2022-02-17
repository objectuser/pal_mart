defmodule PalMart.Transactions do
  @moduledoc """
  Manage credit and debit transactions related to visits.
  """

  alias PalMart.Transaction
  alias PalMart.Repo

  import Ecto.Query

  def credit_for_signup(user) do
    user
    |> Transaction.credit_for_sign_up()
    |> Repo.insert()
  end

  def credit_for_pal_visit(user, visit) do
    user
    |> Transaction.credit_for_pal_visit(visit)
    |> Repo.insert()
  end

  def debit_for_member_visit(user, visit) do
    user
    |> Transaction.debit_for_member_visit(visit)
    |> Repo.insert()
  end

  def compute_balance(user_id) do
    from(t in Transaction,
      where: t.user_id == ^user_id,
      order_by: t.inserted_at,
      select: sum(t.minutes)
    )
    |> Repo.one()
    |> case do
      nil -> 0
      balance -> balance
    end
  end
end
