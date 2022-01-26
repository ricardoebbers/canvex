defmodule Canvex.Canvas.Update do
  @moduledoc """
  Updates a `canvas` on the database given `attrs` or an updated `canvas`.
  """

  alias Canvex.Canvas.Get
  alias Canvex.PubSub
  alias Canvex.Repo
  alias Canvex.Schema.Canvas

  @spec call(Canvas.t() | map()) :: {:ok, Canvas.t()} | {:error, :bad_request | :not_found}
  def call(attrs = %{"id" => id}), do: do_call(id, attrs)

  def call(canvas = %Canvas{id: id}), do: do_call(id, canvas)

  def call(_), do: {:error, :bad_request}

  defp do_call(id, attrs) do
    Get.by_id(id)
    |> case do
      {:ok, canvas = %Canvas{}} -> do_update(canvas, attrs)
      error -> error
    end
  end

  defp do_update(canvas = %Canvas{}, attrs) do
    canvas
    |> Canvas.update_changeset(attrs)
    |> Repo.update()
    |> case do
      {:ok, canvas} ->
        PubSub.broadcast(canvas)
        {:ok, canvas}

      error = {:error, _changeset} ->
        error
    end
  end
end
