defmodule CanvexWeb.FallbackController do
  @moduledoc """
  Translates controller action results into valid `Plug.Conn` responses.

  See `Phoenix.Controller.action_fallback/1` for more details.
  """
  use CanvexWeb, :controller

  def call(conn, changeset = %Ecto.Changeset{valid?: false}) do
    call(conn, {:error, changeset})
  end

  def call(conn, changeset = {:error, %Ecto.Changeset{errors: errors}}) do
    Logger.error([
      "Error unprocessable_entity ecto changeset. ",
      "request_path: #{inspect(conn.request_path)}, ",
      "params: #{inspect(conn.params)}, errors: #{inspect(errors)}"
    ])

    conn
    |> put_status(:unprocessable_entity)
    |> put_view(CanvexWeb.ChangesetView)
    |> render("error.json", changeset: changeset)
  end

  def call(conn = %{}, {:error, :not_found}) do
    Logger.warn(
      "Error not_found. request_path: #{inspect(conn.request_path)}, params: #{inspect(conn.params)}"
    )

    conn
    |> put_status(:not_found)
    |> put_view(CanvexWeb.ErrorView)
    |> render("error.json", reason: "Not found")
  end

  def call(conn, {:error, :bad_request}) do
    Logger.warn(
      "Error bad_request. request_path: #{inspect(conn.request_path)}, params: #{inspect(conn.params)}"
    )

    conn
    |> put_status(:bad_request)
    |> put_view(CanvexWeb.ErrorView)
    |> render("error.json", reason: "Bad request")
  end

  def call(conn, {:error, :not_ascii_printable}) do
    Logger.warn(
      "Error not_ascii_printable. request_path: #{inspect(conn.request_path)}, params: #{inspect(conn.params)}"
    )

    conn
    |> put_status(:bad_request)
    |> put_view(CanvexWeb.ErrorView)
    |> render("error.json", reason: "Char provided is not on the ASCII table.")
  end
end
