
lu = require("luaunit")

TestRandomizerThings = {}

	function TestRandomizerThings:setUp()
		print("Setting up randomizer thing tests")
		Randomizer = require ("lib.asg.RandGenUtil")
	end


	function TestRandomizerThings:tearDown()
		print("Tearing down randomizer thing tests")
	end

	function TestRandomizerThings:testRandomThings()
		for i=1,12 do
			print("--------------------------------------------\n\n")
			t = Randomizer:generateThing()
			print(i .. ". " .. t.name .. ": " .. t.description)
			lu.assertNotNil(t)
			lu.assertNotNil(t.name)
			lu.assertNotNil(t.description)
			lu.assertNotNil(t.details)
			
		end
	end

	function TestRandomizerThings:testMoreRandomThings()
		local thingTypes = {"weapon", "armor", "potion", "wonderous item", "herb", "treasure", "common item", "magic item"}
		for i=1,#thingTypes do
			print("--------------------------------------------\nGenerating " .. thingTypes[i] .. "\n")
			for j=1,10 do
				t = Randomizer:generateThing(thingTypes[i])
				print(i .. ". " .. t.name .. ": " .. t.description)
				lu.assertNotNil(t)
				lu.assertNotNil(t.name)
				lu.assertNotNil(t.description)
				lu.assertNotNil(t.details)
			end
		end
	end


lu.LuaUnit.run()