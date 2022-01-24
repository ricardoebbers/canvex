defmodule Canvex.Draw.Line do
  alias Canvex.Draw.Canvas

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
