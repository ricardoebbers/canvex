# Canvex
[![CI Tests](https://github.com/ricardoebbers/canvex/workflows/CI%20Tests/badge.svg)](https://github.com/ricardoebbers/canvex/actions)
[![Coverage Status](https://coveralls.io/repos/github/ricardoebbers/canvex/badge.svg?branch=main)](https://coveralls.io/github/ricardoebbers/canvex?branch=main)

Canvex is a web service API made with Elixir that allows `drawing` ASCII art on a `canvas`.

This project is available at [canvex.gigalixirapp.com](https://canvex.gigalixirapp.com/).

**Attention**: Gigalixir free tier is very limited in terms of memory available, so you might find yourself looking at a `502 Bad Gateway` or a `503 Service Temporarily Unavailable` after trying to draw a canvas that is too big (larger than 350x350 or so). If that happens, it's because the server ran out of memory. In a minute or two the server will be up and running again, but you may have lost your art :(

For better validation of the project and visualization of the canvas on the Swagger UI and live view page, I suggest keeping the canvas size below 150x150.

## API

The API consists of three endpoints:

* `POST /api/canvas`: Creates a canvas
* `GET /api/canvas/{id}`: Shows a canvas, given it's UUID
* `PUT /api/canvas/{id}/draw`: Draws onto a canvas, given it's UUID

## Frontend

The complete API documentation was done with the `openapi` specifications and is available as a Swagger UI on the root `/` of the application.

Also, you can see the canvas being updated live on your browser by going to `/canvas/{id}`. Here's an example of Swagger UI and Live View side by side:

![Live view demo](./documentation/live_view_demo.gif)

## Overview

### Canvas

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

### Drawing operations

It's possible to do drawings on a `canvas` with ASCII printable `chars`.

The drawing operations possible are:
  - Draw a rectangle;
  - Do a flood fill.

Drawing operations are applied in the order they are given and may overlap.

#### Draw a rectangle

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

#### Do a flood fill

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


## Running locally

### Prerequisites

* Docker and docker-compose installed
* Ports 5432 and 4000 available

### Step-by-step

```
# Clone this repository and change to the project directory:
git clone https://github.com/ricardoebbers/canvex.git && cd canvex

# Spin up docker containers:
docker-compose up -d

# If it's the first time you run the project it will take some time for
# the app to be generated. You can see what's going on with:
docker-compose logs web 

# The app is up, but there are still migrations to run:
docker-compose run web mix ecto.setup
#     If you see a message 'The database for Canvex.Repo couldn't be created'
#     it's because the postgres container wasn't ready yet.
#     Try running the command again

# Finally, open your browser on localhost:4000 to find the Swagger UI API documentation
xdg-open http://localhost:4000
#     ^ Should work on ubuntu ;)

# Have fun! :)
```

### Testing

All automated tests can be run with `mix test` locally. You do need elixir and erlang installed though. I suggest using [asdf](https://thinkingelixir.com/install-elixir-using-asdf/) for that!

### Postman collection

For convenience and integration testing, a [postman collection](./postman/) is provided with all endpoints and requests examples.

### Cleaning up
```
# Clean up containers and images
docker-compose down --rmi local --volumes

# Delete project folder
cd ..
sudo rm -rf ./canvas
#     ^ You need to run the rm command as sudo
#     because the _build folder is created by the container
```

## Project architecture

### Dependencies

This is a Phoenix project and have the usual dependencies of one generated with a frontend.

Besides that, I've added the following:
* [credo](https://github.com/rrrene/credo) for static code analysis and linting
* [dialyxir](https://github.com/jeremyjh/dialyxir) for static analysis of `typespecs`
* [excoveralls](https://github.com/parroty/excoveralls) for code coverage and reporting
* [mix_test_watch](https://github.com/lpil/mix-test.watch) to run the test suite every time the code is changed
* [ex_machina](https://github.com/thoughtbot/ex_machina) as a factory for testing
* [open_api_spex](https://github.com/open-api-spex/open_api_spex) for API specification and Swagger UI generation

### Folders structure

The implementation follows the Phoenix convention of separating Web and internal domain:
```
lib
????????? canvex     # internal domain folder
????????? canvex.ex  # domain API
????????? canvex_web # default MVC architecture folder
```

The internal domain is divided as below:
```
canvex
????????? canvas                  # holds all operations that interfaces with the repository/database
???   ????????? create.ex
???   ????????? get.ex
???   ????????? update.ex
????????? draw                    # holds all the logic behind "drawing" on a canvas
???   ????????? flood_fill.ex
???   ????????? line.ex
???   ????????? rectangle.ex
???   ????????? stroke.ex
????????? draw.ex                 # provides a common interface for drawing operations
????????? schema                  
???   ????????? canvas.ex           # is an Ecto Schema, which holds and validates the data before persisting
????????? type
    ????????? ascii_printable.ex  # an Ecto Type to cast and validate that only ASCII chars are allowed
```
