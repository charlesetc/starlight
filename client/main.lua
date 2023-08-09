dofile('init.lua')
local love    = require 'love'
local r       = require 'rivulet'
local put     = r.put

local squares = require 'client.squares'
local _       = require 'client.light'
local _       = require 'client.trees'


local offset = nil

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

local time = put("time", 0.0)
local t = 0


function love.update(_dt)
  time:withdraw()
  t = t + 1
  time = put("time", t)
end

function love.draw()
  squares.draw(offset)
end
