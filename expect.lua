local dbg = require "dependencies.debugger"
require "class"

local function dot_pairs(...)
  local args = table.pack(...)
  args.n = nil
  return pairs(args)
end

local function printer()
  local p = { output = {} }

  function p.print(...)
    for _, v in dot_pairs(...) do
      table.insert(p.output, tostring(v))
    end
  end

  function p.pp(...)
    for k, v in dot_pairs(...) do
      if k ~= 'n' then
        table.insert(p.output, dbg.pretty(v))
      end
    end
  end

  function p.read()
    return table.concat(p.output, '\n')
  end

  return p
end

-- idea: run tests when the file is run directly and only then.
-- the file system is the testing framework.
-- also have a command to run all the tests at once

local Expectation = class()

function Expectation:run()
  -- set up context
  local tmp = io.tmpfile()
  local printer = printer(tmp)
  local old_print = _G.print
  local old_pp = _G.pp
  _G.print = printer.print
  _G.pp = printer.pp

  self.f()

  -- tear down context
  _G.print = old_print
  _G.pp = old_pp

  -- print results
  local result = printer.read()

  self.failed = result ~= self.expected_output

  if result ~= self.expected_output then
    print()
    print("--- TEST: " .. self.description .. " ---")
    print("expected", self.expected_output, "got", result)
  end
end

local expectations = {} -- really a global

local function expect(description, expected_output, f)
  expectation = Expectation:new {
    description = description,
    expected_output = expected_output,
    f = f
  }
  table.insert(expectations, expectation)
end

library = {}

function library.run_tests(filter)
  -- first load the right files
  local files = {}

  for file in io.popen('ls test'):lines() do
    if not filter or file:match(filter) then
      table.insert(files, file)
    end
  end

  for _, file in ipairs(files) do
    dofile('test/' .. file)
  end

  -- then run the expectations
  for _, expectation in ipairs(expectations) do
    expectation:run()
  end
end

setmetatable(library, { __call = function(self, ...) return expect(...) end })

return library
