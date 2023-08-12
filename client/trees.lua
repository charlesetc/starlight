local class = require "class"

local Tree  = class()
local trees = {}
local Point = class()

function trees.init()
  self.tendrils = {}
  for i = 1, math.random(8) do
    table.insert(self.tendrils, { 0, 0 })
  end
end

function trees.create(root_square)
  local tree = Tree:new { root_square = root_square }
  root_square.color = { r = 0.1, g = 1, b = 0.2 }
  table.insert(trees, tree)
end

return trees
