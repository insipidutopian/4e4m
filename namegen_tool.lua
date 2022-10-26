-- 
-- Abstract: 4e DM Assistant app, Name Generator Tool Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to generate random names

local storyboard = require ( "composer" )
local widget = require ( "widget" )

-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist

--Create a storyboard scene for this module
local scene = storyboard.newScene()

-- Set up the picker wheel columns
local columnData =
{
    {
        align = "left",
        --width = 226,
        startIndex = 2,
        labels = { "Random", "Dragonborn", "Dwarf", "Elf", "Gnome", "Halfling", "Half-Elf", "Half-Orc", "Human", "Tiefling" }
    },
    {
        align = "right",
        labelPadding = 10,
        startIndex = 2,
        labels = { "Random", "Noble", "Commoner", "Adventurer", "Merchant" }
    }
}

local pickerWheelWidth = display.contentWidth - 60
local pickerWheelHeight = 200
-- Image sheet options and declaration
local options = {
    frames = 
    {
        { x=0, y=0, width=pickerWheelWidth/2, height=pickerWheelHeight},
        { x=pickerWheelWidth/3, y=0, width=pickerWheelWidth/2, height=pickerWheelHeight },
        { x=2*pickerWheelWidth/2, y=0, width=0, height=pickerWheelHeight }
    },
    sheetContentWidth = pickerWheelWidth,
    sheetContentHeight = pickerWheelHeight,
    x = display.contentCenterX
}
local pickerWheelSheet = graphics.newImageSheet( "images/gamemastery/picker_celticspears_square.png", options )
 
-- Create the pickerwheel widget
local pickerWheel = widget.newPickerWheel(
	{
	    --x = display.contentCenterX+200,
	    top = 120,
	    left = 30,
	    fontSize = 14,
	    width=pickerWheelWidth,
	    rowHeight = 30,
	    style = "resizable",
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

--Create the scene
function scene:create( event )
	local group = self.view
	print ("namegen_tool:create called")
	
	local background = display.newImage("images/gamemastery/border_celticspears_tall.png") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background.width = display.contentWidth-4
 	background.height = display.contentHeight-40
 	group:insert(background)

 	group:insert(pickerWheel)

	ssk.easyIFC:presetLabel( group, "appLabel", "Name: ", display.contentWidth/2, 300, {fontSize = 20})
	npcName = ssk.easyIFC:presetLabel( group, "appLabel", "", display.contentWidth/2, 340, {fontSize = 23})
	npcNameOption = ssk.easyIFC:presetLabel( group, "appLabel", "", display.contentWidth/2, 460, 
		{fontSize = 18, width=display.contentWidth-60, height=200, align="center"})
	
	genName() 
	
	
	ssk.easyIFC:presetPush( group, "squareButton", display.contentWidth/2+75, 
		display.contentHeight/2+250, 150, 70, "Back", 
			function() storyboard.gotoScene("tools"); end, {labelSize=12} )
	
	ssk.easyIFC:presetPush( group, "squareButton", display.contentWidth/2-75, 
		display.contentHeight/2+250, 150, 70, "Reroll", 
			function() genName(); end, {labelSize=12} )
	
end

function genName( numNames ) 

	local values = pickerWheel:getValues()
	 
	-- Get the value for each column in the wheel, by column index
	local npcRace = values[1].value
	local npcBackground = values[2].value

	-- set the screen text
	if npcRace == "Random" then
		npcRace = Randomizer:generateNpcRace()
	end
	local nameOption = Randomizer:generateNpcNameOption(npcBackground, npcRace)
	npcNameOption:setText(nameOption)
	npcName:setText(Randomizer:generateNpcName(npcRace))
end

--Add the createScene listener
scene:addEventListener( "create", scene )

return scene
