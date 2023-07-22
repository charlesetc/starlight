local basics = {}

-- just flatten one depth
function basics.flatten(xs)
  local ys = {}
  for _, x in pairs(xs) do
    for _, y in pairs(x) do
      table.insert(ys, y)
    end
  end
  return ys
end

return basics
