defmodule Canvex.Draw.Matrix do
  @moduledoc """
  Helper to better visualize `canvas` charlists
  """
  def from_canvas(canvas) do
    canvas.charlist
    |> Enum.chunk_every(canvas.width)
  end
end
