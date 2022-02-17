defmodule PalMartWeb.UsersControllerTest do
  use PalMartWeb.ConnCase

  test "register user", %{conn: conn} do
    conn =
      post(conn, "/api/v1/users", %{
        "first_name" => "User",
        "last_name" => "One",
        "email" => "user.one@example.com"
      })

    assert %{
             "first_name" => "User",
             "last_name" => "One",
             "email" => "user.one@example.com"
           } = json_response(conn, 200)
  end

  test "register user fails without required field", %{conn: conn} do
    conn =
      post(conn, "/api/v1/users", %{
        "first_name" => "User",
        "last_name" => "One"
      })

    assert %{"email" => ["can't be blank"]} = json_response(conn, 422)
  end
end
