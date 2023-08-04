local expect = require "expect"
local basics = require "basics"

expect.test("basics.flatten", [[
{1 = 1, 2 = 2, 3 = 3, 4 = 4, 5 = {1 = 2}, 6 = 6}
]], function()
  local xs = { { 1, 2, 3 }, { 4, { 2 }, 6 } }
  pp(basics.flatten(xs))
end)

expect.test("basics.shallow_copy", [[
{"xs" = {"a" = 2}}
{"ys" = {"a" = 3}}
]], function()
  local xs = { a = 2 }
  local ys = basics.shallow_copy(xs)
  ys.a = 3
  pp { xs = xs }
  pp { ys = ys }
end)

expect.test("basics.remove_value", [[
{1 = 1, 2 = 2, 3 = 2}
]], function()
  local xs = { 1, 2, 3, 2 }
  basics.remove_value(xs, 3)
  pp(xs)
end)
