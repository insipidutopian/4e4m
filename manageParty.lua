-- manageParty.lua
local Campaign = require("campaign")
local composer = require ( "composer" )
local widget = require("widget") -- for TableView
local PartyMember = require("partyMember")

manageParty = {}


-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local newCampaign
local campaignName
local campaignSystem
local campaignCalendar
local campaignDate
local currentCampaignId
local currentPmId
local dialog
local updateFunction

local function updateCampaign()
	print("Updating Campaign")
	print("         Campaign Name:  " .. newCampaign.name)
end

function manageParty.openViewPartyMemberDialog(partyMember, group, showDeleteButton, onSave)
	updateFunction = onSave
	print("openPartyMemberDialog() called, PartyMember is " .. partyMember.name)
	local function onClose( self, onComplete )
		print("dialog onClose() called")
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local function closeTray( event )
		print("tray closeTray() called")
		if updateFunction then
			updateFunction()
		else
			print("NO UPDATE FUNCTION, IGNORING")
		end
		onClose( dialog, function() dialog.frame:close() end )
	end

	

	local function savePartyMemberToCampaign( )
		print("savePartyMemberToCampaign() called, PM ID is " .. currentPmId)
		newPartyMember = PartyMember.new(partyMemberNameTextField.text, "", partyMemberClassTextField.text, partyMemberRaceTextField.text, partyMemberLevelTextField.text)
		--currentCampaign = CampaignList:getCurrentCampaign()
		if (currentPmId == 0) then
			CampaignList:addPartyMemberToCampaign(newPartyMember)
		else
			newPartyMember.id = currentPmId
			CampaignList:updatePartyMemberForCampaign(newPartyMember)
		end
		updateFunction()

		closeTray()
		--manageCampaign.openNewCampaignDialog(group, onSave, fromRight)
		--TODO: gotoScene manageCampaignSettings
	end

	local function deletePartyMember(thing)
		CampaignList:removePartyMemberFromCampaign(thing)
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
	local x = textWidth/4

	if largeFormat then
		textYOffset = 50
		textBoxHeight = 130
		x = textWidth/4
	end

	y = textYOffset + textHeight / -2
	currentPmId = partyMember.id
	ssk.easyIFC:presetLabel( dialog, "appLabel", "Name:", -textWidth/4, y, {align="left", width=textWidth/2})
	local titleSquare = display.newRoundedRect(dialog, textWidth/8, y, 3*textWidth/4 + 4, 24, 4 )
	titleSquare.fill = {0.1,0.1,0.1}
	partyMemberNameTextField = ssk.easyIFC:presetTextInput(dialog, "title", partyMember.name, textWidth/8, y, 
			{listener=uiTools.textFieldListener, width=3*textWidth/4, keyboardFocus=true, selectedChars={0,99}})
	
   	y = y + 25
   	ssk.easyIFC:presetLabel( dialog, "appLabel", "Class:", 0, y, {align="left", width=textWidth/2})
	local classSquare = display.newRoundedRect(dialog, x, y, -6+textWidth/2, 24, 4 )
	classSquare.fill = {0.1,0.1,0.1}
	partyMemberClassTextField = ssk.easyIFC:presetTextInput(dialog, "title", partyMember.class, x, y, 
			{listener=uiTools.textFieldListener, width=-10+textWidth/2, returnKey='next'})
	
	y = y + 25
	ssk.easyIFC:presetLabel( dialog, "appLabel", "Race:", 0, y, {align="left", width=textWidth/2})
	local raceSquare = display.newRoundedRect(dialog, x, y, -6+textWidth/2, 24, 4 )
	raceSquare.fill = {0.1,0.1,0.1}
	partyMemberRaceTextField = ssk.easyIFC:presetTextInput(dialog, "default", partyMember.race, x, y, 
				{listener=uiTools.textFieldListener, width=-10+textWidth/2})

	y = y + 25
	ssk.easyIFC:presetLabel( dialog, "appLabel", "Level:", 0, y, {align="left", width=textWidth/2})
	local levelSquare = display.newRoundedRect(dialog, x, y, -6+textWidth/2, 24, 4 )
	levelSquare.fill = {0.1,0.1,0.1}
	partyMemberLevelTextField = ssk.easyIFC:presetTextInput(dialog, "default", partyMember.level, x, y, 
				{listener=uiTools.textFieldListener, width=-10+textWidth/2})
	
	y = textYOffset + textHeight / 2 - textYOffset
	if showDeleteButton then
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Delete", function() deletePartyMember(partyMember); end )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", savePartyMemberToCampaign )
		y = y + 40;
		ssk.easyIFC:presetPush( dialog, "appButton", 0, y, 120, 30, "Close", closeTray )
	else
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Close", closeTray )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", savePartyMemberToCampaign )
	end

	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, soy = fullh, sox = 0 } )


	
end

function manageParty.openExistingPartyMemberDialog(group, existingPartyMember, onSave)
	updateFunction = onSave
	print("openExistingPartyMemberDialog() called, onsave=" .. tostring(onSave))
	manageParty.openViewPartyMemberDialog(existingPartyMember, group, true, onSave)
end

function manageParty.openNewPartyMemberDialog(group, onSave)
	updateFunction = onSave
	print("openNewPartyMemberDialog() called, onsave=" .. tostring(onSave))
	blankPartyMember = PartyMember.new("","","","")
	manageParty.openViewPartyMemberDialog(blankPartyMember, group, false, onSave)
end

return manageParty