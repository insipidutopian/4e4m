-- 
-- Abstract: 4e DM Assistant app, Treasure Generator Tool Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to generate treasure/rewards

local storyboard = require ( "composer" )
local widget = require ( "widget" )
local thing = require ("thing")

-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist


--Create a storyboard scene for this module
local scene = storyboard.newScene()

local rewardLevel = 7
local rewardType = 2 

-- Set up the picker wheel columns
local columnData =
{
    {
        align = "left",
        --width = 226,
        startIndex = 2,
        labels = { "Individual", "Hoard" }
    },
    {
        align = "right",
        labelPadding = 10,
        startIndex = 2,
        labels = { "0-4", "5-10", "11-16", "17+" }
    }
}

local pickerWheelWidth = display.contentWidth - 20
-- Image sheet options and declaration
local options = {
    frames = 
    {
        { x=0, y=0, width=pickerWheelWidth/2, height=222 },
        { x=pickerWheelWidth/3, y=0, width=pickerWheelWidth/2, height=222 },
        { x=2*pickerWheelWidth/2, y=0, width=0, height=222 }
    },
    sheetContentWidth = display.contentWidth - 20,
    sheetContentHeight = 222,
    x = display.contentCenterX
}
local pickerWheelSheet = graphics.newImageSheet( "images/gamemastery/picker_celticspears_square.png", options )
 
-- Create the pickerwheel widget
local pickerWheel = widget.newPickerWheel(
	{
	    --x = display.contentCenterX+200,
	    top = 120,
	    left = 20,
	    fontSize = 18,
	    font = "fonts/kellunc.ttf",
	    fontColor = {0.6,0.0,0.0,0.6},
	    fontColorSelected = {0.6,0.0,0.0,1},
	    columnColor = {0,0,0},
	    columns = columnData,
	    sheet = pickerWheelSheet,
    	overlayFrame = 1,
    	backgroundFrame = 2,
    	separatorFrame = 3
	})  

-- function addToCampaign(newThing)
-- 	print("Adding New Thing to Campaign, name is " .. newThing.name)
-- 	CampaignList:addThingToCampaign(newThing)
-- end

--Create the scene
function scene:create( event )
	local group = self.view
	
	print("creating scene for rewardgen tool: curr campaign id=" .. appSettings['currentCampaign'])
	local background = display.newImage("images/gamemastery/border_celticspears_tall.png") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background.width = display.contentWidth-4
 	background.height = display.contentHeight-40
 	group:insert(background)

	group:insert(pickerWheel)

	levelString = ssk.easyIFC:presetLabel( group, "appLabel", "Level: " .. rewardLevel, 
		display.contentWidth/2, 380, {fontSize = 20})
	rewardTypeString = ssk.easyIFC:presetLabel( group, "appLabel", "", display.contentWidth/2, 415, 
		{fontSize = 23})
	rewardString = ssk.easyIFC:presetLabel( group, "appLabel", "", display.contentWidth/2, 530, 
		{fontSize = 18, width=display.contentWidth-60, height=200, align="center"})
	genThingName() 

	--CampaignList:addQuestToCampaign(newQuest)
	
	-- ssk.easyIFC:presetPush( group, "squareButton", display.contentWidth/2+75, 
	--   display.contentHeight/2+210, 160, 70, "Save", 
	--   function() CampaignList:addThingToCampaign(newThing); end, {labelSize=12} )

	ssk.easyIFC:presetPush( group, "squareButton", display.contentWidth/2+75, 
		display.contentHeight/2+250, 150, 70, "Back", function() storyboard.gotoScene("tools"); end, 
		{labelSize=12} )
	
	ssk.easyIFC:presetPush( group, "squareButton", display.contentWidth/2-75, 
		display.contentHeight/2+250, 150, 70, "Reroll", function() genThingName(); end, 
		{labelSize=12} )


	
	
	 
	
	
end

function genThingName( ) 

	-- Get the table of current values for all columns in the picker
	local values = pickerWheel:getValues()
	 
	-- Get the value for each column in the wheel, by column index
	local currentType = values[1].value
	local currentLevel = values[2].value
	levelString:setText("Level " .. currentLevel)
	 
	print( currentType, currentLevel )

	if currentType == "Individual" then
		rewardType = 1
	else
		rewardType = 2
	end

	if currentLevel == "0-4" then
		rewardLevel = 2
	elseif currentLevel == "5-10" then
		rewardLevel = 7
	elseif currentLevel == "1-16" then
		rewardLevel = 13
	else
		rewardLevel = 19
	end

	reward = Randomizer:generateReward(rewardType, rewardLevel)
	
	rewardString:setText(reward)
	
	if rewardType == 1 then
		rewardTypeString:setText("Individual")
	else
		rewardTypeString:setText("Hoard")
	end
end

--Add the createScene listener
scene:addEventListener( "create", scene )

return scene
