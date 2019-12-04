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

InitiativeList = require ("InitiativeList")
Randomizer = require ("RandGenUtil")
FileUtil = require ("FileUtil")

appSettings = {fileVersion = 7, appName = "foo", appVersion = "1.0" }

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
if (readResult ~= "") then -- First time run
	print ("4e4m Settings File Version : " .. appSettings['fileVersion'])
	print ("4e4m App Name              : " .. appSettings['appName'])
	print ("4e4m App Version           : " .. appSettings['appVersion'])
end	
composer.gotoScene( "welcome" )



Runtime:addEventListener( "orientation", onOrientationChange )