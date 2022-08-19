-- manageQuest.lua
local Quest = require("quest")
manageQuest = {}


-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local newQuest
local questName
local questDescription
local questNotes
local currentQuestId

local updateFunction

local function updateQuest()
	print("Updating Quest")
	print("         Quest Name:  " .. newQuest.name)
end

function manageQuest.openViewQuestDialog(quest, group, showRerollButton, onSave)
	updateFunction = onSave
	print("openViewQuestDialog() called, Quest is " .. quest.name)
	local function onClose( self, onComplete )
		print("dialog onClose() called")
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local function closeTray( event )
		print("tray closeTray() called")
		updateFunction()
		onClose( dialog, function() dialog.frame:close() end )
	end

	local function rerollQuest( event )
		print("Rerolling Quest")
		tType = Randomizer:generateQuestType()
		newQuest = Randomizer:generateQuest(tType)
		questNameTextField:setText(newQuest.name)
		questDescription:setText(newQuest.description)
		questNotes:setText(newQuest.details)
	end

	local function saveQuestToCampaign( )
		print("saveQuestToCampaign() called, quest ID is " .. currentQuestId)
		newQuest = Quest:new(questNameTextField.text, questDescription:getText(), questNotes:getText())
		
		if (currentQuestId == 0) then
			print("saveQuestToCampaign() saving new quest, quest (name= " .. newQuest.name .. ", notes= " .. newQuest.details .. ")")
			CampaignList:addQuestToCampaign(newQuest)
		else
			newQuest.id = currentQuestId
			CampaignList:updateQuestForCampaign(newQuest)
		end
		updateFunction()

		closeTray()
	end

	local function deleteQuest(quest)
		CampaignList:removeQuestFromCampaign(quest)
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
	currentQuestId = quest.id
	questNameTextField = ssk.easyIFC:presetTextInput(dialog, "title", quest.name, 0, y, 
			{listener=uiTools.textFieldListener, updateFunction=saveQuestToCampaign, width=textWidth})
	
    y=y+10+textBoxHeight/2; 
    questDescription = ssk.easyIFC:presetTextBox(dialog, "default", quest.description, 10, y, 
			{listener=uiTools.textFieldListener, updateFunction=saveQuestToCampaign, width=textWidth, height=textBoxHeight})

    y=y+10+textBoxHeight/2; 
    ssk.easyIFC:presetLabel( dialog, "appLabel", "Additional Notes:", 0, y, {align="left", width=180})
	
	y=y+10+textBoxHeight/2; 
	questNotes = ssk.easyIFC:presetTextBox(dialog, "default", quest.details, 10, y, 
			{listener=uiTools.textFieldListener, updateFunction=saveQuestToCampaign, width=textWidth, height=textBoxHeight})

	

	y = textYOffset + textHeight / 2 - textYOffset
	--y = y+40
	if showRerollButton then
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Reroll", rerollQuest )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", saveQuestToCampaign )
	else
		--ssk.easyIFC:presetPush( dialog, "appButton", 0, 80, 120, 30, "Save", saveQuestToCampaign )
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Delete", function() deleteQuest(quest); end )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", saveQuestToCampaign )
	end

	y=y+40; 
	ssk.easyIFC:presetPush( dialog, "appButton", 0, y, 80, 30, "Close", closeTray )

	--tf = ssk.easyIFC:quickTextInput(dialog, "Example Input", 0, 40, 150, 40, {placeholder="phold"})
	--tf.text = "Example"

	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function manageQuest.openNewQuestDialog(group, onSave)
	updateFunction = onSave
	print("openNewQuestDialog() called, onsave=" .. tostring(onSave))
	local type = Randomizer:generateQuestType()
	newQuest = Randomizer:generateQuest(type)
	manageQuest.openViewQuestDialog(newQuest, group, true, onSave)
end

return manageQuest