-- 
-- Abstract: 4e DM Assistant app, Event Logs Details Screen
--  
-- Version: 1.0
-- 
--

local composer = require ( "composer" )
local widget = require ( "widget" )
CampaignList = require ("CampaignList")
local campaign = require ( "campaign" )

local scene = composer.newScene()

local currentScene = "manageEvents"

local currentCampaign
local eventsTitleText
local eventsGroup
local navGroup

local eventsX 
local eventsY
local eventsXStart 
local eventsYStart 

-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist

manageEvent = require("manageEvent")

buttonsArr = {}

local dialog


--Create the scene
function scene:create( event )
	local group = self.view

	print(currentScene .. ":createScene")


	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0

	currentCampaign = CampaignList:getCurrentorNewCampaign()

	ssk.easyIFC:presetLabel( group, "appLabel", "Events: ".. currentCampaign.name, 160 , yStart + 10)

	eventsX = display.contentWidth
	eventsY = display.contentHeight-150
	eventsXStart = -eventsX/2 +170
	eventsYStart = -eventsY/2 +40
	--ssk.display.newRect( group, centerX, centerY, { w = fullw, h = fullh, fill = _W_ } )
 	
end

local function doUpdate()
	print("******************** DO UPDATE CALLBACK manageEvents ******************")
	composer.gotoScene("manageEvents")
end

function scene:show( event )
	local group = self.view
	print(currentScene .. ":show")

	
	currentCampaign = CampaignList:getCurrentorNewCampaign()

	if eventsGroup then eventsGroup:removeSelf() end
	eventsGroup = display.newGroup(group)
	eventsGroup.x=display.contentWidth/2
	eventsGroup.y=display.contentHeight/2
	

	local eventsSquare = display.newRect(eventsGroup, 0, 20, eventsX, eventsY)
	eventsSquare.stroke = {0.6,0,0}
	eventsSquare.strokeWidth = 2
	eventsSquare.fill = {0,0,0}

	--ssk.easyIFC:presetLabel( eventsGroup, "appLabel", "Test Label", eventsXStart , eventsYStart +20, {align="left", width=320})

	eventsTitleText = display.newText({ parent = eventsGroup,
	    text = "Events: ".. #currentCampaign.eventList, 
	    x = eventsXStart, 
	    y = eventsYStart, 
	    width = 320,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left" 
	})
	eventsTitleText:setFillColor( 0.6, 0, 0 )

	ssk.easyIFC:presetPush( eventsGroup, "linkButton", display.contentWidth/2-120, eventsYStart, 100, 30, 
			"Create New", 
			function() manageEvent.openNewEventDialog(eventsGroup, doUpdate); end, 
			{labelHorizAlign="left", labelSize=12} )

	local top = - eventsY/2 + 45
	local count=0
	for i=1, #currentCampaign.eventList do		
		if debugFlag then print("Creating Event button for " .. currentCampaign.eventList[i].title); end
		local yLoc = top+20*i
		local max = eventsY/2 - 20
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
		ssk.easyIFC:presetPush( eventsGroup, "linkButton", xLoc, yLoc, 100, 30, "* " .. currentCampaign.eventList[i].title, 
			function() manageEvent.openViewEventDialog(currentCampaign.eventList[i], eventsGroup, false, doUpdate); end, 
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

	if event.phase == "will" then
		print(currentScene .. ":SHOW WILL PHASE")
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
		eventsGroup:removeSelf()
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
