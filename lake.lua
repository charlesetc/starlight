require 'init'
local expect = require 'expect'

local task = {}

function task.test(...)
  expect.run_tests(...)
end

function task.accept(...)
  expect.accept(...)
end

function task.client()
  task.test()
  os.execute("/Applications/love.app/Contents/MacOS/love client")
end

task[arg[1] or 'client'](select(2, ...))
