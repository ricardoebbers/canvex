defmodule Core.CanvasTest do
  use ExUnit.Case

  alias Core.Canvas

  describe "new/0" do
    test "should create a new canvas with default size and fill" do
      assert %Canvas{
               cols: 5,
               rows: 5,
               values: %{
                 {0, 0} => ' ',
                 {0, 1} => ' ',
                 {0, 2} => ' ',
                 {1, 0} => ' ',
                 {1, 1} => ' ',
                 {1, 2} => ' ',
                 {2, 0} => ' ',
                 {2, 1} => ' ',
                 {2, 2} => ' ',
                 {0, 3} => ' ',
                 {0, 4} => ' ',
                 {1, 3} => ' ',
                 {1, 4} => ' ',
                 {2, 3} => ' ',
                 {2, 4} => ' ',
                 {3, 0} => ' ',
                 {3, 1} => ' ',
                 {3, 2} => ' ',
                 {3, 3} => ' ',
                 {3, 4} => ' ',
                 {4, 0} => ' ',
                 {4, 1} => ' ',
                 {4, 2} => ' ',
                 {4, 3} => ' ',
                 {4, 4} => ' '
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
      assert %Canvas{
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
      assert %Canvas{
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

      assert %Canvas{
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

  describe "charlist/1" do
    test "should return {charlist, canvas.cols} from a canvas" do
      size = %{width: 10, height: 1}
      fill = '#'
      assert {'##########', 10} == Canvas.new(size, fill) |> Canvas.charlist()
    end
  end

  describe "from_charlist/2" do
    test "should create a new canvas given a charlist and a width" do
      assert %Canvas{
               cols: 4,
               rows: 3,
               values: %{
                 {0, 0} => 'a',
                 {0, 1} => 'e',
                 {0, 2} => 'i',
                 {1, 0} => 'b',
                 {1, 1} => 'f',
                 {1, 2} => 'j',
                 {2, 0} => 'c',
                 {2, 1} => 'g',
                 {2, 2} => 'k',
                 {3, 0} => 'd',
                 {3, 1} => 'h',
                 {3, 2} => 'l'
               }
             } ==
               Canvas.from_charlist('abcdefghijkl', 4)
    end
  end

  describe "myers_difference/2" do
    test "should calculate the myers_difference from two different canvas" do
      c1 = Canvas.from_charlist('aaabbbccc', 3)
      c2 = Canvas.from_charlist('aaabbbddd', 3)
      assert {[eq: 'aaabbb', del: 'ccc', ins: 'ddd'], 3} == Canvas.myers_difference(c1, c2)
    end

    test "should return error when canvas have different shapes" do
      c1 = Canvas.from_charlist('aaaabbbbcccc', 3)
      c2 = Canvas.from_charlist('aaaabbbbdddd', 4)

      assert {:error, "Both canvas need to have the same shape"} ==
               Canvas.myers_difference(c1, c2)
    end
  end

  describe "from_myers_difference/2" do
    test "should create a new canvas" do
      myers_difference = [del: 'aaa', ins: 'bbb']

      assert %Canvas{
               cols: 1,
               rows: 3,
               values: %{{0, 0} => 'b', {0, 1} => 'b', {0, 2} => 'b'}
             } == Canvas.from_myers_difference(myers_difference, 1)
    end
  end
end
