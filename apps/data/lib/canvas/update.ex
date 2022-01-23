defmodule Data.Canvas.Update do
  alias Data.Schema.Canvas, as: CanvasSchema
  alias Data.Schema.Error
  alias Data.Repo

  def call(id, new_canvas) do
    CanvasSchema
    |> Repo.get(id)
    |> case do
      nil -> {:error, :not_found}
      existing_canvas -> do_update(existing_canvas, new_canvas)
    end
  end

  defp do_update(existing_canvas, new_canvas) do
    existing_canvas
    |> CanvasSchema.update_changeset(new_canvas)
    |> Repo.update()
    |> case do
      {:ok, struct} -> {:ok, struct.id}
      {:error, changeset} -> {:error, Error.translate(changeset)}
    end
  end
end
