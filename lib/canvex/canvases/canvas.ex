defmodule Canvex.Canvases.Canvas do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "canvases" do
    field :height, :integer
    field :user_id, Ecto.UUID
    field :values, :map
    field :width, :integer

    timestamps()
  end

  @doc false
  def changeset(canvas, attrs) do
    canvas
    |> cast(attrs, [:width, :height, :values, :user_id])
    |> validate_required([:width, :height, :values, :user_id])
  end
end
