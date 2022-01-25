defmodule Canvex.Canvas.GetTest do
  use Canvex.DataCase, async: true

  alias Canvex.Canvas.{Create, Get}
  alias Canvex.Schema.Canvas

  describe "by_id/1" do
    setup do
      {:ok, canvas} =
        %{
          "width" => 5,
          "height" => 5,
          "fill" => 'x',
          "user_id" => Ecto.UUID.generate()
        }
        |> Create.call()

      %{canvas: canvas}
    end

    test "should get an existing canvas from database", %{canvas: %{id: id}} do
      from_db = Get.by_id(id)

      assert {:ok,
              %Canvas{
                charlist: 'xxxxxxxxxxxxxxxxxxxxxxxxx',
                height: 5,
                id: ^id,
                width: 5
              }} = from_db
    end

    test "should return error not found for canvas that dont exist" do
      assert {:error, :not_found} = Get.by_id(Ecto.UUID.generate())
    end

    test "should return error bad request when given nil as id" do
      assert {:error, :bad_request} = Get.by_id(nil)
    end

    test "should return error bad request when id is not a uuid" do
      assert {:error, :bad_request} = Get.by_id("abc")
    end

    test "should return error when canvas is malformed on the database" do
      %{id: id} = insert(:canvas, charlist: nil)
      assert {:error, _reason} = Get.by_id(id)
    end
  end
end
