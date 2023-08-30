require 'init'
local expect = require 'expect'

local task = {}

function task.test(...)
  expect.run_tests(...)
end

function task.accept(...)
  expect.accept(...)
end

function task.main()
  print("main")
end

task[arg[1] or 'main'](select(2, ...))
