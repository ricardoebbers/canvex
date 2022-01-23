defmodule Data do
  alias Data.Canvas.{Create, Delete, Get, Update}

  defdelegate create_canvas(canvas), to: Create, as: :call
  defdelegate delete_canvas(id), to: Delete, as: :call
  defdelegate get_canvas_by_id(id), to: Get, as: :by_id
  defdelegate update_canvas(id, canvas), to: Update, as: :call
end
