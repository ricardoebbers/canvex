defmodule Canvex.Repo do
  use Ecto.Repo,
    otp_app: :canvex,
    adapter: Ecto.Adapters.Postgres
end
