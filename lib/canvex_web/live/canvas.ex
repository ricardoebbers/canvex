defmodule CanvexWeb.Canvas do
  use CanvexWeb, :live_view

  def mount(%{"id" => canvas_id}, _session, socket) do
    with {:ok, canvas} <- Canvex.get_canvas_by_id(canvas_id) do
      {:ok, assign(socket, :canvas, canvas)}
    end
  end
end
