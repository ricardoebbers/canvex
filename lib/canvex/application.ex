defmodule Canvex.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Canvex.Repo,
      # Start the Telemetry supervisor
      CanvexWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Canvex.PubSub},
      # Start the Endpoint (http/https)
      CanvexWeb.Endpoint
      # Start a worker by calling: Canvex.Worker.start_link(arg)
      # {Canvex.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Canvex.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    CanvexWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
