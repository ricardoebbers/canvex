defmodule Canvex.PubSub do
  alias Phoenix.PubSub

  @topic "canvas_draw"

  def subscribe(id), do: PubSub.subscribe(__MODULE__, topic(id))

  def broadcast_draw(canvas) do
    PubSub.broadcast(__MODULE__, topic(canvas.id), %{canvas: canvas})
    canvas
  end

  defp topic(id), do: "#{@topic}:#{id}"
end
