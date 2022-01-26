import Config

# Configure your database
config :canvex, Canvex.Repo,
  username: "postgres",
  password: "postgres",
  hostname: "localhost",
  database: "canvex_dev",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10

config :canvex, CanvexWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4000],
  check_origin: false,
  code_reloader: true,
  debug_errors: true,
  secret_key_base: "dRlPRiNb8Fb89O+ffhOpSq6ZiXr7Tpzg+GQSEqYaXt1QGXPvZVXy2z29pD0//6A2",
  watchers: [
    esbuild: {Esbuild, :install_and_run, [:default, ~w(--sourcemap=inline --watch)]}
  ]


config :canvex, CanvexWeb.Endpoint,
  live_reload: [
    patterns: [
      ~r"priv/static/.*(js|css|png|jpeg|jpg|gif|svg)$",
      ~r"priv/gettext/.*(po)$",
      ~r"lib/canvex_web/(live|views)/.*(ex)$",
      ~r"lib/canvex_web/templates/.*(eex)$"
    ]
  ]


config :phoenix, :stacktrace_depth, 20

config :phoenix, :plug_init_mode, :runtime
