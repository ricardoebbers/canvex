defmodule Canvex.Draw.Canvas do
  @moduledoc """
  ASCII art drawing canvas
  """

  alias Canvex.Draw.Stroke

  defstruct width: 0,
            height: 0,
            values: %{{0, 0} => 0},
            charlist: []

  require Logger

  def new(%{width: width, charlist: charlist}) when width > 0 and is_list(charlist) do
    charlist
    |> Enum.map(&Stroke.ascii_printable/1)
    |> build(width)
  end

  def new(%{width: width, height: height, fill: fill})
      when width > 0 and height > 0 and not is_nil(fill) do
    fill
    |> Stroke.ascii_printable()
    |> case do
      error = {:error, _reason} -> error
      fill -> build(width, height, fill)
    end
  end

  def new(params) do
    message = "Unexpected params, unable to create a canvas."
    Logger.error([message, " params: #{inspect(params)}"])
    {:error, message}
  end

  def charlist_from_values(%{width: width, height: height, values: values}) do
    coords(width, height)
    |> Enum.map(&Map.get(values, &1))
    |> List.to_charlist()
  end

  def values_from_charlist(%{width: width, charlist: charlist})
      when width > 0 and is_list(charlist) do
    charlist
    |> Enum.map(&Stroke.ascii_printable/1)
    |> Stream.with_index()
    |> Stream.map(fn {char, index} -> {{rem(index, width), div(index, width)}, char} end)
    |> Map.new()
  end

  def values_from_charlist(params) do
    message = "Unexpected params, unable to create a canvas."
    Logger.error([message, " params: #{inspect(params)}"])
    {:error, message}
  end

  def charlist_and_values_from_params(%{width: width, height: height, fill: fill})
      when width > 0 and height > 0 and not is_nil(fill) do
    fill
    |> Stroke.ascii_printable()
    |> case do
      error = {:error, _reason} ->
        error

      fill ->
        %{
          values: Map.new(coords(width, height), &{&1, fill}),
          charlist: List.duplicate(fill, height * width) |> List.to_charlist()
        }
    end
  end

  def charlist_and_values_from_params(params) do
    message = "Unexpected params, unable to create a canvas."
    Logger.error([message, " params: #{inspect(params)}"])
    {:error, message}
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
        update_value(canvas, coords, value)
    end
  end

  def put_value_at(canvas, _coords, _value), do: canvas

  defp build(width, height, fill) do
    %__MODULE__{
      height: height,
      width: width,
      values: Map.new(coords(width, height), &{&1, fill}),
      charlist: List.duplicate(fill, height * width) |> List.to_charlist()
    }
  end

  defp build(charlist, width) do
    values =
      charlist
      |> Stream.with_index()
      |> Stream.map(fn {char, index} -> {{rem(index, width), div(index, width)}, char} end)
      |> Map.new()

    height =
      charlist
      |> length()
      |> div(width)

    %__MODULE__{
      height: height,
      width: width,
      values: values,
      charlist: charlist |> List.to_charlist()
    }
  end

  defp update_value(canvas, coords = {x, y}, value) do
    %{
      canvas
      | values: Map.put(canvas.values, coords, value),
        charlist:
          List.replace_at(canvas.charlist, y * canvas.width + x, value) |> List.to_charlist()
    }
  end

  defp coords(width, height), do: for(y <- 0..(height - 1), x <- 0..(width - 1), do: {x, y})
end
