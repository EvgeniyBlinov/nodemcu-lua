local module = {}

local config = require('config')
local wifiService = require('wifiService')
local httpRouter = require('httpRouter')
local httpService = require('httpService')
local handlerGpio = require('handlerGpio')

function module.start()
    print('Node ID is: ' .. config.nodeId)
    wifiService.init(config.wifi)
    local handlerGpioConfig = {}
    if config.handlerGpio ~= nil then
        handlerGpioConfig = config.handlerGpio
    end
    httpRouter:use('/gpio', handlerGpio.createHandler(handlerGpioConfig))
    httpService.init(config.http, httpRouter:init())
end

return module
