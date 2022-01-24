defmodule Canvex.Schemas.Canvas do
  use Ecto.Schema
  import Ecto.Changeset

  alias Canvex.Draw.Canvas, as: DrawCanvas

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required ~w(height user_id width)a
  @optional ~w(charlist fill values)a
  schema "canvas" do
    field :charlist, {:array, :integer}
    field :fill, :integer, virtual: true, redact: true
    field :height, :integer
    field :values, :map, virtual: true, redact: true
    field :width, :integer
    field :user_id, Ecto.UUID

    timestamps()
  end

  @doc false
  def changeset(canvas, attrs) do
    canvas
    |> validate_input(attrs)
    |> validate_draw()
  end

  def load_values(canvas = %{charlist: _charlist, width: _width}) do
    canvas
    |> DrawCanvas.new()
    |> case do
      %{values: values, charlist: charlist} -> %{canvas | values: values, charlist: charlist}
      error = {:error, _reason} -> error
    end
  end

  defp validate_input(canvas, attrs) do
    canvas
    |> cast(attrs, @optional ++ @required)
    |> validate_required(@required)
    |> validate_number(:width, greater_than: 0)
    |> validate_number(:height, greater_than: 0)
  end

  defp validate_draw(canvas = %{valid?: false}), do: canvas

  defp validate_draw(canvas = %{changes: changes}) do
    case DrawCanvas.new(changes) do
      %{values: values, charlist: charlist} ->
        canvas
        |> put_change(:values, values)
        |> put_change(:charlist, charlist)

      {:error, reason} ->
        canvas
        |> validate_change(:fill, fn _, _ -> [fill: reason] end)
    end
  end
end
