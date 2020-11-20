-------------------------------------------------
--
-- npc.lua
--
-- class for Npc objects.
--
-------------------------------------------------
 
local npc = {}
local npc_mt = { __index = npc }	-- metatable
 
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function npc.new( name, race, notes )	-- constructor
	print ("npc.new() called")
	local newNpc = {
		name = name or "Unnamed",
		id = 0,
		race = race or "human",
		notes = notes
	}
	print ("npc.new - creating name=" .. newNpc.name .. ", notes=" .. newNpc.notes)
	
	return setmetatable( newNpc, npc_mt )
end
 

 function npc.newNpc( n )	-- constructor
	print ("npc.newNpc() called")
	local newNpc = {
		id = n.id,
		name = n.name or "Unnamed",
		notes = n.notes or "notes",
		race = n.race or "human"
	}
	print ("npc.newNpc - creating name=" .. newNpc.name .. ", desc=" .. newNpc.notes)
	
	return setmetatable( newNpc, npc_mt )
end

-------------------------------------------------
 
function npc:setNotes(desc)
	print ("npc:setNotes - setting npc notes = " .. desc)
	self.notes = desc
end

function npc:setName(name)
	print ("npc:setName - setting npc name = " .. name)
	self.name = name
end

function npc:setRace(details)
	print ("npc:setRace - setting npc race = " .. details)
	self.race = details
end


function npc:getNotes()
	print ("npc:getNotes - getting npc notes = " .. self.notes)
	return self.notes
end


function npc:getName()
	print ("npc:getName - getting npc name = " .. self.name)
	return self.name
end

function npc:getRace()
	print ("npc:getRace - getting npc race = " .. self.race)
	return self.race
end

return npc