defmodule Canvex.Canvas.UpdateTest do
  use Canvex.DataCase

  alias Canvex.Canvas.{Create, Update}
  alias Canvex.Draw.Line
  alias Canvex.Schema.Canvas

  describe "call/1" do
    setup do
      {:ok, canvas} =
        %{
          "width" => 3,
          "height" => 3,
          "fill" => ' ',
          "user_id" => Ecto.UUID.generate()
        }
        |> Create.call()

      %{canvas: canvas}
    end

    test "should store and return a canvas given a charlist and width", %{canvas: %{id: id}} do
      updated_canvas =
        %{
          "id" => id,
          "width" => 3,
          "charlist" => 'abcdefghi'
        }
        |> Update.call()

      assert {:ok,
              %Canvas{
                charlist: 'abcdefghi',
                height: 3,
                id: ^id,
                width: 3
              }} = updated_canvas
    end

    test "should store and return a canvas given another canvas", %{canvas: canvas = %{id: id}} do
      changed_canvas = Line.horizontal(canvas, %{x: 0, y: 0, size: 2, stroke: '-'})

      assert {:ok,
              %Canvas{
                id: ^id,
                charlist: '--       '
              }} = Update.call(changed_canvas)
    end

    test "should return errors when passed invalid attrs", %{canvas: %{id: id}} do
      attrs = %{
        "id" => id,
        "width" => 0,
        "height" => -1,
        "fill" => 'ñ',
        "charlist" => 'não'
      }

      assert %{
               charlist: ["is invalid"],
               fill: ["is invalid"],
               height: ["must be greater than 0"],
               width: ["must be greater than 0"]
             } = attrs |> Update.call() |> errors_on()
    end

    test "should return error bad request when missing id" do
      assert {:error, :bad_request} = Update.call(%{})
    end

    test "should return error bad request when called with nil" do
      assert {:error, :bad_request} = Update.call(nil)
    end

    test "should return error not found when canvas dont exist" do
      assert {:error, :not_found} = Update.call(%{"id" => Ecto.UUID.generate()})
    end
  end
end
