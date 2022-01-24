defmodule Canvex.CanvasesTest do
  use Canvex.DataCase

  alias Canvex.Canvases

  describe "canvases" do
    alias Canvex.Canvases.Canvas

    import Canvex.CanvasesFixtures

    @invalid_attrs %{height: nil, user_id: nil, values: nil, width: nil}

    test "list_canvases/0 returns all canvases" do
      canvas = canvas_fixture()
      assert Canvases.list_canvases() == [canvas]
    end

    test "get_canvas!/1 returns the canvas with given id" do
      canvas = canvas_fixture()
      assert Canvases.get_canvas!(canvas.id) == canvas
    end

    test "create_canvas/1 with valid data creates a canvas" do
      valid_attrs = %{height: 42, user_id: "7488a646-e31f-11e4-aace-600308960662", values: %{}, width: 42}

      assert {:ok, %Canvas{} = canvas} = Canvases.create_canvas(valid_attrs)
      assert canvas.height == 42
      assert canvas.user_id == "7488a646-e31f-11e4-aace-600308960662"
      assert canvas.values == %{}
      assert canvas.width == 42
    end

    test "create_canvas/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Canvases.create_canvas(@invalid_attrs)
    end

    test "update_canvas/2 with valid data updates the canvas" do
      canvas = canvas_fixture()
      update_attrs = %{height: 43, user_id: "7488a646-e31f-11e4-aace-600308960668", values: %{}, width: 43}

      assert {:ok, %Canvas{} = canvas} = Canvases.update_canvas(canvas, update_attrs)
      assert canvas.height == 43
      assert canvas.user_id == "7488a646-e31f-11e4-aace-600308960668"
      assert canvas.values == %{}
      assert canvas.width == 43
    end

    test "update_canvas/2 with invalid data returns error changeset" do
      canvas = canvas_fixture()
      assert {:error, %Ecto.Changeset{}} = Canvases.update_canvas(canvas, @invalid_attrs)
      assert canvas == Canvases.get_canvas!(canvas.id)
    end

    test "delete_canvas/1 deletes the canvas" do
      canvas = canvas_fixture()
      assert {:ok, %Canvas{}} = Canvases.delete_canvas(canvas)
      assert_raise Ecto.NoResultsError, fn -> Canvases.get_canvas!(canvas.id) end
    end

    test "change_canvas/1 returns a canvas changeset" do
      canvas = canvas_fixture()
      assert %Ecto.Changeset{} = Canvases.change_canvas(canvas)
    end
  end
end
