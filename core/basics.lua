local basics = {}

-- just flatten one depth
function basics.flatten(xs)
  local ys = {}
  -- TODO: use ipairs maybe but careful bc we're not passing in an array anymore
  for _, x in pairs(xs) do
    for _, y in pairs(x) do
      table.insert(ys, y)
    end
  end
  return ys
end

function basics.shallow_copy(input)
  local output = {}
  for k, v in pairs(input) do
    output[k] = v
  end
  return output
end

function basics.remove_value(xs, x)
  for i, y in pairs(xs) do
    if x == y then
      table.remove(xs, i)
      return
    end
  end
end

function basics.with_file(name, mode, callback)
  local f = io.open(name, mode)
  local ret = callback(f)
  io.close(f)
  return ret
end

return basics
