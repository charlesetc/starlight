require 'init'
local star = {}

function star.init()
  if file_exists('~/.starconfig') then
    print("star config exists")
  end
  print("main")
end

function star.status()
  print("status")
end

star[arg[1] or 'status'](select(2, ...))
