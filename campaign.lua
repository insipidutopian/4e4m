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
		placeList = {}
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
		placeList = campaign.placeList
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
	if (self.thingList) then
		self.thingList[#self.thingList+1] = thing
	else
		self.thingList = {}
		self.thingList[1] = thing
	end
end

function campaign.addPlace(self, place)
	print ("campaign:addPlace - adding campaign Place = " .. tostring(place))
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

return campaign