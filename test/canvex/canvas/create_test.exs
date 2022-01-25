defmodule Canvex.Canvas.CreateTest do
  use Canvex.DataCase, async: true

  alias Canvex.Canvas.Create
  alias Canvex.Schema.Canvas

  describe "call/1" do
    test "should store and return a filled canvas" do
      canvas =
        %{
          "width" => 5,
          "height" => 5,
          "fill" => ' ',
          "user_id" => Ecto.UUID.generate()
        }
        |> Create.call()

      assert {:ok,
              %Canvas{
                width: 5,
                height: 5,
                charlist: '                         '
              }} = canvas
    end

    test "should return error when there are missing parameters" do
      canvas = Create.call(%{})

      assert %{
               fill: ["can't be blank"],
               height: ["can't be blank"],
               user_id: ["can't be blank"],
               width: ["can't be blank"]
             } = errors_on(canvas)
    end

    test "should return error when fill is invalid" do
      canvas =
        %{
          "width" => 5,
          "height" => 5,
          "fill" => 'à',
          "user_id" => Ecto.UUID.generate()
        }
        |> Create.call()

      assert %{fill: ["is invalid"]} = errors_on(canvas)
    end

    test "should return errors when height or width are not positive" do
      canvas =
        %{
          "width" => 0,
          "height" => -1,
          "fill" => ' ',
          "user_id" => Ecto.UUID.generate()
        }
        |> Create.call()

      assert %{height: ["must be greater than 0"], width: ["must be greater than 0"]} =
               errors_on(canvas)
    end
  end
end
