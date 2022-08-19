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
	currentThingId = thing.id
	local titleSquare = display.newRoundedRect(dialog, 0, y-10, textWidth+4, 24, 4 )
	titleSquare.fill = {0.1,0.1,0.1}
	thingNameTextField = ssk.easyIFC:presetTextInput(dialog, "title", thing.name, 0, y-10, 
			{listener=uiTools.textFieldListener, width=textWidth, keyboardFocus=true, selectedChars={0,99}})
	
    y=y+20; 
    ssk.easyIFC:presetLabel( dialog, "appLabel", "Notes:", 0, y, {align="left", width=textWidth})
	
	y=y+10+textBoxHeight/2; 
	local notesSquare = display.newRoundedRect(dialog, 0, y, textWidth+4, textBoxHeight+4, 4 )
	notesSquare.fill = {0.1,0.1,0.1}
	thingNotes = ssk.easyIFC:presetTextBox(dialog, "default", thing.description, 10, y, 
			{listener=uiTools.textFieldListener, width=textWidth, height=textBoxHeight})

	
	y = textYOffset + textHeight / 2 - textYOffset
	if showRerollButton then
		rerollThing(nil)
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Reroll", rerollThing )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", saveThingToCampaign )
	else
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Delete", function() deleteThing(thing); end )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", saveThingToCampaign )
	end

	y = y + 40;
	ssk.easyIFC:presetPush( dialog, "appButton", 0, y, 120, 30, "Close", closeTray )


	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function manageThing.openNewThingDialog(group, onSave)
	updateFunction = onSave
	print("openNewThingDialog() called, onsave=" .. tostring(onSave))
	--local type = Randomizer:generateThingType()
	newThing = Thing.new("Thing", "") --Randomizer:generateThing(type)
	manageThing.openViewThingDialog(newThing, group, true, onSave)
end

return manageThing