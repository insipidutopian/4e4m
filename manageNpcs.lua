-- 
-- Abstract: 4e DM Assistant app, NPC Details Screen
--  
-- Version: 1.0
-- 
--

local composer = require ( "composer" )
local widget = require ( "widget" )
CampaignList = require ("CampaignList")
local campaign = require ( "campaign" )
--local CampaignClass = require ( "campaign" )

local scene = composer.newScene()

local currentScene = "manageNpcs"

local currentCampaign
local npcsTitleText
local npcsGroup
local navGroup

local npcsX 
local npcsY
local npcsXStart 
local npcsYStart 
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist

manageNpc = require("manageNpc")

buttonsArr = {}

local dialog


--Create the scene
function scene:create( event )
	local group = self.view

	print(currentScene .. ":createScene")


	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0

	currentCampaign = CampaignList:getCurrentorNewCampaign()

	ssk.easyIFC:presetLabel( group, "appLabel", "NPCs: ".. currentCampaign.name, 160 , yStart + 10)

	npcsX = display.contentWidth
	npcsY = display.contentHeight-150
	npcsXStart = -npcsX/2 +170
	npcsYStart = -npcsY/2 +40
	--ssk.display.newRect( group, centerX, centerY, { w = fullw, h = fullh, fill = _W_ } )
 	
end

local function doUpdate()
	print("******************** DO UPDATE CALLBACK manageNpcs ******************")
	composer.gotoScene("manageNpcs")
end

function scene:show( event )
	local group = self.view
	print(currentScene .. ":show")

	if event.phase == "will" then
		print(currentScene .. ":SHOW WILL PHASE")
		currentCampaign = CampaignList:getCurrentorNewCampaign()

		if npcsGroup then npcsGroup:removeSelf() end
		npcsGroup = display.newGroup(group)
		npcsGroup.x=display.contentWidth/2
		npcsGroup.y=display.contentHeight/2
		

		local npcsSquare = display.newRect(npcsGroup, 0, 20, npcsX, npcsY)
		npcsSquare.stroke = {0.6,0,0}
		npcsSquare.strokeWidth = 2
		npcsSquare.fill = {0,0,0}

		--ssk.easyIFC:presetLabel( npcsGroup, "appLabel", "Test Label", npcsXStart , npcsYStart +20, {align="left", width=320})

		npcsTitleText = display.newText({ parent = npcsGroup,
		    text = "NPCs: ".. #currentCampaign.npcList, 
		    x = npcsXStart, 
		    y = npcsYStart, 
		    width = 320,
		    font = mainFont,   
		    fontSize = mainFontSize,
		    align = "left" 
		})
		npcsTitleText:setFillColor( 0.6, 0, 0 )

		ssk.easyIFC:presetPush( npcsGroup, "linkButton", display.contentWidth/2-120, npcsYStart, 100, 30, 
				"Create New", 
				function() manageNpc.openNewNpcDialog(npcsGroup, doUpdate); end, 
				{labelHorizAlign="left", labelSize=12} )

		local top = - npcsY/2 + 45
		local count=0
		for i=1, #currentCampaign.npcList do		
			if debugFlag then print("Creating NPC button for " .. currentCampaign.npcList[i].name); end
			--currentCampaign.npcList[i].id = i
			local yLoc = top+20*i
			local max = npcsY/2 - 20
			local xLoc = - (display.contentWidth/2 - 60)
			if (yLoc > max) then
				xLoc = display.contentWidth/2-120
				yLoc = top+20*(i-count)
				--print("c=".. tostring(count) .. ", i=".. tostring(i))
				if ((i-count) > count) then print("Oh crud, this is too big..."); end
			else
				count = count+1
				--print("c=".. tostring(count) .. ", i=".. tostring(i))
			end
			ssk.easyIFC:presetPush( npcsGroup, "linkButton", xLoc, yLoc, 100, 30, "* " .. currentCampaign.npcList[i].name, 
				function() manageNpc.openViewNpcDialog(currentCampaign.npcList[i], npcsGroup, false, doUpdate); end, 
				{labelHorizAlign="left", labelSize=12} )
		end
		

	    if navGroup then navGroup:removeSelf() end
		navGroup = display.newGroup(group)
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
		navGroup:insert(homeBtn)


		local function tapListener( event )
		    if event then
		    	print( "tapped: " .. tostring(event.target) )  
		    	if event.target.name then
		    		print("Pressed " .. event.target.name .. " Navigation Button")
		    		composer.gotoScene("manage" .. event.target.name, { effect = "fade", time = 400, params = {campaign = currentCampaign}})
		    	end
		    	--do stuff
		    end
	   	 	return true
		end

		settingsButton = widget.newButton(
	    {
	        label = "Settings", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/settings.png",
	        overFile= "images/gamemastery/icons/settings-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 170, height=60, width=60
	    })
	    settingsButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
	    settingsButton.name = "CampaignSettings"
		navGroup:insert(settingsButton)

		encountersButton = widget.newButton(
	    {
	        label = "Encounters", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/encounters.png",
	        overFile= "images/gamemastery/icons/encounters-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 250, height=60, width=60
	    })

		encountersButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		encountersButton.name = "Encounters"
		navGroup:insert(encountersButton)

		eventsButton = widget.newButton(
	    {
	        label = "Events", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/events.png",
	        overFile= "images/gamemastery/icons/events-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 330, height=60, width=60
	    })

		eventsButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		eventsButton.name = "Events"
		navGroup:insert(eventsButton)

		npcsButton = widget.newButton(
	    {
	        label = "NPCs", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/npcs-selected.png",
	        overFile= "images/gamemastery/icons/npcs.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 410, height=60, width=60
	    })

		--npcsButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		npcsButton.name = "Npcs"
		navGroup:insert(npcsButton)

		questsButton = widget.newButton(
	    {
	        label = "Quests", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/quests.png",
	        overFile= "images/gamemastery/icons/quests-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 490, height=60, width=60
	    })

		questsButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		questsButton.name = "Quests"
		navGroup:insert(questsButton)

		placesButton = widget.newButton(
	    {
	        label = "Places", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/places.png",
	        overFile= "images/gamemastery/icons/places-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 570, height=60, width=60
	    })

		placesButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		placesButton.name = "Places"
		navGroup:insert(placesButton)

		thingsButton = widget.newButton(
	    {
	        label = "Things", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/things.png",
	        overFile= "images/gamemastery/icons/things-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 650, height=60, width=60
	    })

		thingsButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		thingsButton.name = "Things"
		navGroup:insert(thingsButton)

		-- local backBtn = widget.newButton(
	 --    {   
	 --        label = "Back", font=btnFont, fontSize=btnFontSize, emboss = false,
	 --        shape = "circle", radius = 50*0.9, cornerRadius = 2, strokeWidth = 4,
	 --        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
	 --        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
	 --        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
	 --        onPress = function()  composer.gotoScene("editCampaign", { effect = "fade", time = 400, params = {campaign = currentCampaign}}) end,
	 --    	x = 60,
	 --      	y = display.contentHeight-60
	 --    })
	 --    navGroup:insert(backBtn)

	
		
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
		npcsGroup:removeSelf()
		navGroup:removeSelf()
	--elseif event.phase == "did" then
		
	end
end	


--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene)
scene:addEventListener( "destroy", scene )


return scene
