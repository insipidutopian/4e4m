-- 
-- Abstract: RandGenUtil - Random Generation Utilities 
--  
-- Version: 1.0
-- 

local quest = require ( "quest" )

local names = {"an", "dor", "in", "al", "gar", "zi", "ip", "er", "ar", "el", "if", "ap", "nar",
			   "jo", "jon", "dar", "raf", "cha", "le", "o", "lo", "ri", "a", "pip", "kal", "jab",
			   "kor", "kal", "bin", "ban", "la", "gre", "gra", "pho", "pha", "cid" }

local adjectives = {"old", "forgotten", "iron", "golden", "pleasant", "dusty", "dark", "gloomy", "bright",
					"murky", "misty", "sullen", "wintry", "burned", "crumbling", "shadowy", "night" }
local colorNames = {"blue", "green", "white", "red", "black", "grey", "gold" }
local placeNames = {"hills", "forest", "mountains", "plains", "river", "valley", "peaks", "pass", 
					"castle", "fort", "fortress", "ruins", "downs", "keep", "haven", "hold",
					"brook", "road", "vale", "citadel", "desert", "grasslands", "sea", "ocean", "lake", 
					"pond", "temple", "forge", "fens", "spire", "down", "abbey", "lands", "gulf", "bay", 
					"city", "marches", "marsh", "warrens", "rift", "territory", "deep", "caverns", "caves", 
					"tomb", "kingdom", "wastes", "guard", "thicket", "glade", "glen"}

local thingNames = {"sword", "bow", "dagger", "staff", "wand", "axe", "spear", "halberd", "glaive",
					"necklace", "treasure chest", "ring", "brooch", "crown", "gem", "bracelet", "gold",
					"torch", "daughter", "walking stick", "kettle", "knife", "knickers", "pantaloons", 
					"shield", "armor", "helmet", "helm", "buckler", "breastplate", "boots"}

local adversaries = {"orcs", "a dragon", "kobolds", "bandits", "mercenaries", "giants", "trolls",
					 "a rust monster", "minotaurs", "drow", "duergar"}

local obstacles = {"washed out road", "ruined bridge", "flooded river", "slaughtered caravan"}
local RandGenUtil = {Instances={}}
--local RandGenUtil = {}
local RandGenUtil_mt = { __index = RandGenUtil }  -- metatable
-- RandGenUtil.__index = RandGenUtil

function RandGenUtil:new(...)	-- constructor
	--local self = setmetatable( {}, RandGenUtil )
	local instance = setmetatable({}, self)
	--print ("CampaignList.new called, value="..init)
	--instance:initialize(...)
	return instance
end
 

function RandGenUtil:initialize()
	-- instance.cList = {}
	print ("RandGenUtil:initialize() - Initializing RandGenUtil...")
	table.insert(self.Instances, self)
	-- self.currentCampaignIndex = -1
	-- self.cList = {}
end

function RandGenUtil.__call(_, value)
	return Underscore:new(value)
end

function RandGenUtil:new(value, chained)
	return setmetatable({ _val = value or false }, self)
end


function RandGenUtil.generateName()
    syllables = math.random( 3 )
	print("gen'ing name, syllables=" .. syllables+1)

	local tmpName = "";
	for i = 1, syllables+1 do
		tmpName = tmpName .. names[math.random(#names)]	
	end
		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  name generated: " .. tmpName)
	-- set the screen text
	--nameResultString.text = tmpName

	return tmpName
end

function RandGenUtil.generatePlaceName()
	local tmpName = "";

	local nameStyle =  math.random( 4 )

	if (nameStyle == 1) then -- Ariedor type name
		local syllables = math.random( 3 )
		print("gen'ing Ariedor type name, syllables=" .. syllables+1)

		for i = 1, syllables+1 do
			tmpName = tmpName .. names[math.random(#names)]	
		end
	elseif (nameStyle == 2) then -- Blue Hills type name...
		print("gen'ing Blue Hills type name")
		local nameOrder = math.random( 2 )

		if (nameOrder == 1) then
			tmpName = colorNames[math.random(#colorNames)] .. " " .. placeNames[math.random(#placeNames)]
		else
			tmpName = placeNames[math.random(#placeNames)]	.. " of " .. colorNames[math.random(#colorNames)]
		end
    elseif (nameStyle == 3) then -- Dusty Crypt type name...
    	print("gen'ing Dusty Crypt type name")
		
		tmpName = adjectives[math.random(#adjectives)] .. " " .. placeNames[math.random(#placeNames)]

	else -- Agdon Fort type name
		print("gen'ing Agdon Fort type type name")
		local randNameTmp = ""
		local syllables = math.random( 3 )
		for i = 1, syllables+1 do
			randNameTmp = randNameTmp .. names[math.random(#names)]	
		end

		local nameOrder = math.random( 2 )
		
		if (nameOrder == 1) then
			tmpName = randNameTmp .. " " .. placeNames[math.random(#placeNames)]
		else
			tmpName = placeNames[math.random(#placeNames)] .. " of " .. randNameTmp
		end
	end

		
	-- tmpName = tmpName:gsub("^%l", string.upper)
	tmpName = tmpName:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)
	print("  name generated: " .. tmpName)
	

	-- set the screen text
	-- placeResultString.text = tmpName


	return tmpName
end


function RandGenUtil.generateThingName( ) 
	local tmpName = "";

	tmpName = thingNames[math.random(#thingNames)]	

		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  thing generated: " .. tmpName)
	

	-- set the screen text
	-- thingResultString.text = tmpName
	return tmpName
end


function RandGenUtil.generateAdversary( ) 
	local tmpName = "";

	tmpName = adversaries[math.random(#adversaries)]	

		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  adversary generated: " .. tmpName)
	
	return tmpName
end


function RandGenUtil.generateObstacle( ) 
	local tmpName = "";

	tmpName = obstacles[math.random(#obstacles)]	

		
	tmpName = tmpName:gsub("^%l", string.upper)
	print("  obstacle generated: " .. tmpName)
	
	return tmpName
end


function RandGenUtil.generateQuest( )
	local qTmp = "";
	print("==========================================================")
	print("RandGenUtil.generateQuest() called")
	local newQuest = quest.new("New Quest", "")

	local questStyle =  math.random( 4 )

	newQuest:addQuestGiver( RandGenUtil:generateName() )

	if (questStyle == 1) then -- Gather: X has asked you to go to Y to retrieve Z
		local thing = RandGenUtil:generateThingName()
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to go to \n"
		qTmp = qTmp .. RandGenUtil:generatePlaceName() .. " to retrieve his \n"
		qTmp = qTmp .. thing
		newQuest:setName(newQuest.questGiver .. "'s " .. thing)
	elseif (questStyle == 2) then -- Investigate: X has done/is doing Y at Z
		local place = RandGenUtil:generatePlaceName()
		local adversary = RandGenUtil:generateAdversary()
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to go to \n"
		qTmp = qTmp .. place .. " to investigate \n"
		qTmp = qTmp .. adversary -- TODO: add more investigation topics
		newQuest:setName( adversary .. " of " .. place)
	elseif (questStyle == 3) then -- Kill: 
		local adversary = RandGenUtil:generateAdversary()
		local place = RandGenUtil:generatePlaceName()
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to go to \n"
		qTmp = qTmp .. place .. " to kill \n"
		qTmp = qTmp .. adversary
		newQuest:setName( "Kill " .. adversary .. " of " .. place)
	elseif (questStyle == 4) then -- Deliver: 
		local thing = RandGenUtil:generateThingName()
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to bring his\n"
		qTmp = qTmp .. thing .. " to " .. RandGenUtil:generateName()
		qTmp = qTmp .. "\nin " .. RandGenUtil:generatePlaceName()
		newQuest:setName( thing .. " delivery")
	elseif (questStyle == 5) then -- Escort: 
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to escort"
	elseif (questStyle == 6) then -- Liberate:
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to save"
	elseif (questStyle == 7) then -- Summon/Build: 
		qTmp = qTmp .. newQuest.questGiver .. " has asked you to build a"
	end

	newQuest:setDescription(qTmp)
	newQuest:setDetails( RandGenUtil.generateQuestDetails(newQuest) )
	print ("RandGenUtil.generateQuest - Random Quest Generated: " .. qTmp)
	return newQuest

end

function RandGenUtil.genPrepPhrase()

	local prep = math.random ( 3 )

	if (prep == 1) then
		prepPhrase = "On the way is"
	elseif (prep == 2) then
		prepPhrase = "On the way back is"
	elseif (prep == 3) then
		prepPhrase = "Guarding it is"
	end

	return prepPhrase
end

function RandGenUtil.generateQuestDetails( quest)
	local qTmp = "";

	local questDetailsCount =  math.random( 3 )
	local prepPhrase = ""

	for i=1, questDetailsCount do
		local wrinkleType =  math.random( 3 )
		local prepPhrase = RandGenUtil.genPrepPhrase()

		-- if (prep == 1) then
		-- 	prepPhrase = "On the way is"
		-- elseif (prep == 2) then
		-- 	prepPhrase = "On the way back is"
		-- elseif (prep == 3) then
		-- 	if (wrinkleType == 2) then 
		-- 		prepPhrase = "Guarding it is"
		-- 	else
		-- end

		if (wrinkleType == 1) then -- Obstacle:
			while ( prepPhrase == "Guarding it is") do
				prepPhrase = RandGenUtil.genPrepPhrase()
			end
			qTmp = qTmp .. "Wrinkle: " .. prepPhrase .. " " .. RandGenUtil:generateObstacle() .. "\n"
		elseif (wrinkleType == 2) then -- Monster: 
			qTmp = qTmp .. "Wrinkle: " .. prepPhrase .. " " .. RandGenUtil:generateAdversary() .. "\n"
		elseif (wrinkleType == 3) then -- Prerequisite: 
			qTmp = qTmp .. "Wrinkle: First you must find " .. quest.questGiver .. "'s\n"
			qTmp = qTmp .. "    " .. RandGenUtil:generateThingName() .. "\n"
		end
	end
	
	print ("RandGenUtil.generateQuest - Random Quest Details Generated: " .. qTmp)
	return qTmp
end

 -- Initialize the RandGenUtil
RandGenUtil:new()
RandGenUtil:initialize()


return RandGenUtil