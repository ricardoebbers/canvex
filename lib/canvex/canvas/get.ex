defmodule Canvex.Canvas.Get do
  @moduledoc false

  alias Canvex.Repo
  alias Canvex.Schema.Canvas
  alias Canvex.Draw.Canvas, as: DrawCanvas

  require Logger

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

      canvas = %Canvas{} -> load_values(canvas)
    end
  end

  defp load_values(canvas = %{charlist: _charlist, width: _width}) do
    case DrawCanvas.new(canvas) do
      %DrawCanvas{values: values, charlist: charlist} ->
        {:ok, %{canvas | values: values, charlist: charlist}}

      error = {:error, reason} ->
        Logger.error([
          "Unexpected error when loading canvas.",
          "reason: #{inspect(reason)}, canvas: #{inspect(canvas)}"
        ])

        error
    end
  end
end
