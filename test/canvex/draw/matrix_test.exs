defmodule Canvex.Draw.MatrixTest do
  use ExUnit.Case

  alias Canvex.Draw.{Canvas, Matrix}

  describe "matrix/1" do
    test "should return a list of lists of values from canvas" do
      canvas = Canvas.new(%{width: 5, height: 5, fill: 'o'})

      assert [
               'ooooo',
               'ooooo',
               'ooooo',
               'ooooo',
               'ooooo'
             ] = Matrix.from_canvas(canvas)
    end

    test "should keep rows and columns ordered correctly" do
      canvas =
        %{width: 5, height: 3, fill: 'o'}
        |> Canvas.new()
        |> Canvas.put_value_at({1, 2}, 'x')

      assert [
               'ooooo',
               'ooooo',
               'oxooo'
             ] = Matrix.from_canvas(canvas)
    end
  end
end
