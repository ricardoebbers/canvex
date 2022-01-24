defmodule Core.Draw.Rectangle do
  @moduledoc """
  Rectangles are made of ASCII chars of size `width` x `height`.

  Rectangles can have a `fill`, an `outline` or both.
  """

  alias Core.{Canvas, Type}
  alias Core.Draw.Line

  @doc """
  Draws a `rectangle` made of ASCII chars of size `width` x `height`
  on a given `canvas` starting from `origin` coordinates.

  Rectangles can have a `fill`, an `outline` or both.
  """
  @spec call(Canvas.t(), Type.coordinates(), Type.size(), charlist(), charlist()) :: Canvas.t()
  def call(canvas, _origin, _size, _fill = nil, _outline = nil), do: canvas

  def call(canvas, origin, size, nil, outline) do
    outline_retangle(canvas, origin, size, outline)
  end

  def call(canvas, origin, size, fill, nil) do
    fill_retangle(canvas, origin, size, fill)
  end

  def call(canvas, origin, size, fill, outline) do
    canvas
    |> fill_retangle(origin, size, fill)
    |> outline_retangle(origin, size, outline)
  end

  defp outline_retangle(
         canvas,
         origin = %{x: start_x, y: start_y},
         _size = %{width: width, height: height},
         outline
       ) do
    end_point = %{x: start_x + width - 1, y: start_y + height - 1}

    canvas
    |> Line.vertical(origin, height - 1, outline)
    |> Line.horizontal(origin, width - 1, outline)
    |> Line.vertical(end_point, -height, outline)
    |> Line.horizontal(end_point, -width, outline)
  end

  defp fill_retangle(
         canvas,
         _origin = %{x: start_x, y: start_y},
         _size = %{width: width, height: height},
         fill
       ) do
    Enum.reduce(start_x..(start_x + width - 1), canvas, fn x, acc ->
      Line.vertical(acc, %{x: x, y: start_y}, height, fill)
    end)
  end
end
