import Config

config :canvex,
  ecto_repos: [Canvex.Repo],
  generators: [binary_id: true]

config :canvex, CanvexWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [view: CanvexWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Canvex.PubSub,
  live_view: [signing_salt: "yzMeQl6p"]

config :esbuild,
  version: "0.14.0",
  default: [
    args:
      ~w(js/app.js --bundle --target=es2017 --outdir=../priv/static/assets --external:/fonts/* --external:/images/*),
    cd: Path.expand("../assets", __DIR__),
    env: %{"NODE_PATH" => Path.expand("../deps", __DIR__)}
  ]

config :logger, :console,
  format: "$time [$level] $metadata $message\n",
  metadata: [:request_id, :mfa]

config :phoenix, :json_library, Jason

import_config "#{config_env()}.exs"
