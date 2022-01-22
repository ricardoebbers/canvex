defmodule Core.Draw.RectangleTest do
  use ExUnit.Case

  alias Core.Canvas
  alias Core.Draw.Rectangle

  setup do
    canvas = Canvas.new(%{width: 10, height: 10}, '.')
    %{canvas: canvas}
  end

  describe "call/4" do
    test "should draw a rectangle outline", %{canvas: canvas} do
      starting_coordinates = %{x: 1, y: 1}
      size = %{width: 4, height: 5}

      assert [
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '#', '#', '#', '#', '.', '.', '.', '.', '.'],
               ['.', '#', '.', '.', '#', '.', '.', '.', '.', '.'],
               ['.', '#', '.', '.', '#', '.', '.', '.', '.', '.'],
               ['.', '#', '.', '.', '#', '.', '.', '.', '.', '.'],
               ['.', '#', '#', '#', '#', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.']
             ] ==
               canvas
               |> Rectangle.call(starting_coordinates, size, nil, '#')
               |> Canvas.matrix()
    end

    test "should draw a rectangle with fill", %{canvas: canvas} do
      starting_coordinates = %{x: 1, y: 1}
      size = %{width: 4, height: 5}

      assert [
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', 'W', 'W', 'W', 'W', '.', '.', '.', '.', '.'],
               ['.', 'W', 'W', 'W', 'W', '.', '.', '.', '.', '.'],
               ['.', 'W', 'W', 'W', 'W', '.', '.', '.', '.', '.'],
               ['.', 'W', 'W', 'W', 'W', '.', '.', '.', '.', '.'],
               ['.', 'W', 'W', 'W', 'W', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.']
             ] ==
               canvas
               |> Rectangle.call(starting_coordinates, size, 'W', nil)
               |> Canvas.matrix()
    end

    test "should draw multiple rectangles", %{canvas: canvas} do
      r1_starting_coordinates = %{x: 1, y: 1}
      r1_size = %{width: 4, height: 5}

      r2_starting_coordinates = %{x: 6, y: 1}
      r2_size = %{width: 3, height: 4}

      assert [
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '#', '#', '#', '#', '.', 'R', 'R', 'R', '.'],
               ['.', '#', ' ', ' ', '#', '.', 'R', 'A', 'R', '.'],
               ['.', '#', ' ', ' ', '#', '.', 'R', 'A', 'R', '.'],
               ['.', '#', ' ', ' ', '#', '.', 'R', 'R', 'R', '.'],
               ['.', '#', '#', '#', '#', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.']
             ] ==
               canvas
               |> Rectangle.call(r1_starting_coordinates, r1_size, ' ', '#')
               |> Rectangle.call(r2_starting_coordinates, r2_size, 'A', 'R')
               |> Canvas.matrix()
    end

    test "should draw overlapping rectangles", %{canvas: canvas} do
      r1_starting_coordinates = %{x: 1, y: 1}
      r1_size = %{width: 4, height: 5}

      r2_starting_coordinates = %{x: 2, y: 4}
      r2_size = %{width: 3, height: 5}

      assert [
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '#', '#', '#', '#', '.', '.', '.', '.', '.'],
               ['.', '#', '.', '.', '#', '.', '.', '.', '.', '.'],
               ['.', '#', '.', '.', '#', '.', '.', '.', '.', '.'],
               ['.', '#', 'R', 'R', 'R', '.', '.', '.', '.', '.'],
               ['.', '#', 'R', 'A', 'R', '.', '.', '.', '.', '.'],
               ['.', '.', 'R', 'A', 'R', '.', '.', '.', '.', '.'],
               ['.', '.', 'R', 'A', 'R', '.', '.', '.', '.', '.'],
               ['.', '.', 'R', 'R', 'R', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.']
             ] ==
               canvas
               |> Rectangle.call(r1_starting_coordinates, r1_size, nil, '#')
               |> Rectangle.call(r2_starting_coordinates, r2_size, 'A', 'R')
               |> Canvas.matrix()
    end

    test "should do nothing if neither fill nor outline are passed", %{canvas: canvas} do
      starting_coordinates = %{x: 1, y: 1}
      size = %{width: 4, height: 5}

      assert [
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.', '.', '.', '.', '.', '.']
             ] ==
               canvas
               |> Rectangle.call(starting_coordinates, size, nil, nil)
               |> Canvas.matrix()
    end
  end
end
