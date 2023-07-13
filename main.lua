local dbg = require("dependencies/debugger")

print("Hello world")

entity = {
  x = 0,
  y = 0,
  width = 32,
  height = 32,
  speed = 100
}
dbg.pp(entity)
