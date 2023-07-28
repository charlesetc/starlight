require 'init'
local rivulet = require 'rivulet'
local recompute = rivulet.recompute
local when = rivulet.when
local put = rivulet.put

local function init()
end

local function tick()
  recompute()
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
