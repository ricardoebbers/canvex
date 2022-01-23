defmodule Core.Draw.FloodFillTest do
  use ExUnit.Case

  alias Core.Canvas
  alias Core.Draw.FloodFill

  describe "call/3" do
    setup do
      canvas =
        Canvas.new(%{width: 15, height: 15}, ' ')
        |> Core.draw_rectangle(%{x: 2, y: 4}, %{width: 7, height: 6}, nil, 'Z')
        |> Core.draw_rectangle(%{x: 4, y: 4}, %{width: 3, height: 8}, '1', '0')
        |> Core.draw_rectangle(%{x: 9, y: 10}, %{width: 3, height: 3}, 'W', nil)

      %{canvas: canvas}
    end

    test "should fill a contiguous area", %{canvas: canvas} do
      assert [
               ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'Z', 'Z', '0', '0', '0', 'Z', 'Z', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'Z', ' ', '0', '1', '0', ' ', 'Z', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'Z', ' ', '0', '1', '0', ' ', 'Z', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'Z', ' ', '0', '1', '0', ' ', 'Z', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'Z', ' ', '0', '1', '0', ' ', 'Z', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'Z', 'Z', '0', '1', '0', 'Z', 'Z', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', '0', '1', '0', 'x', 'x', 'W', 'W', 'W', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', '0', '0', '0', 'x', 'x', 'W', 'W', 'W', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'W', 'W', 'W', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x'],
               ['x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x', 'x']
             ] == FloodFill.call(canvas, %{x: 0, y: 0}, 'x') |> Core.matrix()
    end

    test "should fill an outline", %{canvas: canvas} do
      assert [
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', 'Z', 'x', 'x', 'x', 'Z', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', ' ', 'x', '1', 'x', ' ', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', ' ', 'x', '1', 'x', ' ', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', ' ', 'x', '1', 'x', ' ', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', ' ', 'x', '1', 'x', ' ', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', 'Z', 'x', '1', 'x', 'Z', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', 'x', '1', 'x', ' ', ' ', 'W', 'W', 'W', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', 'x', 'x', 'x', ' ', ' ', 'W', 'W', 'W', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'W', 'W', 'W', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
             ] == FloodFill.call(canvas, %{x: 4, y: 4}, 'x') |> Core.matrix()
    end

    test "should not jump other chars", %{canvas: canvas} do
      assert [
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', 'Z', '0', '0', '0', 'Z', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', 'x', '0', '1', '0', ' ', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', 'x', '0', '1', '0', ' ', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', 'x', '0', '1', '0', ' ', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', 'x', '0', '1', '0', ' ', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', 'Z', 'Z', '0', '1', '0', 'Z', 'Z', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', '0', '1', '0', ' ', ' ', 'W', 'W', 'W', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', '0', '0', '0', ' ', ' ', 'W', 'W', 'W', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', 'W', 'W', 'W', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '],
               [' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ', ' ']
             ] == FloodFill.call(canvas, %{x: 3, y: 5}, 'x') |> Core.matrix()
    end

    test "should do nothing when target char is the same of fill char", %{canvas: canvas} do
      assert canvas |> Core.matrix() ==
               FloodFill.call(canvas, %{x: 4, y: 4}, '0') |> Core.matrix()
    end
  end
end
