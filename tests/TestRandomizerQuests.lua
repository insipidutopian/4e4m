
lu = require("luaunit")

TestRandomizerQuests = {}

	function TestRandomizerQuests:setUp()
		print("Setting up randomizer tests")
		Randomizer = require ("RandGenUtil")
	end


	function TestRandomizerQuests:tearDown()
		print("Tearing down randomizer tests")
	end

	function TestRandomizerQuests:testRandomQuests()
		for i=1,12 do
			print("--------------------------------------------\n\n")
			q = Randomizer:generateQuest()
			print(i .. ". " .. q.name .. ": " .. q.description)
			lu.assertNotNil(q)
			lu.assertNotNil(q.name)
			lu.assertNotNil(q.description)
			lu.assertNotNil(q.questGiver)
			lu.assertNotNil(q.details)
		end
	end

	function TestRandomizerQuests:testEachQuestType()
		for i=1,12 do
			print("--------------------------------------------\n\n")
			q = Randomizer:generateQuest(i)
			print(i .. ". " .. q.name .. ": " .. q.description)
			lu.assertNotNil(q)
			lu.assertNotNil(q.name)
			lu.assertNotNil(q.description)
			lu.assertNotNil(q.questGiver)
			lu.assertNotNil(q.details)
		end
	end

	function TestRandomizerQuests:testLiberateQuests()
		for i=1,10 do
			print("--------------------------------------------\n\n")
			q = Randomizer:generateQuest(6)
			print(i .. ". " .. q.name .. ": " .. q.description)
			lu.assertNotNil(q)
			lu.assertNotNil(q.name)
			lu.assertNotNil(q.description)
			lu.assertNotNil(q.questGiver)
			lu.assertNotNil(q.details)
		end
	end

	function TestRandomizerQuests:testSummonQuests()
		for i=1,10 do
			print("--------------------------------------------\n\n")
			q = Randomizer:generateQuest(7)
			print(i .. ". " .. q.name .. ": " .. q.description)
			lu.assertNotNil(q)
			lu.assertNotNil(q.name)
			lu.assertNotNil(q.description)
			lu.assertNotNil(q.questGiver)
			lu.assertNotNil(q.details)
		end
	end

	function TestRandomizerQuests:testProphesyQuests()
		for i=1,10 do
			print("--------------------------------------------\n\n")
			q = Randomizer:generateQuest(8)
			print(i .. ". " .. q.name .. ": " .. q.description)
			lu.assertNotNil(q)
			lu.assertNotNil(q.name)
			lu.assertNotNil(q.description)
			lu.assertNotNil(q.questGiver)
			lu.assertNotNil(q.details)
		end
	end

	function TestRandomizerQuests:testTrickQuests()
		for i=1,10 do
			print("--------------------------------------------\n\n")
			q = Randomizer:generateQuest(9)
			print(i .. ". " .. q.name .. ": " .. q.description)
			lu.assertNotNil(q)
			lu.assertNotEquals(q.name, "New Quest")
			lu.assertNotNil(q.description)
			lu.assertNotNil(q.questGiver)
			lu.assertNotNil(q.details)
		end
	end

	function TestRandomizerQuests:testFactionQuests()
		for i=1,10 do
			print("--------------------------------------------\n\n")
			q = Randomizer:generateQuest(10)
			print(i .. ". " .. q.name .. ": " .. q.description)
			lu.assertNotNil(q)
			lu.assertNotEquals(q.name, "New Quest")
			lu.assertNotNil(q.description)
			lu.assertNotNil(q.questGiver)
			lu.assertNotNil(q.details)
		end
	end

	function TestRandomizerQuests:testFactionNames()
		for i=1,20 do
			print("--------------------------------------------\n\n")
			q = Randomizer:generateFactionName()
			print(i .. ". " .. q)
			lu.assertNotNil(q)
		end
	end

	function TestRandomizerQuests:testFactionQuestTypes()
		for i=1,20 do
			print("--------------------------------------------\n\n")
			q = Randomizer:generateFactionQuestType()
			print(i .. ". " .. q)
			lu.assertNotNil(q)
		end
	end

	function TestRandomizerQuests:testDiscoveryQuests()
		for i=1,10 do
			print("--------------------------------------------\n\n")
			q = Randomizer:generateQuest(11)
			print(i .. ". " .. q.name .. ": " .. q.description)
			lu.assertNotNil(q)
			lu.assertNotEquals(q.name, "New Quest")
			lu.assertNotNil(q.description)
			lu.assertNotNil(q.questGiver)
			lu.assertNotNil(q.details)
		end
	end

	function TestRandomizerQuests:testRumorQuests()
		for i=1,10 do
			print("--------------------------------------------\n\n")
			q = Randomizer:generateQuest(12)
			print(i .. ". " .. q.name .. ": " .. q.description)
			lu.assertNotNil(q)
			lu.assertNotEquals(q.name, "New Quest")
			lu.assertNotNil(q.description)
			lu.assertNotNil(q.questGiver)
			lu.assertNotNil(q.details)
		end
	end

lu.LuaUnit.run()