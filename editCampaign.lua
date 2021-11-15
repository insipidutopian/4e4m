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

local scene = composer.newScene()

local currentScene = "editCampaign"
local shown=nil

local campaignNameTextField
local currentCampaign
local campaignSystemText
local campaignNotesText
local campaignEncountersText
local campaignNpcsText
local campaignQuestsText

local npcsGroup
local questGroup
local campaignNotesLock = false

buttonsArr = {}


local function saveButton(button) 
	if debugFlag then print("SAVING BUTTON " .. tostring(button) .." to " .. tostring(#buttonsArr+1)); end
	buttonsArr[#buttonsArr+1] = button
end

local function clearButtons( )
	if debugFlag then print("CLEARING BUTTONS"); end
	for i=1, #buttonsArr do
		if debugFlag then print("* REMOVING BUTTON"); end
		buttonsArr[i]:removeSelf()
	end
end


local function updateCampaignNotes( updatedVar)
	print("updateCampaignNotes: " .. updatedVar)
	if currentCampaign then
		currentCampaign.description = updatedVar
		CampaignList:writeCampaignFile(currentCampaign)
	end
end

local function updateCampaignName( )
	print("updateCampaignName: " .. campaignNameTextField.text)
	if currentCampaign then
		currentCampaign.name = campaignNameTextField.text
		CampaignList:writeCampaignFile(currentCampaign)
	end
end

local function toggleCampaignNotesLock( group, val )
	campaignNotesLock = not val
	if debugFlag then print("toggle was: " .. tostring(val) .. ", now: " .. tostring(campaignNotesLock)); end
	local imageName = "images/padlock.png"
	local overImageName = "images/padlock-open.png"
	if campaignNotesLock then
		imageName = "images/padlock-open.png"
		overImageName = "images/padlock.png"
	end
	
	group:remove(cntEditBtn)
	
	cntEditBtn = widget.newButton(
	{   defaultFile = imageName,  overFile = overImageName,
        onPress = function() uiTools.toggleTBEditable(campaignNotesText, updateCampaignNotes, toggleCampaignNotesLock(group, campaignNotesLock)); end,
        emboss = false,
        left = 0 , top = 110,
        width = 20, height=20
	})
	group:insert(cntEditBtn)
	return campaignNotesLock
end

--Create the scene
function scene:create( event )
	local group = self.view

	print(currentScene .. ":createScene")


	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0

	local encountersGroup = display.newGroup()
	encountersGroup.x=0
	encountersGroup.y=160

	local encountersSquare = display.newRect( 80, 70, 160, 140 )
	encountersSquare.stroke = {1,0,0}
	encountersSquare.strokeWidth = 2
	encountersSquare.fill = {0,0,0}
	encountersGroup:insert(encountersSquare)
	group:insert(encountersGroup)
	
	if npcsGroup then npcsGroup:removeSelf() end
	npcsGroup = display.newGroup()
	npcsGroup.x=display.viewableContentWidth/2
	npcsGroup.y=160

	local npcsSquare = display.newRect( 80, 70, 160, 140 )
	npcsSquare.stroke = {1,0,0}
	npcsSquare.strokeWidth = 2
	npcsSquare.fill = {0,0,0}
	npcsGroup:insert(npcsSquare)
	group:insert(npcsGroup)

	if questGroup then questGroup:removeSelf() end
	questGroup = display.newGroup()
	questGroup.x=0
	questGroup.y=350

	

	local questSquare = display.newRect( 100, 100, 200, 200 )
	questSquare.stroke = {1,0,0}
	questSquare.strokeWidth = 2
	questSquare.fill = {0,0,0}
	questGroup:insert(questSquare)
	
	group:insert(questGroup)


	if campaignNameTextField then campaignNameTextField:removeSelf() end
	if not currentCampaign then currentCampaign = CampaignClass.new("..."); end
	campaignNameTextField = uiTools.createInputTextField( 170, 70, 320, 40, uiTools.textFieldListener, updateCampaignName)
	campaignNameTextField.font = native.newFont(mainFont, mainFontSize+2)
	campaignNameTextField.text = currentCampaign.name
	campaignNameTextField.hasBackground = false
	campaignNameTextField.isEditable = true
	group:insert(campaignNameTextField)

	
	-- Create text box for the campaign description
	campaignNotesText = uiTools.createInputTextBox( 172, 120, 300, 75, uiTools.textBoxListener )
	campaignNotesText.text = currentCampaign.description
	campaignNotesText.hasBackground = false
	campaignNotesText.isEditable = true
	group:insert(campaignNotesText)

	uiTools.toggleTFEditable(campaignNameTextField, updateCampaignNotes, false)
	
	uiTools.toggleTBEditable(campaignNotesText, updateCampaignNotes, false)
	
	cntEditBtn = widget.newButton(
	{   defaultFile = "images/padlock.png", overFile="images/padlock-open.png",
        onPress = function() uiTools.toggleTBEditable(campaignNotesText, updateCampaignNotes, toggleCampaignNotesLock(group,campaignNotesLock)); end,
        emboss = false,
        left = 0 , top = 110,
        width = 20, height=20
	})
	group:insert(cntEditBtn)
	

	if campaignEncountersText then campaignEncountersText:removeSelf() end;
	campaignEncountersText = display.newText({
	    text = "Encounters: ".. #currentCampaign.encounterList,     
	    x = 80,
	    y = 10,
	    width = 150,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left" 
	})
	campaignEncountersText:setFillColor( 0.6, 0, 0 )
	encountersGroup:insert(campaignEncountersText)

	if campaignNpcsText then campaignNpcsText:removeSelf() end;
	campaignNpcsText = display.newText({
	    text = "NPCs: ".. #currentCampaign.npcList,     
	    x = 80,
	    y = 10,
	    width = 150,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left"
	})
	campaignNpcsText:setFillColor( 0.6, 0, 0 )
	npcsGroup:insert(campaignNpcsText)


	if campaignQuestsText then campaignQuestsText:removeSelf() end;
	campaignQuestsText = display.newText({
	    text = "Quests: ".. #currentCampaign.questList,     
	    x = 100,
	    y = 10,
	    width = 190,
	    --height = 40,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left" 
	})
	questGroup:insert(campaignQuestsText)
	campaignQuestsText:setFillColor( 0.6, 0, 0 )

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

 	
end




function scene:show( event )
	local group = self.view
	print(currentScene .. ":show")

	print("event.params.campaign: " .. event.params.campaign.id)
	local i = event.params.campaign.id --CampaignList:getCurrentCampaignIndex()
	if (i==0) then
		if event.phase == "will" then
			--i=CampaignList.getNewCampaignId()
			local newCampaign = CampaignClass.new(event.params.campaign.name)
			newCampaign.description = event.params.campaign.description

			print("New campaign ID: " .. newCampaign.id)
			CampaignList:addCampaign(newCampaign)
		
			i = newCampaign.id
			print ("NEW CAMPAIGN CALLED, ID IS " .. i)
		else
			i = CampaignList:getCurrentCampaignIndex()
		end

	end
	CampaignList:setCurrentCampaignIndex(i)
	print ("Current campaign number=" .. i)
	currentCampaign = CampaignList:getCurrentCampaign()

	if (currentCampaign == nil) then
		print("**********CURRENT CAMPAIGN NIL, THAT IS BAD***********")
	end
	--campaignNameText.text = currentCampaign.name
	
	
	campaignEncountersText.text = "Encounters: " .. #currentCampaign.encounterList


	--if not npcsGroup then npcsGroup = display.newGroup(); end
	campaignNpcsText.text = "NPCS: " .. #currentCampaign.npcList
	for i=1, #currentCampaign.npcList do
		print("NPC found: " .. currentCampaign.npcList[i].name)
		if (i < 6) then
			if debugFlag then print("Creating NPC button for " .. currentCampaign.npcList[i].name); end
			b = uiTools.createAndInsertButton(npcsGroup, 
					{   buttonName="* " .. currentCampaign.npcList[i].name, 
					    x=10, y=20*i,
						width=140, align="left",
						onPressScene = "editNpc",
						onPressParams = { npc = currentCampaign.npcList[i] }
				  	})
			saveButton(b)
		else
			npcsGroup:insert(display.newText({
			    text = "more...",
			    x = 80,
			    y = 130,
			    width = 140,
			    font = mainFont,
			    fontSize = mainFontSize-2,
			    align = "right"
			}))
		end
	end
	campaignQuestsText.text = "Quests: " .. #currentCampaign.questList



	for i=1, #currentCampaign.questList do
		print("Quest found: " .. currentCampaign.questList[i].name)
		if (i < 6) then
			b = uiTools.createAndInsertButton(questGroup, 
					{   buttonName="* " .. currentCampaign.questList[i].name, 
						x=10, y=20*i,
						width=180, align="left",
						onPressScene = "editQuest",
						onPressParams = { quest = currentCampaign.questList[i] }
					})
			saveButton(b)
		else
			questGroup:insert(display.newText({
			    text = "more...",
			    x = 100,
			    y = 130,
			    width = 180,
			    font = mainFont,   
			    fontSize = mainFontSize-2,
			    align = "right"
			}))
		end
	end

	if event.phase == "will" then
		print(currentScene .. ":SHOW WILL PHASE")
		
		if not campaignNotesText then
			campaignNotesText = uiTools.createInputTextBox(172, 120, 300, 75, uiTools.textBoxListener)
			campaignNotesText.isEditable = true
			campaignNotesText.hasBackground = false
			group:insert(campaignNotesText)
		end
		if not campaignNameTextField then
			campaignNameTextField = uiTools.createInputTextField(170, 70, 320, 40, uiTools.textFieldListener, updateCampaignName)
			campaignNameTextField.isEditable = true
			campaignNameTextField.hasBackground = false
			group:insert(campaignNotesText)
		end
		campaignNotesText.text = currentCampaign.description
		campaignNameTextField.text = currentCampaign.name
	else
		print(currentScene .. ":SHOW DID PHASE")
		print("--> event.params.campaign.id : " .. event.params.campaign.id)
		local i = event.params.campaign.id --CampaignList:getCurrentCampaignIndex()
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
		if campaignNotesText then
			if debugFlag then print("**** hide.removing campaignNotesText"); end
			campaignNotesText:removeSelf()
			campaignNotesText = nil
			--
		end
		if campaignNameTextField then
			if debugFlag then print("**** hide.removing campaignNameTextField"); end
			campaignNameTextField:removeSelf()
			campaignNameTextField = nil
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
