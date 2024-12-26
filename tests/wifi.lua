local module = {}

function module.setmode(int)
end

local Station = {}

function Station.config(cnf)
end

local Eventmon = {
    STA_CONNECTED = 0,
    STA_DISCONNECTED = 1,
    STA_GOT_IP = 1,
}

function Eventmon.unregister(int)
end

function Eventmon.register(int, cb)
    local t = {
        SSID = 'Test wifi',
        IP = '192.168.0.1',
    }
    cb(t)
end

module.sta = Station
module.eventmon = Eventmon

return module
