defmodule CanvexWeb.OpenAPI.ApiSpec do
  @moduledoc false
  alias OpenApiSpex.{Info, OpenApi, Paths, Server}
  alias CanvexWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    server =
      if Mix.env() == :prod do
        %Server{url: "https://canvex.gigalixirapp.com:443", description: "Production"}
      else
        Server.from_endpoint(Endpoint)
      end

    %OpenApi{
      servers: [server],
      info: %Info{
        title: to_string(Application.spec(:canvex, :description)),
        version: to_string(Application.spec(:canvex, :vsn))
      },
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
