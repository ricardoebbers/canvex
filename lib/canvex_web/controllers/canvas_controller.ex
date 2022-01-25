defmodule CanvexWeb.CanvasController do
  use CanvexWeb, :controller
  action_fallback CanvexWeb.FallbackController

  alias CanvexWeb.Commands.Draw

  def create(conn, params) do
    with {:ok, canvas} <- Canvex.new_canvas(params) do
      conn
      |> put_status(:created)
      |> render("show.json", canvas: canvas)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, canvas} <- Canvex.get_canvas_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", canvas: canvas)
    end
  end

  def draw(conn, params = %{"id" => id}) do
    with %{valid?: true, changes: changes} <- Draw.validate(params),
         {:ok, updated_canvas} <- Canvex.draw_on_canvas(id, changes) do
      conn
      |> put_status(:ok)
      |> render("show.json", canvas: updated_canvas)
    end
  end
end
