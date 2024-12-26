local string = string

local module = {
    _mids = {}
}

module.name = 'httpRouter'


local function echo(text)
    print('['..module.name..'] '..text)
end
--------------------
-- helper
--------------------
local function urlDecode(url)
    return url:gsub('%%(%x%x)', function(x)
        return string.char(tonumber(x, 16))
    end)
end
--------------------
-- Middleware
--------------------
local function parseHeader(req, res)
    local _, _, path, vars = string.find(req.url, '(.+)?(.*)')
    if path == nil then
        _, _, path = string.find(req.url, '(.+)')
    end
    local _GET = {}
    if (vars ~= nil and vars ~= '') then
        vars = urlDecode(vars)
        for k, v in string.gmatch(vars, '([^&]+)=([^&]*)&*') do
            _GET[k] = v
        end
    end

    req.query = _GET
    req.path = path

    return true
end

local function pageNotFound(req, res)
    res:finish('Page not found.', 404)

    return false
end

--------------------
-- Router
--------------------

function module:init()
    return function(req, res)
        parseHeader(req, res)
        echo("+R:"..req.method..":"..req.url..":"..req.path)

        for i = 1, #self._mids do
            if string.find(req.path, '^' .. self._mids[i].url .. '$')
                and not self._mids[i].cb(req, res) then
                    break
            end
            if i == #self._mids then
                pageNotFound(req, res)
                break
            end
        end

        collectgarbage("collect")
    end
end

function module:use(url, cb)
    table.insert(self._mids, {
        url = url,
        cb = cb
    })
end

return module
