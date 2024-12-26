package.path = package.path .. ";tests/?.lua;src/?.lua;tests/?.lc;src/?.lc"

local startup = require("startup")

startup.start()
