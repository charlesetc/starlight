local expect = require 'expect'
local class = require 'class'

expect.test("a basic class instantiation works", [[
2
]], function()
  local A = class()
  function A:test()
    return 2
  end

  print(A:new():test())
end)


expect.test("init is called when it exists", [[
"called!"
{"x" = 2, "y" = 3}
{"x" = 2, "y" = 3}
]], function()
  local A = class()

  function A:init()
    pp("called!", self)
  end

  pp(A:new({ x = 2, y = 3 }))
end)
