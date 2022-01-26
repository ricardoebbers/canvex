# Canvex
[![CI Tests](https://github.com/ricardoebbers/canvex/workflows/CI%20Tests/badge.svg)](https://github.com/ricardoebbers/canvex/actions)
[![Coverage Status](https://coveralls.io/repos/github/ricardoebbers/canvex/badge.svg?branch=main)](https://coveralls.io/github/ricardoebbers/canvex?branch=main)

Canvex is a web service API made with Elixir that allows `drawing` ASCII art on a `canvas`.

## Canvas

Canvases are represented as a zero-indexed matrix (or list of lists) of `chars`, all being ASCII printable, with coordinates that start from the top left, like this:
```
# a canvas with width = 10, height = 5, fill = 'o'
          0 1 2 3 4 5 6 7 8 9 (x axis)
          _ _ _ _ _ _ _ _ _ _
      0 | o o o o o o o o o o
      1 | o o o o o o o o o o
      2 | o o o o o o o o o o
      3 | o o o o o o o o o o
      4 | o o o o o o o o o o
(y axis)
```

Canvases are identifiable with a global unique identifier in the form of an UUID.

Valid canvases are persisted on the database with a reference to the user who created it.

## Drawing operations

It's possible to do drawings on a `canvas` with ASCII printable `chars`.

The drawing operations possible are:
  - Draw a rectangle;
  - Do a flood fill.

Drawing operations are applied in the order they are given and may overlap.

### Draw a rectangle

Rectangles are drawn by passing the `x` and `y` coordinates of it's `top left vertex`, a `width`, a `height`, and can have a `fill`, an `outline`, or both.

Here is an example of a rectangle on a canvas:
```
# a canvas with width = 10, height = 5, fill = ' '
# after a draw operation with
# x = 2, y = 1, width = 5, height = 3, fill = '-', outline = 'X'
      0 1 2 3 4 5 6 7 8 9 (x axis)
      _ _ _ _ _ _ _ _ _ _
  0 |                    
  1 |     X X X X X      
  2 |     X - - - X      
  3 |     X X X X X      
  4 |                    
(y axis)
```

Subsequent drawings of rectangles on the same canvas may overlap:
```
# the same canvas as before, but
# after another draw operation with
# x = 0, y = 0, width = 4, height = 3, fill = 'o'
      0 1 2 3 4 5 6 7 8 9 (x axis)
      _ _ _ _ _ _ _ _ _ _
  0 | o o o o            
  1 | o o o o X X X      
  2 | o o o o - - X      
  3 |     X X X X X      
  4 |                    
(y axis)
```

### Do a flood fill

A [flood fill](https://en.wikipedia.org/wiki/Flood_fill) operation draws the `fill` character to the start `x` and `y` coordinates, and continues to attempt drawing the character around (up, down, left, right) in each direction from the position it was drawn at, as long as a different character, or a border of the canvas, is not reached.

Here is an example of a flood fill operation:
```
# given a canvas like this
        0 1 2 3 4 5 6 7 8 9 (x axis)
      _ _ _ _ _ _ _ _ _ _
  0 |                    
  1 |     X X X X X      
  2 |     X - - - X      
  3 |     X X X X X      
  4 |                    
(y axis)
# after a flood fill operation with,
# x = 4, y = 3, fill = 'W'
# it becomes:
      0 1 2 3 4 5 6 7 8 9 (x axis)
      _ _ _ _ _ _ _ _ _ _
  0 | o o o o o o o o o o
  1 | o o W W W W W o o o
  2 | o o W - - - W o o o
  3 | o o W W W W W o o o
  4 | o o o o o o o o o o
(y axis)
```

## Running instructions

The web service consists of three endpoints:

`POST /api/canvas`: Creates a canvas
`GET /api/canvas/{id}`: Shows a canvas, given it's UUID
`PUT /api/canvas/{id}/draw`: Draws onto a canvas, given it's UUID

The complete API documentation is done with the `openapi` specification and is available as a Swagger UI on the root `/` of the application.

### Locally

#### Prerequisites

* Docker and docker-compose installed
* Ports 5432 and 4000 available

#### Step-by-step

```
# Clone this repository
git clone https://github.com/ricardoebbers/canvex.git

# Change directory to the repository folder
cd canvex

# Spin up docker containers
docker-compose up -d

# Create the database and run migrations
docker-compose run web mix ecto.setup
#     If you see a message 'The database for Canvex.Repo couldn't be created'
#     it's because the postgres container wasn't ready yet.
#     Try running the command below again

# Open your browser on localhost:4000 to find the Swagger UI API documentation
xdg-open http://localhost:4000
# The command above should work on ubuntu ;)

# Clean up
docker-compose down --volumes
```

#### Postman collection

For convenience a [postman collection](./postman/) is provided with all endpoints and requests examples.

### Gigalixir

This project is available at [canvex.gigalixirapp.com](https://canvex.gigalixirapp.com/).

On the root path `/` you can find a Swagger UI with the documentation of the API and examples ready for testing.

**Attention**: Gigalixir free tier is very limited in terms of memory available, so you might find yourself looking at a `502 Bad Gateway` or a `503 Service Temporarily Unavailable` after trying to draw a canvas that is too big (larger than 350x350 or so). If that happens, it's because the server ran out of memory. In a minute or two the server will be up and running again, but you may have lost your art :(

For better validation of the project and visualization of the canvas on the Swagger UI, I suggest keeping the canvas size below 150x150.

## Overview

### Dependencies

This is a Phoenix project and have the usual dependencies of one generated with a frontend.

Besides that, I've added the following:
* [credo](https://github.com/rrrene/credo) for static code analysis and linting
* [dialyxir](https://github.com/jeremyjh/dialyxir) for static analysis of `typespecs`
* [excoveralls](https://github.com/parroty/excoveralls) for code coverage and reporting
* [mix_test_watch](https://github.com/lpil/mix-test.watch) to run the test suite every time the code is changed
* [ex_machina](https://github.com/thoughtbot/ex_machina) as a factory for testing
* [open_api_spex](https://github.com/open-api-spex/open_api_spex) for API specification and Swagger UI generation

### Project structure

The implementation follows the Phoenix convention of separating Web and internal domain:
  - canvex: internal domain
  - canvex_web: default MVC architecture

The internal domain is separated into three main parts:
  - canvas: holds all operations that interfaces with the repository/database (create, get, update)
  - draw: holds all the logic behind "drawing" on a canvas
  - schema: holds the `canvas` schema, which validates the data before persisting.

### Testing

All tests can be run with `mix test` locally.