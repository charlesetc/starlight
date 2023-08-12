local task = {}

-- function task.fetch_htmx()
--   os.execute("curl https://unpkg.com/htmx.org@1.9.4 > htmx.min.js")
-- end

function task.package()
  local files = {
    '.args',
    '.init.lua',
    'hello.lua',
    'lua/template.lua',
    '_index.html'
  }

  for _, file in ipairs(files) do
    os.execute('zip starlight.com ' .. file)
  end
end

function task.run()
  task.package()
  os.execute("./starlight.com")
end

local a = arg[1] or "run"
a = string.gsub(a, "-", "_")
task[a](select(2, ...))
