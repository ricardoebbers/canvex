defmodule Canvex.Factory do
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
end
