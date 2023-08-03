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

-- local parent = nil
-- local depth = 0
-- local data = {}
--
-- function When:matches(datum)
--   for k, v in pairs(self.pattern) do
--     if datum[k] ~= v then
--       return false
--     end
--   end
--   return true
-- end
--
-- function When:compute()
--   -- set up context
--   depth = depth + 1
--   current_parent = parent
--   parent = self
--
--   -- run against the data
--   if data[self.english_key] then
--     for _, datum in pairs(data[self.english_key]) do
--       if self:matches(datum) then
--         -- maybe pcall this at some point
--         self.f(datum)
--       end
--     end
--   end
--
--   -- tear down context
--   parent = current_parent
--   depth = depth - 1
-- end
--
-- function When:record()
--   whens[self.english_key] = whens[self.english_key] or {}
--
--   -- only record ourself if this when isn't already recorded
--   if not whens[self.english_key][self.f] then
--     whens[self.english_key][self.f] = self
--
--     if self.parent then
--       table.insert(self.parent.children, self)
--     end
--   end
-- end
--
-- function When:unrecord()
--   -- unrecord all children
--   for _, child in pairs(self.children) do
--     child:unrecord()
--   end
--
--   -- remove reference from the parent's children
--   if self.parent then
--     table.remove(self.parent.children, ml.indexof(self.parent.children, self))
--   end
--
--   -- remove reference from the whens table
--   whens[self.english_key][self.f] = nil
--
--   -- mark as not stale, so we will skip this in the iteration of `recompute`
--   self.stale = false
-- end
--
-- -- TODO: keep track of the puts that the whens used to have and no longer have
-- function put(english_key, datum)
--   datum = datum or {}
--   data[english_key] = data[english_key] or {}
--   table.insert(data[english_key], datum)
--
--
--   whens[english_key] = whens[english_key] or {}
--   for _, when in pairs(whens[english_key]) do
--     if when:matches(datum) then
--       when.stale = true
--     end
--   end
-- end
--
-- function when(english_key, pattern, f)
--   if not f then
--     f = pattern
--     pattern = {}
--   end
--
--   local when = When:new {
--     english_key = english_key,
--     pattern = pattern,
--     f = f,
--     children = {},
--     depth = depth,
--     stale = false,
--     parent = parent,
--   }
--
--   when:record()
--   when:compute()
-- end
--
-- function recompute()
--   local done
--   repeat
--     done = true
--     local by_depth = function(a, b) return a.depth < b.depth end
--     whens_by_depth = basics.flatten(whens)
--     table.sort(whens_by_depth, by_depth)
--     for _, when in ipairs(whens_by_depth) do
--       -- it's important that this `if` is here and not a filter
--       -- because we don't want to recompute a when that was unrecorded
--       if when.stale then
--         done = false
--         when.stale = false
--         when:unrecord()
--         when:record()
--         when:compute()
--       end
--     end
--   until done
-- end
--
-- function rivulet_debug_graph()
--   for k, v in pairs(whens) do
--     print(k)
--     for _, when in pairs(v) do
--       print("  " .. dbg.pretty(when))
--     end
--   end
-- end
