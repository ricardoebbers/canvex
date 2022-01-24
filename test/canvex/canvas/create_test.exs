defmodule Canvex.Canvas.CreateTest do
  use Canvex.DataCase

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

    test "should store and return a canvas given a charlist and a width" do
      canvas =
        %{
          "width" => 5,
          "charlist" => 'ooooooxxxooxoxooxoxooxxxoooooo',
          "user_id" => Ecto.UUID.generate()
        }
        |> Create.call()

      assert {:ok,
              %Canvas{
                charlist: 'ooooooxxxooxoxooxoxooxxxoooooo',
                height: 6,
                width: 5
              }} = canvas
    end

    test "should return error when there are missing parameters" do
      canvas = Create.call(%{})

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  fill: {"can't be blank", [validation: :required]},
                  height: {"can't be blank", [validation: :required]},
                  user_id: {"can't be blank", [validation: :required]},
                  width: {"can't be blank", [validation: :required]}
                ]
              }} = canvas
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

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  fill: {"is invalid", [type: Canvex.Type.ASCIIPrintable, validation: :cast]}
                ]
              }} = canvas
    end

    test "should return error when there are invalid chars on charlist" do
      canvas =
        %{
          "width" => 1,
          "charlist" => 'ñão',
          "user_id" => Ecto.UUID.generate()
        }
        |> Create.call()

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  charlist:
                    {"is invalid",
                     [type: {:array, Canvex.Type.ASCIIPrintable}, validation: :cast]}
                ]
              }} = canvas
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

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  width:
                    {"must be greater than %{number}",
                     [validation: :number, kind: :greater_than, number: 0]},
                  height:
                    {"must be greater than %{number}",
                     [validation: :number, kind: :greater_than, number: 0]}
                ]
              }} = canvas
    end

    test "should return error if generated canvas have zero height" do
      canvas =
        %{
          "width" => 5,
          "charlist" => 'oooo',
          "user_id" => Ecto.UUID.generate()
        }
        |> Create.call()

      assert {:error,
              %Ecto.Changeset{
                errors: [
                  height:
                    {"must be greater than %{number}",
                     [validation: :number, kind: :greater_than, number: 0]}
                ]
              }} = canvas
    end
  end
end
