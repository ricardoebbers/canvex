defmodule Canvex.Canvas.Get do
  @moduledoc """
  Fetches `canvas` from database given it's `id`.
  """

  alias Canvex.Repo
  alias Canvex.Schema.Canvas

  require Logger

  @spec by_id(Ecto.UUID.t() | any()) :: {:ok, Canvas.t()} | {:error, :bad_request | :not_found}
  def by_id(nil), do: {:error, :bad_request}

  def by_id(id) do
    case Ecto.UUID.cast(id) do
      {:ok, id} ->
        do_get_by_id(id)

      :error ->
        Logger.warn("Invalid UUID. id: #{inspect(id)}")
        {:error, :bad_request}
    end
  end

  defp do_get_by_id(id) do
    case Repo.get(Canvas, id) do
      nil ->
        {:error, :not_found}

      canvas = %Canvas{} ->
        {:ok, Canvas.load_values(canvas)}
    end
  end
end
