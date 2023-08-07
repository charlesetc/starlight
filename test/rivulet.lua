local expect = require("expect")
local r = require("rivulet")
local when = r.when
local put = r.put

function query(english_key)
  local results = r.query(english_key)
  local output = {}
  for _, result in pairs(results) do
    table.insert(output, result['english_key'])
  end
  return output
end

function expect.before()
  r.reset()
end

expect.test("nested whens", [[
::: a
--> 1
--> 2
::: b
::: c
]], function()
  when('a', function(a)
    print("::: a")
    when('b', function(b)
      print("::: b")
      put('c', a + b)
    end)
  end)

  when('a', function(a)
    print("--> 1")
  end)

  when('a', function(a)
    print("--> 2")
  end)

  put('a', 100)
  put('b', 100)

  when('c', function(result)
    print("::: c")
  end)
end)

expect.test("multiple recomputations", [[
evaluating fact 1
evaluating fact 2
evaluating fact 3
]], function()
  when('fact 1', function()
    print("evaluating fact 1")
    put('fact 2')
  end)

  when('fact 2', function()
    print("evaluating fact 2")
    when('fact 3', function()
      print("evaluating fact 3")
    end)
  end)

  put('fact 1')
  put('fact 3')
end)

expect.test("filter based on a field", [[
{"data" = 3, "ok" = 2}
]], function()
  when('a', { ok = 2 }, function(data)
    pp(data)
  end)

  put('a', { err = 1 })
  put('a', { ok = 2, data = 3 })
end)

expect.test("pat.any", [[
{"err" = 1}
{"err" = "hi", "extra" = 2}
]], function()
  when('a', { err = r.pat.any }, function(data)
    pp(data)
  end)
  put('a', { err = 1 })
  put('a', { ok = 2, data = 3 })
  put('a', { err = "hi", extra = 2 })
end)

expect.test("rivulet query", [[
"---"
{}
{}
{}
"---"
{1 = "a"}
{}
{}
"---"
{1 = "a"}
{1 = "b"}
{1 = "c"}
]], function()
  pp('---', query('a'), query('b'), query('c'))
  put('a')
  when('a', function()
    when('b', function()
      put('c')
    end)
  end)
  pp('---', query('a'), query('b'), query('c'))
  put('b')
  pp('---', query('a'), query('b'), query('c'))
end)


expect.test("withdrawing an atom should remove any atoms that depend on it", [[
"---"
{1 = "a"}
{1 = "b"}
{1 = "c"}
{1 = "d"}
"---"
{}
{}
{}
{}
]], function()
  local a = put('a')
  when('a', function()
    put('b')
  end)

  when('b', function()
    put('c')
  end)

  when('c', function()
    put('d')
  end)

  pp('---', query('a'), query('b'), query('c'), query('d'))
  a:withdraw()
  pp('---', query('a'), query('b'), query('c'), query('d'))
end)

expect.test("withdrawing an atom should remove the effect of any whens that depend on it ", [[
"---"
{1 = "a"}
{1 = "b", 2 = "b"}
{1 = "c", 2 = "c"}
"---"
{}
{1 = "b"}
{}
"---"
{}
{1 = "b", 2 = "b"}
{}
]], function()
  local a = put('a')
  local b1 = put('b')
  local b2 = put('b')

  when('a', function()
    when('b', function()
      put('c')
    end)
  end)
  pp('---', query('a'), query('b'), query('c'))
  a:withdraw()
  b1:withdraw()
  pp('---', query('a'), query('b'), query('c'))
  put('b')
  pp('---', query('a'), query('b'), query('c'))
end)

-- expect.test("update an atom", [[
-- ]], function()
--   local a = put('a', 2.4)
--   local b = put('b', 2.5)
--
--   when('a', function(a)
--     when('b', function(b)
--       put('c', a + b)
--     end)
--   end)
--
--   when('c', function(c)
--     pp(c)
--   end)
-- end)
