-------------------------------------------------
--
-- CustomDiceList.lua
--
-- class for managing CustomDice objects.
--
-------------------------------------------------
--FileUtil = require ("FileUtil")
local CustomDiceClass = require ( "custom_dice" )

local CustomDiceList = {Instances={}}
--local CustomDiceList = {}
local CustomDiceList_mt = { __index = CustomDiceList }	-- metatable

local json = require "json"

local round = 0;


-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
function CustomDiceList:new(...)	-- constructor
	--local self = setmetatable( {}, CustomDiceList )
	local instance = setmetatable({}, self)
	--print ("CustomDiceList.new called, value="..dice)
	--instance:initialize(...)
	return instance
end
 

function CustomDiceList:initialize()
	-- instance.cdList = {}
	print ("CustomDiceList:initialize() - Initializing CustomDiceList...")
	table.insert(self.Instances, self)
	self.currentCustomDiceIndex = -1
	self.loaded = 0
	self.cdList = {}
	self.started = false

end


function CustomDiceList.getCustomDiceCount(self)
  print ("CustomDiceList.getCustomDiceCount(): count=" .. #self.cdList)
  return #self.cdList
end






function CustomDiceList.loadCustomDiceFile(self, fName)
	print ("CustomDiceList.loadCustomDiceFile() - loading CustomDice file " .. fName)
	if (fName == nil) then
		print ("Can't load nil CustomDice file")
		return
	end
	local fData = FileUtil:loadUserFile(fName)
	if (fData and fData ~= "") then
		print ("CustomDiceList.loadCustomDiceFile() - adding CustomDice File ==" .. fName)
		--local cFileData = "cname="..c.name.."\ncId="..c.id.."\ncDesc="..c.description.."\n"
		local i = json.decode(fData)
		if (i == nil) then
			print "CustomDiceList.loadCustomDiceFile() - nil data"
		else
			self.cdList = i
			for j=1, #self.cdList do
				print ("got an dice entry")
				print ("  name=" .. self.cdList[j].name .. ", dice=" .. self.cdList[j].dice)
				
			end
		end
	end
	
end




function CustomDiceList.writeCustomDiceFile(self)
	print ("CustomDiceList.writeCustomDiceFile() - writing CustomDice file")
	local fileName = "CustomDice.4ed"

	print ("CustomDiceList.writeCustomDiceFile() - adding CustomDice file ==" .. fileName)
	local iFileData = json.encode(self.cdList) -- "cname="..c.name.."\ncId="..c.id.."\ncDesc="..c.description.."\n"
	FileUtil:writeUserFile(fileName, iFileData)

	--local test = json.encode(c)
	--print ("JSON: " .. test)
end




function CustomDiceList.deleteCustomDice( self, die )
	print ("CustomDiceList.deleteCustomDice: Deleting customDice #" .. die.initSlot .. "...")
	

	print("Deleting CustomDice of " .. die.name .. " at slot " .. die.initSlot)

	for i=#self.cdList,1,-1 do
		if self.cdList[i].name == die.name and self.cdList[i].initSlot == die.initSlot then
			if self.cdList[i].initSlot < self.currentCustomDiceIndex then
				self.currentCustomDiceIndex = self.currentCustomDiceIndex - 1
			end
			table.remove(self.cdList, i)
		end
	end

end


function CustomDiceList.getNewCustomDiceId(self)
	if #self.cdList == 0 then
		return 1
	else
		return self.cdList[#self.cdList].id + 1
	end
end



function CustomDiceList.addCustomDice(self, dice)
--	self.cdList.insert(CustomDice)
	print ("CustomDiceList.addCustomDice() - adding CustomDice == " .. dice.name)
	if (dice.dice) then
		print ("CustomDiceList.addCustomDice() -    dice ==" .. dice.dice)
	end
	dice.id = CustomDiceList:getNewCustomDiceId()

	if (self.cdList) then
		self.cdList[#self.cdList+1] = dice
	else
		self.cdList = {}
		self.cdList[1] = dice
	end
	print ("CustomDiceList.addCustomDice() - " .. #self.cdList .. " CustomDices now found after add.")

	print ("CustomDiceList.addCustomDice() - Writing CustomDice to disk" )
	CustomDiceList:writeCustomDiceFile()

end




function CustomDiceList.loadCustomDice(self)
	
	if (self.loaded == 0) then
		CustomDiceList:loadCustomDiceFile("CustomDice.4ed")
		self.loaded = 1
	end
end
-------------------------------------------------
 

 -- Initialize the CustomDiceList
CustomDiceList:new()
CustomDiceList:initialize()


return CustomDiceList
