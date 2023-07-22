function class()
  local c = {}

  function c:new(o)
    o = o or {} -- create object if user does not provide one
    setmetatable(o, c)
    self.__index = c
    return o
  end

  return c
end
