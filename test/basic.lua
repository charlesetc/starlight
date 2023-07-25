local expect = require("expect")
require 'lake'



expect("a basic implementation", [[
"a 1"
::: a
::: b
"a 2"
::: c
"hi there"
{"value" = 200}
]], function()
  when('a', {}, function(a)
    print("::: a")
    when('b', {}, function(b)
      print("::: b")
      put('c', { value = a.value + b.value })
    end)
  end)

  when('a', {}, function(a)
    pp("a 1")
  end)

  when('a', {}, function(a)
    pp("a 2")
  end)

  put('a', { value = 100 })
  put('b', { value = 100 })

  when('c', {}, function(result)
    print("::: c")
    pp("hi there", result)
  end)

  recompute()
end)
