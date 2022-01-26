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

### Locally

#### Prerequisites

* Docker and docker-compose installed
* Ports 5432 and 4000 available

#### Step-by-step

* Clone this repository
* 
TODO: describe all steps

#### Postman collection

For convenience a [postman collection](./postman/) is provided with all endpoints and requests examples.


### Gigalixir

TODO: deploy to Gigalixir
## Overview

The implementation follows the Phoenix convention of separating Web and internal domain:
  - canvex: internal domain
  - canvex_web: default MVC architecture

The internal domain is separated into three main parts:
  - canvas: holds all operations that interfaces with the repository/database (create, get, update)
  - draw: holds all the logic behind "drawing" on a canvas
  - schema: holds the `canvas` schema, which validates the data before persisting.

TODO: add more details
