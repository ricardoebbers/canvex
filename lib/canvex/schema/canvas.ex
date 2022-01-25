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
    |> generate_charlist_from_values()
  end

  @doc false
  def changeset(canvas, attrs) do
    canvas
    |> cast(attrs, @fields)
    |> validate_required(@required_new)
    |> generate_charlist_and_values()
    |> validate_number(:height, greater_than: 0, less_than_or_equal_to: 500)
    |> validate_number(:width, greater_than: 0, less_than_or_equal_to: 500)
  end

  defp generate_charlist_from_values(changeset = %{valid?: false}), do: changeset

  defp generate_charlist_from_values(changeset = %{data: data, changes: changes}) do
    data
    |> Map.merge(changes)
    |> DrawCanvas.charlist_from_values()
    |> case do
      {:error, _reason} -> changeset
      charlist -> put_change(changeset, :charlist, charlist)
    end
  end

  defp generate_charlist_and_values(canvas = %{valid?: false}), do: canvas

  defp generate_charlist_and_values(canvas = %{changes: changes}) do
    case DrawCanvas.charlist_and_values_from_params(changes) do
      {:error, _reason} ->
        canvas

      %{charlist: charlist, values: values} ->
        canvas
        |> put_change(:charlist, charlist)
        |> put_change(:values, values)
    end
  end

  defp get_attrs(canvas) do
    @fields
    |> Enum.map(fn key -> {key, Map.get(canvas, key)} end)
    |> Map.new()
  end
end
