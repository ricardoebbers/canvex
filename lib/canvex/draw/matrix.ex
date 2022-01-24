defmodule Canvex.Draw.Matrix do
  def from_canvas(canvas) do
    canvas.charlist
    |> Enum.chunk_every(canvas.width)
  end
end
