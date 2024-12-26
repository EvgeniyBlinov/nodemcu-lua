package.path = package.path .. ";src/?.lua;src/?.lc"

local startup = require("startup")

startup.start()
