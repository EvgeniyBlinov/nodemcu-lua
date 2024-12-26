local module = {}

module.nodeId = 'nodemcu-id'

module.wifi = {
    ssid = "${WIFI_SSID}",
    pwd = "${WIFI_PASS}",
    auto = true,
    --bssid="AA:BB:CC:DD:EE:FF",
    --save=true
}

module.http = {
    port = 80,
}

module.handlerGpio = {
    settings = {
        defaults = {
            --start_level = gpio.HIGH,
            --mode = gpio.OUTPUT,
            --pullup = gpio.FLOAT,
            delay_times = 995000, -- 5 ms long every second
        }
    }
}

return module
