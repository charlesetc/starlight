local class = require "class"

local Tree  = class()
local trees = {}

function trees.create(root_square)
  local tree = Tree:new { root_square = root_square }
  root_square.color = { r = 0.1, g = 1, b = 0.2 }
  table.insert(trees, tree)
end

return trees
