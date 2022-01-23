defmodule Data.Canvas.Get do
  alias Data.Schema.Canvas, as: CanvasSchema
  alias Data.Repo

  def by_id(nil), do: nil

  def by_id(id) do
    CanvasSchema
    |> Repo.get(id)
    |> case do
      nil -> {:error, :not_found}
      canvas -> {:ok, CanvasSchema.to_canvas(canvas)}
    end
  end
end
