-- 
-- Abstract: 4e DM Assistant app, Tools Screen
--  
-- Version: 2.0
-- 
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- This file is used to display the corresponding screen content when the user clicks the tab bar. 

-- local composer = require ( "composer" )
local composer = require ( "composer" )
local widget = require ( "widget" )

--Create a composer scene for this module
local scene = composer.newScene()
local shown=nil



-- Function to handle button events
local function handlePress( event )
 
    if ( "ended" == event.phase ) then
        print( "Home Button was pressed" )
        composer.gotoScene("home", { effect = "fade", time = 400})
    end
end

--Create the scene
function scene:create( event )
	local group = self.view
	
	currentScene = "tools"
	print(currentScene .. ":createScene")

	initPage(group)

	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0


	local diceButton = widget.newButton(
    {
        label = "Dice", font=btnFont, fontSize=btnFontSize, emboss = false,
        shape = "circle", radius = 70*0.9, cornerRadius = 2, strokeWidth = 4,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
        onPress = function() composer.gotoScene( "dice_tool" ); end,
        x = 90,
      	y = display.contentHeight/2 + yOffset + titleBarHeight/2
    })
 	
	group:insert(diceButton)

	


	local initiativeButton = widget.newButton(
    {
        label = "Initiative", font=btnFont, fontSize=btnFontSize, emboss = false,
        shape = "circle", radius = 70*0.9, cornerRadius = 2, strokeWidth = 4,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
        onPress = function() composer.gotoScene( "initiative_tool" ); end,
        x = display.contentWidth-90,
      	y = display.contentHeight/2 + yOffset + titleBarHeight/2
    })
 	
	group:insert(initiativeButton)

	
	local nameGenButton = widget.newButton(
    {
        label = "Names", font=btnFont, fontSize=btnFontSize, emboss = false,
        shape = "circle", radius = 70*0.9, cornerRadius = 2, strokeWidth = 4,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
        onPress = function() composer.gotoScene( "namegen_tool" ); end,
        x = display.contentWidth-90,
      	y =90 + yOffset*2 + titleBarHeight
    })
 	
	group:insert(nameGenButton)

	local placeGenButton = widget.newButton(
    {
        label = "Places", font=btnFont, fontSize=btnFontSize, emboss = false,
        shape = "circle", radius = 70*0.9, cornerRadius = 2, strokeWidth = 4,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
        onPress = function() composer.gotoScene( "placegen_tool" ); end,
        x = 90,
      	y =90 + yOffset*2 + titleBarHeight
    })


	group:insert(placeGenButton)

	
	local objectGenButton = widget.newButton(
    {
        label = "Things", font=btnFont, fontSize=btnFontSize, emboss = false,
        shape = "circle", radius = 70*0.9, cornerRadius = 2, strokeWidth = 4,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
        onPress = function() composer.gotoScene( "thinggen_tool" ); end,
        x = 90,
      	y =display.contentHeight-90
    })
	
	group:insert(objectGenButton)


	local homeBtn = widget.newButton(
    {
        label = "Home", font=btnFont, fontSize=btnFontSize, emboss = false,
        shape = "circle", radius = 70*0.9, cornerRadius = 2, strokeWidth = 4,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
        onPress = function()  composer.gotoScene("home", { effect = "fade", time = 400}) end,
    	x = display.contentWidth-90,
      	y = display.contentHeight-90
    })

	group:insert(homeBtn)

end

function scene:show( event )
	local group = self.view

	currentScene = "tools"

	if not shown then
		print(currentScene .. ":SHOW")		

		--titleText.x = display.contentCenterX
	
		--timer.performWithDelay( 200*delayMultiplier, listener1 )
		shown=1
	else
		print(currentScene .. ":show skipped")
	end
end

--Destroy the scene
function scene:destroy( event )
	local group = self.view

	print(currentScene .. ":destroy")
end

--Hide the scene
function scene:hide( event )
	local group = self.view
	print(currentScene .. ":hide")
end

--Add the createScene, enterScene, and exitScene listeners

scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
