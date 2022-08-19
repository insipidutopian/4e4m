
lu = require("luaunit")

TestRandomizerPlaces = {}

	function TestRandomizerPlaces:setUp()
		print("Setting up randomizer place tests")
		Randomizer = require ("RandGenUtil")
	end


	function TestRandomizerPlaces:tearDown()
		print("Tearing down randomizer place tests")
	end

	function TestRandomizerPlaces:testRandomPlaces()
		for i=1,12 do
			print("--------------------------------------------\n\n")
			p = Randomizer:generatePlace()
			print(i .. ". " .. p.name .. ": " .. p.type .. " :" .. p.description)
			lu.assertNotNil(p)
			lu.assertNotNil(p.name)
			lu.assertNotNil(p.description)
			lu.assertNotNil(p.type)
		end
	end

	function TestRandomizerPlaces:testEachPlaceType()
		placeTypes = {"Lake", "Crypt", "Town", "Dungeon", "Keep", "Forest", "Sea", "Road", "Region"}

		for j=1, 10 do
			for i=1,#placeTypes do
				print("\n\n--------------------------------------------")
				print("TestRandomizerPlaces:testEachPlaceType: Testing " .. placeTypes[i] .. " generation.")
				p = Randomizer:generatePlace(placeTypes[i])
				print(j .. "." .. i .. ". " .. p.name .. ": " .. p.type .. " :" .. p.description)
				lu.assertNotNil(p)
				lu.assertNotNil(p.name)
				lu.assertNotNil(p.description)
				lu.assertEquals(p.type, placeTypes[i])
			end
		end
	end

lu.LuaUnit.run()