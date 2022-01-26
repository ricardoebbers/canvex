import Config

if System.get_env("PHX_SERVER") && System.get_env("RELEASE_NAME") do
  config :canvex, CanvexWeb.Endpoint, server: true
end

if config_env() == :prod do
  database_url =
    System.get_env("DATABASE_URL") ||
      raise """
      environment variable DATABASE_URL is missing.
      For example: ecto://USER:PASS@HOST/DATABASE
      """

  maybe_ipv6 = if System.get_env("ECTO_IPV6"), do: [:inet6], else: []

  config :canvex, Canvex.Repo,
    # ssl: true,
    url: database_url,
    pool_size: String.to_integer(System.get_env("POOL_SIZE") || "2"),
    socket_options: maybe_ipv6

  config :canvex, CanvexWeb.Endpoint,
    server: true,
    http: [port: {:system, "PORT"}],
    url: [host: System.get_env("APP_NAME") <> ".gigalixirapp.com", port: 443]
end
