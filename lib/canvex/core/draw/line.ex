defmodule Core.Draw.Line do
  @moduledoc """
  Lines are made of ASCII `chars`, can be `vertical` or `horizontal`, and have a `size`.
  """
  alias Core.{Canvas, Type}

  @doc """
  Draw a vertical line on a `canvas` given an `origin`, a `size` and a `stroke`
  """
  @spec vertical(Canvas.t(), Type.coordinates(), integer(), charlist()) :: Canvas.t()
  def vertical(canvas, _origin = %{x: start_x, y: start_y}, size, stroke)
      when size >= 0 do
    coordinates = for y <- start_y..(start_y + size - 1), do: {start_x, y}
    do_draw(coordinates, canvas, stroke)
  end

  def vertical(canvas, _origin = %{x: start_x, y: start_y}, size, stroke)
      when size < 0 do
    coordinates = for y <- (start_y + size + 1)..start_y, do: {start_x, y}
    do_draw(coordinates, canvas, stroke)
  end

  @doc """
  Draw a horizontal line on a `canvas` given a starting `coordinates`, a `size` and a `stroke`
  """
  @spec horizontal(Canvas.t(), Type.coordinates(), integer(), charlist()) :: Canvas.t()
  def horizontal(canvas, _origin = %{x: start_x, y: start_y}, size, stroke)
      when size >= 0 do
    coordinates = for x <- start_x..(start_x + size - 1), do: {x, start_y}
    do_draw(coordinates, canvas, stroke)
  end

  def horizontal(canvas, _origin = %{x: start_x, y: start_y}, size, stroke)
      when size < 0 do
    coordinates = for x <- (start_x + size + 1)..start_x, do: {x, start_y}
    do_draw(coordinates, canvas, stroke)
  end

  defp do_draw(coordinates, canvas, stroke) do
    Enum.reduce(coordinates, canvas, fn {x, y}, acc -> Canvas.put(acc, %{x: x, y: y}, stroke) end)
  end
end
