-- 
-- Abstract: 4e DM Assistant app, Tools Screen
--  
-- Version: 2.0
-- 
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- This file is used to display the corresponding screen content when the user clicks the tab bar. 

-- local storyboard = require ( "storyboard" )
local storyboard = require ( "composer" )
local widget = require ( "widget" )

--Create a storyboard scene for this module
local scene = storyboard.newScene()

--Create the scene
function scene:create( event )
	local group = self.view
	

	local background = display.newImage("images/treasure.jpg") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background:scale(0.9,0.8)
 	background.alpha = 0.5
 	group:insert(background)


	--Create a text object that displays the current scene name and insert it into the scene's view
	-- local screenText = display.newText( "Tools", display.contentCenterX, 50, native.systemFontBold, 18 )
	-- screenText:setFillColor( 0 )
	-- group:insert( screenText )
		-- Create title bar to go at the top of the screen
	local titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	titleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( titleBar )
	-- create embossed text to go on toolbar
	local titleText = display.newEmbossedText( "Tools", display.contentCenterX, titleBar.y, 
												native.systemFontBold, 20 )
	group:insert ( titleText )

	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0


 	local diceButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Dice",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() storyboard.gotoScene( "dice_tool" ); end,
		scaleX = 0.2,
		fontSize = 12,
		isVisible = true,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(diceButton)

	buttonCount = buttonCount + 1

 	local initiativeButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Initiative",
		emboss = true,
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		onPress = function() storyboard.gotoScene( "initiative_tool" ); end,
		fontSize = 12,
		scaleX = 0.2,
		isVisible = true,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(initiativeButton)

	buttonCount = buttonCount + 1

 	local nameGenButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Names",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() storyboard.gotoScene( "namegen_tool" ); end,
		scaleX = 0.2,
		fontSize = 12,
		isVisible = true,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(nameGenButton)

	buttonCount = buttonCount + 1

	local placeGenButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Places",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() storyboard.gotoScene( "placegen_tool" ); end,
		scaleX = 0.2,
		fontSize = 12,
		isVisible = true,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(placeGenButton)

	buttonCount = buttonCount + 1

	local objectGenButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Things",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() storyboard.gotoScene( "thinggen_tool" ); end,
		scaleX = 0.2,
		fontSize = 12,
		isVisible = true,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(objectGenButton)
end

--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
