local class = require 'class'

local meta = {}
local Point = class()
setmetatable(Point, meta)

function meta:__call(x, y)
  return Point:new { x = x, y = y }
end

return Point
