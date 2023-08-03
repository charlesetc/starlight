-- changes that I want:
-- - require should also setlocal for the basename of the module
-- - open should require and setlocal for each module in the list
-- - there should be a way to set a new variable that gets the right index
-- - also: add and test rivulet.pattern.any

local expect = require("expect")
require("rivulet")

function expect.before()
  rivulet.reset()
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
