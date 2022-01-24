defmodule Canvex.Canvas.Update do
  alias Canvex.Canvas.Get
  alias Canvex.Repo
  alias Canvex.Schema.Canvas

  def call(attrs = %{"id" => id}) do
    id
    |> Get.by_id()
    |> case do
      {:ok, canvas} -> do_update(canvas, attrs)
      error -> error
    end
  end

  def call(_), do: {:error, :bad_request}

  defp do_update(canvas, attrs) do
    canvas
    |> Canvas.changeset(attrs)
    |> Repo.update()
  end
end
