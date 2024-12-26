local utils = require('utils')
local gpio = require('gpio')
local tmr = require('tmr')
local module = {}

module.name = 'handlerGpio'

local next = next

local function echo(text)
    print('['..module.name..'] '..text)
end

local GpioValidator = {}
GpioValidator.settings = {
    defaults = {
        start_level = gpio.HIGH,
        mode = gpio.OUTPUT,
        pullup = gpio.FLOAT,
        delay_times = {5000,995000}, -- 5 ms long every second
        action = 'blink',
    }
}

function GpioValidator.get(name, default)
    if GpioValidator.settings.defaults[name] ~= nil then
        return GpioValidator.settings.defaults[name]
    else
        return default
    end
end

function GpioValidator.ruleDelayTimes(value)
    local err = ''
    local values = {}

    for v in string.gmatch(value, "(%d+)") do
        table.insert(values, v)
    end

    return err, values
end

GpioValidator.rules = {
    { name = 'gpio'        ,r = '^[0-9]+$', required = true },
    { name = 'start_level' ,r = '^[0-1]$',   required = false, default = GpioValidator.get('start_level', gpio.HIGH) },
    { name = 'mode'        ,r = '^[0-1]$',   required = false, default = GpioValidator.get('mode', gpio.OUTPUT) },
    { name = 'pullup'      ,r = '^[0-1]$',   required = false, default = GpioValidator.get('pullup', gpio.FLOAT) },
    { name = 'delay_times' ,r = GpioValidator.ruleDelayTimes,  required = false, default = GpioValidator.get('delay_times', {5000,995000}) },
    { name = 'action'      ,r = '^(blink)$', required = false, default = GpioValidator.get('action', 'blink') },
}

function GpioValidator.validate(query)
    local errors = {}
        for _, rule in ipairs(GpioValidator.rules) do
            if query[rule.name] ~= nil then
                if type(rule.r) == 'string' then
                    if not string.match(query[rule.name], rule.r) then
                        table.insert(errors, {
                            name = rule.name,
                            msg = 'Field %s has wrong data!'
                        })
                    end
                elseif type(rule.r) == 'function' then
                    local ruleFnError, ruleFnValue = rule.r(query[rule.name])
                    if ruleFnError ~= '' then
                        table.insert(errors, {
                            name = rule.name,
                            msg = ruleFnError
                        })
                    else
                        query[rule.name] = ruleFnValue
                    end
                end
            else
                if rule.required then
                    table.insert(errors, {
                        name = rule.name,
                        msg = 'Field %s required!'
                    })
                else
                    if rule['default'] ~= nil then
                        query[rule.name] = GpioValidator.get(rule.name, rule['default'])
                    end
                end
            end
        end

    return errors
end

local function gpio_blink(g, mode, pullup, start_level, delay_times)
    local tmrDelay
    if type(delay_times) == 'number' then
        tmrDelay = delay_times
    else
        tmrDelay = table.remove(delay_times, 1)
    end
    echo('[->gpio_blink](gpio=' .. g ..', mode='.. mode ..', pullup='.. pullup ..', start_level='.. start_level ..', delay_times='.. tmrDelay ..')')
    gpio.mode(g, mode, pullup)
    gpio.write(g, start_level)
    tmr.delay(tmrDelay)
    if start_level == gpio.HIGH then
        gpio.write(g, gpio.LOW)
    else
        gpio.write(g, gpio.HIGH)
    end
end

local function gpio_serout(g, mode, pullup, start_level, delay_times)
    echo('[->gpio_serout](gpio=' .. g ..', mode='.. mode ..', pullup='.. pullup ..', start_level='.. start_level ..', delay_times='.. utils:dump(delay_times) ..')')
    gpio.mode(g, mode, pullup)
    gpio.serout(g, start_level, delay_times, 1, 1)
end

function module.handler(req, res)
    local dataErrors = GpioValidator.validate(req.query)
    echo("+R:/gpio:"..req.method..":"..req.url)

    if next(dataErrors) ~= nil then
        res:finish('Bad request!\r\n', 400)
        return false
    end

    if req.query.action == 'blink' then
        gpio_blink(req.query.gpio, req.query.mode, req.query.pullup, req.query.start_level, req.query.delay_times)
    elseif req.query.action == 'serout' then
        gpio_serout(req.query.gpio, req.query.mode, req.query.pullup, req.query.start_level, req.query.delay_times)
    else
        res:finish('Bad request!\r\n', 400)
        return false
    end

    echo('collectgarbage=' .. collectgarbage("count"))

    res:finish('{"status": 200}\r\n', 200)
    return false
end

function module.createHandler(config)
    if config.settings ~= nil then
        GpioValidator.settings = config.settings
    end
    return module.handler
end

return module
