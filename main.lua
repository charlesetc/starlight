-- setup `require` to work with dependencies
package.path = package.path .. ';./dependencies/?.lua;./dependencies/?/init.lua'

local dbg = require("debugger")
require("lake")

local function init()
end

local function tick()
  lake.compute()
end

local function render()
end

local function main()
  init()
  while true do
    tick()
    render()
  end
end
