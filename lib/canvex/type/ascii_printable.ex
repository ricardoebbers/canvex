defmodule Canvex.Type.ASCIIPrintable do
  use Ecto.Type

  alias Canvex.Draw.Stroke

  require Logger
  def type, do: :ascii_printable

  def cast(char) do
    case Stroke.ascii_printable(char) do
      {:error, _reason} ->
        Logger.warn("Char not in the ASCII table. char: #{inspect(char)}")
        :error

      valid ->
        {:ok, valid}
    end
  end

  def load(char), do: {:ok, char}

  def dump(char), do: {:ok, Stroke.ascii_printable(char)}
end
