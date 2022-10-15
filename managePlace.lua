-- managePlace.lua
local Place = require("place")
managePlace = {}


-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local newPlace
local placeName
local placeNotes
local currentPlaceId

local updateFunction

local function updatePlace()
	print("Updating Place")
	print("         Place Name:  " .. newPlace.name)
end

function managePlace.openViewPlaceDialog(place, group, showRerollButton, onSave, rollOnInit)
	updateFunction = onSave
	print("openViewPlaceDialog() called, Place is " .. place.name)
	local function onClose( self, onComplete )
		print("dialog onClose() called")
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local function closeTray( event )
		print("tray closeTray() called")
		updateFunction()
		onClose( dialog, function() dialog.frame:close() end )
	end

	local function rerollPlace( event )
		print("Rerolling Place")
		tType = Randomizer:generatePlaceType()
		newPlace = Randomizer:generatePlace(tType)
		placeNameTextField:setText(newPlace.name)
		--placeRaceTextField:setText(newPlace.race)
		placeNotes:setText(newPlace.description)
	end

	local function savePlaceToCampaign( )
		print("savePlaceToCampaign() called, place ID is " .. currentPlaceId)
		newPlace = Place.new(placeNameTextField.text, "", placeNotes.text)
		--currentCampaign = CampaignList:getCurrentCampaign()
		if (currentPlaceId == 0) then
			CampaignList:addPlaceToCampaign(newPlace)
		else
			newPlace.id = currentPlaceId
			CampaignList:updatePlaceForCampaign(newPlace)
		end
		updateFunction()

		closeTray()
	end

	local function deletePlace(place)
		CampaignList:removePlaceFromCampaign(place)
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
	currentPlaceId = place.id
	local titleSquare = display.newRoundedRect(dialog, 0, y, textWidth+4, 24, 4 )
	titleSquare.fill = {0.1,0.1,0.1}
	local focus = false
	if place.name == "" then
		focus = true
	end
	placeNameTextField = ssk.easyIFC:presetTextInput(dialog, "title", place.name, 0, y, 
			{listener=uiTools.textFieldListener, width=textWidth, placeholder='Place Name', keyboardFocus=focus})
	
    y=y+25; ssk.easyIFC:presetLabel( dialog, "appLabel", "Notes:", 0, y, {align="left", width=textWidth})
	y=y+10+textBoxHeight; 
	local notesSquare = display.newRoundedRect(dialog, 0, y, textWidth+4, 2*textBoxHeight+4, 4 )
	notesSquare.fill = {0.1,0.1,0.1}
	placeNotes = ssk.easyIFC:presetTextBox(dialog, "default", place.description, 10, y, 
			{listener=uiTools.textFieldListener, width=textWidth, height=2*textBoxHeight})

	

	y = textYOffset + textHeight / 2 - textYOffset
	if showRerollButton then
		if rollOnInit then
			rerollPlace(nil)
			native.setKeyboardFocus(nil)
		end
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Reroll", rerollPlace )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", savePlaceToCampaign )
	else
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Delete", function() deletePlace(place); end )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", savePlaceToCampaign )
	end

	y = y+40; 
	ssk.easyIFC:presetPush( dialog, "appButton", 0, y, 120, 30, "Close", closeTray )

	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function managePlace.openNewPlaceDialog(group, onSave)
	updateFunction = onSave
	print("openNewPlaceDialog() called, onsave=" .. tostring(onSave))
	newPlace = Place.new("", "", "") 
	managePlace.openViewPlaceDialog(newPlace, group, true, onSave)
end

function managePlace.openNewRandomPlaceDialog(group, onSave)
	updateFunction = onSave
	print("openNewRandomPlaceDialog() called, onsave=" .. tostring(onSave))
	newPlace = Place.new("", "", "") 
	managePlace.openViewPlaceDialog(newPlace, group, true, onSave, true)
end
return managePlace