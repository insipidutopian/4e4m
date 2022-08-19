-- manageEvent.lua
local Event = require("event")
local currentScene = "editCampaign"

manageEvent = {}


-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local newEvent
local eventTitle
local eventRace
local eventNotes
local currentEventId

local updateFunction

local function updateEvent()
	print("Updating Event")
	print("         Event Title:  " .. newEvent.title)
end

function manageEvent.openViewEventDialog(event, group, showRerollButton, onSave)
	updateFunction = onSave
	print("openViewEventDialog() called, Event is " .. event.title)
	local function onClose( self, onComplete )
		print("dialog onClose() called")
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local function closeTray( event )
		print("tray closeTray() called")
		updateFunction()
		onClose( dialog, function() dialog.frame:close() end )
	end

	local function rerollEvent( event )
		print("Rerolling Event")
		--keywords = Randomizer:generateEventKeywords()
		newEvent = Event:new(Randomizer:generateEventTitle(), {"random"}, Randomizer:generateEventNotes())
		eventTitleTextField:setText(newEvent.title)
		--eventRaceTextField:setText()
		eventNotes:setText(newEvent.notes)
	end

	local function saveEventToCampaign( )
		print("saveEventToCampaign() called, event ID is " .. currentEventId)
		newEvent = Event:new(eventTitleTextField.text, {"random"}, eventNotes:getText())
		--currentCampaign = CampaignList:getCurrentCampaign()
		if (currentEventId == 0) then
			CampaignList:addEventToCampaign(newEvent)
		else
			newEvent.id = currentEventId
			CampaignList:updateEventForCampaign(newEvent)
		end
		updateFunction()

		closeTray()
	end

	local function deleteEvent(event)
		CampaignList:removeEventFromCampaign(event)
		updateFunction()
		closeTray()
	end

	centerX=0
	centerY=0
	local image = "images/gamemastery/dialog_celticspears_tall3.png"
	if largeFormat then
		image = "images/gamemastery/dialog_celticspears_tall2.png"
	end

	local width, height = ssk.misc.getImageSize( image )
	print("IMAGE W=" .. tostring(width) .. ", H=" .. tostring(height))
	if not group then group = display.newGroup(); end
	dialog = ssk.dialogs.custom.create( group, 0, 0, 
	         { width = width,
	           height = height,
	           softShadow = true,
	           softShadowOX = 8,
	           softShadowOY = 8,
	           softShadowBlur = 6,
	           closeOnTouchBlocker = false, 
	           blockerFill = _WHITE_,
	           blockerAlpha = 0.15,
	           softShadowAlpha = 0.3,
	           blockerAlphaTime = 100,
	           onClose = onClose,
	           trayImage = image,
           	   shadowImage = image } )

	local textWidth = width - 80
	local textHeight = height - 200
	local textYOffset = 0
	local textBoxHeight = 80

	if largeFormat then
		textYOffset = 50
		textBoxHeight = 130
	end

	y = textYOffset + textHeight / -2
	currentEventId = event.id
	eventTitleTextField = ssk.easyIFC:presetTextInput(dialog, "title", event.title, 0, y-10, 
			{listener=uiTools.textFieldListener, updateFunction=saveEventToCampaign})
	
    y=y+20; ssk.easyIFC:presetLabel( dialog, "appLabel", "Notes:", 0, y, {align="left", width=180})
	y=y+60; 
	eventNotes = ssk.easyIFC:presetTextBox(dialog, "default", event.notes, 10, y, 
			{listener=uiTools.textFieldListener, updateFunction=saveEventToCampaign, width=240, height=80})


	y = textYOffset + textHeight / 2 - textYOffset

	if showRerollButton then
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Reroll", rerollEvent )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", saveEventToCampaign )
	else
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Delete", function() deleteEvent(event); end )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", saveEventToCampaign )
	end

	y=y+40; 
	ssk.easyIFC:presetPush( dialog, "appButton", 0, y, 120, 30, "Close", closeTray )


	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function manageEvent.openNewEventDialog(group, onSave)
	updateFunction = onSave
	print("openNewEventDialog() called, onsave=" .. tostring(onSave))
	--local race = Randomizer:generateEventRace()
	newEvent = Event:new(Randomizer:generateEventTitle(), race, Randomizer:generateEventNotes())
	manageEvent.openViewEventDialog(newEvent, group, true, onSave)
end

return manageEvent