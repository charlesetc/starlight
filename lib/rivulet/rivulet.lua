require "class"
local ml = require "ml"
local basics = require "basics"
local class = require "class"

local When = require "rivulet.when"
local Atom = require "rivulet.atom"

local whens = {}
local atoms = {}

rivulet = {}

rivulet_globals = {
  whens = whens,
  atoms = atoms,
  dependencies = {}
}

function rivulet.reset()
  whens = {}
  atoms = {}
  rivulet_globals.whens = whens
  rivulet_globals.atoms = atoms
  rivulet_globals.dependencies = {}
end

local function whens_for_atom(atom)
  local coll = {}
  for _, when in pairs(whens[atom.english_key] or {}) do
    if when:matches(atom) then
      table.insert(coll, when)
    end
  end
  return coll
end

local function atoms_for_when(when)
  local coll = {}
  for _, atom in pairs(atoms[when.english_key] or {}) do
    if when:matches(atom) then
      table.insert(coll, atom)
    end
  end
  return coll
end

function when(english_key, pattern, f)
  if not f then
    f = pattern
    pattern = nil
  end

  local when = When:new {
    english_key = english_key,
    pattern = pattern,
    f = f,
    children = {},
    parent = parent,
    dependencies = basics.shallow_copy(rivulet_globals.dependencies),
  }

  whens[english_key] = whens[english_key] or {}
  table.insert(whens[english_key], when)

  for _, atom in pairs(atoms_for_when(when)) do
    when:run(atom)
  end
end

function put(english_key, data)
  local atom = Atom:new {
    english_key = english_key,
    data = data,
    dependencies = basics.shallow_copy(rivulet_globals.dependencies),
  }
  atoms[english_key] = atoms[english_key] or {}
  table.insert(atoms[english_key], atom)
  -- todo: check to make sure none of the dependencies would match this atom

  for _, when in pairs(whens_for_atom(atom)) do
    when:run(atom)
  end
  return atom
end
