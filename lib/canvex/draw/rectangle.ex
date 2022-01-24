defmodule Canvex.Draw.Rectangle do
  @moduledoc """
  Draws `rectangles` onto `canvas`.

  Uses the `Canvex.Draw.Line` module to draw four lines for
  each __side__ of the rectangle, and __fills__ the rectangles by
  drawing parallel vertical lines.
  """
  alias Canvex.Draw.Line

  require Logger

  def call(canvas, args = %{fill: _fill, outline: _outline}) do
    canvas
    |> fill_rectangle(args)
    |> outline_rectangle(args)
  end

  def call(canvas, args = %{outline: _outline}) do
    outline_rectangle(canvas, args)
  end

  def call(canvas, args = %{fill: _fill}) do
    fill_rectangle(canvas, args)
  end

  def call(_canvas, args) do
    Logger.error("Missing fill and outline. Can't draw a rectangle. args: #{inspect(args)}")
    {:error, :bad_request}
  end

  defp outline_rectangle(canvas, %{
         x: start_x,
         y: start_y,
         width: width,
         height: height,
         outline: outline
       }) do
    {end_x, end_y} = {start_x + width - 1, start_y + height - 1}

    canvas
    |> Line.vertical(%{x: start_x, y: start_y, size: height - 1, stroke: outline})
    |> Line.vertical(%{x: end_x, y: end_y, size: -height, stroke: outline})
    |> Line.horizontal(%{x: start_x, y: start_y, size: width - 1, stroke: outline})
    |> Line.horizontal(%{x: end_x, y: end_y, size: -width, stroke: outline})
  end

  defp fill_rectangle(canvas, %{
         x: start_x,
         y: start_y,
         width: width,
         height: height,
         fill: fill
       }) do
    Enum.reduce(start_x..(start_x + width - 1), canvas, fn x, acc ->
      Line.vertical(acc, %{x: x, y: start_y, size: height, stroke: fill})
    end)
  end
end
