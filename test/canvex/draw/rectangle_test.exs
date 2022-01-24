defmodule Canvex.Draw.RectangleTest do
  use ExUnit.Case

  alias Canvex.Draw.{Canvas, Matrix, Rectangle}

  setup do
    canvas = Canvas.new(%{width: 5, height: 5, fill: ' '})
    %{canvas: canvas}
  end

  describe "call/2" do
    test "should draw a rectangle outline", %{canvas: canvas} do
      args = %{origin: {1, 1}, width: 3, height: 3, outline: 'x'}

      assert [
               '     ',
               ' xxx ',
               ' x x ',
               ' xxx ',
               '     '
             ] =
               canvas
               |> Rectangle.call(args)
               |> Matrix.from_canvas()
    end

    test "should draw a rectangle with fill", %{canvas: canvas} do
      args = %{origin: {1, 1}, width: 3, height: 3, fill: 'o'}

      assert [
               '     ',
               ' ooo ',
               ' ooo ',
               ' ooo ',
               '     '
             ] =
               canvas
               |> Rectangle.call(args)
               |> Matrix.from_canvas()
    end

    test "should draw a rectangle with fill and outline", %{canvas: canvas} do
      args = %{origin: {1, 1}, width: 3, height: 3, fill: 'o', outline: 'x'}

      assert [
               '     ',
               ' xxx ',
               ' xox ',
               ' xxx ',
               '     '
             ] =
               canvas
               |> Rectangle.call(args)
               |> Matrix.from_canvas()
    end

    test "should draw multiple rectangles", %{canvas: canvas} do
      args_r1 = %{origin: {0, 0}, width: 3, height: 3, outline: 'x'}
      args_r2 = %{origin: {2, 3}, width: 3, height: 2, fill: 'o'}

      assert [
               'xxx  ',
               'x x  ',
               'xxx  ',
               '  ooo',
               '  ooo'
             ] =
               canvas
               |> Rectangle.call(args_r1)
               |> Rectangle.call(args_r2)
               |> Matrix.from_canvas()
    end

    test "should draw overlapping rectangles", %{canvas: canvas} do
      args_r1 = %{origin: {0, 0}, width: 4, height: 4, outline: 'x'}
      args_r2 = %{origin: {2, 1}, width: 3, height: 4, fill: 'o'}

      assert [
               'xxxx ',
               'x ooo',
               'x ooo',
               'xxooo',
               '  ooo'
             ] =
               canvas
               |> Rectangle.call(args_r1)
               |> Rectangle.call(args_r2)
               |> Matrix.from_canvas()
    end

    test "should do nothing if neither fill nor outline are passed", %{canvas: canvas} do
      args = %{origin: {1, 1}, width: 3, height: 3}

      assert {:error, _reason} = Rectangle.call(canvas, args)
    end
  end
end
