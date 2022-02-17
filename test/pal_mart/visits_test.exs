defmodule PalMart.VisitsTest do
  use PalMart.DataCase

  alias PalMart.User
  alias PalMart.Visit
  alias PalMart.Visits
  alias PalMart.Transaction
  alias PalMart.Repo

  describe "request/1" do
    setup do
      user =
        %User{email: "user.one@example.com", first_name: "User", last_name: "One"}
        |> Repo.insert!()

      %{user: user}
    end

    test "with sufficient balance", %{user: %{id: user_id} = user} do
      Transaction.credit_for_sign_up(user)
      |> Repo.insert!()

      assert {:ok, %{member_id: ^user_id, pal_id: nil}} =
               Visits.request(%{
                 member_id: user_id,
                 date: ~D[2022-02-18],
                 minutes: 60,
                 tasks: "Grocery run"
               })
    end

    test "with insufficient balance", %{user: %{id: user_id} = _user} do
      assert {:error, :insufficient_balance} =
               Visits.request(%{
                 member_id: user_id,
                 date: ~D[2022-02-18],
                 minutes: 60,
                 tasks: "Grocery run"
               })
    end
  end

  test "accept/1" do
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

    assert {:ok, %{pal_id: ^user_id2}} = Visits.accept(%{id: visit.id, pal_id: user_id2})
  end
end
