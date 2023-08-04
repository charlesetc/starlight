local task = {}

function task.test()
  os.execute("lua test.lua run")
end

function task.accept()
  os.execute("lua test.lua accept")
end

function task.client()
  os.execute("/Applications/love.app/Contents/MacOS/love .")
end

task[arg[1] or 'test']()
