--local tostring, string = tostring, string
local httpserver = require("httpserver")

local module = {}

module.name = 'http'

module._srv = nil

local function echo(text)
    print('['..module.name..'] '..text)
end

function module.init(cnf, handler)
    module._srv = httpserver.createServer(cnf.port, handler)
    echo("Http server started at PORT: "..cnf.port)
end

return module
