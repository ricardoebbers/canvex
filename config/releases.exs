import Config

if config_env() == :prod do
  config :canvex, CanvexWeb.Endpoint, server: true
end
