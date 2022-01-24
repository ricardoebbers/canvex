defmodule Canvex.Draw.LineTest do
  use ExUnit.Case

  alias Canvex.Draw.{Canvas, Line, Matrix}

  setup do
    canvas = Canvas.new(%{width: 5, height: 5, fill: ' '})
    %{canvas: canvas}
  end

  describe "vertical/2" do
    test "should draw a vertical line", %{canvas: canvas} do
      args = %{origin: {2, 2}, size: 2, stroke: '|'}

      assert [
               '     ',
               '     ',
               '  |  ',
               '  |  ',
               '     '
             ] = Line.vertical(canvas, args) |> Matrix.from_canvas()
    end

    test "should draw up given negative size", %{canvas: canvas} do
      args = %{origin: {2, 2}, size: -2, stroke: '|'}

      assert [
               '     ',
               '  |  ',
               '  |  ',
               '     ',
               '     '
             ] = Line.vertical(canvas, args) |> Matrix.from_canvas()
    end

    test "should not draw past canvas boundaries", %{canvas: canvas} do
      args = %{origin: {2, 2}, size: 5, stroke: '|'}

      assert [
               '     ',
               '     ',
               '  |  ',
               '  |  ',
               '  |  '
             ] = Line.vertical(canvas, args) |> Matrix.from_canvas()
    end

    test "should return error when trying to draw non-ascii printable chars", %{canvas: canvas} do
      args = %{origin: {2, 2}, size: 3, stroke: 'ñ'}

      assert {:error, _reason} = Line.vertical(canvas, args)
    end
  end

  describe "horizontal/2" do
    test "should draw a horizontal line", %{canvas: canvas} do
      args = %{origin: {2, 2}, size: 2, stroke: '-'}

      assert [
               '     ',
               '     ',
               '  -- ',
               '     ',
               '     '
             ] = Line.horizontal(canvas, args) |> Matrix.from_canvas()
    end

    test "should draw to the left given negative size", %{canvas: canvas} do
      args = %{origin: {2, 2}, size: -2, stroke: '-'}

      assert [
               '     ',
               '     ',
               ' --  ',
               '     ',
               '     '
             ] = Line.horizontal(canvas, args) |> Matrix.from_canvas()
    end

    test "should not draw past canvas boundaries", %{canvas: canvas} do
      args = %{origin: {2, 2}, size: 5, stroke: '-'}

      assert [
               '     ',
               '     ',
               '  ---',
               '     ',
               '     '
             ] = Line.horizontal(canvas, args) |> Matrix.from_canvas()
    end

    test "should return error when trying to draw non-ascii printable chars", %{canvas: canvas} do
      args = %{origin: {2, 2}, size: 2, stroke: 'ñ'}

      assert {:error, _reason} = Line.horizontal(canvas, args)
    end
  end
end
