defmodule Canvex.Draw.CanvasTest do
  use Canvex.DataCase, async: true

  alias Canvex.Draw.Canvas
  alias Canvex.Canvas.Create

  describe "get_value_at/2" do
    setup do
      {:ok, canvas} =
        %{width: 1, height: 3, fill: '#', user_id: Ecto.UUID.generate()}
        |> Create.call()

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
      {:ok, canvas} =
        %{width: 5, height: 2, fill: 'o', user_id: Ecto.UUID.generate()}
        |> Create.call()

      %{canvas: canvas}
    end

    test "should update a value of given coordinates on the canvas", %{canvas: canvas} do
      assert %{charlist: 'ooooooxooo'} =
               Canvas.put_value_at(canvas, {1, 1}, 'x') |> Canvas.update_charlist()
    end

    test "should not update out of bounds", %{canvas: canvas} do
      assert %{charlist: 'oooooooooo'} = Canvas.put_value_at(canvas, {3, 3}, 'x')
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
