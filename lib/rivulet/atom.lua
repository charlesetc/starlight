local ml = require "dependencies.ml"
local Atom = class()

function Atom:withdraw()
  local atoms             = rivulet_globals.atoms
  atoms[self.english_key] = atoms[self.english_key] or {}
  basics.remove_value(atoms[self.english_key], self)

  for _, bucket in pairs(atoms) do
    for i, atom in pairs(bucket) do
      if atom == self then
        table.remove(bucket, i)
        return
      end
    end
  end
end

return Atom
