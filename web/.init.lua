-- special script called by main redbean process at startup
HidePath('/usr/share/zoneinfo/')
HidePath('/usr/share/ssl/')

function addpath(path)
  package.path = package.path .. ';./' .. path .. '/?.lua;./' .. path .. '/?/?.lua'
end

addpath('lua')
print("listening on port 4242")
