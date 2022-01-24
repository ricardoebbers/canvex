defmodule Canvex.Draw.FloodFillTest do
  use ExUnit.Case

  alias Canvex.Draw.{Canvas, FloodFill, Matrix, Rectangle}

  describe "call/3" do
    setup do
      canvas =
        Canvas.new(%{width: 10, height: 10, fill: ' '})
        |> Rectangle.call(%{origin: {1, 1}, width: 8, height: 5, outline: '*'})
        |> Rectangle.call(%{origin: {3, 2}, width: 3, height: 5, fill: '_', outline: 'o'})
        |> Rectangle.call(%{origin: {6, 7}, width: 3, height: 3, fill: '+'})

      %{canvas: canvas}
    end

    test "should fill a contiguous area", %{canvas: canvas} do
      assert [
               '          ',
               ' ******** ',
               ' * ooo  * ',
               ' * o o  * ',
               ' * o o  * ',
               ' **o*o*** ',
               '   ooo    ',
               '      +++ ',
               '      +++ ',
               '      +++ '
             ] = Matrix.from_canvas(canvas)

      assert [
               'xxxxxxxxxx',
               'x********x',
               'x* ooo  *x',
               'x* o o  *x',
               'x* o o  *x',
               'x**o*o***x',
               'xxxoooxxxx',
               'xxxxxx+++x',
               'xxxxxx+++x',
               'xxxxxx+++x'
             ] = FloodFill.call(canvas, %{origin: {0, 0}, fill: 'x'}) |> Matrix.from_canvas()
    end

    test "should fill an outline", %{canvas: canvas} do
      assert [
               '          ',
               ' xxxxxxxx ',
               ' x ooo  x ',
               ' x o o  x ',
               ' x o o  x ',
               ' xxo*oxxx ',
               '   ooo    ',
               '      +++ ',
               '      +++ ',
               '      +++ '
             ] = FloodFill.call(canvas, %{origin: {1, 1}, fill: 'x'}) |> Matrix.from_canvas()
    end

    test "should not jump other chars", %{canvas: canvas} do
      assert [
               '          ',
               ' ******** ',
               ' *xooo  * ',
               ' *xo o  * ',
               ' *xo o  * ',
               ' **o*o*** ',
               '   ooo    ',
               '      +++ ',
               '      +++ ',
               '      +++ '
             ] = FloodFill.call(canvas, %{origin: {2, 2}, fill: 'x'}) |> Matrix.from_canvas()
    end

    test "should do nothing when target char is the same of fill char", %{canvas: canvas} do
      assert Matrix.from_canvas(canvas) ==
               FloodFill.call(canvas, %{origin: {0, 0}, fill: ' '}) |> Matrix.from_canvas()
    end

    test "should do nothing when trying to fill out of bounds", %{canvas: canvas} do
      assert Matrix.from_canvas(canvas) ==
               FloodFill.call(canvas, %{origin: {-2, 2}, fill: 'x'}) |> Matrix.from_canvas()
    end
  end
end
