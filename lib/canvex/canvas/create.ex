defmodule Canvex.Canvas.Create do
  alias Canvex.Repo
  alias Canvex.Schema.Canvas

  def call(attrs) do
    %Canvas{}
    |> Canvas.changeset(attrs)
    |> Repo.insert()
  end
end
