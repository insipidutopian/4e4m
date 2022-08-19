-- 
-- GameMastery Mobile Application
--  
--
------------------------------------------------------------
debugFlag = false

local widget = require ( "widget" )
--widget.setTheme("widget_theme_ios7")
local composer = require ( "composer" )
-- My Local Imports

require("mobdebug").start()

CampaignList = require ("CampaignList")
InitiativeList = require ("InitiativeList")
QuestList = require ("QuestList")
Randomizer = require ("RandGenUtil")
FileUtil = require ("FileUtil")
local CampaignClass = require ( "campaign" )

GAMEMASTERY_VERSION = "1.3.3"
-- SSK2 Begin Load
io.output():setvbuf("no")
display.setStatusBar(display.HiddenStatusBar)
-- =============================================================
_G.fontN 	= "Raleway-Light.ttf" 
_G.fontB 	= "Raleway-Black.ttf" 
-- =============================================================
--require "com.roaminggamer.ssk.loadSSK"
-- =============================================================

require "ssk2.loadSSK"
_G.ssk.init( { launchArgs 				= ..., 
	            gameFont 				= "fonts/Aclonica.ttf",
	            measure 					= true,
	            math2DPlugin 			= false,
	            enableAutoListeners 	= true,
	            exportColors 			= true,
	            exportCore 				= true,
	            exportSystem 			= true,
	            debugLevel 				= 0 } )

-- SSK2 Finished Load
require("skin")

--ssk.android.easyAndroidUIVisibility("immersiveSticky")


display.setStatusBar( display.HiddenStatusBar ) 
display.setDefault( "background", 1, 1, 1 )

currentScene = "welcome"
local currentOrientation

newQuestType='new'

-- Fonts --
titleFont = "fonts/Fiddums Family.ttf"
mainFont = "fonts/Aclonica.ttf"
mainFontSize = 16

btnFont = "fonts/kellunc.ttf"
btnFontSize = 14

titleBarHeight = 50

popOptions = { isModal = true }

largeFormat = false
if system.getInfo("platform")=="macos" then
	largeFormat = true
end

appSettings = {fileVersion = 1, appName = "GameMastery", appVersion = GAMEMASTERY_VERSION, 
				campaignCounter = 0, encounterCounter = 0,  questCounter = 0, initiativeCounter = 0,
			    currentCampaign = -1}

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

function initPage( group)
	titleBar = display.newRect( display.contentCenterX, titleBarHeight/2 + yOffset/2, 
		display.contentWidth, titleBarHeight + yOffset )

	titleBar:setFillColor( titleGradientDark ) 
	group:insert(titleBar)
	
	display.setDefault( "background", 0, 0, 0 )

	titleText = display.newEmbossedText(appSettings["appName"], display.contentCenterX, 
		titleBarHeight/2 + yOffset, titleFont, 40 )
	titleText:setFillColor(0.6,0,0 )
	group:insert ( titleText )
end

delayMultiplier = 5

if debugFlag then
	delayMultiplier = 1
end


titleGradient = {
	type = 'gradient',
	color1 = { 204/255, 51/255, 51/255, 255/255 }, 
	color2 = { 153/255, 51/255, 51/255, 255/255 },
	direction = "down"
}

titleGradientRed = {
	type = 'gradient',
	color1 = { 204/255, 51/255, 51/255, 255/255 }, 
	color2 = { 153/255, 51/255, 51/255, 255/255 },
	direction = "down"
}

titleGradientDark = {
	type = 'gradient',
	color1 = { 204/255, 0/255, 0/255, 122/255 }, 
	color2 = { 0/255, 0/255, 0/255, 122/255 },
	direction = "down"
}


leftPadding = 10
rightPadding = 10
buttonWidth = 30
squareButtonWidth = 7
buttonHeight = 30
yPadding = 10
inputFontSize = 12
--yOffset = 35
yOffset = 10

if (system.getInfo("platform")=="ios" and 
	(string.find( system.getInfo("architectureInfo"),"iPhone10,3")~= nil) or 
	 (string.find(system.getInfo("architectureInfo"),"iPhone10,6" )~= nil)) or 
     (system.getInfo("environment")=="simulator" 
     and display.pixelHeight==2436 and display.pixelWidth==1125) then

 		-- CODE would go here if 1) actual device is iOS and iPhoneX and 2) 
 		print("iPhone X")

 		yOffset = 35
else
	print("Non-IPhone X display detected")
end

if debugFlag then 
	print("SYSTEM: " .. system.getInfo("platform"))
	print("ARCH:   " .. system.getInfo("architectureInfo"))
	print("ENV:    " .. system.getInfo("environment"))
	print("HEIGHT: " .. display.viewableContentHeight)
	print("WIDTH:  " .. display.viewableContentWidth)
	print("dHght:  " .. display.pixelHeight)
	print("dWdth:  " .. display.pixelWidth)
end


roundTimeElapsed = 0 
turnTimeElapsed = 0

math.randomseed( os.time() )






-- Load App Settings
FileUtil:initializeSettingsFileIfNotExists("settings.cfg", appSettings)
FileUtil:loadSettingsFile("settings.cfg", appSettings)
print("Campaign count: " .. appSettings['campaignCounter'])
FileUtil:upgradeSettingsFileIfNeeded(appSettings)

print ("4e4m Settings File Version : " .. appSettings['fileVersion'])
print ("4e4m App Name              : " .. appSettings['appName'])
print ("4e4m App Version           : " .. appSettings['appVersion'])


composer.gotoScene( "welcome" )



--[[print ("************************")
print ("Fonts: ")
local fonts = native.getFontNames()
for i=1, #fonts do
	print ( i .. ": " .. fonts[i])
end
print ("************************")

--]]


Runtime:addEventListener( "orientation", onOrientationChange )
