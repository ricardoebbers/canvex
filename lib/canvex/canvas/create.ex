defmodule Canvex.Canvas.Create do
  @moduledoc """
  Creates a `canvas` from it's `attrs`, or return the `changeset` with errors.
  """

  alias Canvex.Repo
  alias Canvex.Schema.Canvas

  @spec call(map()) :: {:ok, Canvas.t()} | {:error, Ecto.Changeset.t()}
  def call(attrs) do
    %Canvas{}
    |> Canvas.changeset(attrs)
    |> Repo.insert()
  end
end
