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

local scene = composer.newScene()

local currentScene = "editCampaign"
local shown=nil

local campaignNameText
local currentCampaign
local campaignSystemText
local campaignNotesText
local campaignEncountersText
local campaignNpcsText
local campaignQuestsText

local npcsGroup
local questGroup


local function textListener( event )

    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
        print( "begin editing....")
 
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        print( "ended editing: " ..  event.target.text )
 
    elseif ( event.phase == "editing" ) then
        print( "new: " .. event.newCharacters )
        print( "old: " .. event.oldText )
        print( "sp: " .. event.startPosition )
        print( "et:" .. event.text )
    end
end
 
function toggleEditable( textBox )
	if textBox then
		isEditable = textBox.isEditable
		print("ToggleEditable() called, textbox state is: " .. tostring( isEditable ))
		if isEditable then
			print("tbie: " .. tostring( textBox.isEditable ))
			textBox.isEditable = false
			print("tbie: " .. tostring( textBox.isEditable ))
		else
			textBox.isEditable = true
		end
	end
	
	if textBox.isEditable then
		print( "textbox now enabled" )
		native.setKeyboardFocus( textBox )
	else
		print( "textbox now disabled" )
		if currentCampaign then
			currentCampaign.description = textBox.text
			CampaignList:writeCampaignFile(currentCampaign)
			native.setKeyboardFocus( nil )
		end

	end

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
	--encountersSquare:setFillColor( 0, 1, 0 )
	encountersSquare.stroke = {1,0,0}
	encountersSquare.strokeWidth = 2
	encountersSquare.fill = {0,0,0}
	encountersGroup:insert(encountersSquare)
	group:insert(encountersGroup)
	
	npcsGroup = display.newGroup()
	npcsGroup.x=display.viewableContentWidth/2
	npcsGroup.y=160

	local npcsSquare = display.newRect( 80, 70, 160, 140 )
	--npcsSquare:setFillColor( 0, 1, 0 )
	npcsSquare.stroke = {1,0,0}
	npcsSquare.strokeWidth = 2
	npcsSquare.fill = {0,0,0}
	npcsGroup:insert(npcsSquare)
	group:insert(npcsGroup)

	questGroup = display.newGroup()
	questGroup.x=0
	questGroup.y=350

	

	local questSquare = display.newRect( 100, 100, 200, 200 )
	--questSquare:setFillColor( 0, 1, 0 )
	questSquare.stroke = {1,0,0}
	questSquare.strokeWidth = 2
	questSquare.fill = {0,0,0}
	questGroup:insert(questSquare)
	
	group:insert(questGroup)

	if campaignNameText then campaignNameText:removeSelf() end;

	if not currentCampaign then currentCampaign = campaign.new("..."); end
	campaignNameText = display.newText({
	    text = "".. currentCampaign.name,     
	    x = 170,
	    y = 70, anchorY = 0,
	    width = 320,
	    font = mainFont,   
	    fontSize = mainFontSize+6,
		height=40,	    
	    align = "center" 
	})
	campaignNameText:setFillColor( 0.6, 0, 0 )
	-- print("Inserting name")
	group:insert(campaignNameText)

	
	-- Create text box for the campaign description
	campaignNotesText = createTextBox( 172, 120, 300, 75, textListener )
	campaignNotesText.text = currentCampaign.description
	campaignNotesText.isEditable = true
	group:insert(campaignNotesText)

	cntEditBtn = widget.newButton(
	{   defaultFile = "images/big-gear.png", overFile="images/big-gear2.png",
        --onPress = options.onPress,
        onPress = function() timer.performWithDelay(1000, toggleEditable(campaignNotesText)); end,
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
	--[[campaignQuestsText = display.newText({
	    text = "Quests: ".. #currentCampaign.questList,     
	    x = 170,
	    y =  display.contentHeight-250, anchorY = 0,
	    width = 320,
	    height = 40,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left" 
	})
	--]]
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
	--group:insert(campaignQuestsText)

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

function createAndInsertButton(group, options)
								  
							--[[  { buttonName=currentCampaign.npcList[i].name, 
									x=80, y=10 + 20*i,
									width=150, align="right",
									onPress=function() print("pressed button") end; 
								  })--]]
	print("create and Insert Button called.")
	--print("createAndInsertButton() group is " .. group)
	print("createAndInsertButton() buttonName is " .. options.buttonName)
	print("createAndInsertButton() x=" .. options.x .. " y=" .. options.y)

	newButton = widget.newButton(
	{   label = options.buttonName,
        --onPress = options.onPress,
        onPress = function() composer.showOverlay(options.onPressScene, 
        			{ isModal=true, 
        			  params = options.onPressParams }); end,
        emboss = false,
        font=btnFont, fontSize=btnFontSize*0.7,
        left = options.x , top = options.y,
        width = options.width, height=15,
        labelAlign=options.align,
        labelColor = { default={.6,0,0,1}, over={0.4,0.0,0,1} },
	})
	group:insert(newButton)


end



function createTextBox(x, y, height, width, listener) 
	print("createTextBox() called")
	tb = native.newTextBox( x, y, height, width )
	tb.hasBackground = false
	tb.isEditable = true
	tb.font = native.newFont(mainFont, mainFontSize-2)
	tb:setTextColor(.6,0,0,1)
	tb:addEventListener( "userInput", listener )
	return tb
end

function scene:show( event )
	local group = self.view
	print(currentScene .. ":show")

	print("event.params.campaign: " .. event.params.campaign.id)
	local i = event.params.campaign.id --CampaignList:getCurrentCampaignIndex()
	if (i==-1) then
		i=1
		print ("Setting current campaign from -1 to 1")
	end
	CampaignList:setCurrentCampaignIndex(i)
	print ("Current campaign number=" .. i)
	currentCampaign = CampaignList:getCurrentCampaign()

	local i = event.params.campaign.id --CampaignList:getCurrentCampaignIndex()
	if (i==-1) then
		i=1
		print ("Setting current campaign from -1 to 1")
	end
	CampaignList:setCurrentCampaignIndex(i)
	print ("Current campaign number=" .. i)
	currentCampaign = CampaignList:getCurrentCampaign()
	campaignNameText.text = currentCampaign.name
	
	
	campaignEncountersText.text = "Encounters: " .. #currentCampaign.encounterList
	campaignNpcsText.text = "NPCS: " .. #currentCampaign.npcList
	for i=1, #currentCampaign.npcList do
		print("NPC found: " .. currentCampaign.npcList[i].name)
		if (i < 6) then
			createAndInsertButton(npcsGroup, 
								  { buttonName="* " .. currentCampaign.npcList[i].name, 
									x=10, y=20*i,
									width=150, align="left",
									onPressScene = "editNpc",
									onPressParams = { npc = currentCampaign.npcList[i] }
								  })
		else
			npcsGroup:insert(display.newText({
			    text = "more...",
			    x = 80,
			    y = 130,
			    width = 150,
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
			createAndInsertButton(questGroup, 
								  { buttonName="* " .. currentCampaign.questList[i].name, 
									x=10, y=20*i,
									width=150, align="left",
									onPressScene = "editQuest",
									onPressParams = { quest = currentCampaign.questList[i] }
								  })
		else
			questGroup:insert(display.newText({
			    text = "more...",
			    x = 100,
			    y = 130,
			    width = 190,
			    font = mainFont,   
			    fontSize = mainFontSize-2,
			    align = "right"
			}))
		end
	end

	if event.phase == "will" then
		print(currentScene .. ":SHOW WILL PHASE")
		--group:insert(campaignNotesText)
		print(campaignNotesText)
		if not campaignNotesText then
			campaignNotesText = createTextBox(172, 120, 300, 75, textListener)
			campaignNotesText.isEditable = true
			
			group:insert(campaignNotesText)
			--campaignNotesText.isEditable = false
		end
		campaignNotesText.text = currentCampaign.description
	else
		print(currentScene .. ":SHOW DID PHASE")
		print("--> event.params.campaign: " .. event.params.campaign.id)
		local i = event.params.campaign.id --CampaignList:getCurrentCampaignIndex()
	end
end


function scene:destroy( event )
	print(currentScene .. ":destroy started")
	local group = self.view

	--if campaignNotesText then
		--print("*** destroy.removing campaignNotesText")
		--campaignNotesText:removeEventListener( "userInput", textListener )
		--campaignNotesText:removeSelf()
		--campaignNotesText = nil
	--end

	print(currentScene .. ":exitScene")
end	

function scene:hide( event )
	print(currentScene .. ":hide started")
	local group = self.view

	if event.phase == "will" then
		if campaignNotesText then
			print("**** hide.removing campaignNotesText")
			--campaignNotesText:removeEventListener( "userInput", textListener )
			--campaignNotesText:removeSelf()
			print("CNT: " .. type(campaignNotesText))
			campaignNotesText:removeSelf()
			campaignNotesText = nil
			print("CNT: " .. type(campaignNotesText))
			--
		end
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
