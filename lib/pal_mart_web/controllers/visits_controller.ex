defmodule PalMartWeb.VisitsController do
  use PalMartWeb, :controller

  alias PalMart.Visits
  alias Ecto.Changeset

  def index(conn, _attrs) do
    json(conn, Visits.list_available())
  end

  def show(conn, %{"id" => id} = _attrs) do
    with {id, ""} <- Integer.parse(id) do
      json(conn, Visits.list_visits_by_member(id))
    else
      _ ->
        conn
        |> put_status(400)
        |> json(%{error: :member_id})
    end
  end

  def create(conn, attrs) do
    with {:ok, visit_request} <- create_request(attrs),
         {:ok, visit} <- Visits.request(visit_request) do
      json(conn, visit)
    else
      {:error, %Changeset{} = changeset} ->
        conn
        |> put_status(400)
        |> json(error_response(changeset))

      {:error, reason} when is_atom(reason) ->
        conn
        |> put_status(400)
        |> json(%{error: reason})

      _error ->
        conn
        |> put_status(400)
        |> json(%{error: :unknown})
    end
  end

  def update(conn, attrs) do
    with {:ok, acceptance} <- create_accept(attrs),
         {:ok, visit} <- Visits.accept(acceptance) do
      json(conn, visit)
    else
      {:error, %Changeset{} = changeset} ->
        conn
        |> put_status(400)
        |> json(error_response(changeset))

      {:error, reason} when is_atom(reason) ->
        conn
        |> put_status(400)
        |> json(%{error: reason})

      _error ->
        conn
        |> put_status(400)
        |> json(%{error: :unknown})
    end
  end

  defp error_response(changeset) do
    Ecto.Changeset.traverse_errors(changeset, fn {message, _error} ->
      message
    end)
  end

  defp create_request(attrs) do
    types = %{date: :date, member_id: :integer, minutes: :integer, tasks: :string}

    {%{}, types}
    |> Changeset.cast(attrs, Map.keys(types))
    |> Changeset.validate_required(Map.keys(types))
    |> then(fn changeset ->
      case changeset.valid? do
        true -> {:ok, Changeset.apply_changes(changeset)}
        false -> {:error, changeset}
      end
    end)
  end

  defp create_accept(attrs) do
    types = %{id: :integer, pal_id: :integer}

    {%{}, types}
    |> Changeset.cast(attrs, Map.keys(types))
    |> Changeset.validate_required(Map.keys(types))
    |> then(fn changeset ->
      case changeset.valid? do
        true -> {:ok, Changeset.apply_changes(changeset)}
        false -> {:error, changeset}
      end
    end)
  end
end
