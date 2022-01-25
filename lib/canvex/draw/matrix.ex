defmodule Canvex.Draw.Matrix do
  @moduledoc """
  Helper to better visualize `canvas` charlists
  """

  alias Canvex.Draw.Canvas

  def from_canvas(canvas) do
    canvas =
      canvas
      |> Canvas.update_charlist()

    canvas.charlist
    |> Enum.chunk_every(canvas.width)
  end
end
