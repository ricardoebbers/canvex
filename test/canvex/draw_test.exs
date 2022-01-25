defmodule Canvex.DrawTest do
  use Canvex.DataCase, async: true

  alias Canvex.Draw

  describe "call/2" do
    setup do
      {:ok, %{id: id}} = Canvex.new_canvas(params_for(:canvas))
      %{id: id}
    end

    test "should draw rectangle", %{id: id} do
      params = params_for(:rectangle_with_fill)

      assert {:ok, %{charlist: 'ooo  ooo  ooo            '}} = Draw.call(id, params)
    end

    test "should draw multiple rectangles", %{id: id} do
      r1_params = params_for(:rectangle_with_fill)

      assert {:ok, %{charlist: 'ooo  ooo  ooo            '}} = Draw.call(id, r1_params)

      r2_params = params_for(:rectangle_with_outline, x: 1, y: 1)

      assert {:ok, %{charlist: 'ooo  oXXX oXoX  XXX      '}} = Draw.call(id, r2_params)
    end
  end
end
