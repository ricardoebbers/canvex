defmodule Core.Entity.Canvas do
  @type t :: %__MODULE__{
    rows: pos_integer(),
    cols: pos_integer(),
    values: %{{non_neg_integer(), non_neg_integer()} => char()}
  }

  @width 3
  @height 3
  @fill '.'

  defstruct rows: @width,
            cols: @height,
            values: %{}

  @spec new() :: t
  def new() do
    new(%{width: @width, height: @height}, @fill)
  end

  @spec new(Type.size(), char()) :: t
  def new(%{width: width, height: height}, fill) do
    coordinates = for x <- 0..(width - 1), y <- 0..(height - 1), do: {x, y}

    %__MODULE__{
      rows: width,
      cols: height,
      values: Map.new(coordinates, fn pair -> {pair, fill} end)
    }
  end

  @spec get(t, Type.coordinates()) :: char()
  def get(canvas, %{x: x, y: y}) do
    Map.get(canvas.values, {x, y})
  end

  @spec update(t, Type.coordinates(), char()) :: t
  def update(canvas = %{rows: rows, cols: cols, values: values}, %{x: x, y: y}, value)
      when x >= 0 and x < rows and y >= 0 and y < cols do
    %{canvas | values: Map.put(values, {x, y}, value)}
  end

  def update(canvas, _coordinates, _value), do: canvas

  @spec to_matrix(t) :: list(list(char()))
  def to_matrix(canvas) do
    Enum.reduce((canvas.cols - 1)..0, [], fn col, acc ->
      [
        Enum.reduce((canvas.rows - 1)..0, [], fn row, acc ->
          [Map.get(canvas.values, {row, col}) | acc]
        end)
        | acc
      ]
    end)
  end
end
