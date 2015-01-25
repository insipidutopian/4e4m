-- 
-- Abstract: 4e DM Assistant app, Welcome Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to display the corresponding screen content when the user clicks the tab bar. 

local storyboard = require ( "storyboard" )
local widget = require ( "widget" )
FileUtil = require ("FileUtil")



--Create a storyboard scene for this module
local scene = storyboard.newScene()

local welcomeTitleText
local LEFT_PADDING = 10
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local widgetGroup = display.newGroup()



--Create the scene
function scene:createScene( event )
	local group = self.view

	print("welcome:createScene")
	
	local background = display.newImage("images/world-map.jpg") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background:scale(0.8, 0.8)
 	background.alpha = 0.5
 	group:insert(background)
	

	appSettings = { fileVersion = 1, 
					appName = "4e4m", 
					appVersion = "1.0", 
					campaignCounter=0,
					questCounter=0,
					encounterCounter=0,
					initiativeCounter=0,
	}

	FileUtil:writeSettingsFile("settings.cfg", appSettings)
	-- FileUtil:writeUserFile("settings.cfg", "fileVersion=1\nappName=4e4m\nappVersion=1.0\ncampaignCounter=0\n" 
	-- 	.. "questCounter=0\nencounterCounter=0\n")

	-- Create title bar to go at the top of the screen
	local titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	titleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( titleBar )
	
	-- create embossed text to go on toolbar
	local titleText = display.newEmbossedText( "Welcome", display.contentCenterX, titleBar.y, 
												native.systemFontBold, 20 )
	group:insert ( titleText )
	
	local newCampaignButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "OK",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() storyboard.gotoScene( "Campaigns" ); end,
		scaleX = 0.2,
		isVisible = true,
		x = display.contentWidth - buttonWidth - leftPadding,
		y = titleBarHeight/2,
	}
	group:insert(newCampaignButton)
end






function scene:enterScene( event )
	local group = self.view

	print("welcome:enterScene")


	welcomeTitleText = display.newText("Welcome.", centerX, display.contentHeight - 100, native.systemFontBold, 16 )
	welcomeTitleText:setFillColor( 1, 0, 0)
	group:insert( welcomeTitleText )

	welcomeText = display.newText("Welcome to " .. appSettings["appName"] .. "v" .. appSettings["appVersion"], centerX, display.contentHeight - 100, native.systemFontBold, 16 )
	welcomeTitleText:setFillColor( 1, 0, 0)
	group:insert( welcomeTitleText )
end

function scene:exitScene( event )
	local group = self.view

	if welcomeTitleText then
		welcomeTitleText:removeSelf()
		welcomeTitleText = nil
	end
	print("welcome:exitScene")
end	






--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )

return scene
