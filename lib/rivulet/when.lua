local class = require "class"
local basics = require "basics"

local When = class()

function When:init()
  self.withdrawn = false
end

function When.pattern_matches_atom(pattern, atom)
  if pattern == nil then
    return true
  end

  if type(atom.data) ~= type(pattern) then
    return false
  end

  if type(atom.data) ~= "table" then
    return atom.data == pattern
  end

  for k, v in pairs(pattern) do
    if type(v) == "table" and v.__rivulet_special == "any" then
      if atom.data[k] == nil then
        return false
      end
    else
      if atom.data[k] ~= v then
        return false
      end
    end
  end
  return true
end

function When:matches(atom)
  return When.pattern_matches_atom(self.pattern, atom)
end

function When:run(atom)
  table.insert(rivulet_globals.dependencies, atom)
  self.f(atom.data)
  table.remove(rivulet_globals.dependencies)
end

function When:withdraw(atom)
  if self.withdrawn then
    return
  end
  self.withdrawn = true

  -- remove ourself from `whens`
  local whens = rivulet_globals.whens
  whens[self.english_key] = whens[self.english_key] or {}
  basics.remove_value(whens[self.english_key], self)
end

return When
