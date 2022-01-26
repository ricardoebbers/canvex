defmodule Canvex.Draw.FloodFill do
  @moduledoc """
  Stack-based recursive implementation of the flood fill algorithm

  Inspired by https://en.wikipedia.org/wiki/Flood_fill
  """

  alias Canvex.Schema.Canvas

  @spec call(Canvas.t(), map()) :: Canvas.t()
  def call(canvas = %{values: values}, %{x: x, y: y, fill: fill}) do
    do_fill(canvas, fill, Map.get(values, {x, y}), [{x, y}])
  end

  defp do_fill(canvas, _fill, _target_fill, []) do
    canvas
  end

  defp do_fill(
         canvas = %{values: values, width: width, height: height},
         fill,
         target_fill,
         [coords = {x, y} | stack]
       )
       when x >= 0 and x < width and y >= 0 and y < height do
    current_fill = Map.get(values, coords)

    {canvas, stack} = maybe_update(canvas, fill, current_fill, target_fill, coords, stack)

    do_fill(canvas, fill, target_fill, stack)
  end

  defp do_fill(canvas, fill, target_fill, [_coords | stack]) do
    do_fill(canvas, fill, target_fill, stack)
  end

  defp maybe_update(canvas, fill, current_fill, target_fill, coords = {x, y}, stack)
       when current_fill == target_fill and current_fill != fill do
    canvas = Canvas.put_value_at(canvas, coords, fill)
    stack = [{x, y + 1} | stack]
    stack = [{x, y - 1} | stack]
    stack = [{x + 1, y} | stack]
    stack = [{x - 1, y} | stack]
    {canvas, stack}
  end

  defp maybe_update(canvas, _fill, _current_fill, _target_fill, _coords, stack),
    do: {canvas, stack}
end
