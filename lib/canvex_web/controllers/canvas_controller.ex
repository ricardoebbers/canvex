defmodule CanvexWeb.CanvasController do
  use CanvexWeb, :controller
  action_fallback CanvexWeb.FallbackController

  alias Canvex.Canvas
  alias CanvexWeb.Commands.Draw

  def create(conn, params) do
    with {:ok, canvas} <- Canvas.new_canvas(params) do
      conn
      |> put_status(:created)
      |> render("show.json", canvas: canvas)
    end
  end

  def show(conn, %{"id" => id}) do
    with {:ok, canvas} <- Canvas.get_canvas_by_id(id) do
      conn
      |> put_status(:ok)
      |> render("show.json", canvas: canvas)
    end
  end

  def draw(conn, params = %{"id" => id}) do
    with %{valid?: true, changes: changes} <- Draw.validate(params),
         {:ok, canvas} <- Canvas.get_canvas_by_id(id),
         {:ok, updated_canvas} <- do_draw(canvas, changes) do
      conn
      |> put_status(:ok)
      |> render("show.json", canvas: updated_canvas)
    end
  end

  defp do_draw(canvas, changes = %{command: "rectangle"}) do
    case Canvas.draw_rectangle(canvas, changes) do
      error = {:error, _reason} -> error
      canvas -> Canvas.update_canvas(canvas)
    end
  end

  defp do_draw(canvas, changes = %{command: "flood_fill"}) do
    case Canvas.flood_fill(canvas, changes) do
      error = {:error, _reason} -> error
      canvas -> Canvas.update_canvas(canvas)
    end
  end
end
