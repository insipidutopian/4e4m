-- 
-- Abstract: 4e DM Assistant app, New Quest Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to create a new quest

local storyboard = require ( "storyboard" )
local widget = require ( "widget" )
local QuestClass = require ( "quest" )
QuestList = require ("QuestList")


--Create a storyboard scene for this module
local scene = storyboard.newScene()
local questNameText, questDescText, questGoodnessText

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local tHeight = 30
local yStart = titleBarHeight + yPadding 



--Create the scene
function scene:createScene( event )
	local group = self.view

	print ("new_quest:createScene - New Quest Type=" .. newQuestType)
	
	local background = display.newImage("images/treasure-map.jpg") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background:scale(0.8, 0.8)
 	background.alpha = 0.5
 	group:insert(background)
	
	-- Create title bar to go at the top of the screen
	local titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	titleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( titleBar )
	-- create embossed text to go on toolbar
	local titleText = display.newEmbossedText( "Quest Details", display.contentCenterX, titleBar.y, 
												native.systemFontBold, 20 )
	group:insert ( titleText )

	--Create a text object that displays the current scene name and insert it into the scene's view
	-- local screenText = display.newText( "New Quest", centerX, 50, native.systemFontBold, 18 )
	-- screenText:setFillColor( 1, 0, 0 )
	-- group:insert( screenText )

	local backButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Back",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress =  function() storyboard.gotoScene( "quests" ); end,
		x =  buttonWidth + rightPadding,
		y = titleBarHeight/2,
	}
	group:insert(backButton)

	local isAndroid = "Android" == system.getInfo( "platformName" )
	local inputFontSize = 18

	if ( isAndroid ) then
	    inputFontSize = inputFontSize - 4
	end

	local questOverviewHeader = display.newText( { text = "Quest Overview", 
									 x= leftPadding, y = yStart + inputFontSize * .5, 
									 font = native.systemFontBold, fontSize = inputFontSize
								   } )
	questOverviewHeader.anchorX = 0 -- left align
	questOverviewHeader:setFillColor( 1, 0, 0)
	group:insert( questOverviewHeader )
	local questDetailsHeader = display.newText( { text = "Quest Details", 
									 x= leftPadding, y = yStart + 100 + inputFontSize * .5 , 
									 font = native.systemFontBold, fontSize = inputFontSize
								   } )
	questDetailsHeader.anchorX = 0 -- left align
	questDetailsHeader:setFillColor( 1, 0, 0)
	group:insert( questDetailsHeader )


	local encountersHeader = display.newText( { text = "Encounters", 
									 x= leftPadding, y = yStart + 200 + inputFontSize * .5 , 
									 font = native.systemFontBold, fontSize = inputFontSize
								   } )
	encountersHeader.anchorX = 0 -- left align
	encountersHeader:setFillColor( 1, 0, 0)
	group:insert( encountersHeader )

	local newEncounterButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Add New",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress =  function() storyboard.gotoScene( "encounters" ); end,
		x =  buttonWidth + rightPadding,
		y  = yStart + 230 + inputFontSize * .5,
	}
	group:insert(newEncounterButton)

end

function scene:enterScene( event )
	local group = self.view

	local index = QuestList:getCurrentQuestIndex()
	local currentQuest = QuestList:getQuest( index)
	questGoodnessText = display.newText( { text = currentQuest.description, 
									 x= leftPadding, y = yStart + 50 + inputFontSize * .5, 
									 font = native.systemFontBold, fontSize = inputFontSize +2
								   } )
	questGoodnessText.anchorX = 0 -- left align
	questGoodnessText:setFillColor( 1, 0, 0)
	group:insert( questGoodnessText )

	-- local newRandoQuestDetails = Randomizer:generateQuestDetails()
	questDetailsText = display.newText( { text = currentQuest.details, 
									 x= leftPadding, y = yStart + 150 + inputFontSize * .5, 
									 font = native.systemFontBold, fontSize = inputFontSize +2
								   } )
	questDetailsText.anchorX = 0 -- left align
	questDetailsText:setFillColor( 1, 0, 0)
	group:insert( questDetailsText )

end

function scene:exitScene( event )
	local group = self.view

	-- remove any native objects, since widget objects will be cleaned automatically, but native ones won't

	if questKeywords then
		questKeywords:removeSelf()
		questKeywords = nil
	end

	if questGoodnessText then
		questGoodnessText:removeSelf()
		questGoodnessText = nil
	end

	if questDetailsText then
		questDetailsText:removeSelf()
		questDetailsText = nil
	end
end


--Add the createScene listener
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )
return scene
