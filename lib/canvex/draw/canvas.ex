defmodule Canvex.Draw.Canvas do
  @moduledoc """
  ASCII art drawing canvas
  """

  alias Canvex.Draw.Stroke

  require Logger

  def update_charlist(canvas = %{width: width, height: height, values: values}) do
    charlist =
      coords(width, height)
      |> Enum.map(&Map.get(values, &1))
      |> List.to_charlist()

    %{canvas | charlist: charlist}
  end

  def values_from_charlist(canvas = %{width: width, charlist: charlist})
      when width > 0 and is_list(charlist) do
    values =
      charlist
      |> Stream.with_index()
      |> Stream.map(fn {char, index} -> {{rem(index, width), div(index, width)}, char} end)
      |> Map.new()

    Map.put(canvas, :values, values)
  end

  def get_value_at(canvas, {x, y}) do
    Map.get(canvas.values, {x, y})
  end

  def put_value_at(canvas = %{width: width, height: height}, coords = {x, y}, value)
      when x >= 0 and x < width and y >= 0 and y < height do
    value
    |> Stroke.ascii_printable()
    |> case do
      error = {:error, _reason} ->
        error

      value ->
        %{canvas | values: Map.put(canvas.values, coords, value)}
    end
  end

  def put_value_at(canvas, _coords, _value), do: canvas

  defp coords(width, height), do: for(y <- 0..(height - 1), x <- 0..(width - 1), do: {x, y})
end
