defmodule Canvex.Draw.FloodFill do
  @moduledoc """
  Stack-based recursive implementation of the flood fill algorithm

  Inspired by https://en.wikipedia.org/wiki/Flood_fill
  """

  alias Canvex.Draw.Stroke
  alias Canvex.Schema.Canvas

  @spec call(Canvas.t(), map()) :: Canvas.t()
  def call(canvas = %{values: values}, %{x: x, y: y, fill: fill}) do
    case Stroke.ascii_printable(fill) do
      error = {:error, _reason} ->
        error

      fill ->
        target_fill = Map.get(values, {x, y})
        do_fill(canvas, fill, target_fill, [{x, y}])
    end
  end

  # First exit condition: when the target fill is the same as the fill from the command
  defp do_fill(canvas, target_fill, target_fill, _stack), do: canvas

  # Second exit condition: when the stack is empty
  defp do_fill(canvas, _fill, _target_fill, []), do: canvas

  # Main function, matches when the coords are inside the canvas
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

  # Stepper function, discards coords outside the canvas
  defp do_fill(canvas, fill, target_fill, [_coords | stack]) do
    do_fill(canvas, fill, target_fill, stack)
  end

  # Updates the current coords and stacks the adjacent coords
  defp maybe_update(canvas, fill, current_fill, target_fill, coords = {x, y}, stack)
       when current_fill == target_fill and current_fill != fill do
    canvas = Canvas.put_value_at(canvas, coords, fill)
    stack = [{x, y + 1} | stack]
    stack = [{x, y - 1} | stack]
    stack = [{x + 1, y} | stack]
    stack = [{x - 1, y} | stack]
    {canvas, stack}
  end

  # Otherwise do nothing
  defp maybe_update(canvas, _fill, _current_fill, _target_fill, _coords, stack),
    do: {canvas, stack}
end
