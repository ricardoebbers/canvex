defmodule Canvex.Draw.Line do
  @moduledoc """
  Draws `lines` onto `canvas`.

  Can draw both `vertical` and `horizontal` lines.
  By default, draws to the right and down from the origin,
  but can draw to the left and up by passing a negative `size`.
  """

  alias Canvex.Schema.Canvas

  @spec vertical(Canvas.t(), map()) :: Canvas.t()
  def vertical(canvas, %{x: start_x, y: start_y, size: size, stroke: stroke})
      when size >= 0 do
    coords = for y <- start_y..(start_y + size - 1), do: {start_x, y}
    do_draw(coords, canvas, stroke)
  end

  def vertical(canvas, %{x: start_x, y: start_y, size: size, stroke: stroke})
      when size < 0 do
    coords = for y <- (start_y + size + 1)..start_y, do: {start_x, y}
    do_draw(coords, canvas, stroke)
  end

  def horizontal(canvas, %{x: start_x, y: start_y, size: size, stroke: stroke})
      when size >= 0 do
    coords = for x <- start_x..(start_x + size - 1), do: {x, start_y}
    do_draw(coords, canvas, stroke)
  end

  def horizontal(canvas, %{x: start_x, y: start_y, size: size, stroke: stroke})
      when size < 0 do
    coords = for x <- (start_x + size + 1)..start_x, do: {x, start_y}
    do_draw(coords, canvas, stroke)
  end

  defp do_draw(coords, canvas, stroke) do
    Enum.reduce(coords, canvas, fn coords, acc ->
      Canvas.put_value_at(acc, coords, stroke)
    end)
  end
end
