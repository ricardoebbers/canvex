defmodule Canvex.CanvasesFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Canvex.Canvases` context.
  """

  @doc """
  Generate a canvas.
  """
  def canvas_fixture(attrs \\ %{}) do
    {:ok, canvas} =
      attrs
      |> Enum.into(%{
        height: 42,
        user_id: "7488a646-e31f-11e4-aace-600308960662",
        values: %{},
        width: 42
      })
      |> Canvex.Canvases.create_canvas()

    canvas
  end
end
