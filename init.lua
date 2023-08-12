-- setup `require` to work with dependencies
function addpath(path)
  package.path = package.path .. ';./' .. path .. '/?.lua;./' .. path .. '/?/?.lua'
end

addpath('dependencies')
addpath('lib')
addpath('client')

dbg = require 'debugger'
pp = dbg.pp
