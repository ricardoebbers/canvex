defmodule Core.Draw.FloodFill do
  @moduledoc """
  Stack-based recursive implementation of the flood fill algorithm

  Inspired by https://en.wikipedia.org/wiki/Flood_fill
  """
  alias Core.{Canvas, Type}

  @doc """
  Fills a continuous area in a `canvas`, given the origin `coordinates` and a fill `char`.
  """
  @spec call(Canvas.t(), Type.coordinates(), charlist()) :: Canvas.t()
  def call(canvas, origin, fill) do
    do_fill(canvas, fill, Canvas.get(canvas, origin), [origin])
  end

  defp do_fill(canvas, _fill, _target_fill, []) do
    canvas
  end

  defp do_fill(
         canvas = %{cols: cols, rows: rows},
         fill,
         target_fill,
         [coords = %{x: x, y: y} | stack]
       )
       when x >= 0 and x < cols and y >= 0 and y < rows do
    current_fill = Canvas.get(canvas, coords)

    {canvas, stack} = maybe_update(canvas, fill, current_fill, target_fill, coords, stack)

    do_fill(canvas, fill, target_fill, stack)
  end

  defp do_fill(canvas, fill, target_fill, [_coords | stack]) do
    do_fill(canvas, fill, target_fill, stack)
  end

  defp maybe_update(canvas, fill, current_fill, target_fill, coords, stack)
       when current_fill == target_fill and current_fill != fill do
    canvas = Canvas.put(canvas, coords, fill)
    stack = [%{coords | x: coords.x - 1} | stack]
    stack = [%{coords | x: coords.x + 1} | stack]
    stack = [%{coords | y: coords.y - 1} | stack]
    stack = [%{coords | y: coords.y + 1} | stack]
    {canvas, stack}
  end

  defp maybe_update(canvas, _fill, _current_fill, _target_fill, _coords, stack),
    do: {canvas, stack}
end
