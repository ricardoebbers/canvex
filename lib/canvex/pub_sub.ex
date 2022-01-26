defmodule Canvex.PubSub do
  @moduledoc """
  PubSub channel to allow updating the live view of a canvas
  """
  alias Phoenix.PubSub

  def subscribe(id), do: PubSub.subscribe(__MODULE__, topic(id))

  def broadcast(canvas) do
    PubSub.broadcast(__MODULE__, topic(canvas.id), %{canvas: canvas})
    canvas
  end

  defp topic(id), do: "canvas:#{id}"
end
