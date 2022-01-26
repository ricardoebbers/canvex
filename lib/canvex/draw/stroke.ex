defmodule Canvex.Draw.Stroke do
  @moduledoc """
  Validate and sanitize all __strokes__ to be made on the `canvas`.

  Tries it's best to convert the `char` input into an `ASCII` printable representation.
  """

  @spec ascii_printable(any) :: list | {:error, :not_ascii_printable}
  def ascii_printable(char) do
    if valid?(char), do: sanitize(char), else: {:error, :not_ascii_printable}
  end

  defp valid?(char = [_]), do: List.ascii_printable?(char)

  defp valid?(char) when is_binary(char) do
    charlist = String.to_charlist(char)
    length(charlist) == 1 and List.ascii_printable?(charlist)
  end

  defp valid?(char) when is_integer(char), do: List.ascii_printable?([char])
  defp valid?(_), do: false

  defp sanitize(char = [_]), do: char
  defp sanitize(char) when is_binary(char), do: String.to_charlist(char)
  defp sanitize(char) when is_integer(char), do: [char]
end
