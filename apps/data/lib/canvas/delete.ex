defmodule Data.Canvas.Delete do
  alias Data.Repo
  alias Data.Schema.Canvas, as: CanvasSchema
  alias Data.Schema.Error

  def call(id) do
    CanvasSchema
    |> Repo.get(id)
    |> case do
      nil -> {:error, :not_found}
      canvas -> do_delete(canvas)
    end
  end

  defp do_delete(canvas) do
    canvas
    |> Repo.delete()
    |> case do
      {:ok, struct} -> {:ok, CanvasSchema.to_canvas(struct)}
      {:error, changeset} -> {:error, Error.translate(changeset)}
    end
  end
end
