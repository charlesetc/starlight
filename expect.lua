local dbg = require "dependencies.debugger"
require "class"
local ml = require "dependencies.ml"

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
  local printer = printer()
  local old_print = _G.print
  local old_pp = _G.pp
  _G.print = printer.print
  _G.pp = printer.pp

  self.f()

  -- tear down context
  _G.print = old_print
  _G.pp = old_pp

  -- print results
  self.result = printer.read()
  self.failed = self.result ~= self.expected
end

local expectations = {} -- really a global
local current_file = nil

local function expect(description, expected, f)
  local expectation = Expectation:new {
    description = description,
    expected = expected,
    f = f,
    line = debug.getinfo(2).currentline,
  }
  expectations[current_file] = expectations[current_file] or {}
  table.insert(expectations[current_file], expectation)
end

local function write_corrected_file(filename, expectations_for_file)
  local expectations_by_line = {}
  for _, expectation in pairs(expectations_for_file) do
    expectations_by_line[expectation.line] = expectation
  end

  local file = assert(io.open(filename, "r"))
  local new_contents = {}

  local drop = false
  for i, line in ipairs(ml.collect(file:lines())) do
    if line:sub(1, 2) == "]]" then
      drop = false
    end
    if not drop then
      table.insert(new_contents, line .. "\n")
    end
    if expectations_by_line[i] then
      table.insert(new_contents, expectations_by_line[i].result .. "\n")
      drop = true
    end
  end
  file:close()

  local errfile = assert(io.open(filename .. '.err', "w"))
  errfile:write(table.concat(new_contents))
  errfile:close()
end

local function run_tests(filter)
  -- first load the right files
  local files = {}

  for file in io.popen('ls test/*.lua'):lines() do
    name = file:match('test/(.*)%.lua')
    if not filter or name:match(filter) then
      table.insert(files, file)
    end
  end

  for _, file in ipairs(files) do
    current_file = file
    dofile(file)
  end

  -- then run the expectations
  for file, expectations_for_file in pairs(expectations) do
    local file_success = true
    for _, expectation in ipairs(expectations_for_file) do
      expectation:run()

      file_success = file_success and not expectation.failed
    end

    if file_success then
      print(file .. ' passed')
    else
      print(file .. ' failed')
      write_corrected_file(file, expectations_for_file)
      local pipe = assert(io.popen("patdiff -context 3 " .. file .. " " .. file .. ".err"))
      local diff = pipe:read("*all")
      print(diff)
      pipe:close()
    end
  end
end

local library = { run_tests = run_tests }
setmetatable(library, { __call = function(self, ...) return expect(...) end })

return library
