require "class"
local ml = require "ml"

local whens = {}
local data = {}

local When = class()

function When:compute()
  for _, datum in pairs(data[self.english_key]) do
    if self:matches(datum) then
      self.f(datum)
    end
  end
end

function When:matches(data)
  for k, v in pairs(self.pattern) do
    if data[k] ~= v then
      return false
    end
  end
  return true
end

function put(english_key, datum)
  data[english_key] = data[english_key] or {}
  table.insert(data[english_key], datum)
end

function when(english_key, pattern, f)
  local when = When:new { english_key = english_key, pattern = pattern, f = f }
  table.insert(whens, when)
end

local function step()
  for _, when in pairs(whens) do
    when:compute()
  end
end

function checksum(data)
  local sum = 0
  for english_key, data_list in pairs(data) do
    sum = sum + tonumber(string.format("%p", english_key))
    for _, datum in pairs(data_list) do
      sum = sum + tonumber(string.format("%p", datum))
    end
  end
  sum = sum * ml.count(data)
  return sum
end

function compute()
  local old, new
  repeat
    old = new
    step()
    new = checksum(data)
    pp(new)
  until old == new
end
