defmodule CanvexWeb.CanvasControllerTest do
  use CanvexWeb.ConnCase, async: true

  describe "create/2" do
    test "should render a canvas when params are valid", %{conn: conn} do
      params = string_params_for(:canvas)

      conn = post(conn, Routes.canvas_path(conn, :create), params)

      assert %{
               "charlist" => ["     ", "     ", "     ", "     ", "     "],
               "height" => 5,
               "width" => 5
             } = json_response(conn, 201)["data"]
    end

    test "should render errors when params are missing", %{conn: conn} do
      conn = post(conn, Routes.canvas_path(conn, :create), %{})

      assert %{
               "fill" => ["can't be blank"],
               "height" => ["can't be blank"],
               "user_id" => ["can't be blank"],
               "width" => ["can't be blank"]
             } = json_response(conn, 422)["errors"]
    end

    test "should render errors when params are invalid", %{conn: conn} do
      params = string_params_for(:canvas, height: -1, width: 0, fill: "não", user_id: "abcd")
      conn = post(conn, Routes.canvas_path(conn, :create), params)

      assert %{
               "fill" => ["is invalid"],
               "height" => ["must be greater than 0"],
               "user_id" => ["is invalid"],
               "width" => ["must be greater than 0"]
             } = json_response(conn, 422)["errors"]
    end

    test "should render errors when width and height are too big", %{conn: conn} do
      params = string_params_for(:canvas, height: 501, width: 501)
      conn = post(conn, Routes.canvas_path(conn, :create), params)

      assert %{
               "height" => ["must be less than or equal to 500"],
               "width" => ["must be less than or equal to 500"]
             } = json_response(conn, 422)["errors"]
    end

    test "should ignore id passed on params", %{conn: conn} do
      id = Ecto.UUID.generate()
      params = string_params_for(:canvas, id: id)
      conn = post(conn, Routes.canvas_path(conn, :create), params)

      refute id == json_response(conn, 201)["data"]["id"]
    end
  end

  describe "show/2" do
    setup do
      {:ok, %{id: id}} = Canvex.new_canvas(params_for(:canvas))
      %{id: id}
    end

    test "should render a canvas", %{conn: conn, id: id} do
      conn = get(conn, Routes.canvas_path(conn, :show, id))

      assert %{
               "charlist" => ["     ", "     ", "     ", "     ", "     "],
               "height" => 5,
               "id" => ^id,
               "user_id" => _user_id,
               "width" => 5
             } = json_response(conn, 200)["data"]
    end

    test "should render error not found when canvas don't exist", %{conn: conn} do
      conn = get(conn, Routes.canvas_path(conn, :show, Ecto.UUID.generate()))
      assert %{"error" => "Not found"} = json_response(conn, 404)
    end

    test "should render error bad request when id is not an uuid", %{conn: conn} do
      conn = get(conn, Routes.canvas_path(conn, :show, "foo"))
      assert %{"error" => "Bad request"} = json_response(conn, 400)
    end
  end

  describe "draw/2" do
    setup do
      {:ok, %{id: id}} = Canvex.new_canvas(params_for(:canvas))
      %{id: id}
    end

    test "should render canvas with a rectangle with outline", %{conn: conn, id: id} do
      params = string_params_for(:rectangle_with_outline)
      conn = put(conn, Routes.canvas_path(conn, :draw, id), params)

      assert %{
               "charlist" => ["XXX  ", "X X  ", "XXX  ", "     ", "     "],
               "height" => 5,
               "id" => ^id,
               "user_id" => _user_id,
               "width" => 5
             } = json_response(conn, 200)["data"]
    end

    test "should render canvas with a rectangle with fill", %{conn: conn, id: id} do
      params = string_params_for(:rectangle_with_fill)
      conn = put(conn, Routes.canvas_path(conn, :draw, id), params)

      assert %{
               "charlist" => ["ooo  ", "ooo  ", "ooo  ", "     ", "     "],
               "height" => 5,
               "id" => ^id,
               "user_id" => _user_id,
               "width" => 5
             } = json_response(conn, 200)["data"]
    end

    test "should render canvas with a rectangle with fill and outline", %{conn: conn, id: id} do
      params = string_params_for(:rectangle_with_fill_and_outline)
      conn = put(conn, Routes.canvas_path(conn, :draw, id), params)

      assert %{
               "charlist" => ["XXX  ", "XoX  ", "XXX  ", "     ", "     "],
               "height" => 5,
               "id" => ^id,
               "user_id" => _user_id,
               "width" => 5
             } = json_response(conn, 200)["data"]
    end

    test "should render canvas after flood fill", %{conn: conn, id: id} do
      params = string_params_for(:flood_fill)
      conn = put(conn, Routes.canvas_path(conn, :draw, id), params)

      assert %{
               "charlist" => ["xxxxx", "xxxxx", "xxxxx", "xxxxx", "xxxxx"],
               "height" => 5,
               "id" => ^id,
               "user_id" => _user_id,
               "width" => 5
             } = json_response(conn, 200)["data"]
    end

    test "should render canvas after flood fill when fill is a blank space", %{conn: conn, id: id} do
      params = string_params_for(:flood_fill)
      conn = put(conn, Routes.canvas_path(conn, :draw, id), params)

      assert %{"charlist" => ["xxxxx", "xxxxx", "xxxxx", "xxxxx", "xxxxx"]} =
               json_response(conn, 200)["data"]

      params = string_params_for(:flood_fill, fill: " ")
      conn = put(conn, Routes.canvas_path(conn, :draw, id), params)

      assert %{
               "charlist" => ["     ", "     ", "     ", "     ", "     "],
               "height" => 5,
               "id" => ^id,
               "user_id" => _user_id,
               "width" => 5
             } = json_response(conn, 200)["data"]
    end

    test "should render error when params are missing", %{conn: conn, id: id} do
      conn = put(conn, Routes.canvas_path(conn, :draw, id), %{})

      assert %{"command" => ["can't be blank"]} = json_response(conn, 422)["errors"]
    end

    test "should render error when rectangle params are missing", %{conn: conn, id: id} do
      conn = put(conn, Routes.canvas_path(conn, :draw, id), %{"command" => "rectangle"})

      assert %{
               "fill" => ["can't be blank"],
               "height" => ["can't be blank"],
               "outline" => ["can't be blank"],
               "width" => ["can't be blank"],
               "x" => ["can't be blank"],
               "y" => ["can't be blank"]
             } = json_response(conn, 422)["errors"]
    end

    test "should render error when flood fill params are missing", %{conn: conn, id: id} do
      conn = put(conn, Routes.canvas_path(conn, :draw, id), %{"command" => "flood_fill"})

      assert %{"fill" => ["can't be blank"], "x" => ["can't be blank"], "y" => ["can't be blank"]} =
               json_response(conn, 422)["errors"]
    end

    test "should render error when flood fill char is invalid", %{conn: conn, id: id} do
      params = string_params_for(:flood_fill, fill: "ñ")

      conn = put(conn, Routes.canvas_path(conn, :draw, id), params)

      assert %{"error" => "Char provided is not on the ASCII table."} = json_response(conn, 422)
    end
  end
end
