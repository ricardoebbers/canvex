defmodule Core do
  alias Core.Entity.Canvas
  @type canvas :: Canvas.t()
  @type coordinates :: %{
          x: non_neg_integer(),
          y: non_neg_integer()
        }
  @type size :: %{
          width: non_neg_integer(),
          height: non_neg_integer()
        }
  @type fill :: char()
  @type outline :: char()

  @spec new_canvas :: canvas
  def new_canvas do
    %{}
  end

  @spec draw_rectangle(canvas, coordinates, size, fill, outline) :: canvas
  def draw_rectangle(canvas, coordinates, size, fill, outline) do
    %{}
  end

  @spec flood_fill(canvas, coordinates, fill) :: canvas
  def flood_fill(canvas, coordinates, fill) do
    %{}
  end
end
