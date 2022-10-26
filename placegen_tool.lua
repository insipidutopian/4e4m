-- 
-- Abstract: 4e DM Assistant app, Place Name Generator Tool Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to generate detailed, random places

local storyboard = require ( "composer" )
local widget = require ( "widget" )

-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist


--Create a storyboard scene for this module
local scene = storyboard.newScene()

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local placeResultString 

--Create the scene
function scene:create( event )
	local group = self.view
	
	local background = display.newImage("images/gamemastery/border_celticspears_tall.png") 	
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background.width = display.contentWidth-4
 	background.height = display.contentHeight-40
 	group:insert(background)

	ssk.easyIFC:presetLabel( group, "appLabel", "Place Name: ", display.contentWidth/2, 150, {fontSize = 20})
	placeResultString = ssk.easyIFC:presetLabel( group, "appLabel", "", display.contentWidth/2, 200, {fontSize = 23})
	placeNotesString = ssk.easyIFC:presetLabel( group, "appLabel", "", display.contentWidth/2, 330, 
		{fontSize = 18, width=display.contentWidth-60, height=200, align="center"})
	genPlaceName() 

	
	ssk.easyIFC:presetPush( group, "squareButton", display.contentWidth/2+75, 
		display.contentHeight/2+250, 150, 70, "Back", 
			function() storyboard.gotoScene("tools"); end, {labelSize=12} )
	
	ssk.easyIFC:presetPush( group, "squareButton", display.contentWidth/2-75, 
		display.contentHeight/2+250, 150, 70, "Reroll", 
			function() genPlaceName(); end, {labelSize=12} )

	
end

function genPlaceName( ) 
	-- set the screen text
	local plType = Randomizer:generatePlaceType()
	
	placeNotesString:setText(Randomizer:generatePlaceNotes("" .. plType))
	placeResultString:setText(Randomizer:generatePlaceName("" .. plType))
end

--Add the createScene listener
scene:addEventListener( "create", scene )

return scene
