-------------------------------------------------
--
-- encounter.lua
--
-- class for Encounter objects.
--
-------------------------------------------------
 
local encounter = {}
local encounter_mt = { __index = encounter }	-- metatable
 
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function encounter.new( name, type, description )	-- constructor
	print ("encounter.new() called")
	local newEncounter = {
		name = name or "Unnamed",
		id = 0,
		type = type or "unknown",
		description = description or "",
		details = "",
		keywords = {},
		entities = {},
		featuresOfTheArea = "",
		rewards = "",
		tactics = "",
		--Trap Specific
		-- detection = "",
		-- mitigation = "",
		-- triggering = "",
		-- --Monster Specific
		-- hp = 0,
		-- ac = 0,
		-- --Skill Challenge Specific
		-- checks = {},
		-- dcs = {}
	}
	
	print ("encounter.new - creating name=" .. tostring(name) .. ", desc=" .. tostring(description))
	
	return setmetatable( newEncounter, encounter_mt )
end
 

 function encounter.newEncounter( newEncounter )	-- constructor
	print ("encounter.newEncounter() called")
	local newlyCreatedEncounter = {
		id = newEncounter.id,
		name = newEncounter.name or "Unnamed",
		type = newEncounter.type or "unknown",
		description = newEncounter.description or "",
		details = newEncounter.details,
		keywords = newEncounter.keywords,
		entities = newEncounter.entities or {},
		featuresOfTheArea = newEncounter.featuresOfTheArea or "",
		rewards = newEncounter.rewards or "",
		tactics = newEncounter.tactics or "",
		--Trap Specific
		-- detection = newEncounter.detection or "",
		-- mitigation = newEncounter.mitigation or "",
		-- triggering = newEncounter.triggering or "",
		-- --Monster Specific
		-- hp = newEncounter.hp or 1,
		-- ac = newEncounter.ac or 10,
		-- --Skill Challenge Specific
		-- checks = newEncounter.checks or {},
		-- dcs = newEncounter.dcs or {}
	}
	print ("encounter.newEncounter - creating name=" .. newlyCreatedEncounter.name .. ", desc=" .. newlyCreatedEncounter.description)
	
	return setmetatable( newEncounter, encounter_mt )
end

-------------------------------------------------
 
function encounter:setDescription(desc)
	print ("encounter:setDescription - setting encounter description = " .. desc)
	self.description = desc
end

function encounter:setName(name)
	print ("encounter:setName - setting encounter name = " .. name)
	self.name = name
end

function encounter:setDetails(details)
	print ("encounter:setDetails - setting encounter details = " .. details)
	self.details = details
end

function encounter:setType(type)
	print ("encounter:setType - setting encounter type = " .. type)
	self.type = type
end

function encounter:addKeyword(self, keyword)
--	self.cList.insert(encounter)
	print ("encounter:addKeyword - adding encounter keyword = " .. keyword)
	if (self.keywords) then
		self.keywords[#self.keywords+1] = keyword
	else
		self.keywords[1] = keyword
	end
end

function encounter:addEntity(entity)
--	self.cList.insert(encounter)
	print ("encounter:addEntity - adding encounter entity = " .. tostring(entity.name))
	if (self.entities) then
		print("Adding entity")
		if #self.entities == 0 then
			entity.id = 1
		else
			entity.id = self.entities[#self.entities].id + 1
		end
		self.entities[#self.entities+1] = entity
	else
		print("New entities list")
		entity.id = 1
		self.entities[1] = entity
	end
	return true
end

function encounter:removeEntity(entity)
--	self.cList.insert(encounter)
	print ("encounter:addEntity - removing encounter entity = " .. tostring(entity.name))
	if (self.entities) then
		print("Removing entity")
		for i=1, #self.entities do
			if self.entities[i].id == entity.id then
				table.remove( self.entities, i )
				return true
			end
		end
		print("No matching entity found to remove")
		return false
	else
		print("No entities found to remove from")
		return false
	end
end

function encounter:getDescription()
	print ("encounter:getDescription - getting encounter description = " .. self.description)
	return self.description
end

function encounter:getDetails()
	print ("encounter:getDetails - getting encounter details = " .. self.details)
	return self.details
end

function encounter:getName()
	print ("encounter:getName - getting encounter name = " .. self.name)
	return self.name
end

return encounter