defmodule Core.API do
  alias Core.{Canvas, Type}

  @type canvas :: Canvas.t()
  @type coordinates :: Type.coordinates()
  @type size :: Type.size()
  @type fill :: char()
  @type outline :: char()

  @spec new_canvas :: canvas
  defdelegate new_canvas, to: Canvas, as: :new

  # @spec draw_rectangle(canvas, coordinates, size, fill, outline) :: canvas
  # def draw_rectangle(canvas, coordinates, size, fill, outline) do
  #   %{}
  # end

  # @spec flood_fill(canvas, coordinates, fill) :: canvas
  # def flood_fill(canvas, coordinates, fill) do
  #   %{}
  # end
end
