require("tests.TestRandomizerRewards")
require("tests.TestRandomizerQuests")
require("tests.TestRandomizerNpcs")
require("tests.TestRandomizerThings")
require("tests.TestRandomizerPlaces")
--

-- function showProps(o)
-- 	print("-- showProps --")
-- 	print("o: " .. o)
-- 	for key,value in pairs(o) do
-- 		print("key: " .. key .. " value: " .. value)
-- 	end
-- 	print("-- end of showProps --")
-- end

pcall(require, "luacov") -- code coverage if luacov present
lu = require("luaunit")

os.exit(lu.LuaUnit.run())
