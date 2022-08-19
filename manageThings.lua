-- 
-- Abstract: 4e DM Assistant app, Things Details Screen
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

local currentScene = "manageThings"

local currentCampaign
local thingsTitleText
local thingsGroup
local navGroup

local thingsX 
local thingsY
local thingsXStart 
local thingsYStart 
-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist

manageThing = require("manageThing")

buttonsArr = {}

local dialog


--Create the scene
function scene:create( event )
	local group = self.view

	print(currentScene .. ":createScene")


	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0

	currentCampaign = CampaignList:getCurrentorNewCampaign()

	ssk.easyIFC:presetLabel( group, "appLabel", "Things: ".. currentCampaign.name, 160 , yStart + 10)

	thingsX = display.contentWidth
	thingsY = display.contentHeight-150
	thingsXStart = -thingsX/2 +170
	thingsYStart = -thingsY/2 +40
	--ssk.display.newRect( group, centerX, centerY, { w = fullw, h = fullh, fill = _W_ } )
 	
end

local function doUpdate()
	print("*********************DO UPDATE CALLBACK manageThings ******************")
	composer.gotoScene("manageThings")
end

function scene:show( event )
	local group = self.view
	print(currentScene .. ":show")

	
	currentCampaign = CampaignList:getCurrentorNewCampaign()

	if thingsGroup then thingsGroup:removeSelf() end
	thingsGroup = display.newGroup(group)
	thingsGroup.x=display.contentWidth/2
	thingsGroup.y=display.contentHeight/2
	

	local thingsSquare = display.newRect(thingsGroup, 0, 20, thingsX, thingsY)
	thingsSquare.stroke = {0.6,0,0}
	thingsSquare.strokeWidth = 2
	thingsSquare.fill = {0,0,0}

	--ssk.easyIFC:presetLabel( thingsGroup, "appLabel", "Test Label", thingsXStart , thingsYStart +20, {align="left", width=320})

	thingsTitleText = display.newText({ parent = thingsGroup,
	    text = "Things: ".. #currentCampaign.thingList, 
	    x = thingsXStart, 
	    y = thingsYStart, 
	    width = 320,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left" 
	})
	thingsTitleText:setFillColor( 0.6, 0, 0 )

	ssk.easyIFC:presetPush( thingsGroup, "linkButton", display.contentWidth/2-120, thingsYStart, 100, 30, 
			"Create New", 
			function() manageThing.openNewThingDialog(thingsGroup, doUpdate); end, 
			{labelHorizAlign="left", labelSize=12} )

	local top = - thingsY/2 + 45
	local count=0
	for i=1, #currentCampaign.thingList do		
		if debugFlag then print("Creating Thing button for " .. currentCampaign.thingList[i].name); end
		--currentCampaign.thingList[i].id = i
		local yLoc = top+20*i
		local max = thingsY/2 - 20
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
		ssk.easyIFC:presetPush( thingsGroup, "linkButton", xLoc, yLoc, 100, 30, "* " .. currentCampaign.thingList[i].name, 
			function() manageThing.openViewThingDialog(currentCampaign.thingList[i], thingsGroup, false, doUpdate); end, 
			{labelHorizAlign="left", labelSize=12} )
	end

	-- for i=1, #currentCampaign.thingList do		
	-- 	if debugFlag then print("Creating Thing button for " .. currentCampaign.thingList[i].name); end
	-- 	currentCampaign.thingList[i].id = i
	-- 	ssk.easyIFC:presetPush( thingsGroup, "linkButton", 80, top+20*i, 100, 30, "* " .. currentCampaign.thingList[i].name, 
	-- 		function() manageThing.openViewThingDialog(currentCampaign.thingList[i]); end, {labelHorizAlign="left"} )
	-- end
	

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
		--campaignNameText.text = "Things: " .. currentCampaign.name
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
		thingsGroup:removeSelf()
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
