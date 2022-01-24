defmodule Canvex.Canvas.Get do
  alias Canvex.Repo
  alias Canvex.Schema.Canvas

  def by_id(nil), do: {:error, :bad_request}

  def by_id(id) do
    case Ecto.UUID.cast(id) do
      {:ok, id} -> do_get_by_id(id)
      _ -> {:error, :bad_request}
    end
  end

  defp do_get_by_id(id) do
    case Repo.get(Canvas, id) do
      nil -> {:error, :not_found}
      canvas -> {:ok, canvas |> Canvas.load_values()}
    end
  end
end