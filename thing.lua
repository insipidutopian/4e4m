-------------------------------------------------
--
-- thing.lua
--
-- class for Thing objects.
--
-------------------------------------------------
 
local thing = {}
local thing_mt = { __index = thing }	-- metatable
 
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function thing.new( name, type, description )	-- constructor
	print ("thing.new() called")
	local newThing = {
		name = name or "Unnamed",
		id = 0,
		type = type or "unknown",
		description = description or "",
		details = "",
		keywords = {}
	}
	
	print ("thing.new - creating name=" .. tostring(name) .. ", desc=" .. tostring(description))
	
	return setmetatable( newThing, thing_mt )
end
 

 function thing.newThing( newThing )	-- constructor
	print ("thing.newThing() called")
	local newlyCreatedThing = {
		id = newThing.id,
		name = newThing.name or "Unnamed",
		type = newThing.type or "unknown",
		description = newThing.description or "",
		details = newThing.details,
		keywords = newThing.keywords,
	}
	print ("thing.newThing - creating name=" .. newlyCreatedThing.name .. ", desc=" .. newlyCreatedThing.description)
	
	return setmetatable( newThing, thing_mt )
end

-------------------------------------------------
 
function thing:setDescription(desc)
	print ("thing:setDescription - setting thing description = " .. desc)
	self.description = desc
end

function thing:setName(name)
	print ("thing:setName - setting thing name = " .. name)
	self.name = name
end

function thing:setDetails(details)
	print ("thing:setDetails - setting thing details = " .. details)
	self.details = details
end

function thing:setType(type)
	print ("thing:setType - setting thing type = " .. type)
	self.type = type
end

function thing:addKeyword(keyword)
--	self.cList.insert(thing)
	print ("thing:addKeyword - adding thing keyword = " .. keyword)
	if (self.keywords) then
		self.keywords[#self.keywords+1] = keyword
	else
		self.keywords[1] = keyword
	end
end

function thing:getDescription()
	print ("thing:getDescription - getting thing description = " .. self.description)
	return self.description
end

function thing:getDetails()
	print ("thing:getDetails - getting thing details = " .. self.details)
	return self.details
end

function thing:getName()
	print ("thing:getName - getting thing name = " .. self.name)
	return self.name
end

return thing