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


function CampaignList.loadCampaigns(self)
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
-------------------------------------------------


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
		print("CampaignList:addNpc: count after is: " .. #c.npcList)
		CampaignList:writeCampaignFile(c)
		return "success"
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