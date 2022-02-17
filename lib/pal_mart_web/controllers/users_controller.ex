defmodule PalMartWeb.UsersController do
  use PalMartWeb, :controller

  alias PalMart.Accounts
  alias PalMart.Transactions

  def show(conn, %{"id" => id} = _attrs) do
    with {user_id, _} <- Integer.parse(id),
         {:ok, user} <- Accounts.find_user(user_id) do
      json(conn, %{user: user, balance: Transactions.compute_balance(user_id)})
    end
  end

  def create(conn, attrs) do
    with {:ok, user} <- Accounts.register_user(attrs) do
      json(conn, user)
    else
      {:error, changeset} ->
        conn
        |> put_status(422)
        |> json(error_response(changeset))
    end
  end

  defp error_response(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, _error} ->
      message
    end)
  end
end
