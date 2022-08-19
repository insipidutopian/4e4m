-- manageNpc.lua
local Npc = require("npc")
local currentScene = "editCampaign"

manageNpc = {}


-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local newNpc
local npcName
local npcRace
local npcNotes
local currentNpcId

local updateFunction

local function updateNpc()
	print("Updating NPC")
	print("         NPC Name:  " .. newNpc.name)
end

function manageNpc.openViewNpcDialog(npc, group, showRerollButton, onSave)
	updateFunction = onSave
	print("openViewNpcDialog() called, NPC is " .. npc.name)
	local function onClose( self, onComplete )
		print("dialog onClose() called")
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local function closeTray( event )
		print("tray closeTray() called")
		updateFunction()
		onClose( dialog, function() dialog.frame:close() end )
	end

	local function rerollNpc( event )
		print("Rerolling NPC")
		race = Randomizer:generateNpcRace()
		newNpc = Npc:new(Randomizer:generateNpcName(race), race, Randomizer:generateNpcTraits())
		npcNameTextField:setText(newNpc.name)
		npcRaceTextField:setText(newNpc.race)
		npcNotes:setText(newNpc.notes)
	end

	local function saveNpcToCampaign( )
		print("saveNpcToCampaign() called, npc ID is " .. currentNpcId)
		newNpc = Npc:new(npcNameTextField.text, npcRaceTextField:getText(), npcNotes:getText())
		--currentCampaign = CampaignList:getCurrentCampaign()
		if (currentNpcId == 0) then
			CampaignList:addNpcToCampaign(newNpc)
		else
			newNpc.id = currentNpcId
			CampaignList:updateNpcForCampaign(newNpc)
		end
		updateFunction()

		closeTray()
	end

	local function deleteNpc(npc)
		CampaignList:removeNpcFromCampaign(npc)
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
	currentNpcId = npc.id
	local nameSquare = display.newRoundedRect(dialog, 0, y, textWidth+4, 24, 4 )
	nameSquare.fill = {0.1,0.1,0.1}
	npcNameTextField = ssk.easyIFC:presetTextInput(dialog, "title", npc.name, 0, y, 
			{listener=uiTools.textFieldListener, width = textWidth, keyboardFocus=true, selectedChars={0,99}})
	
    y=y+25; 
    npcRace = ssk.easyIFC:presetLabel( dialog, "appLabel", "Race: ", 0, y, {align="left", width=textWidth})
    local notesSquare = display.newRoundedRect(dialog, 30, y, textWidth-58, 20, 4 )
	notesSquare.fill = {0.1,0.1,0.1}
    npcRaceTextField = ssk.easyIFC:presetTextInput(dialog, "default", npc.race, 30, y, 
			{listener=uiTools.textFieldListener, width=textWidth - 70})
   
    y=y+20; 
    ssk.easyIFC:presetLabel( dialog, "appLabel", "Notes:", 0, y, {align="left", width=textWidth}) 

	y=y+10+textBoxHeight; 
	local notesSquare = display.newRoundedRect(dialog, 0, y, textWidth+4, 2*textBoxHeight+4, 4 )
	notesSquare.fill = {0.1,0.1,0.1}
	npcNotes = ssk.easyIFC:presetTextBox(dialog, "default", npc.notes, 0, y, 
			{listener=uiTools.textFieldListener, width=textWidth, height=textBoxHeight*2})

	

	y = textYOffset + textHeight / 2 - textYOffset
	if showRerollButton then
		rerollNpc(nil)
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Reroll", rerollNpc )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", saveNpcToCampaign )
	else
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Delete", function() deleteNpc(npc); end )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", saveNpcToCampaign )
	end

	y=y+40;
	ssk.easyIFC:presetPush( dialog, "appButton", 0, y, 120, 30, "Close", closeTray )

	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function manageNpc.openNewNpcDialog(group, onSave)
	updateFunction = onSave
	print("openNewNpcDialog() called, onsave=" .. tostring(onSave))
	--local race = Randomizer:generateNpcRace()
	newNpc = Npc:new("Name", "", "")
	manageNpc.openViewNpcDialog(newNpc, group, true, onSave)
end

return manageNpc