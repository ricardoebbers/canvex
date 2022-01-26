defmodule CanvexWeb.PageControllerTest do
  use CanvexWeb.ConnCase, async: true

  test "GET /", %{conn: conn} do
    conn = get(conn, "/")
    assert html_response(conn, 200) =~ "Swagger UI"
  end
end
