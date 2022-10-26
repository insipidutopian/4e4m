-------------------------------------------------
--
-- InitiativeList.lua
--
-- class for managing Initiative objects.
--
-------------------------------------------------
--FileUtil = require ("FileUtil")
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

	turnTimeElapsed = 0

	if nextInit == 0 then -- just starting...
		nextInit = 2
	end

	if nextInit > #self.iList then
		self.roundCount = self.roundCount+1
		nextInit = 1
		roundTimeElapsed = 0
	else
		print("**** nextInit = " .. nextInit)
	end

	print ("InitiativeList.nextInitiative() called.  setting next Initiative to: " .. nextInit)
	self.currentInitiativeIndex = nextInit
	InitiativeList:writeInitiativeStateFile()

end

function InitiativeList.previousInitiative(self)

	print ("InitiativeList.previousInitiative() called.  current Initiative is: " .. self.currentInitiativeIndex)
	local prevInit = self.currentInitiativeIndex-1

	turnTimeElapsed = 0 -- TODO - need to look it up from the prev init...

	if prevInit < 1 then
		self.roundCount = self.roundCount-1
		prevInit = #self.iList
	end

	print ("InitiativeList.previousInitiative() called.  setting previous Initiative to: " .. prevInit)
	self.currentInitiativeIndex = prevInit
	InitiativeList:writeInitiativeStateFile()

end


function InitiativeList.delayInitiative(self, newInit)
	local curInit = self.currentInitiativeIndex
	print ("-------------------------------------------------------------------------")
	print ("InitiativeList.delayInitiative() called.  current Initiative slot is: " .. curInit)
	if newInit then
		print ("InitiativeList.delayInitiative() called.  new Initiative slot is after: " .. newInit)
	--else
		--print ("oops...can't delay past end of round...")
	end
	local nextInit = curInit+1

	if newInit then
    	nextInit = newInit
    end

	if nextInit == 0 then -- just starting...
		nextInit = 2
	elseif nextInit > #self.iList then
		print ("oops...can't delay past end of round...")
		newInit = 1
		InitiativeList:nextInitiative()
	end

	if nextInit > #self.iList then
		self.roundCount = self.roundCount+1
		nextInit = 1
	end
    
    
	if newInit then
		local curInitE = self.iList[self.currentInitiativeIndex]
		print ("Moving " .. curInitE.name .. " to after " .. self.iList[newInit].name )
		niv = self.iList[newInit].initVal + self.iList[newInit].initBon
		print ("Moving " .. curInitE.name .. " from init slot " .. self.iList[self.currentInitiativeIndex].initVal .. " to init slot " .. niv )
		self.iList[self.currentInitiativeIndex].initVal = niv
		self.iList[self.currentInitiativeIndex].initBon = 0

		
		if (self.currentInitiativeIndex < newInit) then
			for i=self.currentInitiativeIndex,newInit-1 do
				print ("Swapping " .. self.iList[i].name .. " <--> " .. self.iList[i+1].name)
				local curInit = self.iList[i]
				local slotTmp = self.iList[i].initSlot
				self.iList[i].initSlot = self.iList[i+1].initSlot
				self.iList[i+1].initSlot = slotTmp
				self.iList[i] = self.iList[i+1]
	    		self.iList[i+1] = curInit
			end
		else
			-- move to the start of the list
			for i=self.currentInitiativeIndex,newInit+2,-1 do
				print ("Swapping "..i.." with prev init")
				print ("Swapping " .. self.iList[i].name .. " <--> " .. self.iList[i-1].name)
				local slotTmp = self.iList[i].initSlot
				self.iList[i].initSlot = self.iList[i-1].initSlot
	    		self.iList[i-1].initSlot = slotTmp
				local curInit = self.iList[i]
				self.iList[i] = self.iList[i-1]
	    		self.iList[i-1] = curInit
	    		
	    		print ("Done Swapping " .. self.iList[i].name .. " <--> " .. curInit.name)
			end

		end
	else
		--swap inits
	    local curInit = self.iList[self.currentInitiativeIndex]
	    curInit.initSlot = self.currentInitiativeIndex+1
	    self.iList[self.currentInitiativeIndex] = self.iList[nextInit]
	    self.iList[self.currentInitiativeIndex].initSlot = self.currentInitiativeIndex
	    self.iList[nextInit] = curInit
		self.iList[nextInit].initVal = self.iList[self.currentInitiativeIndex].initVal + self.iList[self.currentInitiativeIndex].initBon
		self.iList[nextInit].initBon = 0 --todo don't actually reset this, use another val which gets set at add/modify time
	end

	--print ("InitiativeList.nextInitiative() called.  setting next Initiative to: " .. nextInit)
	--self.currentInitiativeIndex = nextInit
	InitiativeList:writeInitiativeFile()
	InitiativeList:writeInitiativeStateFile()
	InitiativeList:sortInitiativesBySlot()
	InitiativeList:orderInitiatives()

end

function InitiativeList.getInitiativeCount(self)
  print ("InitiativeList.getInitiativeCount(): count=" .. #self.iList)
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

function _sortInitsBySlot(a,b)
	--print ("a="..a.initSlot..",b="..b.initSlot)
	return a.initSlot<b.initSlot
end

function InitiativeList.quickPrintInits(self)
	for i=1,#self.iList do
		print (i..". " .. self.iList[i].name)
	end
end

function InitiativeList.sortInitiativesBySlot(self)
	print ("InitiativeList.sortInitiativesBySlot()")
	self:quickPrintInits()
	if self then 
		table.sort( self.iList, _sortInitsBySlot  )
	end
	self:quickPrintInits()
end

function InitiativeList.reorderSlots(self)
	print("InitiativeList.reorderSlots() called.")
	for i=1, #self.iList do

		self.iList[i].initSlot = i
	end

end

function InitiativeList.sortInitiatives(self)
	print ("InitiativeList.sortInitiatives()")
	if self then 
		table.sort( self.iList, _sortInits  )
	end
end

function InitiativeList.orderInitiatives(self)
	for i=1, #self.iList do
		self.iList[i].initSlot = i
		print ("InitiativeList.orderInitiatives(): " .. self.iList[i].initSlot ..": " .. self.iList[i].name)
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
	print("InitiativeList.getOffsetInitiative() - current Init Index = " .. self.currentInitiativeIndex)
	local offset = 0

	if self.currentInitiativeIndex == -1 then
		offset = 1
		self.currentInitiativeIndex = 1
	else
		-- If round marker is in the way, take that into consideration
		if self.currentInitiativeIndex < i then
			offset = i + self.currentInitiativeIndex - 1
			if offset > #self.iList then
				offset = offset - #self.iList
			elseif offset < 1 then
				offset = 1
			end
		else
			offset = i + self.currentInitiativeIndex - 1
			if offset > #self.iList then
				offset = offset - #self.iList
			end
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

	print ("InitiativeList.getOffsetInitiative() - found Initiative, name=" .. self.iList[offset].name)
	print ("                                     - init =" .. "self.iList[offset].initVal" .. " bonus = " .. "self.iList[offset].initBon")
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
	print ("InitiativeList.loadInitiativeFile() - loading Initiative file " .. fName)
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


function InitiativeList.deleteInitiative( self, ini )
	print ("InitiativeList.deleteInitiative: Deleting initiative #" .. ini.initSlot .. "...")
	

	print("Deleting Initiative of " .. ini.name .. " at slot " .. ini.initSlot)

	for i=#self.iList,1,-1 do
		if self.iList[i].name == ini.name and self.iList[i].initSlot == ini.initSlot then
			if self.iList[i].initSlot < self.currentInitiativeIndex then
				self.currentInitiativeIndex = self.currentInitiativeIndex - 1
			end
			table.remove(self.iList, i)
		end
	end

end

function InitiativeList.deleteInitiativeBySlot( self, initSlotToDel )
	print ("InitiativeList.deleteInitiative: Deleting initiative " .. initSlotToDel .. "...")
	ini = InitiativeList:getOffsetInitiative(initSlotToDel)

	print("Deleting Initiative of " .. ini.name .. " at slot " .. ini.initSlot)

	for i=#self.iList,1,-1 do
		if self.iList[i].name == ini.name then
			if self.iList[i].initSlot < self.currentInitiativeIndex then
				self.currentInitiativeIndex = self.currentInitiativeIndex - 1
			end
			table.remove(self.iList, i)
		end
	end

end


function InitiativeList.resetInitiatives(self)
	print ("****************************************")
	print ("InitiativeList.resetInitiatives() called")

	self.currentInitiativeIndex = -1
	self.roundCount = 1
	for i=1,#self.iList do
		self.iList[i].initBon = self.iList[i].initBonusSaved
	end
	
	InitiativeList:sortInitiatives()
	InitiativeList:reorderSlots()

	InitiativeList:writeInitiativeFile()
	InitiativeList:writeInitiativeStateFile()	
print ("****************************************")
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
	print ("InitiativeList.updateInitiative() - updating Initiative == " .. init.name)
	print ("InitiativeList.updateInitiative() - updating Initiative #" .. tostring(initNumToMod))
	--print ("InitiativeList.updateInitiative() - replacing " ..self.iList[initNumToMod].name .. " at #"..initNumToMod )
	print ("")
	-- self.iList[initNumToMod] = init
	
	InitiativeList:sortInitiatives()
	InitiativeList:reorderSlots()

	print ("InitiativeList.updateInitiative() - Writing Initiative to disk" )
	InitiativeList:writeInitiativeFile()
	InitiativeList:writeInitiativeStateFile()
end



function InitiativeList.addInitAtSlot(self, init, i)
	print ("Adding init for " .. init.name .. " at slot " .. i)
	table.insert(self.iList, i, init)
	InitiativeList:reorderSlots()
	return
end

function InitiativeList.addInitiative(self, init)
--	self.iList.insert(Initiative)
	print ("InitiativeList.addInitiative() - adding Initiative == " .. init.name)
	if (init.type) then
		print ("InitiativeList.addInitiative() -    type ==" .. init.type)
	end
	init.id = InitiativeList.getNewInitiativeId()

	local inserted = 0
	if (#self.iList == 0) then
		print ("first in list")
		InitiativeList:addInitAtSlot(init, 1)
		inserted = 1
	else
		for i=1, #self.iList do
			if (init.initVal+init.initBon > self.iList[i].initVal + self.iList[i].initBon) then
				if (inserted == 0 ) then
					print (init.name .. " should go at init " .. i)
					InitiativeList:addInitAtSlot(init, i)
					inserted = 1
				end
			elseif (init.initVal+init.initBon == self.iList[i].initVal + self.iList[i].initBon) then
				print ("TIED INITIATIVES at " .. init.initVal+init.initBon .. " new init bonus=" .. 
						init.initBon .. " vs encumbant at " .. self.iList[i].initBon)
				if (init.initBon > self.iList[i].initBon) then
					if (inserted == 0 ) then
						print (init.name .. " should go at init " .. i)
						InitiativeList:addInitAtSlot(init, i)
						inserted = 1
					end
				end
			end
		end
	end
	if (inserted == 0) then
		InitiativeList:addInitAtSlot(init, #self.iList+1)
	end

	--self.iList[#self.iList+1] = init
	InitiativeList.sortInitiatives()
	self:reorderSlots()
	print ("InitiativeList.addInitiative() - " .. #self.iList .. " Initiatives now found after add.")

	print ("InitiativeList.addInitiative() - Writing Initiative to disk" )
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
