defmodule CanvexWeb.CanvasView do
  use CanvexWeb, :view
  alias CanvexWeb.CanvasView

  def render("index.json", %{canvases: canvases}) do
    %{data: render_many(canvases, CanvasView, "canvas.json")}
  end

  def render("show.json", %{canvas: canvas}) do
    %{data: render_one(canvas, CanvasView, "canvas.json")}
  end

  def render("canvas.json", %{canvas: canvas}) do
    %{
      id: canvas.id,
      width: canvas.width,
      height: canvas.height,
      values: canvas.values,
      user_id: canvas.user_id
    }
  end
end
