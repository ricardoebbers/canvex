defmodule Canvex.Draw.MatrixTest do
  use Canvex.DataCase, async: true

  alias Canvex.Draw.{Canvas, Matrix}
  alias Canvex.Canvas.Create

  describe "matrix/1" do
    test "should return a list of lists of values from canvas" do
      {:ok, canvas} =
        Create.call(%{width: 5, height: 5, fill: 'o', user_id: Ecto.UUID.generate()})

      assert [
               'ooooo',
               'ooooo',
               'ooooo',
               'ooooo',
               'ooooo'
             ] = Matrix.from_canvas(canvas)
    end

    test "should keep rows and columns ordered correctly" do
      {:ok, canvas} =
        Create.call(%{width: 5, height: 3, fill: 'o', user_id: Ecto.UUID.generate()})

      canvas = Canvas.put_value_at(canvas, {1, 2}, 'x')

      assert [
               'ooooo',
               'ooooo',
               'oxooo'
             ] = Matrix.from_canvas(canvas)
    end
  end
end
