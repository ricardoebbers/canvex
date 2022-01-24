defmodule Canvex.Draw.Rectangle do
  alias Canvex.Draw.Line

  def call(canvas, args = %{fill: _fill, outline: _outline}) do
    canvas
    |> fill_retangle(args)
    |> outline_retangle(args)
  end

  def call(canvas, args = %{outline: _outline}) do
    outline_retangle(canvas, args)
  end

  def call(canvas, args = %{fill: _fill}) do
    fill_retangle(canvas, args)
  end

  def call(_canvas, _args), do: {:error, "Missing fill and outline"}

  defp outline_retangle(canvas, %{
         origin: origin = {start_x, start_y},
         width: width,
         height: height,
         outline: outline
       }) do
    end_point = {start_x + width - 1, start_y + height - 1}

    canvas
    |> Line.vertical(%{origin: origin, size: height - 1, stroke: outline})
    |> Line.vertical(%{origin: end_point, size: -height, stroke: outline})
    |> Line.horizontal(%{origin: origin, size: width - 1, stroke: outline})
    |> Line.horizontal(%{origin: end_point, size: -width, stroke: outline})
  end

  defp fill_retangle(canvas, %{
         origin: {start_x, start_y},
         width: width,
         height: height,
         fill: fill
       }) do
    Enum.reduce(start_x..(start_x + width - 1), canvas, fn x, acc ->
      Line.vertical(acc, %{origin: {x, start_y}, size: height, stroke: fill})
    end)
  end
end
