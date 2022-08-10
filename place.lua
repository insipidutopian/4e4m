-------------------------------------------------
--
-- place.lua
--
-- class for Place objects.
--
-------------------------------------------------
 
local place = {}
local place_mt = { __index = place }	-- metatable
 
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function place.new( name, type, description )	-- constructor
	print ("place.new() called")
	local newPlace = {
		name = name or "Unnamed",
		id = 0,
		type = type or "unknown",
		description = description or "description",
		details = "",
		keywords = {}
	}
	
	print ("place.new - creating name=" .. newPlace.name .. ", desc=" .. newPlace.description)
	
	return setmetatable( newPlace, place_mt )
end
 

 function place.newPlace( newPlace )	-- constructor
	print ("place.newPlace() called")
	local newlyCreatedPlace = {
		id = newPlace.id,
		name = newPlace.name or "Unnamed",
		type = newPlace.type or "unknown",
		description = newPlace.description or "description",
		details = newPlace.details,
		keywords = newPlace.keywords,
	}
	print ("place.newPlace - creating name=" .. newlyCreatedPlace.name .. ", desc=" .. newlyCreatedPlace.description)
	
	return setmetatable( newPlace, place_mt )
end

-------------------------------------------------
 
function place:setDescription(desc)
	print ("place:setDescription - setting place description = " .. desc)
	self.description = desc
end

function place:setName(name)
	print ("place:setName - setting place name = " .. name)
	self.name = name
end

function place:setDetails(details)
	print ("place:setDetails - setting place details = " .. details)
	self.details = details
end

function place:setType(type)
	print ("place:setType - setting place type = " .. type)
	self.type = type
end

function place:addKeyword(keyword)
--	self.cList.insert(place)
	print ("place:addKeyword - adding place keyword = " .. keyword)
	if (self.keywords) then
		self.keywords[#self.keywords+1] = keyword
	else
		self.keywords[1] = keyword
	end
end

function place:getDescription()
	print ("place:getDescription - getting place description = " .. self.description)
	return self.description
end

function place:getDetails()
	print ("place:getDetails - getting place details = " .. self.details)
	return self.details
end

function place:getName()
	print ("place:getName - getting place name = " .. self.name)
	return self.name
end

return place