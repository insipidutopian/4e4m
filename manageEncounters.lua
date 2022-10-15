-- 
-- Abstract: 4e DM Assistant app, Encounters Details Screen
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

local currentScene = "manageEncounters"

local currentCampaign
local encountersTitleText
local encountersGroup
local navGroup

local encountersX 
local encountersY
local encountersXStart 
local encountersYStart 
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist

manageEncounter = require("manageEncounter")

buttonsArr = {}

local dialog


--Create the scene
function scene:create( event )
	local group = self.view

	
	print(currentScene .. ":createScene")


	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0

	currentCampaign = CampaignList:getCurrentorNewCampaign()

	ssk.easyIFC:presetLabel( group, "appLabel", "Encounters: ".. currentCampaign.name, 160 , yStart + 10)

	encountersX = display.contentWidth
	encountersY = display.contentHeight-150
	encountersXStart = -encountersX/2 +170
	encountersYStart = -encountersY/2 +40
	--ssk.display.newRect( group, centerX, centerY, { w = fullw, h = fullh, fill = _W_ } )
 	
end

local function doUpdate()
	print("*********************DO UPDATE CALLBACK manageEncounters ******************")
	composer.gotoScene("manageEncounters")
end

function scene:show( event )
	local group = self.view
	if event.phase == "will" then
		print(currentScene .. ":SHOW WILL PHASE")
		print(currentScene .. ":show")

		
		currentCampaign = CampaignList:getCurrentorNewCampaign()
		if currentCampaign then
			print("Loading encounters for campaign " .. currentCampaign.name)
		end

		if encountersGroup then encountersGroup:removeSelf() end
		encountersGroup = display.newGroup(group)
		encountersGroup.x=display.contentWidth/2
		encountersGroup.y=display.contentHeight/2
		

		local encountersSquare = display.newRect(encountersGroup, 0, 20, encountersX, encountersY)
		encountersSquare.stroke = {0.6,0,0}
		encountersSquare.strokeWidth = 2
		encountersSquare.fill = {0,0,0}

		--ssk.easyIFC:presetLabel( encountersGroup, "appLabel", "Test Label", encountersXStart , encountersYStart +20, {align="left", width=320})

		encountersTitleText = display.newText({ parent = encountersGroup,
		    text = "Encounters: ".. #currentCampaign.encounterList, 
		    x = encountersXStart, 
		    y = encountersYStart, 
		    width = 320,
		    font = mainFont,   
		    fontSize = mainFontSize,
		    align = "left" 
		})
		encountersTitleText:setFillColor( 0.6, 0, 0 )

		ssk.easyIFC:presetPush( encountersGroup, "linkButton", display.contentWidth/2-120, encountersYStart, 100, 30, 
				"Create New", 
				function() manageEncounter.openNewEncounterDialog(encountersGroup, doUpdate); end, 
				{labelHorizAlign="left", labelSize=12} )

		local top = - encountersY/2 + 45
		local count=0
		for i=1, #currentCampaign.encounterList do		
			if debugFlag then print("Creating Encounter button for " .. currentCampaign.encounterList[i].name); end
			--currentCampaign.encounterList[i].id = i
			local yLoc = top+20*i
			local max = encountersY/2 - 20
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
			ssk.easyIFC:presetPush( encountersGroup, "linkButton", xLoc, yLoc, 100, 30, "* " .. currentCampaign.encounterList[i].name, 
				function() manageEncounter.openViewEncounterDialog(currentCampaign.encounterList[i], encountersGroup, false, doUpdate); end, 
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

		local backBtn = widget.newButton(
	    {   
	        label = "Back", font=btnFont, fontSize=btnFontSize, emboss = false,
	        shape = "circle", radius = 50*0.9, cornerRadius = 2, strokeWidth = 4,
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
	        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
	        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
	        onPress = function()  composer.gotoScene("editCampaign", { effect = "fade", time = 400, params = {campaign = currentCampaign}}) end,
	    	x = 60,
	      	y = display.contentHeight-60
	    })
	    navGroup:insert(backBtn)

		
		
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
		encountersGroup:removeSelf()
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
