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
		keywords = {},
		questList = {},
		npcList = {},
		encounterList = {}
	}
	-- if (debugFlag == 1) then
	-- 	print ("campaign.new - DEBUG=TRUE - generating campaign keywords")
	-- 	rand = math.random( 3 ) + 1
	-- 	for i = 1, rand do
	-- 		print ("generating random keyword for campaign.")
	-- 		keywords[i] = "keyword" .. i
	-- 	end
	-- end
	print ("campaign.new - creating name=" .. newCampaign.name .. ", desc=" .. newCampaign.description)
	
	return setmetatable( newCampaign, campaign_mt )
end
 
function campaign.newCampaign( campaign )	-- constructor
	print ("campaign.newCampaign() called")
	local newCampaign = {
		id = campaign.id,
		name = campaign.name or "Unnamed",
		description = campaign.description or "description",
		keywords = campaign.keywords,
		questList = campaign.questList,
		npcList = campaign.npcList,
		encounterList = campaign.encounterList
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

function campaign:getDescription()
--	self.cList.insert(campaign)
	print ("campaign:getDescription - getting campaign description = " .. self.description)
	return self.description
end

return campaign