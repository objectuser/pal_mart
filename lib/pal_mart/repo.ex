defmodule PalMart.Repo do
  use Ecto.Repo,
    otp_app: :pal_mart,
    adapter: Ecto.Adapters.SQLite3
end
