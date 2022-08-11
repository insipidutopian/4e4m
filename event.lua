-------------------------------------------------
--
-- event.lua
--
-- class for Event objects.
--
-------------------------------------------------
 
local event = {}
local event_mt = { __index = event }	-- metatable
 
-------------------------------------------------
-- PRIVATE FUNCTIONS
-------------------------------------------------
 
 
-------------------------------------------------
-- PUBLIC FUNCTIONS
-------------------------------------------------
 
function event.new(self, title, keywords, notes, date, location )	-- constructor
	print ("event.new() called")
	local newEvent = {
		title = title or "Untitled",
		id = 0,
		keywords = keywords or {},
		notes = notes or "",
		date = date or "",
		location = location or ""
	}
	print ("event.new - creating title=" .. newEvent.title .. ", # keywords=" .. #newEvent.keywords .. ", notes=" .. newEvent.notes)
	
	return setmetatable( newEvent, event_mt )
end
 

 function event.newEvent( ev )	-- constructor
	print ("event.newEvent() called")
	local newEvent = {
		id = ev.id,
		title = ev.title or "Untitled",
		notes = ev.notes or "notes",
		keywords = ev.keywords or {},
		date = ev.date or "",
		location = ev.location
	}
	print ("event.newEvent - creating title=" .. newEvent.title .. ", notes=" .. newEvent.notes)
	
	return setmetatable( newEvent, event_mt )
end

-------------------------------------------------
 
function event:setNotes(notes)
	print ("event:setNotes - setting event notes = " .. notes)
	self.notes = notes
end

function event:setTitle(title)
	print ("event:setTitle - setting event title = " .. title)
	self.title = title
end

function event:setRace(keywords)
	print ("event:setRace - setting event keywords = " .. #keywords .. " keywords")
	self.keywords = keywords
end

function event:setLocation(location)
	print ("event:setNotes - setting event location = " .. location)
	self.location = location
end

function event:setDate(date)
	print ("event:setNotes - setting event date = " .. date)
	self.date = date
end


function event:getTitle()
	print ("event:getTitle - getting event title = " .. self.title)
	return self.title
end

function event:getNotes()
	print ("event:getNotes - getting event notes = " .. self.notes)
	return self.notes
end

function event:getKeywords()
	print ("event:getKeywords - getting event keywords, found " .. #self.keywords .. " keywords")
	return self.keywords
end

function event:getDate()
	print ("event:getDate - getting event date = " .. self.date)
	return self.date
end

function event:getLocation()
	print ("event:getLocation - getting event Location = " .. self.location)
	return self.location
end

return event