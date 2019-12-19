-- 
-- Abstract: 4e4m Application
--  
-- Version: 1.0
-- 
--
------------------------------------------------------------
debugFlag = 1

local widget = require ( "widget" )
--local storyboard = require ( "storyboard" )
local composer = require ( "composer" )

display.setStatusBar( display.HiddenStatusBar ) 
display.setDefault( "background", 1 )

currentScene = "welcome"
local currentOrientation

CampaignList = require ("CampaignList")
InitiativeList = require ("InitiativeList")
QuestList = require ("QuestList")
Randomizer = require ("RandGenUtil")
FileUtil = require ("FileUtil")
local CampaignClass = require ( "campaign" )
newQuestType='new'

appSettings = {fileVersion = 1, appName = "GameMastery", appVersion = "1.0.1", 
				campaignCounter = 0, encounterCounter = 0,  questCounter = 0, initiativeCounter = 0}

--Orientation
print( "INITIAL ORIENTATION: "..system.orientation )

function onOrientationChange( event )
    print( "Current orientation: " .. system.orientation )
    print( "display.contentCenterX now: " .. display.contentCenterX)
	print( "display.contentCenterY now: " .. display.contentCenterY)
	print( "display.contentWidth now: " .. display.contentWidth)
	print( "display.contentHeight now: " .. display.contentHeight)

	composer.gotoScene( currentScene )
end






titleGradient = {
	type = 'gradient',
	color1 = { 204/255, 51/255, 51/255, 255/255 }, 
	color2 = { 153/255, 51/255, 51/255, 255/255 },
	direction = "down"
}


titleBarHeight = 40
leftPadding = 10
rightPadding = 10
buttonWidth = 30
squareButtonWidth = 7
buttonHeight = 30
yPadding = 10
inputFontSize = 12

roundTimeElapsed = 0 
turnTimeElapsed = 0

math.randomseed( os.time() )

-- Create buttons table for the tab bar
local tabButtons = 
{
	{
		width = 32, height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Campaigns",
		onPress = function() composer.gotoScene( "campaigns" ); end,
--		onPress = function() storyboard.gotoScene( "campaigns" ); end,
		selected = true
	},
	{
		width = 32, height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Quests",
		-- onPress = function() storyboard.gotoScene( "quests" ); end,
		onPress = function() composer.gotoScene( "quests" ); end,
	},
	{
		width = 32, height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Encounters",
		onPress = function() composer.gotoScene( "encounters" ); end,
		--onPress = function() storyboard.gotoScene( "encounters" ); end,
	},
	{
		width = 32, height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Tools",
		onPress = function() composer.gotoScene( "tools" ); end,
		--onPress = function() storyboard.gotoScene( "tools" ); end,
	}
}

--Create a tab-bar and place it at the bottom of the screen
local demoTabs = widget.newTabBar
{
	top = display.contentHeight - 50,
	width = display.contentWidth,
	backgroundFile = "assets/tabbar.jpg",
	tabSelectedLeftFile = "assets/tabBar_tabSelectedLeft.png",
	tabSelectedMiddleFile = "assets/tabBar_tabSelectedMiddle.png",
	tabSelectedRightFile = "assets/tabBar_tabSelectedRight.png",
	tabSelectedFrameWidth = 20,
	tabSelectedFrameHeight = 52,
	buttons = tabButtons
}




-- Load App Settings
local readResult = FileUtil:initializeSettingsFileIfNotExists("settings.cfg", appSettings)
		
-- print ("************************")
-- print ("Fonts: ")
-- local fonts = native.getFontNames()
-- for i=1, #fonts do
-- 	print ( i .. ": " .. fonts[i])
-- end
-- print ("************************")


--print ("Load of settings file result: read " .. readResult )
if (readResult ~= "") then -- First time run
	print ("4e4m Settings File Version : " .. appSettings['fileVersion'])
	print ("4e4m App Name              : " .. appSettings['appName'])
	print ("4e4m App Version           : " .. appSettings['appVersion'])
end	
composer.gotoScene( "welcome" )



Runtime:addEventListener( "orientation", onOrientationChange )
