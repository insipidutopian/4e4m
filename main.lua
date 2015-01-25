-- 
-- Abstract: 4e4m Application
--  
-- Version: 1.0
-- 
--
------------------------------------------------------------

local widget = require ( "widget" )
local storyboard = require ( "storyboard" )

display.setStatusBar( display.HiddenStatusBar ) 
display.setDefault( "background", 1 )

CampaignList = require ("CampaignList")
InitiativeList = require ("InitiativeList")
QuestList = require ("QuestList")
Randomizer = require ("RandGenUtil")
FileUtil = require ("FileUtil")
local CampaignClass = require ( "campaign" )

appSettings = {fileVersion = 7, appName = "foo", appVersion = "1.0" }

newQuestType='new'
debugFlag = 1


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

math.randomseed( os.time() )

-- Create buttons table for the tab bar
local tabButtons = 
{
	{
		width = 32, height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Campaigns",
		onPress = function() storyboard.gotoScene( "campaigns" ); end,
		selected = true
	},
	{
		width = 32, height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Quests",
		onPress = function() storyboard.gotoScene( "quests" ); end,
	},
	{
		width = 32, height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Encounters",
		onPress = function() storyboard.gotoScene( "encounters" ); end,
	},
	{
		width = 32, height = 32,
		defaultFile = "assets/tabIcon.png",
		overFile = "assets/tabIcon-down.png",
		label = "Tools",
		onPress = function() storyboard.gotoScene( "tools" ); end,
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


--local readResult = FileUtil:loadAppFile("test.test")

-- Load App Settings
local readResult = FileUtil:loadSettingsFile("settings.cfg", appSettings)
		
-- print ("************************")
-- print ("Fonts: ")
-- local fonts = native.getFontNames()
-- for i=1, #fonts do
-- 	print ( i .. ": " .. fonts[i])
-- end
-- print ("************************")


--print ("Load of settings file result: read " .. readResult )
if (readResult == "") then -- First time run
	storyboard.gotoScene( "welcome" ) 
else -- Loaded settings
	print ("4e4m Settings File Version : " .. appSettings['fileVersion'])
	print ("4e4m App Name              : " .. appSettings['appName'])
	print ("4e4m App Version           : " .. appSettings['appVersion'])
	
	storyboard.gotoScene( "campaigns" )
end

