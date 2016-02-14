-- 
-- Abstract: 4e DM Assistant app, Quests Screen
--  
-- Version: 2.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- This file is used to display the corresponding screen content when the user clicks the tab bar. 

-- local storyboard = require ( "storyboard" )
local storyboard = require ( "composer" )
local widget = require ( "widget" )
local quest = require ( "quest" )
QuestList = require ("QuestList")


local questsFoundText, questListDisplay
--Create a storyboard scene for this module
local scene = storyboard.newScene()

local LEFT_PADDING = 10
local centerX = display.contentCenterX
local centerY = display.contentCenterY


-- create embossed text to go on toolbar
-- local titleText = display.newEmbossedText( "Quests", display.contentCenterX, titleBar.y, 
											-- native.systemFontBold, 20 )


-- Hande row touch events
local function onRowTouch( event )
	print ("onRowTouch event caught")
	local phase = event.phase
	local row = event.target
	
	if "press" == phase then
		print( "Pressed row: " .. row.index )

	elseif "release" == phase then
		-- Update the item selected text
		local q = QuestList:getQuest( row.index )
		 
		QuestList:setCurrentQuestIndex( row.index )
		
		--Transition out the list, transition in the item selected text and the back button
		storyboard.gotoScene( "quest_details" )
		
		print( "Tapped and/or Released row: " .. row.index )
	end
end


-- Handle row rendering
local function onRowRender( event )
	print ("quests - onRowRender..." )
	local phase = event.phase
	local row = event.row
	
	-- in graphics 2.0, the group contentWidth / contentHeight are initially 0, and expand once elements are inserted into the group.
	-- in order to use contentHeight properly, we cache the variable before inserting objects into the group

	local groupContentHeight = row.contentHeight

	local rowTitle

	-- if (#campaigns > 0) campaigns[row.index+1]
	if (event.row.params ) then
		local params = row.params
		local splan = params.name
		rowTitle = display.newText( row, splan, 12, 0, native.systemFontBold, 16 )
		rowTitle:setFillColor( gray )
	else
		rowTitle = display.newText( row, "Quest " .. row.index, 0, 0, native.systemFontBold, 16 )
	end
	-- in Graphics 2.0, the row.x is the center of the row, no longer the top left.
	-- rowTitle.x = LEFT_PADDING

	-- we also set the anchorX of the text to 0, so the object is x-anchored at the left
	rowTitle.y = groupContentHeight * 0.5 -- centered in the row
	rowTitle.anchorX = 0
	row:insert( rowTitle )
	
	
	local rowArrow = display.newImage( row, "rowArrow.png", false )
	rowArrow.x = row.contentWidth - LEFT_PADDING
	rowArrow.y = groupContentHeight * 0.5 -- centered in the row

	-- we set the image anchorX to 1, so the object is x-anchored at the right
	rowArrow.anchorX = 1
	
end


function showQuest( i )

	local q = QuestList:getQuest( i )
	questListDisplay:insertRow
	{
		height = 72,
		rowColor = 
		{ 
			default = { 1, 1, 1, 0 },
		},
		lineColor = { 0.5, 0.5, 0.5 },
		params = { name = q.name }
	}
end




--Create the scene
function scene:create( event )
	local group = self.view

	local background = display.newImage("images/treasure-map.jpg") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background:scale(0.8,0.8)
 	background.alpha = 0.5
 	group:insert(background)

	-- Create title bar to go at the top of the screen
	local titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	titleBar:setFillColor( titleGradient ) 
	group:insert ( titleBar )
	-- create embossed text to go on toolbar
	local titleText = display.newEmbossedText( "Quests", display.contentCenterX, titleBar.y, 
												native.systemFontBold, 20 )
	group:insert ( titleText )
	

	local randomQuestButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Random",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() newQuestType='rando'; storyboard.gotoScene( "new_quest" ); end,
		scaleX = 0.2,
		isVisible = true,
		x = display.contentWidth - buttonWidth - leftPadding,
		y = titleBarHeight/2,
	}
	group:insert(randomQuestButton)
end

function scene:exit ( event )
	local group = self.view

	if questsFoundText then
		questsFoundText:removeSelf()
		questsFoundText = nil
	end

	if questListDisplay then
		questListDisplay:removeSelf()
		questListDisplay = nil
	end
end

function scene:enter( event )
	local group = self.view
	
	print("quests:enterScene")
	-- Create a tableView
	questListDisplay = widget.newTableView
	{
		top = 38,
		width = 320, 
		height = 400,
		hideBackground = true,
		maskFile = "mask-320x448.png",
		onRowRender = onRowRender,
		onRowTouch = onRowTouch,
	}

	QuestList:loadQuests()

	local qc = QuestList:getQuestCount()

 	for i = 1, qc do
 		print ("Showing Quest #" .. i)
		showQuest(i)
 	end

	questsFoundText = display.newText(qc.." Quests found.", centerX, display.contentHeight - 100, native.systemFontBold, 16 )
	questsFoundText:setFillColor( 1, 0, 0)
	group:insert( questsFoundText )
	-- group:insert( questsFoundText )
end




--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "enter", scene )
scene:addEventListener( "exit", scene )

return scene
