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
  os.execute("/Applications/love.app/Contents/MacOS/love .")
end

task[arg[1] or 'test'](select(2, ...))
