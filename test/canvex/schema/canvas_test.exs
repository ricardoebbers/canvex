defmodule Canvex.Draw.CanvasTest do
  use Canvex.DataCase, async: true

  alias Canvex.Canvas.Create
  alias Canvex.Schema.Canvas

  describe "put_value_at/3" do
    setup do
      {:ok, canvas} =
        %{width: 5, height: 2, fill: 'o', user_id: Ecto.UUID.generate()}
        |> Create.call()

      %{canvas: canvas}
    end

    test "should update a value of given coordinates on the canvas", %{canvas: canvas} do
      assert %{values: %{{1, 1} => 'x'}} = Canvas.put_value_at(canvas, {1, 1}, 'x')
    end

    test "should not update out of bounds", %{canvas: canvas} do
      canvas = Canvas.put_value_at(canvas, {3, 3}, 'x')
      refute Map.has_key?(canvas.values, {3, 3})
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
