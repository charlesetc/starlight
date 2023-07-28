local expect = require("expect")
require 'rivulet'

-- expect.test("nested whens", [[
-- "a 1"
-- ::: a
-- ::: b
-- "a 2"
-- ::: c
-- "hi there"
-- 200
-- ]], function()
--   when('a', {}, function(a)
--     print("::: a")
--     when('b', {}, function(b)
--       print("::: b")
--       put('c', { value = a.value + b.value })
--     end)
--   end)
--
--   when('a', {}, function(a)
--     pp("a 1")
--   end)
--
--   when('a', {}, function(a)
--     pp("a 2")
--   end)
--
--   put('a', { value = 100 })
--
--   put('b', { value = 100 })
--
--   when('c', {}, function(result)
--     print("::: c")
--     pp("hi there", result.value)
--   end)
--
--   recompute()
-- end)
--
expect.test("multiple recomputations", [[
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

  recompute()

  print('---')

  put('fact 1')

  recompute()

  put('fact 2')

  recompute()

  print('---')

  put('fact 3')

  rivulet_debug_graph()

  recompute()

  print('---')

  recompute()

  print('---')

  recompute()
end)
