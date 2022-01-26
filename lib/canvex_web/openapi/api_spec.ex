defmodule CanvexWeb.OpenAPI.ApiSpec do
  @moduledoc false
  alias OpenApiSpex.{Info, OpenApi, Paths, Server}
  alias CanvexWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    server =
      if System.get_env("MIX_ENV") == "dev" do
        Server.from_endpoint(Endpoint)
      else
        %Server{url: "https://canvex.gigalixirapp.com/", description: "Production"}
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
