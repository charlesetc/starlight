local ml = require "ml"
local basics = require "basics"
local class = require "class"

local When = require "rivulet.when"
local Atom = require "rivulet.atom"

local rivulet = {}

local whens = {}
local atoms = {}

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

local function atoms_for_pattern(english_key, pattern)
  local coll = {}
  for _, atom in pairs(atoms[english_key] or {}) do
    if When.pattern_matches_atom(pattern, atom) then
      table.insert(coll, atom)
    end
  end
  return coll
end

local function atoms_for_when(when)
  return atoms_for_pattern(when.english_key, when.pattern)
end

function rivulet.when(english_key, pattern, f)
  -- nice default arguments
  if not f then
    f = pattern
    pattern = nil
  end

  local when = When:new {
    english_key = english_key,
    pattern = pattern,
    f = f,
  }

  -- record dependency relationships
  for _, dependency in pairs(rivulet_globals.dependencies) do
    table.insert(dependency.children, when)
  end

  -- record self in `whens`
  whens[english_key] = whens[english_key] or {}
  table.insert(whens[english_key], when)

  -- run against each matching atom
  for _, atom in pairs(atoms_for_when(when)) do
    when:run(atom)
  end
end

function rivulet.put(english_key, data)
  local atom = Atom:new {
    english_key = english_key,
    data = data,
    children = {}
  }

  -- record dependency relationships
  for _, dependency in pairs(rivulet_globals.dependencies) do
    table.insert(dependency.children, atom)
  end

  -- record self in `atoms`
  atoms[english_key] = atoms[english_key] or {}
  table.insert(atoms[english_key], atom)

  -- run for each matching when
  for _, when in pairs(whens_for_atom(atom)) do
    when:run(atom)
  end
  return atom
end

rivulet.query   = atoms_for_pattern
rivulet.pat     = {}
rivulet.pat.any = { __rivulet_special = "any" }

return rivulet
