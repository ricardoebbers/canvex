defmodule Data.Canvas.Create do
  alias Data.Repo
  alias Data.Schema.Canvas, as: CanvasSchema
  alias Data.Schema.Error

  def call(canvas) do
    canvas
    |> CanvasSchema.from_canvas()
    |> Repo.insert()
    |> case do
      {:ok, struct} -> {:ok, struct.id}
      {:error, changeset} -> {:error, Error.translate(changeset)}
    end
  end
end
