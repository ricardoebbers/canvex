import Config

config :core, Core.Canvas,
  default_width: 5,
  default_height: 5,
  default_fill: ' '

config :data, Data.Repo,
  database: "canvex_test",
  pool: Ecto.Adapters.SQL.Sandbox
