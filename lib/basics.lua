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

return basics
