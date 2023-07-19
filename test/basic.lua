require 'lake'

when('a', {}, function(a)
  when('b', {}, function(b)
    put('a + b', { value = a.value + b.value })
  end)
end)

put('a', { value = 1 })
put('b', { value = 2 })

compute()
