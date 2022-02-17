defmodule PalMartWeb.VisitsControllerTest do
  use PalMartWeb.ConnCase

  alias PalMart.User
  alias PalMart.Transactions
  alias PalMart.Visit
  alias PalMart.Repo

  test "request a visit", %{conn: conn} do
    %{id: user_id} =
      user =
      %User{email: "user.one@example.com", first_name: "User", last_name: "One"}
      |> Repo.insert!()

    Transactions.credit_for_signup(user)

    conn =
      post(conn, "/api/v1/visits", %{
        "member_id" => user_id,
        "date" => "2022-02-18",
        "minutes" => 60,
        "tasks" => "Grocery run"
      })

    assert %{
             "member_id" => ^user_id,
             "date" => "2022-02-18",
             "minutes" => 60,
             "tasks" => "Grocery run"
           } = json_response(conn, 200)
  end

  test "accept a visit", %{conn: conn} do
    user1 =
      %User{email: "user.one@example.com", first_name: "User", last_name: "One"}
      |> Repo.insert!()

    %{id: user_id2} =
      %User{email: "user.one@example.com", first_name: "User", last_name: "One"}
      |> Repo.insert!()

    visit =
      Visit.changeset(
        %Visit{},
        %{
          "member_id" => user1.id,
          "date" => "2022-02-18",
          "minutes" => 60,
          "tasks" => "Grocery run"
        }
      )
      |> Repo.insert!()

    conn = put(conn, "/api/v1/visits/#{visit.id}", %{"pal_id" => user_id2})

    assert %{"pal_id" => ^user_id2} = json_response(conn, 200)
  end
end
