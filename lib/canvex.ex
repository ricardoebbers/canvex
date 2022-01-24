defmodule Canvex do
  @moduledoc """
  Canvex is an ASCII art drawing canvas in Elixir.

  ## Canvas

  Canvas are identifiable with a global unique identifier in the form of an UUID.
  They are represented as a matrix of `chars`, all being ASCII printable.

  ## Operations

  It's possible to `draw rectangles` and `flood fill` a canvas with ASCII printable
  `chars`.

  To create a new canvas call `Canvex.new_canvas/1`.

  It's possible to fetch a previously created canvas from the database
  by calling `Canvex.get_canvas_by_id/1`.

  After that, you can `draw rectangles` on the canvas by calling `Canvex.draw_rectangle/2`,
  passing the canvas you created and the corresponding `rectangle` parameters.

  Also, you can `flood fill` the canvas with a given `char` by calling `Canvex.flood_fill/2`.

  """
  alias Canvex.Canvas.{Create, Get, Update}
  alias Canvex.Draw.{FloodFill, Rectangle}
  alias Canvex.Schema.Canvas, as: CanvasSchema

  @doc """
  Creates a `canvas` given `width`, `height`, `fill`, and an UUID as `user_id`.

  Alternatively it's possible to create a canvas by passing a `charlist`, a `width`, and an UUID as `user_id`

  Returns {:ok, canvas} if the parameters are valid.
  Otherwise, returns {:error, changeset}

  ## Examples
      iex> attrs = %{"width" => 3, "height" => 5, "fill" => " ", "user_id" => Ecto.UUID.generate()}
      iex> {:ok, %{charlist: '               ', height: 5, width: 3}} = Canvex.new_canvas(attrs)

      iex> attrs = %{"width" => 3, "charlist" => 'xxxoooxxx', "user_id" => Ecto.UUID.generate()}
      iex> {:ok, %{charlist: 'xxxoooxxx', height: 3, width: 3}} = Canvex.new_canvas(attrs)

      iex> {:error, _changeset} = Canvex.new_canvas(%{})
  """
  @spec new_canvas(map) :: {:ok, CanvasSchema.t()} | {:error, Ecto.Changeset.t()}
  defdelegate new_canvas(attrs), to: Create, as: :call

  @doc """
  Fetches an existing `canvas` from the database.

  Returns {:ok, canvas} if the id is an UUID and the canvas exist.
  Otherwise, returns {:error, :not_found} for missing canvas or {:error, :bad_request} for invalid UUID.

  ## Examples
        iex> attrs = %{"width" => 3, "height" => 5, "fill" => " ", "user_id" => Ecto.UUID.generate()}
        iex> {:ok, %{id: id}} = Canvex.new_canvas(attrs)
        iex> {:ok, _canvas} = Canvex.get_canvas_by_id(id)

        iex> {:error, :bad_request} = Canvex.get_canvas_by_id("foo")

        iex> {:error, :not_found} = Canvex.get_canvas_by_id(Ecto.UUID.generate())
  """
  @spec get_canvas_by_id(String.t()) :: {:ok, any()} | {:error, term()}
  defdelegate get_canvas_by_id(id), to: Get, as: :by_id

  @doc """
  Updates a `canvas` on the database.

  Returns {:ok, canvas} if the update happens without problems.
  Otherwise, returns {:error, changeset}

  ## Examples
        iex> attrs = %{"width" => 3, "height" => 5, "fill" => " ", "user_id" => Ecto.UUID.generate()}
        iex> {:ok, canvas} = Canvex.new_canvas(attrs)
        iex> rectangle_attrs = %{x: 0, y: 0, width: 3, height: 3, fill: "x"}
        iex> modified_canvas = Canvex.draw_rectangle(canvas, rectangle_attrs)
        iex> Canvex.update_canvas(modified_canvas)
  """
  @spec update_canvas(any()) :: {:ok, CanvasSchema.t()} | {:error, Ecto.Changeset.t()}
  defdelegate update_canvas(canvas), to: Update, as: :call

  @doc """
  Draws a `rectangle` on the given `canvas`.

  Rectangles can have a `fill`, an `outline` or both.

  Does not update the canvas on the database! You need to call `Canvex.update_canvas/1` after!

  Returns modified `canvas` if the params are valid.
  Otherwise, returns {:error, :bad_request}.

  ## Examples
        iex> canvas_attrs = %{"width" => 3, "height" => 5, "fill" => " ", "user_id" => Ecto.UUID.generate()}
        iex> {:ok, canvas} = Canvex.new_canvas(canvas_attrs)
        iex> rectangle_attrs = %{x: 0, y: 0, width: 3, height: 3, fill: "x"}
        iex> _canvas = Canvex.draw_rectangle(canvas, rectangle_attrs)

        iex> canvas_attrs = %{"width" => 3, "height" => 5, "fill" => " ", "user_id" => Ecto.UUID.generate()}
        iex> {:ok, canvas} = Canvex.new_canvas(canvas_attrs)
        iex> rectangle_attrs = %{x: 0, y: 0, width: 3, height: 3, outline: "o"}
        iex> _canvas = Canvex.draw_rectangle(canvas, rectangle_attrs)

        iex> canvas_attrs = %{"width" => 3, "height" => 5, "fill" => " ", "user_id" => Ecto.UUID.generate()}
        iex> {:ok, canvas} = Canvex.new_canvas(canvas_attrs)
        iex> rectangle_attrs = %{x: 0, y: 0, width: 3, height: 3}
        iex> {:error, :bad_request} = Canvex.draw_rectangle(canvas, rectangle_attrs)
  """
  @spec draw_rectangle(any(), map()) :: any() | {:error, :bad_request}
  defdelegate draw_rectangle(canvas, attrs), to: Rectangle, as: :call

  @doc """
  Does a `flood fill` operation on the `canvas`.

  A flood fill operation draws the fill character to the start coordinate, and continues
  to attempt drawing the character around (up, down, left, right) in each direction from the
  position it was drawn at, as long as a different character, or a border of the canvas,
  is not reached.

  Does not update the canvas on the database! You need to call `Canvex.update_canvas/1` after!

  Returns modified `canvas`.

  ## Examples
        iex> canvas_attrs = %{"width" => 3, "height" => 5, "fill" => " ", "user_id" => Ecto.UUID.generate()}
        iex> {:ok, canvas} = Canvex.new_canvas(canvas_attrs)
        iex> flood_fill_attrs = %{x: 0, y: 0, fill: "x"}
        iex> _canvas = Canvex.flood_fill(canvas, flood_fill_attrs)
  """
  @spec flood_fill(any(), map()) :: any()
  defdelegate flood_fill(canvas, attrs), to: FloodFill, as: :call
end
