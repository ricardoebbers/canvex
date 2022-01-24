defmodule Canvex.Type.ASCIIPrintable do
  use Ecto.Type

  alias Canvex.Draw.Stroke
  def type, do: :ascii_printable

  def cast(char) do
    case Stroke.ascii_printable(char) do
      {:error, _reason} -> :error
      valid -> {:ok, valid}
    end
  end

  def load(char), do: {:ok, char}

  def dump(char), do: {:ok, Stroke.ascii_printable(char)}
end
