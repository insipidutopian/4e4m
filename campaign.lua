-------------------------------------------------
--
-- campaign.lua
--
-- class for Campaign objects.
--
-------------------------------------------------
 
local campaign = {}
local campaign_mt = { __index = campaign }	-- metatable
 
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
local function foo( multiplier )	-- local; only visible in this module
	return multiplier * 7
end
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function campaign.new( name, description )	-- constructor
	print ("campaign.new() called")
	local newCampaign = {
		id = 0,
		name = name or "Unnamed",
		description = description or "description",
		system = "5e",
		keywords = {},
		questList = {},
		npcList = {},
		encounterList = {},
		thingList = {},
		placeList = {},
		eventList = {}
	}
	
	print ("campaign.new - creating name=" .. newCampaign.name .. ", desc=" .. newCampaign.description)
	
	return setmetatable( newCampaign, campaign_mt )
end
 
function campaign.newCampaign( campaign )	-- constructor
	print ("campaign.newCampaign() called")
	local newCampaign = {
		id = campaign.id,
		name = campaign.name or "Unnamed",
		description = campaign.description or "description",
		system = campaign.system or "5e",
		keywords = campaign.keywords,
		questList = campaign.questList,
		npcList = campaign.npcList,
		encounterList = campaign.encounterList,
		thingList = campaign.thingList,
		placeList = campaign.placeList,
		eventList = campaign.eventList or {}
	}
	print ("campaign.newCampaign - creating name=" .. newCampaign.name .. ", desc=" .. newCampaign.description)
	
	return setmetatable( newCampaign, campaign_mt )
end
-------------------------------------------------
 
function campaign:setDescription(desc)
--	self.cList.insert(campaign)
	print ("campaign:setDescription - setting campaign description = " .. desc)
	self.description = desc
end


function campaign:addKeyword(keyword)
--	self.cList.insert(campaign)
	print ("campaign:addKeyword - adding campaign keyword = " .. keyword)
	if (self.keywords) then
		self.keywords[#self.keywords+1] = keyword
	else
		self.keywords[1] = keyword
	end
end

function campaign.addThing(self, thing)
--	self.cList.insert(campaign)
	--print ("campaign:addThing - self = " .. self)
	print ("campaign:addThing - adding campaign thing = " .. tostring(thing))
	if thing.id == 0 then thing.id = self:getNextThingId() end
	if (self.thingList) then
		self.thingList[#self.thingList+1] = thing
	else
		self.thingList = {}
		self.thingList[1] = thing
	end
end

function campaign.addQuest(self, newQuest)
	print ("campaign:addQuest - adding campaign Quest = " .. tostring(newQuest))
	if newQuest.id == 0 then newQuest.id = self:getNextQuestId() end
	if (self.questList) then
		self.questList[#self.questList+1] = newQuest
	else
		self.questList = {}
		self.questList[1] = newQuest
	end
end
function campaign.addEvent(self, event)
--	self.cList.insert(campaign)
	--print ("campaign:addThing - self = " .. self)
	print ("campaign:addEvent - adding campaign event = " .. tostring(event))
	if event.id == 0 then event.id = self:getNextEventId() end
	if (self.eventList) then
		self.eventList[#self.eventList+1] = event
	else
		self.eventList = {}
		self.eventList[1] = event
	end
end

function campaign.addEncounter(self, newEncounter)
	print ("campaign:addEncounter - adding campaign Encounter = " .. tostring(newEncounter))
	if newEncounter.id == 0 then newEncounter.id = self:getNextEncounterId() end
	if (self.encounterList) then
		self.encounterList[#self.encounterList+1] = newEncounter
	else
		self.encounterList = {}
		self.encounterList[1] = newEncounter
	end
end

function campaign.addNpc(self, newNpc)
--	self.cList.insert(campaign)
	--print ("campaign:addNpc - self = " .. self)
	print ("campaign:addNpc - adding campaign Npc = " .. tostring(newNpc))
	if newNpc.id == 0 then newNpc.id = self:getNextNpcId() end
	if (self.npcList) then
		self.npcList[#self.npcList+1] = newNpc
	else
		self.npcList = {}
		self.npcList[1] = newNpc
	end
end

function campaign.addPlace(self, place)
	print ("campaign:addPlace - adding campaign Place = " .. tostring(place))
	if place.id == 0 then place.id = self:getNextPlaceId() end
	if (self.placeList) then
		self.placeList[#self.placeList+1] = place
	else
		self.placeList = {}
		self.placeList[1] = place
	end
end


function campaign:getDescription()
--	self.cList.insert(campaign)
	print ("campaign:getDescription - getting campaign description = " .. self.description)
	return self.description
end

function campaign.getNextEventId(self)
	print ("campaign:getNextEventId - getting next event ID")
	if (self.eventList and #self.eventList > 0) then
		print ("campaign:getNextEventId - event list exists. finding next event ID in list: " .. #self.eventList)
		print ("campaign:getNextEventId - returning: " .. self.eventList[#self.eventList].id + 1)
		return self.eventList[#self.eventList].id + 1
	else
		print ("campaign:getNextEventId - event list empty. returning 1")
		return 1
	end
end

function campaign.getNextThingId(self)
	print ("campaign:getNextThingId - getting next thing ID")
	if (self.thingList and #self.thingList > 0) then
		print ("campaign:getNextThingId - thing list not empty. finding next thing ID in list: " .. #self.thingList)
		print ("campaign:getNextThingId - returning: " .. self.thingList[#self.thingList].id + 1)
		return self.thingList[#self.thingList].id + 1
	else
		print ("campaign:getNextThingId - thing list empty. returning 1")
		return 1
	end
end

function campaign.getNextPlaceId(self)
	print ("campaign:getNextPlaceId - getting next Place ID")
	if (self.placeList and #self.placeList > 0) then
		print ("campaign:getNextPlaceId - Place list not empty. finding next Place ID in list: " .. #self.placeList)
		print ("campaign:getNextPlaceId - returning: " .. self.placeList[#self.placeList].id + 1)
		return self.placeList[#self.placeList].id + 1
	else
		print ("campaign:getNextPlaceId - Place list empty. returning 1")
		return 1
	end
end

function campaign.getNextNpcId(self)
	print ("campaign:getNextNpcId - getting next Npc ID")
	if (self.npcList and #self.npcList > 0) then
		print ("campaign:getNextNpcId - Npc list not empty. finding next Npc ID in list: " .. #self.npcList)
		print ("campaign:getNextNpcId - returning: " .. self.npcList[#self.npcList].id + 1)
		return self.npcList[#self.npcList].id + 1
	else
		print ("campaign:getNextNpcId - Npc list empty. returning 1")
		return 1
	end
end

function campaign.getNextQuestId(self)
	print ("campaign:getNextQuestId - getting next Quest ID")
	if (self.questList and #self.questList > 0) then
		print ("campaign:getNextQuestId - Quest list not empty. finding next Quest ID in list: " .. #self.questList)
		print ("campaign:getNextQuestId - returning: " .. self.questList[#self.questList].id + 1)
		return self.questList[#self.questList].id + 1
	else
		print ("campaign:getNextQuestId - Quest list empty. returning 1")
		return 1
	end
end

function campaign.getNextEncounterId(self)
	print ("campaign:getNextEncounterId - getting next Encounter ID")
	if (self.encounterList and #self.encounterList > 0) then
		print ("campaign:getNextEncounterId - Encounter list not empty. finding next Encounter ID in list: " .. #self.encounterList)
		print ("campaign:getNextEncounterId - returning: " .. self.encounterList[#self.encounterList].id + 1)
		return self.encounterList[#self.encounterList].id + 1
	else
		print ("campaign:getNextEncounterId - Encounter list empty. returning 1")
		return 1
	end
end


return campaign