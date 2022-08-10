
lu = require("luaunit")

TestRandomizerRewards = {}

	function TestRandomizerRewards:setUp()
		print("Setting up randomizer thing tests")
		Randomizer = require ("RandGenUtil")
	end


	function TestRandomizerRewards:tearDown()
		print("Tearing down randomizer thing tests")
	end

	-- function TestRandomizerRewards:testRandomRewards()
	-- 	for i=1,2 do
	-- 		for j=1,20 do
	-- 			print("--------------------------------------------\n\n")
	-- 			t = Randomizer:generateReward(i,j)
	-- 			print(i .. "." .. j ..  ". " .. t)
	-- 			lu.assertNotNil(t)
	-- 		end			
	-- 	end
	-- end

	function TestRandomizerRewards:testHoardRewards()
		print("\n\n\nTEST RANDOM HOARD START\n\n\n")	
		for j=1,20 do
			print("--------------------------------------------\n\n")
			t = Randomizer:generateReward(2,j)
			print(j ..  ". " .. t)
			lu.assertNotNil(t)
		end			
		print("\n\n\nTEST RANDOM HOARD END\n\n\n")
	end
	

lu.LuaUnit.run()