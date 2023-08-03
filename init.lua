-- setup `require` to work with dependencies
function search(path)
  package.path = package.path .. ';./' .. path .. '/?.lua;./' .. path .. '/?/?.lua'
end

search('dependencies')
search('lib')
search('client')
