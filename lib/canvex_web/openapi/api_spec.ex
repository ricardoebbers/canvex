defmodule CanvexWeb.OpenAPI.ApiSpec do
  @moduledoc false
  alias OpenApiSpex.{Info, OpenApi, Paths, Server}
  alias CanvexWeb.{Endpoint, Router}
  @behaviour OpenApi

  @impl OpenApi
  def spec do
    %OpenApi{
      servers: [
        Server.from_endpoint(Endpoint)
      ],
      info: %Info{
        title: to_string(Application.spec(:canvex, :description)),
        version: to_string(Application.spec(:canvex, :vsn))
      },
      paths: Paths.from_router(Router)
    }
    |> OpenApiSpex.resolve_schema_modules()
  end
end
