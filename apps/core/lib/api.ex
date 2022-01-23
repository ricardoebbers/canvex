defmodule Core do
  @moduledoc """
  The public API of the Core application.
  """
  alias Core.{Canvas, Type}
  alias Core.Draw.{FloodFill, Rectangle}

  @opaque canvas :: Canvas.t()
  @type coordinates :: Type.coordinates()
  @type size :: Type.size()
  @type fill :: charlist()
  @type outline :: charlist()

  @doc """
  Creates a new `canvas` with default `size` and `fill`

  ## Examples
      iex> Core.new_canvas()
      %Core.Canvas{
        cols: 5,
        rows: 5,
        values: %{
          {0, 0} => ' ',
          {0, 1} => ' ',
          {0, 2} => ' ',
          {1, 0} => ' ',
          {1, 1} => ' ',
          {1, 2} => ' ',
          {2, 0} => ' ',
          {2, 1} => ' ',
          {2, 2} => ' ',
          {0, 3} => ' ',
          {0, 4} => ' ',
          {1, 3} => ' ',
          {1, 4} => ' ',
          {2, 3} => ' ',
          {2, 4} => ' ',
          {3, 0} => ' ',
          {3, 1} => ' ',
          {3, 2} => ' ',
          {3, 3} => ' ',
          {3, 4} => ' ',
          {4, 0} => ' ',
          {4, 1} => ' ',
          {4, 2} => ' ',
          {4, 3} => ' ',
          {4, 4} => ' '
        }
      }
  """
  @spec new_canvas :: canvas
  defdelegate new_canvas, to: Canvas, as: :new

  @doc """
  Converts `canvas` to a matrix of `char`

  The resulting matrix is a list of lists with size `canvas.rows` x `canvas.cols`

  ## Examples
      iex> Core.new_canvas |> Core.matrix()
      [
        [' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' '],
        [' ', ' ', ' ', ' ', ' ']
      ]
  """
  @spec matrix(canvas) :: list(list(fill()))
  defdelegate matrix(canvas), to: Canvas

  @doc """
  Draws a `rectangle` made of ASCII chars of size `width` x `height`
  on a given `canvas` starting from `origin` coordinates.

  Rectangles can have a `fill`, an `outline` or both.

  ## Examples
      iex> canvas = Core.new_canvas
      iex> origin = %{x: 1, y: 0}
      iex> size = %{width: 3, height: 4}
      iex> Core.draw_rectangle(canvas, origin, size, '-', '#') |> Core.matrix()
      [
        [' ', '#', '#', '#', ' '],
        [' ', '#', '-', '#', ' '],
        [' ', '#', '-', '#', ' '],
        [' ', '#', '#', '#', ' '],
        [' ', ' ', ' ', ' ', ' ']
      ]
  """
  @spec draw_rectangle(canvas, coordinates, size, fill, outline) :: canvas
  defdelegate draw_rectangle(canvas, origin, size, fill, outline), to: Rectangle, as: :call

  @doc """
  Fills a contiguous area in a `canvas`, given the origin `coordinates` and a fill `char`.

  ## Examples
      iex> canvas = Core.new_canvas
      iex> origin = %{x: 0, y: 0}
      iex> Core.flood_fill(canvas, origin, 'B') |> Core.matrix()
      [
        ['B', 'B', 'B', 'B', 'B'],
        ['B', 'B', 'B', 'B', 'B'],
        ['B', 'B', 'B', 'B', 'B'],
        ['B', 'B', 'B', 'B', 'B'],
        ['B', 'B', 'B', 'B', 'B']
      ]
  """
  @spec flood_fill(canvas, coordinates, fill) :: canvas
  defdelegate flood_fill(canvas, origin, fill), to: FloodFill, as: :call
end
