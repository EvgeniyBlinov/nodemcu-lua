local module = {}

function module.delay(delay)
    print('[tmr] sleep' .. delay)
    local sec = tonumber(os.clock() + delay/1000000);
    while (os.clock() < sec) do
    end
end

return module
