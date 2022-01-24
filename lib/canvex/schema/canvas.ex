defmodule Canvex.Schema.Canvas do
  use Ecto.Schema
  import Ecto.Changeset

  alias Canvex.Draw.Canvas, as: DrawCanvas
  alias Canvex.Type.ASCIIPrintable

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @fields ~w(charlist fill height values width user_id)a
  @required_new ~w(height user_id width)a
  @required_existing ~w(charlist user_id width)a
  schema "canvas" do
    field :charlist, {:array, ASCIIPrintable}
    field :fill, ASCIIPrintable, virtual: true, redact: true
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
    |> validate_number(:height, greater_than: 0)
    |> validate_number(:width, greater_than: 0)
  end

  def load_values(canvas = %{charlist: _charlist, width: _width}) do
    canvas
    |> DrawCanvas.new()
    |> case do
      %{values: values, charlist: charlist} -> %{canvas | values: values, charlist: charlist}
      error = {:error, _reason} -> error
    end
  end

  defp validate_input(canvas, attrs = %{"width" => _width, "charlist" => _charlist}) do
    do_validate_input(canvas, attrs, @required_existing)
  end

  defp validate_input(canvas, attrs) do
    do_validate_input(canvas, attrs, @required_new)
  end

  defp do_validate_input(canvas, attrs, required) do
    fields =
      (@fields ++ required)
      |> MapSet.new()
      |> Enum.to_list()

    canvas
    |> cast(attrs, fields)
    |> validate_required(required)
  end

  defp validate_draw(canvas = %{valid?: false}), do: canvas

  defp validate_draw(canvas = %{changes: changes}) do
    case DrawCanvas.new(changes) do
      %DrawCanvas{values: values, charlist: charlist, height: height} ->
        canvas
        |> put_change(:values, values)
        |> put_change(:charlist, charlist)
        |> put_change(:height, height)

      _ ->
        canvas
    end
  end
end
