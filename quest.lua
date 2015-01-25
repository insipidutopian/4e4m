-------------------------------------------------
--
-- quest.lua
--
-- class for Quest objects.
--
-------------------------------------------------
 
local quest = {}
local quest_mt = { __index = quest }	-- metatable
 
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function quest.new( name, description )	-- constructor
	print ("quest.new() called")
	local newQuest = {
		name = name or "Unnamed",
		id = 0,
		description = description or "description",
		details = "",
		questGiver = "",
		keywords = {},
		questList = {},
		npcList = {},
		encounterList = {}
	}
	-- if (debugFlag == 1) then
	-- 	print ("quest.new - DEBUG=TRUE - generating quest keywords")
	-- 	rand = math.random( 3 ) + 1
	-- 	for i = 1, rand do
	-- 		print ("generating random keyword for quest.")
	-- 		keywords[i] = "keyword" .. i
	-- 	end
	-- end
	print ("quest.new - creating name=" .. newQuest.name .. ", desc=" .. newQuest.description)
	
	return setmetatable( newQuest, quest_mt )
end
 

 function quest.newQuest( q )	-- constructor
	print ("quest.newQuest() called")
	local newQuest = {
		id = q.id,
		name = q.name or "Unnamed",
		description = q.description or "description",
		details = q.details,
		questGiver = q.questGiver,
		keywords = q.keywords,
		npcList = q.npcList,
		encounterList = q.encounterList
	}
	print ("quest.newQuest - creating name=" .. newQuest.name .. ", desc=" .. newQuest.description)
	
	return setmetatable( newQuest, quest_mt )
end

-------------------------------------------------
 
function quest:setDescription(desc)
	print ("quest:setDescription - setting quest description = " .. desc)
	self.description = desc
end

function quest:setName(name)
	print ("quest:setName - setting quest name = " .. name)
	self.name = name
end

function quest:setDetails(details)
	print ("quest:setDetails - setting quest details = " .. details)
	self.details = details
end

function quest:addQuestGiver(name)
	print ("quest:addQuestGiver - adding quest giver name = " .. name)
	self.questGiver = name
end

function quest:addKeyword(keyword)
--	self.cList.insert(quest)
	print ("quest:addKeyword - adding quest keyword = " .. keyword)
	if (self.keywords) then
		self.keywords[#self.keywords+1] = keyword
	else
		self.keywords[1] = keyword
	end
end

function quest:getDescription()
	print ("quest:getDescription - getting quest description = " .. self.description)
	return self.description
end

function quest:getDetails()
	print ("quest:getDetails - getting quest details = " .. self.details)
	return self.details
end


function quest:getQuestGiver()
	print ("quest:getQuestGiver - getting Quest Giver = " .. self.questGiver)
	return self.questGiver
end


function quest:getName()
	print ("quest:getName - getting quest name = " .. self.name)
	return self.name
end

return quest