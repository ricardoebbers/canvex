defmodule CanvexWeb.Router do
  use CanvexWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_live_flash
    plug :put_root_layout, {CanvexWeb.LayoutView, :root}
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]
    plug OpenApiSpex.Plug.PutApiSpec, module: CanvexWeb.OpenAPI.ApiSpec
  end

  scope "/" do
    pipe_through :browser

    get "/", OpenApiSpex.Plug.SwaggerUI, path: "/api/openapi"
    live "/canvas/:id", CanvexWeb.Canvas
  end

  scope "/api" do
    pipe_through :api

    resources "/canvas", CanvexWeb.CanvasController, only: [:create, :show]
    put "/canvas/:id/draw", CanvexWeb.CanvasController, :draw
    get "/openapi", OpenApiSpex.Plug.RenderSpec, []
  end

  # coveralls-ignore-start
  if System.get_env("MIX_ENV") in ["dev", "test"] do
    import Phoenix.LiveDashboard.Router

    scope "/" do
      pipe_through :browser

      live_dashboard "/dashboard", metrics: CanvexWeb.Telemetry
    end
  end
end
