defmodule Data.Schema.Canvas do
  use Ecto.Schema
  import Ecto.Changeset

  alias Core.Canvas
  alias Data.Schema.Canvas, as: CanvasSchema

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @required_fields ~w(charlist width)a

  schema "canvas" do
    field(:charlist, {:array, :integer})
    field(:width, :integer)
    timestamps()
  end

  def from_canvas(canvas = %Canvas{}) do
    {charlist, width} = Core.canvas_to_charlist(canvas)

    %CanvasSchema{}
    |> changeset(%{charlist: charlist, width: width})
  end

  def to_canvas(%CanvasSchema{charlist: charlist, width: width}) do
    Core.canvas_from_charlist(charlist, width)
  end

  def changeset(schema = %CanvasSchema{}, attrs) do
    schema
    |> cast(attrs, @required_fields)
    |> validate_required(@required_fields)
    |> validate_number(:width, greater_than: 0)
    |> validate_length(:charlist, min: attrs.width)
    |> validate_change(:charlist, &length_divisble_by_width(&1, &2, attrs.width))
    |> validate_change(:charlist, &ascii_printable/2)
  end

  defp ascii_printable(:charlist, charlist) do
    if List.ascii_printable?(charlist) do
      []
    else
      [charlist: "Must contain only ascii printable chars"]
    end
  end

  defp length_divisble_by_width(:charlist, charlist, width) do
    if charlist |> length |> rem(width) == 0 do
      []
    else
      [charlist: "Must be divisible by #{width}"]
    end
  end
end
