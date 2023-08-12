local love           = require 'love'
local class          = require "class"

local Square         = class()

local squares        = {}
local squares_across = 80
local squares_tall   = 80
local square_size    = 20

function squares.init()
  for i = 1, squares_across do
    for j = 1, squares_tall do
      local color = { r = 0, g = 0, b = 0 }
      local square = Square:new { x = i, y = j, color = color }
      table.insert(squares, square)
    end
  end
end

function squares.draw(offset)
  for _, square in ipairs(squares) do
    love.graphics.setColor(square.color.r, square.color.g, square.color.b)
    love.graphics.rectangle(
      "fill",
      square.x * square_size - offset.x,
      square.y * square_size - offset.y,
      square_size,
      square_size)
  end
end

function squares.random()
  return squares[math.random(#squares)]
end

return squares
