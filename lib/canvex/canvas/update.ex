defmodule Canvex.Canvas.Update do
  @moduledoc false

  alias Canvex.Canvas.Get
  alias Canvex.Repo
  alias Canvex.Schema.Canvas

  def call(attrs = %{"id" => id}), do: do_call(id, attrs)

  def call(canvas = %Canvas{id: id}), do: do_call(id, canvas)

  def call(_), do: {:error, :bad_request}

  defp do_call(id, attrs) do
    Get.by_id(id)
    |> case do
      {:ok, canvas} -> do_update(canvas, attrs)
      error -> error
    end
  end

  defp do_update(canvas, attrs) do
    canvas
    |> Canvas.changeset(attrs)
    |> Repo.update()
  end
end
