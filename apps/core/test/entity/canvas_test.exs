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

      assert %Canvas{cols: 1, rows: 2, values: %{{0, 0} => '#', {0, 1} => '#'}} ==
               Canvas.new(size, fill)
    end

    test "should return error when trying to create canvas with non-ascii printable chars as fill" do
      size = %{width: 1, height: 2}
      fill = 'ã'

      assert {:error, _reason} = Canvas.new(size, fill)
    end

    test "should return error when trying to create canvas with multiple chars as fill" do
      size = %{width: 1, height: 2}
      fill = 'abcd'

      assert {:error, _reason} = Canvas.new(size, fill)
    end

    test "should return error when trying to create canvas with null fill" do
      size = %{width: 1, height: 2}
      fill = nil

      assert {:error, _reason} = Canvas.new(size, fill)
    end

    test "should return error when trying to create canvas with '' fill" do
      size = %{width: 1, height: 2}
      fill = ''

      assert {:error, _reason} = Canvas.new(size, fill)
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

  describe "put/3" do
    setup do
      size = %{width: 2, height: 2}
      fill = '#'
      canvas = Canvas.new(size, fill)
      %{canvas: canvas}
    end

    test "should update a value of given coordinates on the canvas", %{canvas: canvas} do
      assert %Canvas{
               cols: 2,
               rows: 2,
               values: %{
                 {0, 0} => '#',
                 {0, 1} => '#',
                 {1, 0} => '.',
                 {1, 1} => '#'
               }
             } == Canvas.put(canvas, %{x: 1, y: 0}, '.')
    end

    test "should not update out of bounds", %{canvas: canvas} do
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
               Canvas.put(canvas, %{x: 3, y: 3}, '.')
    end

    test "should not update when value is a non-ascii printable char", %{canvas: canvas} do
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
               Canvas.put(canvas, %{x: 0, y: 0}, 'ã')
    end

    test "should not update when value is multiple chars", %{canvas: canvas} do
      coordinates = %{x: 0, y: 0}

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
               Canvas.put(canvas, coordinates, 'abc')
    end

    test "should return error when trying to create canvas with null fill" do
      size = %{width: 1, height: 2}
      fill = nil

      assert {:error, _reason} = Canvas.new(size, fill)
    end

    test "should return error when trying to create canvas with '' fill" do
      size = %{width: 1, height: 2}
      fill = ''

      assert {:error, _reason} = Canvas.new(size, fill)
    end
  end

  describe "matrix/1" do
    test "should return a list of lists of values from canvas" do
      size = %{width: 3, height: 3}
      fill = '.'
      canvas = Canvas.new(size, fill)

      assert [['.', '.', '.'], ['.', '.', '.'], ['.', '.', '.']] ==
               Canvas.matrix(canvas)
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
             ] == Canvas.matrix(canvas)
    end
  end
end
