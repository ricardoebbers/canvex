defmodule Canvex.Draw.FloodFillTest do
  use Canvex.DataCase, async: true

  alias Canvex.Canvas.Create
  alias Canvex.Draw.{FloodFill, Rectangle}

  describe "call/3" do
    setup do
      {:ok, canvas} =
        Create.call(%{width: 10, height: 10, fill: ' ', user_id: Ecto.UUID.generate()})

      canvas =
        canvas
        |> Rectangle.call(%{x: 1, y: 1, width: 8, height: 5, outline: '*'})
        |> Rectangle.call(%{x: 3, y: 2, width: 3, height: 5, fill: '_', outline: 'o'})
        |> Rectangle.call(%{x: 6, y: 7, width: 3, height: 3, fill: '+'})

      %{canvas: canvas}
    end

    test "should fill a contiguous area", %{canvas: canvas} do
      assert [
               '          ',
               ' ******** ',
               ' * ooo  * ',
               ' * o_o  * ',
               ' * o_o  * ',
               ' **o_o*** ',
               '   ooo    ',
               '      +++ ',
               '      +++ ',
               '      +++ '
             ] = matrix(canvas)

      assert [
               'xxxxxxxxxx',
               'x********x',
               'x* ooo  *x',
               'x* o_o  *x',
               'x* o_o  *x',
               'x**o_o***x',
               'xxxoooxxxx',
               'xxxxxx+++x',
               'xxxxxx+++x',
               'xxxxxx+++x'
             ] = FloodFill.call(canvas, %{x: 0, y: 0, fill: 'x'}) |> matrix()
    end

    test "should fill an outline", %{canvas: canvas} do
      assert [
               '          ',
               ' xxxxxxxx ',
               ' x ooo  x ',
               ' x o_o  x ',
               ' x o_o  x ',
               ' xxo_oxxx ',
               '   ooo    ',
               '      +++ ',
               '      +++ ',
               '      +++ '
             ] = FloodFill.call(canvas, %{x: 1, y: 1, fill: 'x'}) |> matrix()
    end

    test "should not jump other chars", %{canvas: canvas} do
      assert [
               '          ',
               ' ******** ',
               ' *xooo  * ',
               ' *xo_o  * ',
               ' *xo_o  * ',
               ' **o_o*** ',
               '   ooo    ',
               '      +++ ',
               '      +++ ',
               '      +++ '
             ] = FloodFill.call(canvas, %{x: 2, y: 2, fill: 'x'}) |> matrix()
    end

    test "should do nothing when target char is the same of fill char", %{canvas: canvas} do
      assert matrix(canvas) ==
               FloodFill.call(canvas, %{x: 0, y: 0, fill: ' '}) |> matrix()
    end

    test "should do nothing when trying to fill out of bounds", %{canvas: canvas} do
      assert matrix(canvas) ==
               FloodFill.call(canvas, %{x: -2, y: 2, fill: 'x'}) |> matrix()
    end

    test "should do nothing when fill is a string equivalent to the target char", %{
      canvas: canvas
    } do
      assert matrix(canvas) ==
               FloodFill.call(canvas, %{x: 0, y: 0, fill: " "}) |> matrix()
    end
  end
end
