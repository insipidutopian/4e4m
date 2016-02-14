-------------------------------------------------
--
-- InitiativeList.lua
--
-- class for managing Initiative objects.
--
-------------------------------------------------
FileUtil = require ("FileUtil")
local InitiativeClass = require ( "initiative" )

local InitiativeList = {Instances={}}
--local InitiativeList = {}
local InitiativeList_mt = { __index = InitiativeList }	-- metatable

local json = require "json"

local round = 0;


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
function InitiativeList:new(...)	-- constructor
	--local self = setmetatable( {}, InitiativeList )
	local instance = setmetatable({}, self)
	--print ("InitiativeList.new called, value="..init)
	--instance:initialize(...)
	return instance
end
 

function InitiativeList:initialize()
	-- instance.iList = {}
	print ("InitiativeList:initialize() - Initializing InitiativeList...")
	table.insert(self.Instances, self)
	self.currentInitiativeIndex = -1
	self.loaded = 0
	self.iList = {}
	self.started = false
	self.roundCount = 1

end

function InitiativeList.getRoundNumber(self)
	
	return self.roundCount
end


function InitiativeList.nextInitiative(self)

	print ("InitiativeList.nextInitiative() called.  current Initiative is: " .. self.currentInitiativeIndex)
	local nextInit = self.currentInitiativeIndex+1

	if nextInit == 0 then -- just starting...
		nextInit = 2
	end

	if nextInit > #self.iList then
		self.roundCount = self.roundCount+1
		nextInit = 1
	end

	print ("InitiativeList.nextInitiative() called.  setting next Initiative to: " .. nextInit)
	self.currentInitiativeIndex = nextInit
	InitiativeList:writeInitiativeStateFile()

end

function InitiativeList.getInitiativeCount(self)
  print ("InitiativeList.getInitiativeCount() - count=" .. #self.iList)
  return #self.iList
end

function _sortInits(a,b)
	aIni = a.initVal+a.initBon
	bIni = b.initVal+b.initBon
	if aIni == bIni then
		return a.initBon>b.initBon
	end

	return aIni>bIni
end

function InitiativeList.sortInitiatives(self)
	print("InitiativeList.sortInitiatives() called")
	if self then 
		table.sort( self.iList, _sortInits  )
	end
end


function InitiativeList.isLast(self, i)
	if self.currentInitiativeIndex == -1 then
		return false
	end

	if self.currentInitiativeIndex + i - 1 == #self.iList then
		return true
	end

	return false

end


function InitiativeList.getOffsetInitiative(self, i)
	print ("InitiativeList.getOffsetInitiative() - getting Initiative #" .. i .. " of " .. #self.iList)
	local offset = 0

	if self.currentInitiativeIndex == -1 then
		offset = 1
		self.currentInitiativeIndex = 1
	else
		offset = i + self.currentInitiativeIndex - 1
		if offset > #self.iList then
			offset = offset - #self.iList
		end
	end

	if (offset < 0) then
		print ("Bad Index: " .. i)
		return nil
	end

	if (offset > #self.iList) then
		print ("Bad Index: " .. i)
		return nil
	end

	print ("InitiativeList.getInitiative() - found Initiative, name=" .. self.iList[offset].name)
	print ("                               - init =" .. self.iList[offset].initVal .. " bonus = " .. self.iList[offset].initBon)
	return self.iList[offset]

end

function InitiativeList.getInitiative(self, i)
	print ("InitiativeList.getInitiative() - getting Initiative #" .. i .. " of " .. #self.iList)
	
	if (i < 0) then
		print ("Bad Index: " .. i)
		return nil
	end

	if (i > #self.iList) then
		print ("Bad Index: " .. i)
		return nil
	end

	print ("InitiativeList.getInitiative() - found Initiative, name=" .. self.iList[i].name)
	print ("                               - init =" .. self.iList[i].initVal .. " bonus = " .. self.iList[i].initBon)
	return self.iList[i]
end


function InitiativeList.loadInitiativeFile(self, fName)
	print ("InitiativeList.loadInitiativeFile() - loading Initiative file")
	if (fName == nil) then
		print ("Can't load nil Initiative file")
		return
	end
	local fData = FileUtil:loadUserFile(fName)
	if (fData and fData ~= "") then
		print ("InitiativeList.loadInitiativeFile() - adding Initiative File ==" .. fName)
		--local cFileData = "cname="..c.name.."\ncId="..c.id.."\ncDesc="..c.description.."\n"
		local i = json.decode(fData)
		if (i == nil) then
			print "InitiativeList.loadInitiativeFile() - nil data"
		else
			self.iList = i
			for j=1, #self.iList do
				print ("got an init entry")
				print ("  name=" .. self.iList[j].name .. ", type=" .. self.iList[j].iType)
				--local newInitiative = InitiativeClass.newInitiative(i)
				--self.iList[#self.iList+1] = newInitiative
			end
		end
	end
	
end


function InitiativeList.loadInitiativeStateFile(self, fName)
	print ("InitiativeList.loadInitiativeStateFile() - loading Initiative file")
	if (fName == nil) then
		print ("Can't load nil Initiative State file")
		print ("default current init = " .. self.currentInitiativeIndex .. ", round number = " .. self.roundCount)
		return
	end
	local fData = FileUtil:loadUserFile(fName)
	if (fData and fData ~= "") then
		print ("InitiativeList.loadInitiativeStateFile() - loading Initiative State File ==" .. fName)
		--local cFileData = "cname="..c.name.."\ncId="..c.id.."\ncDesc="..c.description.."\n"
		local initState = json.decode(fData)
		if (initState == nil) then
			print "InitiativeList.loadInitiativeStateFile() - nil data"
		else
			self.currentInitiativeIndex = initState[1]
			self.roundCount = initState[2]
		end
	end
	print ("got current init = " .. self.currentInitiativeIndex .. ", round number = " .. self.roundCount)

	
end

function InitiativeList.writeInitiativeFile(self)
	print ("InitiativeList.writeInitiativeFile() - writing Initiative file")
	local fileName = "Initiative.4ei"

	print ("InitiativeList.writeInitiativeFile() - adding Initiative file ==" .. fileName)
	local iFileData = json.encode(self.iList) -- "cname="..c.name.."\ncId="..c.id.."\ncDesc="..c.description.."\n"
	FileUtil:writeUserFile(fileName, iFileData)

	--local test = json.encode(c)
	--print ("JSON: " .. test)
end

function InitiativeList.writeInitiativeStateFile(self)
	print ("InitiativeList.writeInitiativeStateFile() - writing Initiative State file")
	local fileName = "InitiativeState.4ei"

	print ("InitiativeList.writeInitiativeStateFile() - adding Initiative file ==" .. fileName)
	local currState = { self.currentInitiativeIndex, self.roundCount }
	local iFileData = json.encode(currState) -- "cname="..c.name.."\ncId="..c.id.."\ncDesc="..c.description.."\n"
	FileUtil:writeUserFile(fileName, iFileData)

	--local test = json.encode(c)
	--print ("JSON: " .. test)
end


function InitiativeList.getNewInitiativeId(self)
	-- print ("4e4m Settings File Version : " .. appSettings['fileVersion'])
	-- print ("4e4m App Name              : " .. appSettings['appName'])
	-- print ("4e4m App Version           : " .. appSettings['appVersion'])
	-- print ("4e4m Initiative Count        : " .. appSettings['initiativeCounter'])	

	cId = appSettings['initiativeCounter'] + 1
	appSettings['initiativeCounter'] = cId

	FileUtil:writeSettingsFile("settings.cfg", appSettings)

	return cId
end


function InitiativeList.deleteInitiative( self, initNumToDel )
	print ("InitiativeList.removeEnemyInitiatives: Deleting initiative " .. initNumToDel .. "...")
	table.remove(self.iList, initNumToDel)

end


function InitiativeList.resetInitiatives(self)
	print ("InitiativeList.resetInitiatives() called")

	self.currentInitiativeIndex = -1
	self.roundCount = 1

	InitiativeList:writeInitiativeFile()
	InitiativeList:writeInitiativeStateFile()	

end


function InitiativeList.removeEnemyInitiatives( self )
	print ("InitiativeList.removeEnemyInitiatives: Removing enemy initiatives...")
	for i=#self.iList,1,-1 do
		print (i..": is type " .. self.iList[i].iType)
		if self.iList[i].iType == "enemy" then
			table.remove(self.iList, i)
			i=i-1
		end
	end

end
function InitiativeList.updateInitiative(self, initNumToMod, init)
	print ("InitiativeList.updateInitiative() - updating Initiative ==" .. init.name)
	self.iList[initNumToMod] = init

	print ("InitiativeList.updateInitiative() - Writing Initiative to disk" )
	InitiativeList:writeInitiativeFile()
	InitiativeList:writeInitiativeStateFile()
end

function InitiativeList.addInitiative(self, init)
--	self.iList.insert(Initiative)
	print ("InitiativeList.updateInitiative() - adding Initiative ==" .. init.name)
	if (init.type) then
		print ("InitiativeList.updateInitiative() -    type ==" .. init.type)
	end
	init.id = InitiativeList.getNewInitiativeId()

	self.iList[#self.iList+1] = init
	print ("InitiativeList.updateInitiative() - " .. #self.iList .. " Initiatives now found after add.")

	print ("InitiativeList.updateInitiative() - Writing Initiative to disk" )
	InitiativeList:writeInitiativeFile()
	InitiativeList:writeInitiativeStateFile()


end

function InitiativeList.setCurrentInitiativeIndex(self, i)
  print ("InitiativeList.setCurrentInitiative() - setting current Initiative to=" .. i)
  self.currentInitiativeIndex = i
end


function InitiativeList.getCurrentInitiativeIndex(self)
  print ("InitiativeList.getCurrentInitiative() - current Initiative=" .. self.currentInitiativeIndex)
  return self.currentInitiativeIndex
end

function InitiativeList.getCurrentInitiative(self)
  print ("InitiativeList.getCurrentInitiative() - current Initiative=" .. self.currentInitiativeIndex)
  if (self.currentInitiativeIndex > -1) then
  	return self.iList[self.currentInitiativeIndex]
  end

  print ("InitiativeList.getCurrentInitiative() - no current Initiative")
  return nil
end


function InitiativeList.loadInitiative(self)
	local c = appSettings['initiativeCounter']
	if c == nil then
		c=0
		appSettings['initiativeCounter'] = 0
		writeInitiativeFile()
		writeInitiativeStateFile()

	end
	if (self.loaded == 0) then
		InitiativeList:loadInitiativeFile("Initiative.4ei")
		InitiativeList:loadInitiativeStateFile("InitiativeState.4ei")
		self.loaded = 1
	end
end
-------------------------------------------------
 

 -- Initialize the InitiativeList
InitiativeList:new()
InitiativeList:initialize()


return InitiativeList