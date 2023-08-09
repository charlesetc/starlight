local love  = require 'love'
local r     = require 'rivulet'
local when  = r.when
local put   = r.put
local query = r.query


local squares        = {}
local squares_across = 80
local squares_tall   = 80
local square_size    = 20

function squares.init()
  for i = 1, squares_across do
    for j = 1, squares_tall do
      put("square", { x = i, y = j })
    end
  end
end

function squares.draw(offset)
  local squares = r.query("square")
  for _, square in pairs(squares) do
    square = square.data
    love.graphics.setColor(square.color.r, square.color.g, square.color.b)
    love.graphics.rectangle(
      "fill",
      square.x * square_size - offset.x,
      square.y * square_size - offset.y,
      square_size,
      square_size)
  end
end

return squares
