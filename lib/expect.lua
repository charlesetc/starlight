local dbg = require "debugger"
local class = require "class"
local ml = require "ml"

local expect = {}

local function strip_suffix(str, suffix)
  local suffixPos = string.find(str, suffix, - #suffix, true)
  if suffixPos and suffixPos == #str - #suffix + 1 then
    return string.sub(str, 1, #str - #suffix)
  else
    return str
  end
end

local function dot_pairs(...)
  local args = table.pack(...)
  args.n = nil
  return ipairs(args)
end

local function printer()
  local p = { output = {} }

  local function sanitize(s)
    s = string.gsub(s, "0x%x%x%x%x%x%x%x%x%x%x%x%x", "0xPOINTER")
    return s
  end

  function p.print(...)
    for _, v in dot_pairs(...) do
      table.insert(p.output, sanitize(tostring(v)))
    end
  end

  function p.pp(...)
    for k, v in dot_pairs(...) do
      if k ~= 'n' then
        table.insert(p.output, sanitize(dbg.pretty(v)))
      end
    end
  end

  function p.read()
    return table.concat(p.output, '\n')
  end

  return p
end

local Expectation = class()

function Expectation:run()
  -- set up context
  local printer = printer()
  local old_print = _G.print
  local old_pp = _G.pp
  _G.print = printer.print
  _G.pp = printer.pp

  if expect.before then
    expect.before()
  end

  local _status = xpcall(self.f, function(err)
    print()
    print(debug.traceback(err, 2))
    print()
  end)

  -- tear down context
  _G.print = old_print
  _G.pp = old_pp

  -- print results
  self.result = printer.read()
  return strip_suffix(self.result, "\n") == strip_suffix(self.expected, "\n")
end

local expectations = {} -- really a global
local current_file = nil

function expect.test(description, expected, f)
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

local function files_matching(filter, extension)
  local files = {}

  for file in io.popen('ls test/*' .. extension .. ' 2>/dev/null'):lines() do
    local name = file:match('test/(.*)%' .. extension)
    if not filter or name:match(filter) then
      table.insert(files, file)
    end
  end

  return files
end

function expect.run_tests(filter)
  -- remove all previous .err files to begin with
  for _, file in ipairs(files_matching(nil, ".lua.err")) do
    os.remove(file)
  end

  -- first load the right files
  for _, file in ipairs(files_matching(filter, ".lua")) do
    current_file = file
    dofile(file)
  end

  -- then run the expectations
  for file, expectations_for_file in pairs(expectations) do
    local file_success = true
    for _, expectation in ipairs(expectations_for_file) do
      local success = expectation:run()
      file_success = file_success and success
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

function expect.accept(filter)
  for _, file in ipairs(files_matching(filter, ".lua.err")) do
    local destination = file:sub(1, -5) -- strip .err
    local pipe = assert(io.popen("mv " .. file .. " " .. destination))
    print(pipe:read("*all"))
    pipe:close()
  end
end

function expect.command(cmd, ...)
  if cmd == "run" then
    return expect.run_tests(...)
  elseif cmd == "accept" then
    return expect.accept(...)
  else
    print("unknown command " .. (cmd or '""') .. ", expected `run` or `accept`")
  end
end

return expect
