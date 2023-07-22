-- test the expect test library itself
local expect = require("expect")

expect("my first test", [[
]], function()
  print("2 plus 2 is")
  print(2 + 2)
end)
