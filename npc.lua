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
 
function npc.new(self, name, race, notes )	-- constructor
	print ("npc.new() called")
	local newNpc = {
		name = name or "Unnamed",
		id = 0,
		race = race or "human",
		notes = notes or ""
	}
	print ("npc.new - creating name=" .. newNpc.name .. ", race=" .. newNpc.race .. ", notes=" .. newNpc.notes)
	
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
	print ("npc.newNpc - creating name=" .. newNpc.name .. ", notes=" .. newNpc.notes)
	
	return setmetatable( newNpc, npc_mt )
end

-------------------------------------------------
 
function npc:setNotes(notes)
	print ("npc:setNotes - setting npc notes = " .. notes)
	self.notes = notes
end

function npc:setName(name)
	print ("npc:setName - setting npc name = " .. name)
	self.name = name
end

function npc:setRace(race)
	print ("npc:setRace - setting npc race = " .. race)
	self.race = race
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