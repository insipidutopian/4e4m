-- manageThing.lua
local Thing = require("thing")
manageThing = {}


-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local newThing
local thingName
local thingNotes
local currentThingId

local updateFunction

local function updateThing()
	print("Updating Thing")
	print("         Thing Name:  " .. newThing.name)
end

function manageThing.openViewThingDialog(thing, group, showRerollButton, onSave)
	updateFunction = onSave
	print("openViewThingDialog() called, Thing is " .. thing.name)
	local function onClose( self, onComplete )
		print("dialog onClose() called")
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local function closeTray( event )
		print("tray closeTray() called")
		updateFunction()
		onClose( dialog, function() dialog.frame:close() end )
	end

	local function rerollThing( event )
		print("Rerolling Thing")
		tType = Randomizer:generateThingType()
		newThing = Randomizer:generateThing(tType)
		thingNameTextField:setText(newThing.name)
		--thingRaceTextField:setText(newThing.race)
		thingNotes:setText(newThing.description)
	end

	local function saveThingToCampaign( )
		print("saveThingToCampaign() called, thing ID is " .. currentThingId)
		newThing = Thing.new(thingNameTextField.text, "", thingNotes.text)
		--currentCampaign = CampaignList:getCurrentCampaign()
		if (currentThingId == 0) then
			CampaignList:addThingToCampaign(newThing)
		else
			newThing.id = currentThingId
			CampaignList:updateThingForCampaign(newThing)
		end
		updateFunction()

		closeTray()
	end

	local function deleteThing(thing)
		CampaignList:removeThingFromCampaign(thing)
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

	y=-100; --thingName = ssk.easyIFC:presetLabel( dialog, "appLabel", thing.name, 0, y, {fontSize = 18})
	currentThingId = thing.id
	thingNameTextField = ssk.easyIFC:presetTextInput(dialog, "title", thing.name, 0, y-10, 
			{listener=uiTools.textFieldListener, updateFunction=saveThingToCampaign})
	--y=y+20; ssk.easyIFC:presetLabel( dialog, "appLabel", "id: " .. thing.id, 0, y, {align="left", width=180})
    --y=y+20; thingRace = ssk.easyIFC:presetLabel( dialog, "appLabel", "Race: ", 0, y, {align="left", width=180})
    --thingRaceTextField = ssk.easyIFC:presetTextInput(dialog, "default", thing.race, 30, y, 
	--		{listener=uiTools.textFieldListener, updateFunction=saveThingToCampaign, width=120})
    y=y+20; ssk.easyIFC:presetLabel( dialog, "appLabel", "Notes:", 0, y, {align="left", width=180})
	y=y+60; --thingNotes = ssk.easyIFC:presetLabel( dialog, "appLabel",  thing.description, 10, y, {align="left", width=180, height=100})
	thingNotes = ssk.easyIFC:presetTextBox(dialog, "default", thing.description, 10, y, 
			{listener=uiTools.textFieldListener, updateFunction=saveThingToCampaign, width=240, height=80})

	ssk.easyIFC:presetPush( dialog, "appButton", 0, 120, 120, 30, "Close", closeTray )

	if showRerollButton then
		ssk.easyIFC:presetPush( dialog, "appButton", -50, 80, 80, 30, "Reroll", rerollThing )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, 80, 80, 30, "Save", saveThingToCampaign )
	else
		--ssk.easyIFC:presetPush( dialog, "appButton", 0, 80, 120, 30, "Save", saveThingToCampaign )
		ssk.easyIFC:presetPush( dialog, "appButton", -50, 80, 80, 30, "Delete", function() deleteThing(thing); end )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, 80, 80, 30, "Save", saveThingToCampaign )
	end

	--tf = ssk.easyIFC:quickTextInput(dialog, "Example Input", 0, 40, 150, 40, {placeholder="phold"})
	--tf.text = "Example"

	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function manageThing.openNewThingDialog(group, onSave)
	updateFunction = onSave
	print("openNewThingDialog() called, onsave=" .. tostring(onSave))
	local type = Randomizer:generateThingType()
	newThing = Randomizer:generateThing(type)
	manageThing.openViewThingDialog(newThing, group, true, onSave)
end

return manageThing