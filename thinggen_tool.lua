-- 
-- Abstract: 4e DM Assistant app, Thing Generator Tool Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to generate random objects

local storyboard = require ( "composer" )
local widget = require ( "widget" )
Randomizer = require ("RandGenUtil")
local thing = require ("thing")

-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist


--Create a storyboard scene for this module
local scene = storyboard.newScene()

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local newThing 

function addToCampaign(newThing)
	print("Adding New Thing to Campaign, name is " .. newThing.name)
	CampaignList:addThingToCampaign(newThing)
end

--Create the scene
function scene:create( event )
	local group = self.view
	
	print("creating scene for thinggen tool: curr campaign id=" .. appSettings['currentCampaign'])
	local background = display.newImage("images/gamemastery/border_celticspears_tall.png") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background.width = display.contentWidth-4
 	background.height = display.contentHeight-40
 	group:insert(background)
	
	ssk.easyIFC:presetLabel( group, "appLabel", "Thing Name: ", display.contentWidth/2, 150, {fontSize = 20})
	thingResultString = ssk.easyIFC:presetLabel( group, "appLabel", "", display.contentWidth/2, 200, {fontSize = 23})
	thingNotesString = ssk.easyIFC:presetLabel( group, "appLabel", "", display.contentWidth/2, 330, 
		{fontSize = 18, width=display.contentWidth-60, height=200, align="center"})
	genThingName() 

	--CampaignList:addQuestToCampaign(newQuest)
	
	ssk.easyIFC:presetPush( group, "squareButton", display.contentWidth/2+75, display.contentHeight/2+210, 160, 70, "Save", 
	 		function() CampaignList:addThingToCampaign(newThing); end, {labelSize=12} )

	ssk.easyIFC:presetPush( group, "squareButton", display.contentWidth/2+75, display.contentHeight/2+140, 160, 70, "Back", 
			function() storyboard.gotoScene("tools"); end, {labelSize=12} )
	
	ssk.easyIFC:presetPush( group, "squareButton", display.contentWidth/2-75, display.contentHeight/2+140, 160, 70, "Reroll", 
			function() genThingName(); end, {labelSize=12} )
	
end

function genThingName( ) 
	newThing = Randomizer:generateThing()
	thingNotesString:setText(newThing.description)
	thingResultString:setText(newThing.name)
end

--Add the createScene listener
scene:addEventListener( "create", scene )

return scene
