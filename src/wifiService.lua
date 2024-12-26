local wifi = require("wifi")

local module = {}

module.name = 'WiFi'
module.onConnect = nil
module.onDisconnect = nil
module.connected = false

local moduleConfig = {
    ssid = "WIFI_SSID",
    pwd = "WIFI_PASS",
    auto = true,
}

local function echo(text)
    print('['..module.name..'] '..text)
end


function module.init(cnf)
    moduleConfig = cnf
    wifi.setmode (wifi.STATION)
    wifi.sta.config(cnf)

    wifi.eventmon.unregister(wifi.eventmon.STA_CONNECTED)
    wifi.eventmon.register(wifi.eventmon.STA_CONNECTED, function(T)
        echo("Connection to AP("..T.SSID..") established!")
        echo("Waiting for IP address...")
    end)

    wifi.eventmon.unregister(wifi.eventmon.STA_GOT_IP)
    wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, function(T)
        module.connected = true
        echo ("IP: "..T.IP)
        if(module.onConnect ~= nil) then
            module.onConnect()
        end
    end)

    wifi.eventmon.unregister(wifi.eventmon.STA_DISCONNECTED)
    wifi.eventmon.register(wifi.eventmon.STA_DISCONNECTED, function(T)
        if(module.connected == true) then
            module.connected = false
            echo("Disconnected from: "..T.SSID)
            if(module.onDisconnect ~= nil) then
                module.onDisconnect()
            end
        end
    end)
end

function module.connect()
    echo('Connecting to ' .. moduleConfig.ssid)
    wifi.sta.autoconnect (1)
end

function module.disconnect()
    echo('Disconnecting from ' .. moduleConfig.ssid)
    wifi.sta.autoconnect(0)
    wifi.sta.disconnect()
end

return module
