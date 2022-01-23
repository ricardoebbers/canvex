import Config

config :core, Core.Canvas,
  default_width: 15,
  default_height: 15,
  default_fill: ' '

config :data,
  ecto_repos: [Data.Repo],
  generators: [binary_id: true]

config :data, Data.Repo,
  migration_primary_key: [type: :uuid],
  database: "canvex",
  username: "postgres",
  password: "postgres",
  hostname: "localhost"

import_config "#{Mix.env()}.exs"
