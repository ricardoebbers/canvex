defmodule Core.Canvas do
  @moduledoc """
  Canvas have a fixed `size` and holds `chars` values on `coordinates`.

  Create a new `canvas` with `Core.Canvas.new/0`.

  Get a `value` for a specific `coordinate` with `Core.Canvas.get/2`.

  Get an updated `canvas` with a new `value` on `coordinates` with
  `Core.Canvas.put/3`.

  Get a matrix representation of a canvas with `Core.Canvas.matrix/1`.
  """

  alias Core.Type

  @type t :: %__MODULE__{
          rows: pos_integer(),
          cols: pos_integer(),
          values: %{{non_neg_integer(), non_neg_integer()} => char()}
        }

  defstruct rows: 0,
            cols: 0,
            values: %{{0, 0} => 0}

  @doc """
  Creates a new `canvas` with default `size` and `fill`

  These default values are set on the config.exs file:
    config :core, Core.Canvas,
      # can be any positive integer
      default_width: 3,
      default_height: 3,
      # can be any char
      default_fill: char()

  ## Examples
      iex> Core.Canvas.new()
      %Core.Canvas{
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
  @spec new :: t | {:error, term()}
  def new do
    params = default_params()
    new(%{width: params.width, height: params.height}, params.fill)
  end

  @doc """
  Creates a new `canvas` with given `size` and `fill`

  ## Examples
      iex> Core.Canvas.new(%{width: 3,height: 4}, '#')
      %Core.Canvas{ cols: 3, rows: 4, values: %{
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
  @spec new(Type.size(), charlist()) :: t | {:error, term()}
  def new(%{width: width, height: height}, fill) do
    coordinates = for x <- 0..(width - 1), y <- 0..(height - 1), do: {x, y}

    if !is_nil(fill) and List.ascii_printable?(fill) and length(fill) == 1 do
      %__MODULE__{
        rows: height,
        cols: width,
        values: Map.new(coordinates, &{&1, fill})
      }
    else
      {:error, "fill '#{fill}' must be a single ASCII printable char"}
    end
  end

  @doc """
  Gets the `char` for a specific `coordinates` in `canvas`

  If the `coordinates` is present on the `canvas`, it's `char` value is returned.
  Otherwise, `nil` is returned.

  ## Examples
      iex> canvas = Core.Canvas.new(%{width: 2, height: 2}, '#')
      iex> Core.Canvas.get(canvas, %{x: 1,y: 0})
      '#'
      iex> Core.Canvas.get(canvas, %{x: 5, y: 9})
      nil
      iex> Core.Canvas.get(canvas, %{x: -1, y: 0})
      nil
  """
  @spec get(t, Type.coordinates()) :: charlist() | nil
  def get(canvas, _coordinates = %{x: x, y: y}) do
    Map.get(canvas.values, {x, y})
  end

  @doc """
  Puts the given `char` value under `coordinates` in `canvas`

  If the given `coordinates` are present in `canvas`, updates it's value
  and returns the updated `canvas`.
  Otherwise, returns the `canvas` unchanged.

  ## Examples
      iex> canvas = Core.Canvas.new(%{width: 2, height: 2}, '#')
      iex> Core.Canvas.put(canvas, %{x: 1, y: 0}, '.')
      %Core.Canvas{
        cols: 2,
        rows: 2,
        values: %{
          {0, 0} => '#',
          {0, 1} => '#',
          {1, 0} => '.',
          {1, 1} => '#'
        }
      }
      iex> Core.Canvas.put(canvas, %{x: 5, y: 9}, '.')
      %Core.Canvas{
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
  @spec put(t, Type.coordinates(), charlist()) :: t
  def put(canvas = %{rows: rows, cols: cols, values: values}, %{x: x, y: y}, value)
      when x >= 0 and x < cols and y >= 0 and y < rows do
    if !is_nil(value) and List.ascii_printable?(value) and length(value) == 1 do
      %{canvas | values: Map.put(values, {x, y}, value)}
    else
      canvas
    end
  end

  def put(canvas, _coordinates, _value), do: canvas

  @doc """
  Converts `canvas` to a matrix of `char`

  Each `coordinate` pair `{x, y}` is put into it's corresponding positon
  on the matrix.

  The resulting matrix is a list of lists with size `canvas.rows` x `canvas.cols`

  ## Examples
      iex> canvas = Core.Canvas.new(%{width: 2, height: 4}, '#')
      iex> Core.Canvas.matrix(canvas)
      [
        ['#', '#'],
        ['#', '#'],
        ['#', '#'],
        ['#', '#']
      ]
  """
  @spec matrix(t) :: list(list(char()))
  def matrix(canvas) do
    coordinates = for y <- 0..(canvas.rows - 1), x <- 0..(canvas.cols - 1), do: {x, y}

    coordinates
    |> Enum.map(&Map.get(canvas.values, &1))
    |> Enum.chunk_every(canvas.cols)
  end

  @doc """
  Converts `canvas` to a `charlist`

  The charlist is populated sequencially from `{0, 0}` to `{width, height}`

  Returns a tuple `{charlist, width}`

  ## Examples
      iex> canvas = Core.Canvas.new(%{width: 3, height: 4}, '#')
      iex> Core.Canvas.charlist(canvas)
      {'############', 3}
  """
  @spec charlist(t) :: {charlist(), pos_integer()}
  def charlist(canvas) do
    charlist =
      canvas
      |> matrix()
      |> List.flatten()

    {charlist, canvas.cols}
  end

  @doc """
  Creates a new `canvas` given a `charlist` and the canvas `width`

  ## Examples
      iex> charlist = 'a...b...c...'
      iex> Core.Canvas.from_charlist(charlist, 4)
      %Core.Canvas{
        cols: 4,
        rows: 3,
        values: %{
          {0, 0} => 'a',
          {0, 1} => 'b',
          {0, 2} => 'c',
          {1, 0} => '.',
          {1, 1} => '.',
          {1, 2} => '.',
          {2, 0} => '.',
          {2, 1} => '.',
          {2, 2} => '.',
          {3, 0} => '.',
          {3, 1} => '.',
          {3, 2} => '.'
        }
      }
  """
  @spec from_charlist(charlist(), pos_integer()) :: t
  def from_charlist(charlist, width) do
    height =
      charlist
      |> length()
      |> div(width)

    base_canvas = new(%{width: width, height: height}, '.')

    charlist
    |> Stream.with_index()
    |> Stream.map(fn {char, index} -> {%{x: rem(index, width), y: div(index, width)}, char} end)
    |> Enum.reduce(base_canvas, fn {coords, char}, acc -> put(acc, coords, [char]) end)
  end

  @doc """
  Calculates the `myers_difference` of two `canvas`, based on their `charlist` representations.

  Both `canvas` must have the same shape.

  Returns `{myers_difference, width}` if both `canvas` have the same shape.
  Otherwise, returns `{:error, reason}`

  ## Examples
      iex> c1 = Core.Canvas.from_charlist('aaaabbbbcccc', 4)
      iex> c2 = Core.Canvas.from_charlist('aaaabbbbdddd', 4)
      iex> Core.Canvas.myers_difference(c1, c2)
      {[eq: 'aaaabbbb', del: 'cccc', ins: 'dddd'], 4}
      iex> c3 = Core.Canvas.from_charlist('aaaabbbbcccc', 3)
      iex> Core.Canvas.myers_difference(c1, c3)
      {:error, "Both canvas need to have the same shape"}
  """
  @spec myers_difference(t, t) ::
          {[{:eq | :ins | :del, list()}], pos_integer()}
          | {:error, term()}
  def myers_difference(canvas, other)
      when canvas.cols == other.cols and canvas.rows == other.rows do
    {c1_charlist, _} = charlist(canvas)
    {c2_charlist, _} = charlist(other)
    {List.myers_difference(c1_charlist, c2_charlist), canvas.cols}
  end

  def myers_difference(_, _), do: {:error, "Both canvas need to have the same shape"}

  @doc """
  Creates a new `canvas` given a `myers_difference` and the canvas `width`

  ## Examples
      iex> myers_difference = [eq: 'aaaabbbb', del: 'cccc', ins: 'dddd']
      iex> Core.Canvas.from_myers_difference(myers_difference, 4)
      %Core.Canvas{
        cols: 4,
        rows: 3,
        values: %{
          {0, 0} => 'a',
          {0, 1} => 'b',
          {0, 2} => 'd',
          {1, 0} => 'a',
          {1, 1} => 'b',
          {1, 2} => 'd',
          {2, 0} => 'a',
          {2, 1} => 'b',
          {2, 2} => 'd',
          {3, 0} => 'a',
          {3, 1} => 'b',
          {3, 2} => 'd'
        }
      }
  """
  @spec from_myers_difference([{:eq | :ins | :del, list()}], pos_integer()) :: t
  def from_myers_difference(myers_difference, width) do
    myers_difference
    |> Enum.map(fn {op, values} ->
      case op do
        :eq -> values
        :ins -> values
        :del -> ''
      end
    end)
    |> List.flatten()
    |> from_charlist(width)
  end

  defp default_params do
    config = Application.get_env(:core, __MODULE__)
    %{width: config[:default_width], height: config[:default_height], fill: config[:default_fill]}
  end
end
