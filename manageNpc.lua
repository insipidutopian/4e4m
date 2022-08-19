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

	y=-100; --npcName = ssk.easyIFC:presetLabel( dialog, "appLabel", npc.name, 0, y, {fontSize = 18})
	currentNpcId = npc.id
	npcNameTextField = ssk.easyIFC:presetTextInput(dialog, "title", npc.name, 0, y-10, 
			{listener=uiTools.textFieldListener, updateFunction=saveNpcToCampaign})
	--y=y+20; ssk.easyIFC:presetLabel( dialog, "appLabel", "id: " .. npc.id, 0, y, {align="left", width=180})
    y=y+20; npcRace = ssk.easyIFC:presetLabel( dialog, "appLabel", "Race: ", 0, y, {align="left", width=180})
    npcRaceTextField = ssk.easyIFC:presetTextInput(dialog, "default", npc.race, 30, y, 
			{listener=uiTools.textFieldListener, updateFunction=saveNpcToCampaign, width=120})
    y=y+20; ssk.easyIFC:presetLabel( dialog, "appLabel", "Notes:", 0, y, {align="left", width=180})
	y=y+60; --npcNotes = ssk.easyIFC:presetLabel( dialog, "appLabel",  npc.notes, 10, y, {align="left", width=180, height=100})
	npcNotes = ssk.easyIFC:presetTextBox(dialog, "default", npc.notes, 10, y, 
			{listener=uiTools.textFieldListener, updateFunction=saveNpcToCampaign, width=240, height=80})

	ssk.easyIFC:presetPush( dialog, "appButton", 0, 120, 120, 30, "Close", closeTray )

	if showRerollButton then
		ssk.easyIFC:presetPush( dialog, "appButton", -50, 80, 80, 30, "Reroll", rerollNpc )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, 80, 80, 30, "Save", saveNpcToCampaign )
	else
		--ssk.easyIFC:presetPush( dialog, "appButton", 0, 80, 120, 30, "Save", saveNpcToCampaign )
		ssk.easyIFC:presetPush( dialog, "appButton", -50, 80, 80, 30, "Delete", function() deleteNpc(npc); end )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, 80, 80, 30, "Save", saveNpcToCampaign )
	end

	--tf = ssk.easyIFC:quickTextInput(dialog, "Example Input", 0, 40, 150, 40, {placeholder="phold"})
	--tf.text = "Example"

	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function manageNpc.openNewNpcDialog(group, onSave)
	updateFunction = onSave
	print("openNewNpcDialog() called, onsave=" .. tostring(onSave))
	local race = Randomizer:generateNpcRace()
	newNpc = Npc:new(Randomizer:generateNpcName(race), race, Randomizer:generateNpcTraits())
	manageNpc.openViewNpcDialog(newNpc, group, true, onSave)
end

return manageNpc