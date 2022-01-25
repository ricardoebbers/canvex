defmodule Canvex.Schema.Canvas do
  @moduledoc """
  Schema for `Canvex.Draw.Canvas` validations and database interaction.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Canvex.Draw.Canvas, as: DrawCanvas
  alias Canvex.Schema.Canvas
  alias Canvex.Type.ASCIIPrintable

  require Logger

  @type t :: %__MODULE__{
          id: Ecto.UUID,
          charlist: {:array, ASCIIPrintable},
          fill: ASCIIPrintable,
          height: :integer,
          values: :map,
          width: :integer,
          user_id: Ecto.UUID
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  @fields ~w(charlist fill height values width user_id)a
  @required_new ~w(fill height user_id width)a
  @required_update ~w(charlist height width user_id)a

  schema "canvas" do
    field :charlist, {:array, ASCIIPrintable}
    field :fill, ASCIIPrintable, virtual: true
    field :height, :integer
    field :values, :map, virtual: true
    field :width, :integer
    field :user_id, Ecto.UUID

    timestamps()
  end

  def update_changeset(canvas, other = %Canvas{}), do: update_changeset(canvas, get_attrs(other))

  def update_changeset(canvas, attrs) do
    canvas
    |> cast(attrs, [:values])
    |> validate_required(@required_update)
    |> update_charlist()
  end

  @doc false
  def changeset(canvas, attrs) do
    canvas
    |> cast(attrs, @fields)
    |> validate_required(@required_new)
    |> validate_number(:height, greater_than: 0, less_than_or_equal_to: 500)
    |> validate_number(:width, greater_than: 0, less_than_or_equal_to: 500)
    |> create_values()
  end

  defp update_charlist(changeset = %{data: data, changes: changes}) do
    canvas =
      Map.merge(data, changes)
      |> DrawCanvas.update_charlist()

    put_change(changeset, :charlist, canvas.charlist)
  end

  defp create_values(canvas = %{valid?: false}), do: canvas

  defp create_values(canvas = %{changes: changes}) do
    canvas
    |> new_charlist(changes)
    |> new_values(changes)
  end

  defp new_charlist(canvas, %{width: width, height: height, fill: fill}) do
    put_change(canvas, :charlist, List.duplicate(fill, height * width) |> List.to_charlist())
  end

  defp new_values(canvas, %{width: width, height: height, fill: fill}) do
    put_change(canvas, :values, Map.new(coords(width, height), &{&1, fill}))
  end

  defp coords(width, height), do: for(y <- 0..(height - 1), x <- 0..(width - 1), do: {x, y})

  defp get_attrs(canvas) do
    @fields
    |> Enum.map(fn key -> {key, Map.get(canvas, key)} end)
    |> Map.new()
  end
end
