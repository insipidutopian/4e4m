
lu = require("luaunit")

TestRandomizerNpcs = {}

	function TestRandomizerNpcs:setUp()
		print("Setting up randomizer NPC tests")
		Randomizer = require ("lib.asg.RandGenUtil")
	end


	function TestRandomizerNpcs:tearDown()
		print("Tearing down randomizer NPC tests")
	end

	function TestRandomizerNpcs:testRandomNpcs()
		for i=1,12 do
			print("--------------------------------------------\n\n")
			n = Randomizer:generateNpc()
			print(i .. ". " .. n.name .. ": " .. n.notes)
			lu.assertNotNil(n)
			lu.assertNotNil(n.name)
			lu.assertNotNil(n.notes)
			lu.assertNotNil(n.race)
		end
	end

	function TestRandomizerNpcs:testRandomDwarfNames()
		print("--------------------------------------------\nDwarf Names:\n")
		for i=1,12 do
			
			n = Randomizer:generateNpcName("dwarf")
			print(i .. ". " .. n )
			lu.assertNotNil(n)
			
		end
	end

	function TestRandomizerNpcs:testRandomElfNames()
		print("--------------------------------------------\nElf Names:\n")
		for i=1,12 do
			
			n = Randomizer:generateNpcName("elf")
			print(i .. ". " .. n )
			lu.assertNotNil(n)
			
		end
	end

	function TestRandomizerNpcs:testRandomGnomeNames()
		print("--------------------------------------------\nGnome Names:\n")
		for i=1,12 do
			
			n = Randomizer:generateNpcName("gnome")
			print(i .. ". " .. n )
			lu.assertNotNil(n)
			
		end
	end

	function TestRandomizerNpcs:testRandomHalforcNames()
		print("--------------------------------------------\nHalf-Orc Names:\n")
		for i=1,12 do
			
			n = Randomizer:generateNpcName("half-orc")
			print(i .. ". " .. n )
			lu.assertNotNil(n)
			
		end
	end

	function TestRandomizerNpcs:testRandomHalflingNames()
		print("--------------------------------------------\nHalfling Names:\n")
		for i=1,12 do
			
			n = Randomizer:generateNpcName("halfling")
			print(i .. ". " .. n )
			lu.assertNotNil(n)
			
		end
	end

	function TestRandomizerNpcs:testRandomDragonbornNames()
		print("--------------------------------------------\nDragonborn Names:\n")
		for i=1,12 do
			
			n = Randomizer:generateNpcName("dragonborn")
			print(i .. ". " .. n )
			lu.assertNotNil(n)
			
		end
	end

	function TestRandomizerNpcs:testRandomTieflingNames()
		print("--------------------------------------------\nTiefling Names:\n")
		for i=1,12 do
			
			n = Randomizer:generateNpcName("tiefling")
			print(i .. ". " .. n )
			lu.assertNotNil(n)
			
		end
	end
lu.LuaUnit.run()