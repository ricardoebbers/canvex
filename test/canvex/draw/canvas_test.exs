defmodule Canvex.Draw.CanvasTest do
  use ExUnit.Case

  alias Canvex.Draw.Canvas

  describe "new/0" do
    test "should create a new canvas with default size and fill" do
      assert %Canvas{
               charlist: '                         ',
               height: 5,
               width: 5
             } = Canvas.new()
    end
  end

  describe "new/1" do
    test "should create a new canvas with given size and fill" do
      args = %{width: 1, height: 2, fill: '#'}

      assert %Canvas{charlist: '##', height: 2, width: 1} = Canvas.new(args)
    end

    test "should create a new canvas with given width and charlist" do
      args = %{width: 1, charlist: '######'}

      assert %Canvas{width: 1, height: 6} = Canvas.new(args)
    end

    test "should return error when trying to create canvas with non-ascii printable chars as fill" do
      args = %{width: 1, height: 2, fill: 'ã'}

      assert {:error, _reason} = Canvas.new(args)
    end

    test "should return error when trying to create canvas with multiple chars as fill" do
      args = %{width: 1, height: 2, fill: 'abcd'}

      assert {:error, _reason} = Canvas.new(args)
    end

    test "should return error when trying to create canvas with null fill" do
      args = %{width: 1, height: 2, fill: nil}

      assert {:error, _reason} = Canvas.new(args)
    end

    test "should return error when trying to create canvas with '' fill" do
      args = %{width: 1, height: 2, fill: ''}

      assert {:error, _reason} = Canvas.new(args)
    end
  end

  describe "get_value_at/2" do
    setup do
      canvas =
        %{width: 1, height: 3, fill: '#'}
        |> Canvas.new()

      %{canvas: canvas}
    end

    test "should get a value from given coordinates of a canvas", %{canvas: canvas} do
      assert '#' == Canvas.get_value_at(canvas, {0, 2})
    end

    test "should return nil if given coordinates are out of bounds", %{canvas: canvas} do
      assert nil == Canvas.get_value_at(canvas, {10, 10})
    end
  end

  describe "put_value_at/3" do
    setup do
      canvas =
        %{width: 5, height: 2, fill: 'o'}
        |> Canvas.new()

      %{canvas: canvas}
    end

    test "should update a value of given coordinates on the canvas", %{canvas: canvas} do
      assert %Canvas{charlist: 'ooooooxooo'} = Canvas.put_value_at(canvas, {1, 1}, 'x')
    end

    test "should not update out of bounds", %{canvas: canvas} do
      assert %Canvas{charlist: 'oooooooooo'} = Canvas.put_value_at(canvas, {3, 3}, 'x')
    end

    test "should return error when value is a non-ascii printable char", %{canvas: canvas} do
      assert {:error, _reason} = Canvas.put_value_at(canvas, {0, 0}, 'ã')
    end

    test "should return error when value is multiple chars", %{canvas: canvas} do
      assert {:error, _reason} = Canvas.put_value_at(canvas, {0, 0}, 'abc')
    end

    test "should return error when value is nil", %{canvas: canvas} do
      assert {:error, _reason} = Canvas.put_value_at(canvas, {0, 0}, nil)
    end
  end
end
