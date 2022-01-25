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

  schema "canvas" do
    field :charlist, {:array, ASCIIPrintable}
    field :fill, ASCIIPrintable, virtual: true, redact: true
    field :height, :integer
    field :values, :map, virtual: true, redact: true
    field :width, :integer
    field :user_id, Ecto.UUID

    timestamps()
  end

  def update_changeset(canvas, other = %Canvas{}), do: update_changeset(canvas, get_attrs(other))

  def update_changeset(canvas, attrs) do
    canvas
    |> cast(attrs, [:charlist, :values])
    |> validate_required([:charlist, :values])
    |> validate_draw()
  end

  @doc false
  def changeset(canvas, attrs) do
    canvas
    |> cast(attrs, @fields)
    |> validate_required(@required_new)
    |> validate_draw()
    |> validate_number(:height, greater_than: 0, less_than: 500)
    |> validate_number(:width, greater_than: 0, less_than: 500)
  end

  def load_values(canvas = %{charlist: _charlist, width: _width}) do
    case DrawCanvas.new(canvas) do
      %DrawCanvas{values: values, charlist: charlist} ->
        {:ok, %{canvas | values: values, charlist: charlist}}

      error = {:error, reason} ->
        Logger.error([
          "Unexpected error when loading canvas.",
          "reason: #{inspect(reason)}, canvas: #{inspect(canvas)}"
        ])

        error
    end
  end

  defp validate_draw(canvas = %{valid?: false}), do: canvas

  defp validate_draw(canvas = %{data: data, changes: changes}) do
    data
    |> get_attrs()
    |> Map.merge(changes)
    |> DrawCanvas.new()
    |> case do
      draw_canvas = %DrawCanvas{} -> put_changes(canvas, draw_canvas)
      _ -> canvas
    end
  end

  defp get_attrs(canvas) do
    @fields
    |> Enum.map(fn key -> {key, Map.get(canvas, key)} end)
    |> Map.new()
  end

  defp put_changes(canvas, draw_canvas) do
    canvas
    |> put_change(:values, draw_canvas.values)
    |> put_change(:charlist, draw_canvas.charlist)
    |> put_change(:height, draw_canvas.height)
  end
end
