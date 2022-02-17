defmodule PalMart.AccountsTest do
  use PalMart.DataCase

  alias PalMart.Accounts
  alias PalMart.User

  describe "register_user/1" do
    test "registers a user" do
      assert {:ok, %User{}} =
               Accounts.register_user(%{
                 "first_name" => "User",
                 "last_name" => "One",
                 "email" => "user.one@example.com"
               })
    end

    test "missing field causes a failure" do
      assert {:error, %Ecto.Changeset{}} =
               Accounts.register_user(%{
                 "first_name" => "User",
                 "email" => "user.one@example.com"
               })
    end
  end

  describe "find_user/1" do
    setup do
      {:ok, user} =
        Accounts.register_user(%{
          "first_name" => "User",
          "last_name" => "One",
          "email" => "user.one@example.com"
        })

      %{user: user}
    end

    test "finds a user", %{user: user} do
      assert {:ok, %User{}} = Accounts.find_user(user.id)
    end

    test "error on not found" do
      assert {:error, :not_found} = Accounts.find_user(-1)
    end
  end
end
