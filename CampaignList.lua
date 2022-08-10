-------------------------------------------------
--
-- campaignList.lua
--
-- class for managing Campaign objects.
--
-------------------------------------------------
FileUtil = require ("FileUtil")
local CampaignClass = require ( "campaign" )

local CampaignList = {Instances={}}
--local CampaignList = {}
local CampaignList_mt = { __index = CampaignList }	-- metatable

local json = require "json"


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
function CampaignList:new(...)	-- constructor
	--local self = setmetatable( {}, CampaignList )
	local instance = setmetatable({}, self)
	--print ("CampaignList.new called, value="..init)
	--instance:initialize(...)
	return instance
end
 

function CampaignList:initialize()
	-- instance.cList = {}
	print ("CampaignList:initialize() - Initializing CampaignList...")
	table.insert(self.Instances, self)
	--self.currentCampaignIndex = appSettings.currentCampaign
	self.loaded = 0
	self.cList = {}

end

function CampaignList.getCampaignCount(self)
  print ("CampaignList.getCampaignCount() - count=" .. #self.cList)
  return #self.cList
end

function CampaignList.getCampaign(self, i)
	print ("CampaignList.getCampaign() - getting campaign #" .. i .. " of " .. #self.cList)
	
	if (i < 0) then
		print ("Bad Index: " .. i)
		return nil
	end

	if (i > #self.cList) then
		print ("Bad Index: " .. i)
		return nil
	end

	print ("CampaignList.getCampaign() - found campaign, name=" .. self.cList[i].name)
	return self.cList[i]
end


function CampaignList.loadCampaignFile(self, fName)
	print ("CampaignList.loadCampaignFile() - loading campaign file")
	if (fName == nil) then
		print ("Can't load nil campaign file")
		return
	end
	local fData = FileUtil:loadUserFile(fName)
	if (fData and fData ~= "") then
		print ("CampaignList.loadCampaignFile() - loading campaign ==" .. fName)
		
		local c = json.decode(fData)
		print ("  name=" .. c.name .. ", desc=" .. c.description)
		local newCampaign = CampaignClass.newCampaign(c)
		local i =  #self.cList+1
		print("::::" .. i .. "::::")
		self.cList[#self.cList+1] = newCampaign
	end
	
end


function CampaignList.writeCampaignFile(self, c)
	print ("CampaignList.writeCampaignFile() - writing campaign file")
	if (c == nil) then
		print ("Can't write nil campaign")
		return
	end
	local cFileName = "campaign_" .. c.id .. ".4ec"

	print ("CampaignList.writeCampaignFile() - adding campaign ==" .. cFileName)
	local cFileData = json.encode(c) 
	FileUtil:writeUserFile(cFileName, cFileData)

	--local test = json.encode(c)
	--print ("JSON: " .. test)
end


function CampaignList.upgradeSettingsFileIfNeeded(self, oldVersion, newVersion)
	print("Upgrading Campaign Settings from " .. oldVersion .. " to " .. newVersion)
	if oldVersion == "1.0.3" or oldVersion == "1.0.2" or oldVersion == "1.0.1" or oldVersion == "1.0.0" then
		CampaignList:reloadCampaigns()
		--need to update thingLists
		for i=1, #self.cList do
			self.cList[i].thingList = {}
			CampaignList:writeCampaignFile(self.cList[i])
		end
	end

	if oldVersion == "1.0.4" then
		CampaignList:reloadCampaigns()
		--need to update thingLists
		for i=1, #self.cList do
			self.cList[i].thingList = {}
			CampaignList:writeCampaignFile(self.cList[i])
		end
	end

	if oldVersion == "1.0.5" then
		CampaignList:reloadCampaigns()
		--need to update thingLists
		for i=1, #self.cList do
			self.cList[i].placeList = {}
			CampaignList:writeCampaignFile(self.cList[i])
		end
	end
	return true
end


function CampaignList.getNewCampaignId(self)
	print ("4e4m Settings File Version : " .. appSettings['fileVersion'])
	print ("4e4m App Name              : " .. appSettings['appName'])
	print ("4e4m App Version           : " .. appSettings['appVersion'])
	print ("4e4m Campaign Count Old    : " .. appSettings['campaignCounter'])	
	cId = appSettings['campaignCounter'] + 1
	appSettings['campaignCounter'] = appSettings['campaignCounter'] + 1
    
    print ("4e4m Campaign Count        : " .. appSettings['campaignCounter'])	


	FileUtil:writeSettingsFile("settings.cfg", appSettings)

	return cId
end

function CampaignList.addCampaign(self, c)
--	self.cList.insert(campaign)
	print ("CampaignList.addCampaign() - adding campaign ==" .. c.name)
	if (c.description) then
		print ("CampaignList.addCampaign() -    description ==" .. c.description)
	end
	c.id = CampaignList.getNewCampaignId()

	self.cList[#self.cList+1] = c
	print ("CampaignList.addCampaign() - " .. #self.cList .. " campaigns now found after add.")

	print ("CampaignList.addCampaign() - Writing Campaigns to disk" )
	CampaignList:writeCampaignFile(c)

end

function CampaignList.setCurrentCampaignIndex(self, i)
	print ("CampaignList.setCurrentCampaign() - setting current campaign to=" .. i)
	self.currentCampaignIndex = i
	appSettings.currentCampaign = i
	FileUtil:writeSettingsFile("settings.cfg", appSettings)
end


function CampaignList.getCurrentCampaignIndex(self)
	if self.currentCampaignIndex then
		print ("CampaignList.getCurrentCampaign() - current campaign=" .. self.currentCampaignIndex)
		return self.currentCampaignIndex
	else
		return -1
	end
end

function CampaignList.getCurrentCampaign(self)
	print ("CampaignList.getCurrentCampaign() - current campaign=" .. self.currentCampaignIndex)
	print ("Size of CLIST: " .. #self.cList)
	if (self.currentCampaignIndex > -1) then
		return self.cList[self.currentCampaignIndex]
	end

	print ("CampaignList.getCurrentCampaign() - no current campaign")
	return nil
end

function CampaignList.getCurrentorNewCampaign(self)
	print ("CampaignList.getCurrentorNewCampaign() - current campaign=" .. self.currentCampaignIndex)
	print ("Size of CLIST: " .. #self.cList)
	if (self.currentCampaignIndex > -1) then
		return self.cList[self.currentCampaignIndex]
	end

	print ("CampaignList.getCurrentorNewCampaign() - no current campaign")
	return CampaignClass.new("...")
end

function CampaignList.loadCampaigns(self)
	print("CampaignList.loadCampaigns() called")
	if (self.loaded == 0) then
		for i=1, appSettings['campaignCounter'] do
			print(".................................")
			CampaignList:loadCampaignFile("campaign_" .. i ..".4ec")
			
		end
	end
	currentCampaignIndex=appSettings.currentCampaign
	self.loaded = 1
end

function CampaignList.reloadCampaigns(self)
	print("reloadCampaigns(): count is :  ".. appSettings['campaignCounter'] )
	self.cList = {}
	for i=1, appSettings['campaignCounter'] do
		print(".................................")
		CampaignList:loadCampaignFile("campaign_" .. i ..".4ec")
		
	end
	self.currentCampaignIndex=appSettings.currentCampaign
end

function CampaignList.addThingToCampaign(self, newThing)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		--print("CampaignList:addQuest: count before is: " .. #c.questList)
		c:addThing(newThing)
		-- table.sort(c.thingList)
		print("CampaignList:addThingToCampaign: count after is: " .. #c.thingList)
		CampaignList:writeCampaignFile(c)
		return "success"
	end
	return "failed"
end


function CampaignList.addPlaceToCampaign(self, newPlace)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		--print("CampaignList:addQuest: count before is: " .. #c.questList)
		c:addPlace(newPlace)
		-- table.sort(c.thingList)
		print("CampaignList:addPlaceToCampaign: count after is: " .. #c.placeList)
		CampaignList:writeCampaignFile(c)
		return "success"
	end
	return "failed"
end

function CampaignList.addNpcToCampaign(self, newNpc)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		print("CampaignList:addNpc: count before is: " .. #c.npcList)
		c.npcList[#c.npcList+1] = newNpc
		-- table.sort(c.npcList)
		print("CampaignList:addNpc: count after is: " .. #c.npcList)
		CampaignList:writeCampaignFile(c)
		return "success"
	end
	return "failed"
end


function CampaignList.updateNpcForCampaign(self, npc)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		
		--c.npcList[#c.npcList+1] = newNpc
		if not npc.id then
			print("ERROR: NPC with no ID cannot be updated.")
			return "failed"
		end

		for i=1, #c.npcList do
			if c.npcList[i].id == npc.id then
				-- update
				print("Updating NPC id: " .. npc.id)
				c.npcList[i] = npc
			end 
		end

		-- table.sort(c.npcList)
		CampaignList:writeCampaignFile(c)
		return "success"
	end
	return "failed"
end

function CampaignList.updatePlaceForCampaign(self, place)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		
		--c.npcList[#c.npcList+1] = newNpc
		if not place.id then
			print("ERROR: Place with no ID cannot be updated.")
			return "failed"
		end

		for i=1, #c.placeList do
			if c.placeList[i].id == place.id then
				-- update
				print("Updating Place id: " .. place.id)
				c.placeList[i] = place
			end 
		end

		-- table.sort(c.npcList)
		CampaignList:writeCampaignFile(c)
		return "success"
	end
	return "failed"
end

function CampaignList.updateThingForCampaign(self, thing)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		
		if not thing.id then
			print("ERROR: Thing with no ID cannot be updated.")
			return "failed"
		end

		for i=1, #c.thingList do
			if c.thingList[i].id == thing.id then
				-- update
				print("Updating Thing id: " .. thing.id)
				c.thingList[i] = thing
			end 
		end

		-- table.sort(c.thingList)
		CampaignList:writeCampaignFile(c)
		return "success"
	end
	return "failed"
end

function CampaignList.updateQuestForCampaign(self, quest)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		
		if not quest.id then
			print("ERROR: Quest with no ID cannot be updated.")
			return "failed"
		end

		for i=1, #c.questList do
			if c.questList[i].id == quest.id then
				-- update
				print("Updating Quest id: " .. quest.id)
				c.questList[i] = quest
			end 
		end

		-- table.sort(c.questList)
		CampaignList:writeCampaignFile(c)
		return "success"
	end
	return "failed"
end

function CampaignList.removeNpcFromCampaign(self, npc)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		print("CampaignList:removeNpcFromCampaign: count before is: " .. #c.npcList)
		
		--c.npcList[#c.npcList+1] = newNpc
		if not npc.id then
			print("ERROR: NPC with no ID cannot be deleted.")
			return "failed"
		end

		for i=1, #c.npcList do
			print("Comparing npc " .. i .. " with id of " .. tostring(c.npcList[i].id) .. " with " .. tostring(npc.id))
			if c.npcList[i].id == npc.id then
				-- delete
				print("Deleting NPC id: " .. npc.id)
				table.remove( c.npcList, i )
				print("CampaignList:removeNpcFromCampaign: count after is: " .. #c.npcList)
				CampaignList:writeCampaignFile(c)
				return "success"
			end 
		end

		print("CampaignList:removeNpcFromCampaign() ERROR: No NPC Found")
	end
	return "failed"
end

function CampaignList.removeThingFromCampaign(self, thing)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		print("CampaignList:removeThingFromCampaign: count before is: " .. #c.thingList)
		
		if not thing.id then
			print("ERROR: Thing with no ID cannot be deleted.")
			return "failed"
		end

		for i=1, #c.thingList do
			print("Comparing thing " .. i .. " with id of " .. tostring(c.thingList[i].id) .. " with " .. tostring(thing.id))
			if c.thingList[i].id == thing.id then
				-- delete
				print("Deleting Thing id: " .. thing.id)
				table.remove( c.thingList, i )
				print("CampaignList:removeThingFromCampaign: count after is: " .. #c.thingList)
				CampaignList:writeCampaignFile(c)
				return "success"
			end 
		end

		print("CampaignList:removeThingFromCampaign() ERROR: No Thing Found")
	end
	return "failed"
end

function CampaignList.removePlaceFromCampaign(self, place)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		print("CampaignList:removePlaceFromCampaign: count before is: " .. #c.placeList)
		
		if not place.id then
			print("ERROR: place with no ID cannot be deleted.")
			return "failed"
		end

		for i=1, #c.placeList do
			print("Comparing place " .. i .. " with id of " .. tostring(c.placeList[i].id) .. " with " .. tostring(place.id))
			if c.placeList[i].id == place.id then
				-- delete
				print("Deleting place id: " .. place.id)
				table.remove( c.placeList, i )
				print("CampaignList:removePlaceFromCampaign: count after is: " .. #c.placeList)
				CampaignList:writeCampaignFile(c)
				return "success"
			end 
		end

		print("CampaignList:removePlaceFromCampaign() ERROR: No Place Found")
	end
	return "failed"
end



function CampaignList.removeQuestFromCampaign(self, quest)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		print("CampaignList:removeQuestFromCampaign: count before is: " .. #c.questList)
		
		if not quest.id then
			print("ERROR: Quest with no ID cannot be deleted.")
			return "failed"
		end

		for i=1, #c.questList do
			print("Comparing quest " .. i .. " with id of " .. tostring(c.questList[i].id) .. " with " .. tostring(quest.id))
			if c.questList[i].id == quest.id then
				-- delete
				print("Deleting quest id: " .. quest.id)
				table.remove( c.questList, i )
				print("CampaignList:removeQuestFromCampaign: count after is: " .. #c.questList)
				CampaignList:writeCampaignFile(c)
				return "success"
			end 
		end

		print("CampaignList:removeQuestFromCampaign() ERROR: No Quest Found")
	end
	return "failed"
end

function CampaignList.addQuestToCampaign(self, newQuest)
	local c = self.cList[tonumber(self.currentCampaignIndex)]
	if not c then
		print("No campaign found for campaign index of " .. self.currentCampaignIndex)
		print("  number of campaigns is " .. #self.cList)
		for i=1, #self.cList do
			print("  cList[" .. tostring(i) .. "] name is " .. self.cList[i].name)
		end
		return "failed to find a current campaign"
	else
		print("Campaign found: " .. c.name)
		--print("CampaignList:addQuest: count before is: " .. #c.questList)
		c.questList[#c.questList+1] = newQuest
		-- table.sort(c.questList)
		print("CampaignList:addQuest: count after is: " .. #c.questList)
		CampaignList:writeCampaignFile(c)
		return "success"
	end
	return "failed"
end

 -- Initialize the campaignList
CampaignList:new()
CampaignList:initialize()


return CampaignList