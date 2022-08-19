-------------------------------------------------
--
-- partyMember.lua
--
-- class for PartyMember objects.
--
-------------------------------------------------
 
local partyMember = {}
local partyMember_mt = { __index = partyMember }	-- metatable
 
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function partyMember.new( name, description, class, race, level)	-- constructor
	print ("partyMember.new() called")
	local newPartyMember = {
		id = 0,
		name = name or "Unnamed",
		description = description or "description",
		race = race or "Human",
		class = class or "Fighter",
		level = level or 1,
	}
	
	print ("partyMember.new - creating name=" .. newPartyMember.name .. ", desc=" .. newPartyMember.description)
	
	return setmetatable( newPartyMember, partyMember_mt )
end
 
function partyMember.newPartyMember( partyMember )	-- constructor
	print ("partyMember.newPartyMember() called")
	local newPartyMember = {
		id = partyMember.id,
		name = partyMember.name or "Unnamed",
		description = partyMember.description or "description",
		level = partyMember.level or 1,
		race = partyMember.race or "Human",
		class = partyMember.class or "Fighter",
	}
	print ("partyMember.newPartyMember - creating name=" .. newPartyMember.name .. ", desc=" .. newPartyMember.description)
	
	return setmetatable( newPartyMember, partyMember_mt )
end
-------------------------------------------------


function partyMember.getDescription(self)
	print ("partyMember:getDescription - getting partyMember description = " .. self.description)
	return self.description
end

function partyMember.getRace(self)
	print ("partyMember:getRace - getting partyMember race = " .. self.race)
	return self.race
end

function partyMember.getClass(self)
	print ("partyMember:getClass - getting partyMember class = " .. self.class)
	return self.class
end
 
function partyMember.getLevel(self)
	print ("partyMember:getLevel - getting partyMember level = " .. self.level)
	return self.level
end
 

function partyMember.setDescription(self, desc)
	print ("partyMember:setDescription - setting partyMember description = " .. desc)
	self.description = desc
end

function partyMember.setRace(self, race)
	print ("partyMember:setRace - setting partyMember race = " .. race)
	self.race = race
end

function partyMember.setClass(self, class)
	print ("partyMember:setClass - setting partyMember description = " .. tostring(class))
	self.class = class
end

function partyMember.setLevel(self, level)
	print ("partyMember:setLevel - setting partyMember level = " .. tostring(level))
	self.class = level
end

return partyMember