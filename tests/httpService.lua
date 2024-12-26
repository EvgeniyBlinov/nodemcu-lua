local module = {}

module.name = 'http'

module._srv = nil

local function echo(text)
    print('['..module.name..'] '..text)
end

local Request = {
    url = '',
    path = '',
    method = '',
    query = {},
}


local Response = {}

function Response:send_header(k, v)
    echo('Header: '..tostring(k)..'='..tostring(v))
end

function Response:send(msg, status)
    echo('Data: '..tostring(msg)..';status='..tostring(status))
end

function Response:finish()
    echo('Conn:close()')
end

local function gpioTest(handler)
    echo('======== gpio test with all params =======')
    local req = Request
    req.method = 'GET'
    req.url = '/gpio?gpio=1&start_level=1&mode=1&pullup=1&action=blink'

    local res = Response
    handler(req, res)
end

local function gpioTest_gpioOnly(handler)
    echo('======== gpio test with gpio only ========')
    local req = Request
    req.method = 'GET'
    req.url = '/gpio?gpio=1'

    local res = Response
    handler(req, res)
end

local function gpioTest_delayTimes1(handler)
    echo('======== gpio test delay_times 1 ========')
    local req = Request
    req.method = 'GET'
    req.url = '/gpio?gpio=1&delay_times=995000'

    local res = Response
    handler(req, res)
end

local function gpioTest_delayTimes2(handler)
    echo('======== gpio test delay_times 2 ========')
    local req = Request
    req.method = 'GET'
    req.url = '/gpio?gpio=1&delay_times=995000,995000'

    local res = Response
    handler(req, res)
end

local function gpioTest_emptyParams(handler)
    echo('======== gpio test with empty params =======')
    local req = Request
    req.method = 'GET'
    req.url = '/gpio'

    local res = Response
    handler(req, res)
end

local function gpioTest_wrongAction(handler)
    echo('======== gpio test wrong action ========')
    local req = Request
    req.method = 'GET'
    req.url = '/gpio?gpio=1&action=wrong'

    local res = Response
    handler(req, res)
end

function module.init(cnf, handler)
    echo("Http server started at PORT: "..cnf.port)
    gpioTest(handler)
    gpioTest_gpioOnly(handler)
    gpioTest_delayTimes1(handler)
    gpioTest_delayTimes2(handler)
    gpioTest_emptyParams(handler)
    gpioTest_wrongAction(handler)
end

return module

