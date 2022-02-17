defmodule PalMart.TransactionTest do
  use ExUnit.Case

  alias PalMart.Transaction
  alias PalMart.User
  alias PalMart.Visit

  test "credit_for_sign_up/1" do
    assert %Transaction{minutes: 100} = Transaction.credit_for_sign_up(%User{})
  end

  test "credit_for_pal_visit/2" do
    assert %Transaction{minutes: 51} =
             Transaction.credit_for_pal_visit(%User{}, %Visit{minutes: 60})
  end

  test "debit_for_member_visit/2" do
    assert %Transaction{minutes: -60} =
             Transaction.debit_for_member_visit(%User{}, %Visit{minutes: 60})
  end
end
