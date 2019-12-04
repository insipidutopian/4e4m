-------------------------------------------------
--
-- questList.lua
--
-- class for managing Quest objects.
--
-------------------------------------------------
local json = require "json"
local QuestClass = require ( "quest" )


local QuestList = {Instances={}}
--local QuestList = {}
local QuestList_mt = { __index = QuestList }	-- metatable
 
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
function QuestList:new(...)	-- constructor
	--local self = setmetatable( {}, QuestList )
	local instance = setmetatable({}, self)
	--print ("QuestList.new called, value="..init)
	--instance:initialize(...)
	return instance
end
 

function QuestList:initialize()
	-- instance.cList = {}
	print ("QuestList:initialize() - Initializing QuestList...")
	table.insert(self.Instances, self)
	self.currentQuestIndex = -1
	self.loaded = 0
	self.qList = {}
end

function QuestList.getNewQuestId(self)

	qId = appSettings['questCounter'] + 1
	appSettings['questCounter'] = appSettings['questCounter'] + 1

	FileUtil:writeSettingsFile("settings.cfg", appSettings)

	return qId
end

function QuestList.getQuestCount(self)
  print ("QuestList.getQuestCount() - count=" .. #self.qList)
  return #self.qList
end


function QuestList.writeQuestFile(self, q)
	print ("QuestList.writeQuestFile() - writing quest file")
	if (q == nil) then
		print ("Can't write nil quest")
		return
	end
	local qFileName = "quest_" .. q.id .. ".4eq"

	print ("QuestList.writeQuestFile() - adding quest ==" .. qFileName)
	local qFileData = json.encode(q) -- "cname="..c.name.."\ncId="..c.id.."\ncDesc="..c.description.."\n"
	FileUtil:writeUserFile(qFileName, qFileData)
end

function QuestList.loadQuestFile(self, fName)
	print ("QuestList.loadQuestFile() - loading quest file")
	if (fName == nil) then
		print ("Can't load nil quest file")
		return
	end
	local fData = FileUtil:loadUserFile(fName)
	if (fData and fData ~= "") then
		print ("QuestList.loadQuestFile() - adding quest from file=" .. fName)
		--local cFileData = "cname="..c.name.."\ncId="..c.id.."\ncDesc="..c.description.."\n"
		local q = json.decode(fData)
		print ("  name=" .. q.name .. ", desc=" .. q.description)
		local newQuest = QuestClass.newQuest(q)
		self.qList[#self.qList+1] = newQuest
	end
	
end

function QuestList.getQuest(self, i)
	print ("QuestList.getQuest() - getting quest #" .. i .. " of " .. #self.qList)
	
	if (i < 0) then
		print ("Bad Index: " .. i)
		return nil
	end

	if (i > #self.qList) then
		print ("Bad Index: " .. i)
		return nil
	end

	print ("QuestList.getQuest() - found quest, name=" .. self.qList[i].name)
	return self.qList[i]
end

function QuestList.addQuest(self, q)
--	self.qList.insert(quest)
	if (q.name == "") then
		q.name = "quest " .. #self.qList+1
	end
	print ("QuestList.addQuest() - adding quest ==" .. q.name)
	if (q.description) then
		print ("QuestList.addQuest() -    description ==" .. q.description)
	end

	q.id = QuestList.getNewQuestId()

	self.qList[#self.qList+1] = q
	print ("QuestList.addQuest() - " .. #self.qList .. " quests now found after add.")

	print ("QuestList.addQuest() - Writing Quest to disk" )
	QuestList:writeQuestFile(q)
end


function QuestList.setCurrentQuestIndex(self, i)
  print ("QuestList.setCurrentQuest() - setting current quest to=" .. i)
  self.currentQuestIndex = i
end


function QuestList.getCurrentQuestIndex(self)
  print ("QuestList.getCurrentQuest() - current quest=" .. self.currentQuestIndex)
  return self.currentQuestIndex
end

function QuestList.getCurrentQuest(self)
  print ("QuestList.getCurrentQuest() - current quest=" .. self.currentQuestIndex)
  if (self.currentQuestIndex > -1) then
  	return self.qList[self.currentQuestIndex]
  end

  print ("QuestList.getCurrentQuest() - no current quest")
  return nil
end


function QuestList.loadQuests(self)
	if (self.loaded == 0) then
		for i=1, appSettings['questCounter'] do
			QuestList:loadQuestFile("quest_" .. i ..".4eq")
			self.loaded = 1
		end
	end
end
-------------------------------------------------
 

 -- Initialize the questList
QuestList:new()
QuestList:initialize()


return QuestList