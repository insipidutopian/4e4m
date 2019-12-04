-------------------------------------------------
--
-- initiative.lua
--
-- class for Initiative objects.
--
-------------------------------------------------
 
local initiative = {}
local initiative_mt = { __index = initiative }	-- metatable
 
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
local function foo( multiplier )	-- local; only visible in this module
	return multiplier * 7
end
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function initiative.new( name, iType, initVal, initBon, initSlot )	-- constructor
	print ("initiative.new() called")
	local newInitiative = {
		id = 0,
		name = name or "Unnamed",
		iType = iType or "player",
		initVal = initVal or 10,
		initBon = initBon or 0,
		initBonusSaved = initBonusSaved or 0,
		initSlot = initSlot or 0,
		hasDelayed = false,
		turnTime = turnTime or 0
	}
	-- if (debugFlag == 1) then
	-- 	print ("initiative.new - DEBUG=TRUE - generating initiative keywords")
	-- 	rand = math.random( 3 ) + 1
	-- 	for i = 1, rand do
	-- 		print ("generating random keyword for initiative.")
	-- 		keywords[i] = "keyword" .. i
	-- 	end
	-- end
	print ("initiative.new - creating name=" .. newInitiative.name .. ", type=" .. newInitiative.iType)
	
	return setmetatable( newInitiative, initiative_mt )
end
 
function initiative.newInitiative( initiative )	-- constructor
	print ("initiative.newInitiative() called")
	local newInitiative = {
		id = initiative.id,
		name = initiative.name or "Unnamed",
		iType = initiative.iType or "player",
		initVal = initiative.initVal,
		initBon = initiative.initBon or 0,
		initBonusSaved = initiative.initBonusSaved or 0,
		initSlot = initiative.initSlot or 0,
		hasDelayed = initiative.hasDelayed,
		turnTime = initiative.turnTime or 0
	}
	print ("initiative.newInitiative - creating name=" .. newInitiative.name .. ", type=" .. newInitiative.iType)
	
	return setmetatable( newInitiative, initiative_mt )
end
-------------------------------------------------
 
function initiative:setInititiativeType(iType)
--	self.cList.insert(initiative)
	print ("initiative:setInititiativeType - setting initiative type = " .. iType)
	self.iType = iType
end


function initiative:addKeyword(keyword)
--	self.cList.insert(initiative)
	print ("initiative:addKeyword - adding initiative keyword = " .. keyword)
	if (self.keywords) then
		self.keywords[#self.keywords+1] = keyword
	else
		self.keywords[1] = keyword
	end
end

function initiative:getInitiativeType()
--	self.cList.insert(initiative)
	print ("initiative:getInitiativeType - getting initiative type = " .. self.iType)
	return self.iType
end

return initiative