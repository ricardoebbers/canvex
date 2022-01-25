defmodule Canvex.Factory do
  @moduledoc false
  use ExMachina.Ecto, repo: Canvex.Repo

  alias Canvex.Schema.Canvas

  def canvas_factory do
    %Canvas{
      width: 5,
      height: 5,
      fill: ' ',
      user_id: Ecto.UUID.generate()
    }
  end

  def rectangle_with_outline_factory do
    draw_rectangle_command()
    |> Map.put(:outline, "X")
  end

  def rectangle_with_fill_factory do
    draw_rectangle_command()
    |> Map.put(:fill, "o")
  end

  def flood_fill_factory do
    %{
      command: "flood_fill",
      x: 0,
      y: 0,
      fill: 'x'
    }
  end

  defp draw_rectangle_command do
    %{
      command: "rectangle",
      x: 0,
      y: 0,
      width: 3,
      height: 3
    }
  end
end
