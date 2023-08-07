local ml = require "ml"
local basics = require "basics"
local class = require 'class'

local Atom = class()

function Atom:init()
  self.withdrawn = false
end

function Atom:withdraw()
  -- this is so that we don't have to worry about removing ourself from
  -- the referecences in other children groups
  if self.withdrawn then
    return
  end
  self.withdrawn          = true

  -- remove ourself from `atoms`
  local atoms             = rivulet_globals.atoms
  atoms[self.english_key] = atoms[self.english_key] or {}
  basics.remove_value(atoms[self.english_key], self)

  -- can be either atoms or whens
  for _, item in pairs(self.children) do
    item:withdraw()
  end
end

return Atom
