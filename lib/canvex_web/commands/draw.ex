defmodule CanvexWeb.Commands.Draw do
  @moduledoc """
  Validates draw commands params before sending them to the domain API.
  """

  import Ecto.Changeset

  @valid_commands ["flood_fill", "rectangle"]

  def validate(params = %{"command" => "flood_fill"}) do
    types = %{x: :integer, y: :integer, fill: :string, command: :string}

    params
    |> do_validate(types, Map.keys(types))
    |> validate_coords()
    |> validate_command()
  end

  def validate(params = %{"command" => "rectangle"}) do
    types = %{
      x: :integer,
      y: :integer,
      width: :integer,
      height: :integer,
      fill: :string,
      outline: :string,
      command: :string
    }

    required = ~w(width height x y)a

    params
    |> do_validate(types, required)
    |> validate_number(:height, greater_than: 0)
    |> validate_number(:width, greater_than: 0)
    |> validate_fill_or_outline()
    |> validate_coords()
    |> validate_command()
  end

  def validate(params) do
    types = %{command: :string}
    required = Map.keys(types)

    params
    |> do_validate(types, required)
    |> validate_command()
  end

  defp do_validate(params, types, required) do
    {%{}, types}
    |> cast(params, Map.keys(types))
    |> validate_required(required)
  end

  defp validate_command(changeset) do
    changeset
    |> validate_inclusion(:command, @valid_commands,
      message: "must be one of: '#{@valid_commands |> Enum.join("', '")}'"
    )
  end

  defp validate_coords(changeset) do
    changeset
    |> validate_number(:x, greater_than_or_equal_to: 0)
    |> validate_number(:y, greater_than_or_equal_to: 0)
  end

  defp validate_fill_or_outline(changeset = %{changes: %{fill: _fill}}), do: changeset
  defp validate_fill_or_outline(changeset = %{changes: %{outline: _outline}}), do: changeset

  defp validate_fill_or_outline(changeset) do
    validate_required(changeset, ~w(fill outline)a)
  end
end
