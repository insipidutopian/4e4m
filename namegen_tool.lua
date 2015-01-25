-- 
-- Abstract: 4e DM Assistant app, Name Generator Tool Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to 

local storyboard = require ( "storyboard" )
local widget = require ( "widget" )
Randomizer = require ("RandGenUtil")

--Create a storyboard scene for this module
local scene = storyboard.newScene()

local centerX = display.contentCenterX

local nameResultString = display.newText( "", display.contentWidth /2 , 200, 
							native.systemFontBold, 50 )

--Create the scene
function scene:createScene( event )
	local group = self.view
	
	local background = display.newImage("images/dragon02.jpg") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background:scale(0.8, 0.8)
 	background.alpha = 0.5
 	group:insert(background)
	
	-- Create title bar to go at the top of the screen
	local titleBar = display.newRect( centerX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	titleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( titleBar )
	-- create embossed text to go on toolbar
	local titleText = display.newEmbossedText( "Name Gen", centerX, titleBar.y, 
												native.systemFontBold, 20 )
	group:insert ( titleText )

	local resultLabel = display.newText( "Name: ", display.contentWidth - 200 , 100, 
							native.systemFontBold, 28 )
	resultLabel:setFillColor( 1, 0, 0)
	group:insert( resultLabel )

	nameResultString:setFillColor( grey )
	group:insert( nameResultString )



	-- local nameResultString = rollDie(6);

	local backButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Back",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress =  function() storyboard.gotoScene( "tools" ); end,
		x = buttonWidth + rightPadding,
		y = titleBarHeight/2,
	}
	group:insert(backButton)


	local nameGenButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Gen!",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() genName(); end,
		x = buttonWidth + rightPadding,
		y = 60,
	}
	group:insert(nameGenButton)


	
end

function genName( numNames ) 
	-- set the screen text
	nameResultString.text = Randomizer:generateName()
end

--Add the createScene listener
scene:addEventListener( "createScene", scene )

return scene
