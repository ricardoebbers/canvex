defmodule CanvexWeb.Canvas do
  use CanvexWeb, :live_view

  alias Canvex.PubSub

  def mount(%{"id" => canvas_id}, _session, socket) do
    with {:ok, canvas} <- Canvex.get_canvas_by_id(canvas_id) do
      PubSub.subscribe(canvas_id)
      {:ok, assign(socket, :canvas, canvas)}
    end
  end

  def handle_info(%{canvas: canvas}, socket) do
    {:noreply, assign(socket, :canvas, canvas)}
  end
end
