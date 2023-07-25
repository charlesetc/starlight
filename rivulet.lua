require "class"
local ml = require "ml"
local basics = require "basics"

local When = class()

local whens = {}
local toplevel_whens = {}
local parent = nil
local depth = 0
local data = {}

function When:matches(datum)
  for k, v in pairs(self.pattern) do
    if datum[k] ~= v then
      return false
    end
  end
  return true
end

function When:compute()
  -- set up context
  depth = depth + 1
  current_parent = parent
  parent = self

  -- run against the data
  if data[self.english_key] then
    for _, datum in pairs(data[self.english_key]) do
      if self:matches(datum) then
        -- maybe pcall this at some point
        self.f(datum)
      end
    end
  end

  -- tear down context
  parent = current_parent
  depth = depth - 1
end

function When:record()
  if self.parent then
    table.insert(self.parent.children, self)
  else
    table.insert(toplevel_whens, self)
  end

  whens[self.english_key] = whens[self.english_key] or {}
  table.insert(whens[self.english_key], self)
end

function When:unrecord()
  -- unrecord all children
  for _, child in pairs(self.children) do
    child:unrecord()
  end

  -- remove reference from the parent's children
  if self.parent then
    table.remove(self.parent.children, ml.indexof(self.parent.children, self))
  else
    table.remove(toplevel_whens, ml.indexof(toplevel_whens, self))
  end

  -- remove reference from the whens table
  table.remove(whens[self.english_key], ml.indexof(whens[self.english_key], self))

  -- mark as not stale, so we will skip this in the iteration of `recompute`
  self.stale = false
end

function put(english_key, datum)
  data[english_key] = data[english_key] or {}
  table.insert(data[english_key], datum)


  whens[english_key] = whens[english_key] or {}
  for _, when in pairs(whens[english_key]) do
    if when:matches(datum) then
      when.stale = true
    end
  end
end

function when(english_key, pattern, f)
  local when = When:new {
    english_key = english_key,
    pattern = pattern,
    f = f,
    children = {},
    depth = depth,
    stale = false,
    parent = parent,
  }

  when:record()
  when:compute()
end

function recompute()
  local done
  repeat
    done = true
    local by_depth = function(a, b) return a.depth < b.depth end
    whens_by_depth = basics.flatten(whens)
    table.sort(whens_by_depth, by_depth)
    for _, when in ipairs(whens_by_depth) do
      -- it's important that this `if` is here and not a filter
      -- because we don't want to recompute a when that was unrecorded
      if when.stale then
        done = false
        when.stale = false
        when:unrecord()
        when:record()
        when:compute()
      end
    end
  until done
end
