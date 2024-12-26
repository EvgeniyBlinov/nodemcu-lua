local utils = require('utils')
--github.com/nodemcu/nodemcu-firmware/app/platform/platform.h:31
--// GPIO subsection
--#define PLATFORM_GPIO_FLOAT 0
--#define PLATFORM_GPIO_PULLUP 1

--#define PLATFORM_GPIO_INT 2
--#define PLATFORM_GPIO_OUTPUT 1
--#define PLATFORM_GPIO_OPENDRAIN 3
--#define PLATFORM_GPIO_INPUT 0

--#define PLATFORM_GPIO_HIGH 1
--#define PLATFORM_GPIO_LOW 0

local module = {
    LOW = 0,
    HIGH = 1,
    OUTPUT = 1,
    PULLUP = 1,
    FLOAT = 0,
}
module.name = 'gpio'

local function echo(text)
    print('['..module.name..'] '..text)
end

function module.mode(gpio, mode, pullup)
    echo('[->mode] gpio='..gpio..';mode='..mode..';pullup='..pullup)
end

function module.serout(pin, start_level, delay_times, cycle_num, callback)
    echo('[->serout] pin='..pin..';start_level='..start_level..';delay_times='..utils:dump(delay_times)..';cycle_num='..cycle_num)
end

function module.write(pin, level)
    echo('[->write] pin='..pin..';level='..level)
end

return module
