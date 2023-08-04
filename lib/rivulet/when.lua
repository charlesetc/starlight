require "class"

local When = class()

function When:matches(atom)
  if self.pattern == nil then
    return true
  end

  if type(atom.data) ~= type(self.pattern) then
    return false
  end

  if type(atom.data) ~= "table" then
    return atom.data == self.pattern
  end

  for k, v in pairs(self.pattern) do
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

function When:run(atom)
  table.insert(rivulet_globals.dependencies, atom)
  self.f(atom.data)
  table.remove(rivulet_globals.dependencies)
end

return When
