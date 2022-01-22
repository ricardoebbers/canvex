defmodule Core.Entity.Canvas do
  @moduledoc """
  Canvas have a fixed `size` and holds `chars` values on `coordinates`.

  Create a new canvas with `Core.Entity.Canvas.new/0`.

  Get a `value` for a specific `coordinate` with `Core.Entity.Canvas.get/2`.

  Get an updated `canvas` with a new `value` on `coordinates` with
  `Core.Entity.Canvas.put/3`.

  Get a matrix representation of a canvas with `Core.Entity.Canvas.to_matrix/1`.
  """

  alias Core.Type

  @type t :: %__MODULE__{
          rows: pos_integer(),
          cols: pos_integer(),
          values: %{{non_neg_integer(), non_neg_integer()} => char()}
        }

  defstruct rows: 0,
            cols: 0,
            values: %{}

  @doc """
  Creates a new canvas with default width, height and fill

  These default values are set on the config.exs file:
    config :core, Core.Entity.Canvas,
      # can be any positive integer
      default_width: 3,
      default_height: 3,
      # can be any char
      default_fill: char()

  ## Examples
      iex> Core.Entity.Canvas.new()
      %Core.Entity.Canvas{
        cols: 3,
        rows: 3,
        values: %{
          {0, 0} => '.',
          {0, 1} => '.',
          {0, 2} => '.',
          {1, 0} => '.',
          {1, 1} => '.',
          {1, 2} => '.',
          {2, 0} => '.',
          {2, 1} => '.',
          {2, 2} => '.'
        }
      }
  """
  @spec new :: t
  def new do
    params = default_params()
    new(%{width: params.width, height: params.height}, params.fill)
  end

  @doc """
  Creates a new canvas with given size and fill

  ## Examples
      iex> Core.Entity.Canvas.new(%{width: 3,height: 4}, '#')
      %Core.Entity.Canvas{ cols: 4, rows: 3, values: %{
          {0, 0} => '#',
          {0, 1} => '#',
          {0, 2} => '#',
          {0, 3} => '#',
          {1, 0} => '#',
          {1, 1} => '#',
          {1, 2} => '#',
          {1, 3} => '#',
          {2, 0} => '#',
          {2, 1} => '#',
          {2, 2} => '#',
          {2, 3} => '#'
        }
      }
  """
  @spec new(Type.size(), char()) :: t
  def new(%{width: width, height: height}, fill) do
    coordinates = for x <- 0..(width - 1), y <- 0..(height - 1), do: {x, y}

    %__MODULE__{
      rows: width,
      cols: height,
      values: Map.new(coordinates, fn pair -> {pair, fill} end)
    }
  end

  @doc """
  Gets the `char` for a specific `coordinates` in `canvas`

  If the `coordinates` is present on the `canvas`, it's `char` value is returned.
  Otherwise, `nil` is returned.

  ## Examples
      iex> canvas = Core.Entity.Canvas.new(%{width: 2, height: 2}, '#')
      iex> Core.Entity.Canvas.get(canvas, %{x: 1,y: 0})
      '#'
      iex> Core.Entity.Canvas.get(canvas, %{x: 5, y: 9})
      nil
      iex> Core.Entity.Canvas.get(canvas, %{x: -1, y: 0})
      nil
  """
  @spec get(t, Type.coordinates()) :: char() | nil
  def get(canvas, _coordinates = %{x: x, y: y}) do
    Map.get(canvas.values, {x, y})
  end

  @doc """
  Puts the given `char` value under `coordinates` in `canvas`

  If the given `coordinates` are present in `canvas`, updates it's value
  and returns the updated `canvas`.
  Otherwise, returns the `canvas` unchanged.

  ## Examples
      iex> canvas = Core.Entity.Canvas.new(%{width: 2, height: 2}, '#')
      iex> Core.Entity.Canvas.put(canvas, %{x: 1, y: 0}, '.')
      %Core.Entity.Canvas{
        cols: 2,
        rows: 2,
        values: %{
          {0, 0} => '#',
          {0, 1} => '#',
          {1, 0} => '.',
          {1, 1} => '#'
        }
      }
      iex> Core.Entity.Canvas.put(canvas, %{x: 5, y: 9}, '.')
      %Core.Entity.Canvas{
        cols: 2,
        rows: 2,
        values: %{
          {0, 0} => '#',
          {0, 1} => '#',
          {1, 0} => '#',
          {1, 1} => '#'
        }
      }
  """
  @spec put(t, Type.coordinates(), char()) :: t
  def put(canvas = %{rows: rows, cols: cols, values: values}, %{x: x, y: y}, value)
      when x >= 0 and x < rows and y >= 0 and y < cols do
    %{canvas | values: Map.put(values, {x, y}, value)}
  end

  def put(canvas, _coordinates, _value), do: canvas

  @doc """
  Converts `canvas` to a matrix of `char`


  Each `coordinate` pair `{x, y}` is put into it's corresponding positon
  on the matrix.

  The resulting matrix is a list of lists with size `canvas.rows` x `canvas.cols`

  ## Examples
      iex> canvas = Core.Entity.Canvas.new(%{width: 3, height: 4}, '#')
      iex> Core.Entity.Canvas.to_matrix(canvas)
      [
        ['#', '#', '#'],
        ['#', '#', '#'],
        ['#', '#', '#'],
        ['#', '#', '#']
      ]
  """
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

  defp default_params do
    config = Application.get_env(:core, __MODULE__)
    %{width: config[:default_width], height: config[:default_height], fill: config[:default_fill]}
  end
end
