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

function managePlace.openViewPlaceDialog(place, group, showRerollButton, onSave)
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
	local width, height = ssk.misc.getImageSize( "images/gamemastery/dialog_celticspears_square.png" )
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
	           trayImage = "images/gamemastery/dialog_celticspears_square.png",
           	   shadowImage = "images/gamemastery/dialog_celticspears_square.png" } )

	y=-100; --placeName = ssk.easyIFC:presetLabel( dialog, "appLabel", place.name, 0, y, {fontSize = 18})
	currentPlaceId = place.id
	placeNameTextField = ssk.easyIFC:presetTextInput(dialog, "title", place.name, 0, y-10, 
			{listener=uiTools.textFieldListener, updateFunction=savePlaceToCampaign})
	--y=y+20; ssk.easyIFC:presetLabel( dialog, "appLabel", "id: " .. place.id, 0, y, {align="left", width=180})
    --y=y+20; placeRace = ssk.easyIFC:presetLabel( dialog, "appLabel", "Race: ", 0, y, {align="left", width=180})
    --placeRaceTextField = ssk.easyIFC:presetTextInput(dialog, "default", place.race, 30, y, 
	--		{listener=uiTools.textFieldListener, updateFunction=savePlaceToCampaign, width=120})
    y=y+20; ssk.easyIFC:presetLabel( dialog, "appLabel", "Notes:", 0, y, {align="left", width=180})
	y=y+60; --placeNotes = ssk.easyIFC:presetLabel( dialog, "appLabel",  place.description, 10, y, {align="left", width=180, height=100})
	placeNotes = ssk.easyIFC:presetTextBox(dialog, "default", place.description, 10, y, 
			{listener=uiTools.textFieldListener, updateFunction=savePlaceToCampaign, width=240, height=80})

	ssk.easyIFC:presetPush( dialog, "appButton", 0, 120, 120, 30, "Close", closeTray )

	if showRerollButton then
		ssk.easyIFC:presetPush( dialog, "appButton", -50, 80, 80, 30, "Reroll", rerollPlace )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, 80, 80, 30, "Save", savePlaceToCampaign )
	else
		--ssk.easyIFC:presetPush( dialog, "appButton", 0, 80, 120, 30, "Save", savePlaceToCampaign )
		ssk.easyIFC:presetPush( dialog, "appButton", -50, 80, 80, 30, "Delete", function() deletePlace(place); end )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, 80, 80, 30, "Save", savePlaceToCampaign )
	end

	--tf = ssk.easyIFC:quickTextInput(dialog, "Example Input", 0, 40, 150, 40, {placeholder="phold"})
	--tf.text = "Example"

	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function managePlace.openNewPlaceDialog(group, onSave)
	updateFunction = onSave
	print("openNewPlaceDialog() called, onsave=" .. tostring(onSave))
	local type = Randomizer:generatePlaceType()
	newPlace = Randomizer:generatePlace(type)
	managePlace.openViewPlaceDialog(newPlace, group, true, onSave)
end

return managePlace