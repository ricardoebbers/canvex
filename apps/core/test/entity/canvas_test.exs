defmodule Core.Entity.CanvasTest do
  use ExUnit.Case

  alias Core.Entity.Canvas

  doctest Canvas

  describe "new/0" do
    test "should create a new canvas with default size and fill" do
      assert %Canvas{
               cols: 3,
               rows: 3,
               values: %{
                 {0, 0} => '.',
                 {0, 1} => '.',
                 {0, 2} => '.',
                 {1, 0} => '.',
                 {1, 1} => '.',
                 {1, 2} => '.',
                 {2, 0} => '.',
                 {2, 1} => '.',
                 {2, 2} => '.'
               }
             } == Canvas.new()
    end
  end

  describe "new/2" do
    test "should create a new canvas with given size and fill" do
      size = %{width: 1, height: 2}
      fill = '#'

      assert %Canvas{cols: 2, rows: 1, values: %{{0, 0} => '#', {0, 1} => '#'}} ==
               Canvas.new(size, fill)
    end
  end

  describe "get/2" do
    test "should get a value from given coordinates of a canvas" do
      size = %{width: 1, height: 3}
      fill = '#'
      canvas = Canvas.new(size, fill)
      coordinates = %{x: 0, y: 2}
      assert '#' == Canvas.get(canvas, coordinates)
    end

    test "should return nil if given coordinates are out of bounds" do
      size = %{width: 1, height: 3}
      fill = '#'
      canvas = Canvas.new(size, fill)
      coordinates = %{x: 5, y: 2}
      assert nil == Canvas.get(canvas, coordinates)
    end
  end

  describe "update/3" do
    test "should update a value of given coordinates on the canvas" do
      size = %{width: 2, height: 2}
      fill = '#'
      canvas = Canvas.new(size, fill)
      coordinates = %{x: 1, y: 0}

      assert %Canvas{
               cols: 2,
               rows: 2,
               values: %{{0, 0} => '#', {0, 1} => '#', {1, 0} => '.', {1, 1} => '#'}
             } == Canvas.put(canvas, coordinates, '.')
    end

    test "should not update out of bounds" do
      size = %{width: 2, height: 2}
      fill = '#'
      canvas = Canvas.new(size, fill)
      coordinates = %{x: 3, y: 3}

      assert %Core.Entity.Canvas{
               cols: 2,
               rows: 2,
               values: %{
                 {0, 0} => '#',
                 {0, 1} => '#',
                 {1, 0} => '#',
                 {1, 1} => '#'
               }
             } ==
               Canvas.put(canvas, coordinates, '.')
    end
  end

  describe "to_matrix/1" do
    test "should return a list of lists of values from canvas" do
      size = %{width: 3, height: 3}
      fill = '.'
      canvas = Canvas.new(size, fill)

      assert [['.', '.', '.'], ['.', '.', '.'], ['.', '.', '.']] ==
               Canvas.to_matrix(canvas)
    end

    test "should keep rows and columns ordered correctly" do
      size = %{width: 5, height: 5}
      fill = '.'
      coordinates = %{x: 1, y: 2}
      canvas = Canvas.new(size, fill) |> Canvas.put(coordinates, '#')

      assert [
               ['.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.'],
               ['.', '#', '.', '.', '.'],
               ['.', '.', '.', '.', '.'],
               ['.', '.', '.', '.', '.']
             ] == Canvas.to_matrix(canvas)
    end
  end
end
