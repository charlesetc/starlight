dofile('init.lua')
local class = require 'class'

local width = 40
local height = 40
local squares = {}

local Square = class()

function Square:draw()
  love.graphics.setColor(0, 0.5 + self.i / 80, 0, 1)
  love.graphics.rectangle("fill", self.i * 20 - offset.x, self.j * 20 - offset.y, 20, 20)
end

local function init()
  offset = { x = 0, y = 0 }
  for i = 1, width do
    squares[i] = {}
    for j = 1, height do
      squares[i][j] = Square:new({ i = i, j = j })
    end
  end
end

function love.load(args)
  local host = args[1] or "localhost"
  local port = tonumber(args[2]) or 8080
  love.window.setMode(1000, 600, { resizable = true, minwidth = 400, minheight = 400 })
  init()
end

function love.update(dt)
end

function love.keyreleased(key)
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

function love.draw()
  for _, row in ipairs(squares) do
    for _, square in ipairs(row) do
      square:draw()
    end
  end
end
