import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :pal_mart, PalMart.Repo,
  database: Path.expand("../pal_mart_test.db", Path.dirname(__ENV__.file)),
  pool_size: 5,
  pool: Ecto.Adapters.SQL.Sandbox

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :pal_mart, PalMartWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "gWabYytpWWna8g+q0jZ+FzL8xxLY1idwXjvh0ffdQ002HZ3lVZ4tu5QWmBzWA5ga",
  server: false

# In test we don't send emails.
config :pal_mart, PalMart.Mailer, adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
