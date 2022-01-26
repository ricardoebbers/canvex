defmodule CanvexWeb.OpenAPI.CanvasControllerSpec do
  @moduledoc """
  OpenAPI specs for the Canvas Controller
  """
  defmacro __using__(_opts \\ []) do
    quote location: :keep do
      use OpenApiSpex.ControllerSpecs

      alias Canvex.OpenAPI.Schemas

      tags [:canvas]

      operation :create,
        summary: "Creates a new canvas",
        request_body: {
          "Canvas create request params",
          "application/json",
          Schemas.CanvasCreateParams,
          required: true
        },
        responses: [
          {:created, "Canvas was created successfully"}
        ]

      operation :show,
        summary: "Show an existing canvas",
        parameters: [
          id: [
            in: :path,
            description: "Canvas UUID",
            type: :string,
            example: "03fe4096-4a12-4f03-a67c-310d78f1107b"
          ]
        ],
        responses: [
          ok: {"Canvas response", "application/json", Schemas.CanvasResponse}
        ]

      operation :draw,
        summary: "Draw a figure on a canvas",
        parameters: [
          id: [
            in: :path,
            description: "Canvas UUID",
            type: :string,
            example: "03fe4096-4a12-4f03-a67c-310d78f1107b"
          ]
        ],
        request_body: {
          "Draw on canvas request params",
          "application/json",
          Schemas.CanvasDrawParams,
          required: true
        },
        responses: [
          ok: {"Canvas response", "application/json", Schemas.CanvasResponse}
        ]
    end
  end
end
