defmodule Canvex do
  @moduledoc """
  Canvex keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """
  alias Canvex.Canvas.{Create, Get, Update}
  alias Canvex.Draw.{FloodFill, Rectangle}

  defdelegate new_canvas(attrs), to: Create, as: :call

  defdelegate get_canvas_by_id(id), to: Get, as: :by_id
  defdelegate draw_rectangle(canvas, attrs), to: Rectangle, as: :call

  defdelegate flood_fill(canvas, attrs), to: FloodFill, as: :call
  defdelegate update_canvas(canvas), to: Update, as: :call
end
