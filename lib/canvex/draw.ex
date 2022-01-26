defmodule Canvex.Draw do
  @moduledoc """
  Aggregates all drawing operations on canvases.
  """

  alias Canvex.Canvas.Get, as: GetCanvas
  alias Canvex.Canvas.Update, as: UpdateCanvas
  alias Canvex.Draw.{FloodFill, Rectangle}
  alias Canvex.Schema.Canvas

  @spec call(Ecto.UUID.t() | any(), map()) ::
          {:ok, Canvas.t()} | {:error, :bad_request | :not_found}
  def call(canvas_id, params = %{command: "rectangle"}) do
    with {:ok, canvas = %Canvas{}} <- GetCanvas.by_id(canvas_id),
         canvas = %Canvas{} <- Rectangle.call(canvas, params) do
      UpdateCanvas.call(canvas)
    end
  end

  def call(canvas_id, params = %{command: "flood_fill"}) do
    with {:ok, canvas = %Canvas{}} <- GetCanvas.by_id(canvas_id),
         canvas = %Canvas{} <- FloodFill.call(canvas, params) do
      UpdateCanvas.call(canvas)
    end
  end
end
