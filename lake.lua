local lake = {}
local reservoir = {}
local whens = {}
local computing = false

--- Define a computation over data within the incremental computation graph
---
--- usage: when("a ball is on the edge", {id = 4}, function (ball) ... end
function lake.when(namespace, pattern, f)
  table.insert(whens, { namespace = namespace, pattern = pattern, callback = f })
end

--- Insert data into the incremental computation graph
---
--- usage: provide("a ball is on the edge", {id = 4, position: {x, y}})
function lake.add(namespace, data)
  reservoir[namespace] = reservoir[namespace] or {}
  table.insert(reservoir[namespace], { data = data, computed = computing })
end

local function remove_computed()
  -- this could be a bit more efficient, storing two namespace addition tables,
  -- one for computed and one for the not-computed, and then clearing the computed
  -- table here.
  for _, namespace_additions in pairs(reservoir) do
    local deletions = {}
    for i, addition in ipairs(namespace_additions) do
      if addition.computed then
        table.insert(deletions, i)
      end
    end

    for _, deletion in pairs(deletions) do
      table.remove(namespace_additions, deletion)
    end
  end
end

function lake.compute()
  remove_computed()

  computing = true

  -- for each when
  for _, when in pairs(whens) do
    -- for each data `add`ed to the when's namespace
    for _, addition in pairs(reservoir[when.namespace]) do
      local data = addition.data
      --- if the pattern matches, call the callback
      local matches = true

      for key, assertion in ipairs(when.pattern) do
        if assertion ~= data[key] then
          matches = false
          break
        end
      end

      if matches then
        local status, err = pcall(function() when.callback(data) end)
        if not status then
          print("encountered an error in callback to when", debug.traceback(err))
        end
      end
    end
  end

  computing = false
end

return lake
