defmodule Canvex.OpenAPI.Schemas do
  @moduledoc false

  alias OpenApiSpex.Schema
  require OpenApiSpex

  defmodule Canvas do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Canvas",
      description: "An ASCII Canvas",
      type: :object,
      properties: %{
        id: %Schema{type: :string, description: "Canvas UUID"},
        charlist: %Schema{
          type: :array,
          description: "A list of lists representing the canvas in a 2D form"
        },
        fill: %Schema{type: :string, description: "A char to fill the canvas with"},
        height: %Schema{type: :integer, description: "Canvas height"},
        width: %Schema{type: :integer, description: "Canvas width"},
        user_id: %Schema{type: :string, description: "User UUID"}
      },
      required: [:height, :width, :fill, :user_id],
      example: %{
        "charlist" => [
          "          ",
          "          ",
          "          ",
          "          ",
          "          ",
          "          ",
          "          ",
          "          ",
          "          ",
          "          "
        ],
        "height" => 10,
        "id" => "03fe4096-4a12-4f03-a67c-310d78f1107b",
        "user_id" => "96e746e3-005c-4191-8192-0cdf4e960477",
        "width" => 10
      }
    })
  end

  defmodule CanvasResponse do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "CanvasResponse",
      description: "Response schema for a single canvas",
      type: :object,
      properties: %{
        data: Canvas
      },
      example: %{
        "data" => %{
          "charlist" => [
            "          ",
            "          ",
            "          ",
            "          ",
            "          ",
            "          ",
            "          ",
            "          ",
            "          ",
            "          "
          ],
          "height" => 10,
          "id" => "03fe4096-4a12-4f03-a67c-310d78f1107b",
          "user_id" => "96e746e3-005c-4191-8192-0cdf4e960477",
          "width" => 10
        }
      }
    })
  end

  defmodule CanvasCreateParams do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Canvas create params",
      description: "Creates a new canvas",
      type: :object,
      properties: %{
        fill: %Schema{type: :string, description: "A char to fill the canvas with"},
        height: %Schema{type: :integer, description: "Canvas height"},
        width: %Schema{type: :integer, description: "Canvas width"},
        user_id: %Schema{type: :string, description: "User UUID"}
      },
      required: [:fill, :height, :width, :user_id],
      example: %{
        "user_id" => "96e746e3-005c-4191-8192-0cdf4e960477",
        "width" => 10,
        "height" => 10,
        "fill" => " "
      }
    })
  end

  defmodule CanvasDrawParams do
    @moduledoc false

    OpenApiSpex.schema(%{
      title: "Draw operation params",
      description: "Draw a rectangle or do a flood fill on a canvas",
      type: :object,
      properties: %{
        command: %Schema{
          type: :string,
          description: "The command detailing what to draw. Can be 'rectangle' or 'flood_fill'"
        },
        x: %Schema{
          type: :integer,
          description: "Upper-left corner of the rectangle, or origin coordinate of flood fill"
        },
        y: %Schema{
          type: :integer,
          description: "Upper-left corner of the rectangle, or origin coordinate of flood fill"
        },
        fill: %Schema{
          type: :string,
          description: "A char to fill the rectangle or flood_fill the canvas"
        },
        outline: %Schema{type: :string, description: "Rectangle outline"},
        height: %Schema{type: :integer, description: "Rectangle height"},
        width: %Schema{type: :integer, description: "Rectangle width"}
      },
      required: [:command, :x, :y, :fill],
      example: %{
        "command" => "rectangle",
        "x" => 1,
        "y" => 1,
        "fill" => ".",
        "outline" => "R",
        "height" => 5,
        "width" => 5
      }
    })
  end
end
