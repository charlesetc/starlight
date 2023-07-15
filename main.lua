local dbg = require("dependencies.debugger")
local lake = require("lake")

local function init()
end

local function tick()
  lake.compute()
end

local function render()
end

init()
while true do
  tick()
  render()
end
