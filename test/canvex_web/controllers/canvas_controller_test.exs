defmodule CanvexWeb.CanvasControllerTest do
  use CanvexWeb.ConnCase

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
      params = string_params_for(:canvas, height: 500, width: 500)
      conn = post(conn, Routes.canvas_path(conn, :create), params)

      assert %{"height" => ["must be less than 500"], "width" => ["must be less than 500"]} =
               json_response(conn, 422)["errors"]
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
               "id" => _id,
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
end
