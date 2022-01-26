import Config

config :canvex, Canvex.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "canvex_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

if System.get_env("GITHUB_ACTIONS") do
  config :canvex, Canvex.Repo,
    username: "postgres",
    password: "postgres"
end

config :canvex, CanvexWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "nuTpsWugXPMox0TC0qmCj+8ug6IpZK7NWGHXU0rRlKmJJ40f9BTQdZ6ulL7zkqtA",
  server: false

config :logger, :console, level: :none

config :phoenix, :plug_init_mode, :runtime
