defmodule PalMart.Visits do
  @moduledoc """
  Manage visitation member requests and pal acceptance.
  """

  alias Ecto.Multi
  alias PalMart.Accounts
  alias PalMart.Repo
  alias PalMart.Transactions
  alias PalMart.Visit

  import Ecto.Query

  @doc """
  List all available visits, that is, visits that have been requested by a
  member but not accepted by a pal.
  """
  def list_available do
    from(v in Visit, where: is_nil(v.pal_id), order_by: v.inserted_at)
    |> Repo.all()
  end

  @doc """
  Return a list of visits for the given member.
  """
  def list_visits_by_member(member_id) do
    from(v in Visit, where: v.member_id == ^member_id, order_by: v.inserted_at)
    |> Repo.all()
  end

  @doc """
  Record a request for a visit for a specific member.
  """
  def request(visit_request) do
    balance = Transactions.compute_balance(visit_request.member_id)

    if balance > 0 do
      record_request(visit_request)
    else
      {:error, :insufficient_balance}
    end
  end

  @doc """
  Record the acceptance of a pal for an existing visit.
  """
  def accept(acceptance) do
    record_accept(acceptance)
  end

  defp record_request(visit_request) do
    Multi.new()
    |> Multi.run(:visit, fn _repo, _changes ->
      %Visit{}
      |> Visit.changeset(visit_request)
      |> Repo.insert()
    end)
    |> Multi.run(:user, fn _repo, _changes ->
      Accounts.find_user(visit_request.member_id)
    end)
    |> Multi.run(:transaction, fn _repo, %{user: user, visit: visit} ->
      Transactions.debit_for_member_visit(user, visit)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{visit: visit}} ->
        {:ok, visit}

      {:error, :user, user_id, _} ->
        {:error, user_id}

      {:error, _, _, _} ->
        {:error, :unknown}
    end
  end

  defp record_accept(acceptance) do
    Multi.new()
    |> Multi.run(:user, fn _repo, _changes ->
      Accounts.find_user(acceptance.pal_id)
    end)
    |> Multi.run(:existing_visit, fn _repo, _changes ->
      case Repo.get(Visit, acceptance.id) do
        nil -> {:error, acceptance.id}
        visit -> {:ok, visit}
      end
    end)
    |> Multi.run(:visit, fn _repo, %{existing_visit: visit} ->
      visit
      |> Visit.update(acceptance)
      |> Repo.update()
    end)
    |> Multi.run(:transaction, fn _repo, %{user: user, visit: visit} ->
      Transactions.credit_for_pal_visit(user, visit)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{visit: visit}} ->
        {:ok, visit}

      {:error, :user, user_id, _} ->
        {:error, user_id}

      {:error, _, _, _} ->
        {:error, :unknown}
    end
  end
end
