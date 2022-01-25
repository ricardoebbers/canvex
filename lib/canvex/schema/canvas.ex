defmodule Canvex.Schema.Canvas do
  @moduledoc """
  Schema for `Canvex.Draw.Canvas` validations and database interaction.
  """

  use Ecto.Schema
  import Ecto.Changeset

  alias Canvex.Draw.Stroke
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

  def changeset(canvas, attrs) do
    canvas
    |> cast(attrs, @fields)
    |> validate_required(@required_new)
    |> validate_number(:height, greater_than: 0, less_than_or_equal_to: 500)
    |> validate_number(:width, greater_than: 0, less_than_or_equal_to: 500)
    |> create_values()
  end

  def update_changeset(canvas, other = %__MODULE__{}),
    do: update_changeset(canvas, get_attrs(other))

  def update_changeset(canvas, attrs) do
    canvas
    |> cast(attrs, [:values])
    |> validate_required(@required_update)
    |> update_charlist()
  end

  def load_values(canvas = %{width: width, charlist: charlist}) do
    values =
      charlist
      |> Stream.with_index()
      |> Stream.map(fn {char, index} -> {{rem(index, width), div(index, width)}, char} end)
      |> Map.new()

    canvas
    |> Map.put(:values, values)
    |> Map.put(:charlist, List.to_charlist(charlist))
  end

  def load_charlist(canvas = %{width: width, height: height, values: values}) do
    charlist =
      coords(width, height)
      |> Enum.map(&Map.get(values, &1))
      |> List.to_charlist()

    Map.put(canvas, :charlist, charlist)
  end

  def put_value_at(canvas = %{width: width, height: height}, coords = {x, y}, value)
      when x >= 0 and x < width and y >= 0 and y < height do
    value
    |> Stroke.ascii_printable()
    |> case do
      error = {:error, _reason} ->
        error

      value ->
        %{canvas | values: Map.put(canvas.values, coords, value)}
    end
  end

  def put_value_at(canvas, _coords, _value), do: canvas

  defp update_charlist(changeset = %{data: data, changes: changes}) do
    %{charlist: charlist} =
      data
      |> Map.merge(changes)
      |> load_charlist()

    put_change(changeset, :charlist, charlist)
  end

  defp create_values(canvas = %{valid?: false}), do: canvas

  defp create_values(canvas = %{changes: %{width: width, height: height, fill: fill}}) do
    canvas
    |> put_change(:charlist, List.duplicate(fill, height * width) |> List.to_charlist())
    |> put_change(:values, Map.new(coords(width, height), &{&1, fill}))
  end

  defp coords(width, height), do: for(y <- 0..(height - 1), x <- 0..(width - 1), do: {x, y})

  defp get_attrs(canvas) do
    @fields
    |> Enum.map(fn key -> {key, Map.get(canvas, key)} end)
    |> Map.new()
  end
end
