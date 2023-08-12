dofile('init.lua')
local love    = require 'love'

local squares = require 'client.squares'

local offset  = nil

function love.load(args)
  love.window.setMode(1000, 600, { resizable = true, minwidth = 400, minheight = 400 })
  offset = { x = 0, y = 0 }
  squares.init()
end

function love.keypressed(key)
  local delta = 200
  if key == "up" then
    offset.y = offset.y - delta
  end

  if key == "down" then
    offset.y = offset.y + delta
  end

  if key == "left" then
    offset.x = offset.x - delta
  end

  if key == "right" then
    offset.x = offset.x + delta
  end
end

function love.update(_dt)
end

function love.draw()
  squares.draw(offset)
end