defmodule PalMart.Accounts do
  @moduledoc """
  User account management.
  """

  alias Ecto.Multi
  alias PalMart.Repo
  alias PalMart.Transactions
  alias PalMart.User

  @doc """
  Register a new user, with an initial credit balance.
  """
  @spec register_user(map()) :: {:ok, User.t()} | {:error, any()}
  def register_user(user_attrs) do
    Multi.new()
    |> Multi.run(:user, fn _repo, _changes ->
      %User{}
      |> User.changeset(user_attrs)
      |> Repo.insert()
    end)
    |> Multi.run(:initial_balance, fn _repo, %{user: user} ->
      Transactions.credit_for_signup(user)
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{user: user}} ->
        {:ok, user}

      {:error, :user, changeset, _} ->
        {:error, changeset}

      {:error, _, _, _} ->
        {:error, :unknown}
    end
  end

  @spec find_user(integer()) :: {:ok, User.t()} | {:error, :not_found}
  def find_user(user_id) do
    case Repo.get(User, user_id) do
      nil -> {:error, :not_found}
      user -> {:ok, user}
    end
  end
end
