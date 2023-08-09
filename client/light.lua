local r     = require 'rivulet'
local when  = r.when
local put   = r.put
local query = r.query

local light = {}

when('square', function(square)
  when('time', function(t)
    square.color = {
      r = 0.2,
      g = 0.4,
      b = 0.4,
    }
  end)
end)


return light
