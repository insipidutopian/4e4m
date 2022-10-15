-- 
-- Abstract: 4e DM Assistant app, Campaign Details Screen
--  
-- Version: 2.0
-- 
--

local composer = require ( "composer" )
local widget = require ( "widget" )
CampaignList = require ("CampaignList")
local campaign = require ( "campaign" )
local CampaignClass = require ( "campaign" )
uiTools = require("uiTools")
local manageNpc = require("manageNpc")
local managePlace = require("managePlace")
local manageQuest = require("manageQuest")
local manageEvent = require("manageEvent")
require("manageCampaignSettings")

local scene = composer.newScene()

local currentScene = "editCampaign"
local shown=nil

local campaignNameTextField
local currentCampaign
local campaignSystemText
local campaignNotesTextField
local campaignQuestsText

local npcsGroup
local questGroup
local placesGroup

local newCampaignFlag = false

buttonsArr = {}

debugFlag = true

-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist

local function saveButton(button) 
	if debugFlag then print("SAVING BUTTON " .. tostring(button) .." to " .. tostring(#buttonsArr+1)); end
	buttonsArr[#buttonsArr+1] = button
end

local function clearButtons( )
	if debugFlag then print("CLEARING BUTTONS"); end
	for i=1, #buttonsArr do
		if debugFlag then print("* REMOVING BUTTON " .. tostring(i)); end
		buttonsArr[i]:removeSelf()
	end
end




local function updateCampaignName()
	print("updateCampaignName: " .. campaignNameTextField.text)
	if currentCampaign then
		currentCampaign.name = campaignNameTextField.text
		CampaignList:writeCampaignFile(currentCampaign)
	end
end


local function truncate(name, len)
	if string.len(name) > len-1 then
		return string.sub(name, 1, len-1) .. "..."
	else
		return name
	end
end

local function doUpdate()
	print("****************** DO UPDATE CALLBACK: editCampaign ******************")
	composer.gotoScene("editCampaign", {  params = { campaign = currentCampaign }})
end



--Create the scene
function scene:create( event )
	local group = self.view

	print(currentScene .. ":createScene")


	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0


	if placesGroup then placesGroup:removeSelf() end
	local placesGroup = display.newGroup()
	placesGroup.x=0
	placesGroup.y=160

	local placesSquare = display.newRect( display.viewableContentWidth/4, 90, display.viewableContentWidth/2 - 5, 180 )
	placesSquare.stroke = {1,0,0}
	placesSquare.strokeWidth = 2
	placesSquare.fill = {0,0,0}
	placesGroup:insert(placesSquare)
	group:insert(placesGroup)
	

	if npcsGroup then npcsGroup:removeSelf() end
	npcsGroup = display.newGroup()
	npcsGroup.x=display.viewableContentWidth/2
	npcsGroup.y=160

	local npcsSquare = display.newRect(display.viewableContentWidth/4, 90, display.viewableContentWidth/2 - 5, 180 )
	npcsSquare.stroke = {1,0,0}
	npcsSquare.strokeWidth = 2
	npcsSquare.fill = {0,0,0}
	npcsGroup:insert(npcsSquare)
	group:insert(npcsGroup)


	if questGroup then questGroup:removeSelf() end
	questGroup = display.newGroup()
	questGroup.x=0
	questGroup.y=345

	local questSquare = display.newRect( display.contentWidth/2, 90, display.contentWidth-10, 180 )
	questSquare.stroke = {1,0,0}
	questSquare.strokeWidth = 2
	questSquare.fill = {0,0,0}
	questGroup:insert(questSquare)
	group:insert(questGroup)

	if eventGroup then eventGroup:removeSelf() end
	eventGroup = display.newGroup()
	eventGroup.x=0
	eventGroup.y=520

	local eventSquare = display.newRect( display.contentWidth/2, 90, display.contentWidth-10, 180 )
	eventSquare.stroke = {1,0,0}
	eventSquare.strokeWidth = 2
	eventSquare.fill = {0,0,0}
	eventGroup:insert(eventSquare)
	group:insert(eventGroup)

	
	currentCampaign = CampaignList:getCurrentorNewCampaign() 
	
	


	local homeBtn = widget.newButton(
    {
        label = "Home", font=btnFont, fontSize=btnFontSize, emboss = false,
        shape = "circle", radius = 50*0.9, cornerRadius = 2, strokeWidth = 4,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
        onPress = function()  composer.gotoScene("home", { effect = "fade", time = 400}) end,
    	x = display.contentWidth-60,
      	y = display.contentHeight-60
    })

	group:insert(homeBtn)

	thingsButton = ssk.easyIFC:presetPush(group, "appButton", 50, display.contentHeight-80, 80, 30, 
											  "Things", 
											  function()  composer.gotoScene("manageThings", { effect = "fade", time = 400}) end, 
											  {labelHorizAlign="left", labelSize=14} )
	settingsButton = ssk.easyIFC:presetPush(group, "appButton", 140, display.contentHeight-80, 80, 30, 
											  "Settings", 
											  function()  composer.gotoScene("manageCampaignSettings", { effect = "fade", time = 400}) end, 
											  {labelHorizAlign="left", labelSize=14} )
	encountersButton = ssk.easyIFC:presetPush(group, "appButton", 60, display.contentHeight-40, 100, 30, 
											  "Encounters", 
											  function()  composer.gotoScene("manageEncounters", { effect = "fade", time = 400}) end, 
											  {labelHorizAlign="left", labelSize=14} )
	
end




function scene:show( event )
	local group = self.view
	print(currentScene .. ":show")

	print("event.params.campaign: " .. event.params.campaign.id)
	local i = event.params.campaign.id
	if (i==0) then
		if event.phase == "will" then
			local newCampaign = CampaignClass.new(event.params.campaign.name)
			newCampaign.description = event.params.campaign.description

			print("New campaign ID: " .. newCampaign.id)
			CampaignList:addCampaign(newCampaign)
		
			i = newCampaign.id
			print ("NEW CAMPAIGN CALLED, ID IS " .. i)
			newCampaignFlag = true
		else
			i = CampaignList:getCurrentCampaignIndex()
			newCampaignFlag = false
		end

	end
	CampaignList:setCurrentCampaignIndex(i)
	print ("Current campaign number=" .. i)
	currentCampaign = CampaignList:getCurrentorNewCampaign()
	
	

	if event.phase == "will" then
		print(currentScene .. ":SHOW WILL PHASE")

		local function updateCampaignNotes()
			print("updateCampaignNotes: " .. campaignNotesTextField.text)
			if currentCampaign then
				currentCampaign.description = campaignNotesTextField.text
				CampaignList:writeCampaignFile(currentCampaign)
			end
		end

		if not npcsGroup then 
			npcsGroup = display.newGroup(); 
			npcsGroup.x=display.viewableContentWidth/2
			npcsGroup.y=160
		end

		
		if not placesGroup then 
			placesGroup = display.newGroup(); 
			placesGroup.x=0
			placesGroup.y=160
		end

		if not overlayGroup then 
			overlayGroup = display.newGroup(); 
			overlayGroup.x=display.viewableContentWidth/2
			overlayGroup.y=display.viewableContentHeight/2
		end

		npcsButton = ssk.easyIFC:presetPush(npcsGroup, "linkButton", display.contentWidth/4 - 13, 15, 140, 30, 
											"NPCs: " .. #currentCampaign.npcList, 
											function()  composer.gotoScene("manageNpcs", { effect = "fade", time = 400}) end, 
											{labelHorizAlign="left", labelSize=14} )
		saveButton(npcsButton)

		for i=1, #currentCampaign.npcList do
			print("NPC found: " .. currentCampaign.npcList[i].name)
			if (i < 9) then
				if debugFlag then print("Creating NPC button for " .. currentCampaign.npcList[i].name); end
				npcButton = ssk.easyIFC:presetPush( npcsGroup, "linkButton", display.contentWidth/4, 20+18*i, 140, 30, "* " .. currentCampaign.npcList[i].name, 
					function() manageNpc.openViewNpcDialog(currentCampaign.npcList[i], overlayGroup, false, doUpdate); end, 
					{labelHorizAlign="left", labelSize=12} )
				saveButton(npcButton)
			end
		end
		
		placesButton = ssk.easyIFC:presetPush(placesGroup, "linkButton", display.contentWidth/4 - 13, 15, 140, 30, 
											  "Places: " .. #currentCampaign.placeList, 
											  function()  composer.gotoScene("managePlaces", { effect = "fade", time = 400}) end, 
											  {labelHorizAlign="left", labelSize=14} )
		saveButton(placesButton)
		for i=1, #currentCampaign.placeList do
			print("Place found: " .. currentCampaign.placeList[i].name)
			if (i < 9) then
				b = ssk.easyIFC:presetPush( placesGroup, "linkButton", display.contentWidth/4 - 13, 20+18*i, 140, 30, "* " .. currentCampaign.placeList[i].name, 
					function() managePlace.openViewPlaceDialog(currentCampaign.placeList[i], overlayGroup, false, doUpdate); end, 
					{labelHorizAlign="left", labelSize=11} )
				saveButton(b)
			end
		end
		
		questsButton = ssk.easyIFC:presetPush(questGroup, "linkButton", display.contentWidth/4 - 13, 15, 140, 30, 
											  "Quests: " .. #currentCampaign.questList, 
											  function()  composer.gotoScene("manageQuests", { effect = "fade", time = 400}) end, 
											  {labelHorizAlign="left", labelSize=14} )
		saveButton(questsButton)
		for i=1, #currentCampaign.questList do
			print("Quest found: " .. currentCampaign.questList[i].name)
			if (i < 9) then
				b = ssk.easyIFC:presetPush( questGroup, "linkButton", display.contentWidth/4 - 13, 20+18*i, 140, 30, "* " .. currentCampaign.questList[i].name, 
					function() manageQuest.openViewQuestDialog(currentCampaign.questList[i], overlayGroup, false, doUpdate); end, 
					{labelHorizAlign="left", labelSize=11} )
				saveButton(b)
			end
		end

		eventButton = ssk.easyIFC:presetPush(eventGroup, "linkButton", display.contentWidth/4 - 13, 15, 140, 30, 
											  "Events: " .. #currentCampaign.eventList, 
											  function()  composer.gotoScene("manageEvents", { effect = "fade", time = 400}) end, 
											  {labelHorizAlign="left", labelSize=14} )
		saveButton(eventButton)
		for i=1, #currentCampaign.eventList do
			print("Quest found: " .. currentCampaign.eventList[i].title)
			if (i < 9) then
				b = ssk.easyIFC:presetPush( eventGroup, "linkButton", display.contentWidth/4 - 13, 20+18*i, 140, 30, "* " .. currentCampaign.eventList[i].title, 
					function() manageEvent.openViewEventDialog(currentCampaign.eventList[i], overlayGroup, false, doUpdate); end, 
					{labelHorizAlign="left", labelSize=11} )
				saveButton(b)
			end
		end

		campaignNameTextField = ssk.easyIFC:presetTextInput(group, "title", currentCampaign.name, 100, 70, 
			{listener=uiTools.textFieldListener, updateFunction=updateCampaignName, keyboardFocus=newCampaignFlag, selectedChars={0,99}})

		campaignNotesTextField = ssk.easyIFC:presetTextBox(group, "default", currentCampaign.description, display.contentCenterX, 120, 
			{listener=uiTools.textFieldListener, updateFunction=updateCampaignNotes, selectedChars={0,99}, height=75, width=display.contentWidth-20})
		

	else
		print(currentScene .. ":SHOW DID PHASE")
	end

end


function scene:destroy( event )
	print(currentScene .. ":destroy started")
	local group = self.view

	print(currentScene .. ":exitScene")
end	

function scene:hide( event )
	print(currentScene .. ":hide started")
	local group = self.view

	if event.phase == "will" then


		if campaignNameTextField then
			if debugFlag then print("**** hide.removing campaignNameTextField"); end
			campaignNameTextField:removeSelf()
			campaignNameTextField = nil
			--
		end

		if campaignNotesTextField then
			campaignNotesTextField:removeSelf()
			campaignNotesTextField = nil
			--
		end
		clearButtons()
	elseif event.phase == "did" then
		--composer.removeScene( currentScene )
	end
end	


--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene)
scene:addEventListener( "destroy", scene )


return scene
