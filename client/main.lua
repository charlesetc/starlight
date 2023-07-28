dofile(os.getenv("HOME") .. "/.lua/init.lua")


function love.load(args)
  host = args[1] or "localhost"
  port = tonumber(args[2]) or 8080
  pp(host, port)
  love.window.setMode(500, 500, { resizable = true, minwidth = 400, minheight = 400 })
  offset = { x = 0, y = 0 }
end

function love.update(dt)
  -- move the offset according to the keyboard

  -- if love.keyboard.isDown("up") then
  --   offset.y = offset.y - 2
  -- end
  --
  -- if love.keyboard.isDown("down") then
  --   offset.y = offset.y + 2
  -- end
  --
  -- if love.keyboard.isDown("left") then
  --   offset.x = offset.x - 2
  -- end
  --
  -- if love.keyboard.isDown("right") then
  --   offset.x = offset.x + 2
  -- end
end

function love.keyreleased(key)
  local delta = 200
  -- move the offset according to the keyboard
  if key == "up" then
    offset.y = offset.y - delta
  end

  if key == "down" then
    offset.y = offset.y + delta
  end

  if key == "left" then
    offset.x = offset.x - delta
  end

  if key == "right" then
    offset.x = offset.x + delta
  end
end

function love.draw()
  -- for each square in the grid
  for i = 0, 40 do
    for j = 0, 40 do
      -- set a more and more light green color
      love.graphics.setColor(0, 0.5 + i / 80, 0, 1)

      -- draw the square
      love.graphics.rectangle("fill", i * 20 - offset.x, j * 20 - offset.y, 20, 20)
    end
  end
end
