defmodule CanvexWeb.Canvas do
  @moduledoc """
  Live View for a canvas.

  Subscribes to the canvas topic on mounting, so it can update
  the client view when the canvas is modified.
  """
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
