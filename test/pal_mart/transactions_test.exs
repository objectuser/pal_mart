defmodule PalMart.TransactionsTest do
  use PalMart.DataCase

  alias PalMart.User
  alias PalMart.Transaction
  alias PalMart.Transactions
  alias PalMart.Visit
  alias PalMart.Repo

  test "credit_for_signup/1" do
    user =
      %User{email: "user.one@example.com", first_name: "User", last_name: "One"}
      |> Repo.insert!()

    assert {:ok, %Transaction{minutes: 100}} = Transactions.credit_for_signup(user)
  end

  test "credit_for_pal_visit/1" do
    user =
      %User{email: "user.one@example.com", first_name: "User", last_name: "One"}
      |> Repo.insert!()

    visit =
      %Visit{member: user, date: ~D[2022-02-18], minutes: 60, tasks: "Grocery run"}
      |> Repo.insert!()

    assert {:ok, %Transaction{minutes: 51}} = Transactions.credit_for_pal_visit(user, visit)
  end

  test "credit_for_member_visit/1" do
    user =
      %User{email: "user.one@example.com", first_name: "User", last_name: "One"}
      |> Repo.insert!()

    visit =
      %Visit{member: user, date: ~D[2022-02-18], minutes: 60, tasks: "Grocery run"}
      |> Repo.insert!()

    assert {:ok, %Transaction{minutes: -60}} = Transactions.debit_for_member_visit(user, visit)
  end

  test "compute_balance/1" do
    user =
      %User{email: "user.one@example.com", first_name: "User", last_name: "One"}
      |> Repo.insert!()

    visit =
      %Visit{member: user, date: ~D[2022-02-18], minutes: 60, tasks: "Grocery run"}
      |> Repo.insert!()

    Transactions.credit_for_signup(user)
    Transactions.debit_for_member_visit(user, visit)

    assert 40 == Transactions.compute_balance(user.id)
  end
end
