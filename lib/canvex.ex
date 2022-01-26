defmodule Canvex do
  @moduledoc """
  Canvex is an ASCII art drawing canvas in Elixir.

  ## Canvas

  Canvases are represented as a matrix of `chars`, all being ASCII printable,
  with coordinates that start from the top left, like this:
  ```
  # a canvas with width = 10, height = 5, fill = 'o'
            0 1 2 3 4 5 6 7 8 9 (x axis)
            _ _ _ _ _ _ _ _ _ _
        0 | o o o o o o o o o o
        1 | o o o o o o o o o o
        2 | o o o o o o o o o o
        3 | o o o o o o o o o o
        4 | o o o o o o o o o o
  (y axis)
  ```

  Canvases are identifiable with a global unique identifier in the form of an UUID.

  To create a `canvas` refer to `Canvex.new_canvas/1`.

  To fetch a previously created canvas from the database refer to `Canvex.get_canvas_by_id/1`.

  ## Drawing

  It's possible to do drawings on a canvas with ASCII printable `chars`.

  Refer to `Canvex.draw_on_canvas/2` to know which drawing operations are possible.
  """
  alias Canvex.Canvas.{Create, Get}
  alias Canvex.Draw
  alias Canvex.Schema.Canvas

  @type canvas :: Canvas.t()

  @doc """
  Creates a `canvas` given a map containing `width`, `height`, `fill`, and an UUID as `user_id`.

  Returns {:ok, canvas} if the parameters are valid.
  Otherwise, returns {:error, changeset}

  ## Examples
      iex> attrs = %{width: 3, height: 5, fill: " ", user_id: Ecto.UUID.generate()}
      iex> {:ok, %{charlist: '               ', height: 5, width: 3}} = Canvex.new_canvas(attrs)

      iex> {:error, _changeset} = Canvex.new_canvas(%{})
  """
  @spec new_canvas(map) :: {:ok, Canvas.t()} | {:error, Ecto.Changeset.t()}
  defdelegate new_canvas(attrs), to: Create, as: :call

  @doc """
  Fetches an existing `canvas` from the database.

  Returns {:ok, canvas} if the id is an UUID and the canvas exist.
  Otherwise, returns {:error, :not_found} for missing canvas or {:error, :bad_request} for invalid UUID.

  ## Examples
        iex> attrs = %{width: 3, height: 5, fill: " ", user_id: Ecto.UUID.generate()}
        iex> {:ok, %{id: id}} = Canvex.new_canvas(attrs)
        iex> {:ok, _canvas} = Canvex.get_canvas_by_id(id)

        iex> {:error, :bad_request} = Canvex.get_canvas_by_id("foo")

        iex> {:error, :not_found} = Canvex.get_canvas_by_id(Ecto.UUID.generate())
  """
  @spec get_canvas_by_id(Ecto.UUID.t() | any()) :: {:ok, Canvas.t()} | {:error, any()}
  defdelegate get_canvas_by_id(id), to: Get, as: :by_id

  @doc """
  Do a drawing operation on `canvas`, given the `canvas_id` and the operation `params`.

  If the operation is successful, will persist the changes to the canvas.
  Otherwise, returns `{:error, reason}`

  The operations that are implemented are `draw rectangle` and `flood fill`.

  ## Draw Rectangle

  Rectangles must have an `x` and `y` coordinates of it's starting point,
  a `width`, a `height`, and can have a `fill`, an `outline`, or both.

  ```
  # a canvas with width = 10, height = 5, fill = 'o'
  # after a draw operation with command = rectangle,
  # x = 2, y = 1, width = 5, height = 3, fill = '-', outline = 'X'
            0 1 2 3 4 5 6 7 8 9 (x axis)
            _ _ _ _ _ _ _ _ _ _
        0 | o o o o o o o o o o
        1 | o o X X X X X o o o
        2 | o o X - - - X o o o
        3 | o o X X X X X o o o
        4 | o o o o o o o o o o
  (y axis)
  ```

  Returns updated `canvas` if the params are valid.
  Otherwise, returns {:error, :bad_request}.

  ## Examples
      iex> canvas_attrs = %{width: 3, height: 5, fill: " ", user_id: Ecto.UUID.generate()}
      iex> {:ok, %{id: id}} = Canvex.new_canvas(canvas_attrs)
      iex> rectangle_attrs = %{command: "rectangle", x: 0, y: 0, width: 3, height: 3, fill: "x"}
      iex> _canvas = Canvex.draw_on_canvas(id, rectangle_attrs)

      iex> canvas_attrs = %{width: 3, height: 5, fill: " ", user_id: Ecto.UUID.generate()}
      iex> {:ok, %{id: id}} = Canvex.new_canvas(canvas_attrs)
      iex> rectangle_attrs = %{command: "rectangle", x: 0, y: 0, width: 3, height: 3, outline: "o"}
      iex> _canvas = Canvex.draw_on_canvas(id, rectangle_attrs)

      iex> canvas_attrs = %{width: 3, height: 5, fill: " ", user_id: Ecto.UUID.generate()}
      iex> {:ok, %{id: id}} = Canvex.new_canvas(canvas_attrs)
      iex> rectangle_attrs = %{command: "rectangle", x: 0, y: 0, width: 3, height: 3}
      iex> {:error, :bad_request} = Canvex.draw_on_canvas(id, rectangle_attrs)

  ## Flood Fill

  Does a `flood fill` operation on the `canvas`.

  A flood fill operation draws the `fill` character to the start `x` and `y` coordinates, and continues
  to attempt drawing the character around (up, down, left, right) in each direction from the
  position it was drawn at, as long as a different character, or a border of the canvas, is not reached.
  ```
  # a canvas with width = 10, height = 5, fill = 'o'
  # after a draw operation with command = "rectangle",
  # x = 2, y = 1, width = 5, height = 3, fill = '-', outline = 'X'
  # and after a draw operation with command = "flood_fill",
  # x = 4, y = 3, fill = 'W'
            0 1 2 3 4 5 6 7 8 9 (x axis)
            _ _ _ _ _ _ _ _ _ _
        0 | o o o o o o o o o o
        1 | o o W W W W W o o o
        2 | o o W - - - W o o o
        3 | o o W W W W W o o o
        4 | o o o o o o o o o o
  (y axis)
  ```
  ## Examples
      iex> canvas_attrs = %{width: 3, height: 5, fill: " ", user_id: Ecto.UUID.generate()}
      iex> {:ok, %{id: id}} = Canvex.new_canvas(canvas_attrs)
      iex> flood_fill_attrs = %{command: "flood_fill", x: 0, y: 0, fill: "x"}
      iex> _canvas = Canvex.draw_on_canvas(id, flood_fill_attrs)
  """
  @spec draw_on_canvas(Ecto.UUID.t() | any(), map()) :: {:ok, Canvas.t()} | {:error, term()}
  defdelegate draw_on_canvas(canvas_id, params), to: Draw, as: :call
end
