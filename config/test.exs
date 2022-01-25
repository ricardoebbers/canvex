import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :canvex, Canvex.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "canvex_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :canvex, CanvexWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "nuTpsWugXPMox0TC0qmCj+8ug6IpZK7NWGHXU0rRlKmJJ40f9BTQdZ6ulL7zkqtA",
  server: false

config :logger, :console, level: :debug

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
