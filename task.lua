local task = {
  -- test = "lua test.lua run",
  -- accept = "lua test.lua accept",
  -- client = "/Applications/love.app/Contents/MacOS/love ."
}

function task.test()
  os.execute("lua test.lua run")
end

function task.accept()
  os.execute("lua test.lua accept")
end

function task.client()
  os.execute("/Applications/love.app/Contents/MacOS/love .")
end

task[arg[1]]()
