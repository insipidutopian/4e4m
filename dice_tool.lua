-- 
-- Abstract: 4e DM Assistant app, Dice Tool Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to 

local storyboard = require ( "composer" )
--local storyboard = require ( "storyboard" )
local widget = require ( "widget" )
local campaign = require ( "campaign" )

--Create a storyboard scene for this module
local scene = storyboard.newScene()

local text1, text2

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local resultString = display.newText( "", display.contentWidth - 100 , 200, 
							native.systemFontBold, 100 )


--Create the scene
function scene:create( event )
	local group = self.view
	
	local background = display.newImage("images/dice01.jpg") 
	background.x = display.contentWidth / 2
 	background.y = background.height / 2 + 20
 	background:scale(0.8, 0.8)
 	background.alpha = 0.5
 	group:insert(background)
	
	-- Create title bar to go at the top of the screen
	local titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	titleBar:setFillColor( titleGradient ) 
	group:insert ( titleBar )

	-- create embossed text to go on toolbar
	local titleText = display.newEmbossedText( "Dice", display.contentCenterX, titleBar.y, 
												native.systemFontBold, 20 )
	group:insert ( titleText )

	local resultLabel = display.newText( "Roll Result: ", display.contentWidth - 100 , 100, 
							native.systemFontBold, 28 )
	resultLabel:setFillColor( 1, 0, 0)
	group:insert( resultLabel )

	resultString:setFillColor( 0.6,0.0,0.0 )
	group:insert( resultString )


	-- create the back button to go back to the tools page
	local backButton = widget.newButton
	{
		defaultFile = "assets/buttonRedSmall.png",
		overFile = "assets/buttonRedSmallOver.png",
		label = "Back",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress =  function() storyboard.gotoScene( "tools" ); end,
		x = buttonWidth + rightPadding,
		y = titleBarHeight/2,
	}
	group:insert(backButton)


	-- here's our content --
	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0

	local d4Button = widget.newButton
	{
		defaultFile = "assets/buttonRedSmall.png",
		overFile = "assets/buttonRedSmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "d4",
		emboss = true,
		onPress = function() rollDie(4); end,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(d4Button)

	buttonCount = buttonCount + 1

	local d6Button = widget.newButton
	{
		defaultFile = "assets/buttonRedSmall.png",
		overFile = "assets/buttonRedSmallOver.png",
		label = "d6",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() rollDie(6); end,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(d6Button)

	buttonCount = buttonCount + 1

	local d8Button = widget.newButton
	{
		defaultFile = "assets/buttonRedSmall.png",
		overFile = "assets/buttonRedSmallOver.png",
		label = "d8",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress =  function() rollDie(8); end,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(d8Button)

	buttonCount = buttonCount + 1

	local d10Button = widget.newButton
	{
		defaultFile = "assets/buttonRedSmall.png",
		overFile = "assets/buttonRedSmallOver.png",
		label = "d10",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress =  function() rollDie(10); end,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(d10Button)

	buttonCount = buttonCount + 1

	local d12Button = widget.newButton
	{
		defaultFile = "assets/buttonRedSmall.png",
		overFile = "assets/buttonRedSmallOver.png",
		label = "d12",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress =  function() rollDie(12); end,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(d12Button)

	buttonCount = buttonCount + 1

	local d20Button = widget.newButton
	{
		defaultFile = "assets/buttonRedSmall.png",
		overFile = "assets/buttonRedSmallOver.png",
		label = "d20",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() rollDie(20); end,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(d20Button)

	buttonCount = buttonCount + 1

	local d30Button = widget.newButton
	{
		defaultFile = "assets/buttonRedSmall.png",
		overFile = "assets/buttonRedSmallOver.png",
		label = "d30",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() rollDie(30); end,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(d30Button)

	buttonCount = buttonCount + 1

	local d100Button = widget.newButton
	{
		defaultFile = "assets/buttonRedSmall.png",
		overFile = "assets/buttonRedSmallOver.png",
		label = "d100",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() rollDie(100); end,
		x = buttonWidth + rightPadding,
		y = yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2),
	}
	group:insert(d100Button)

end

function rollDie( dieType ) 
	print("rolling die: " .. dieType)
	-- roll the die
	rand = math.random( dieType )
	
	print("  rolled a " .. rand)
	-- set the screen text
	resultString.text = rand

	return rand
end

--Add the createScene listener
scene:addEventListener( "create", scene )

return scene
