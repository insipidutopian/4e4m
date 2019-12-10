-- 
-- Abstract: 4e DM Assistant app, New Quest Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to create a new quest

local composer = require ( "composer" )
-- local storyboard = require ( "storyboard" )
local widget = require ( "widget" )
local QuestClass = require ( "quest" )
QuestList = require ("QuestList")


--Create a scene for this module
local scene = composer.newScene()
local questNameTF, questDescTB
local newQuest
local questNameText, questDescText, questGoodnessText

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local tHeight = 30
local yStart = titleBarHeight + yPadding 

local yScrollStart, yScrollEnd

local addQuestName = ""


local function update ()
	newQuest = Randomizer:generateQuest()
	if ( questGoodnessText == nil) then

		questGoodnessText = display.newText( { text = "",  x= display.contentCenterX, y = yStart + 30 + inputFontSize * .5 , 
										 font = native.systemFontBold, fontSize = inputFontSize
									   } )
		questDetailsText = display.newText( { text = "",  x= display.contentCenterX, y = yStart + 120 + inputFontSize * .5 , 
										 font = native.systemFontBold, fontSize = inputFontSize
									   } )
	end
	questGoodnessText.text = newQuest.description
	questDetailsText.text = newQuest.details
	-- updateCountText.text = "Updates: " .. updateCount
	
end


local function textListener( event )

	if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- do something with questNameTF's text
        if (event.text) then
        	print ("user input ended or submitted, text="..event.text)
        else
        	print ("user input ended or submitted, nil text")
        end
    end
end

-- function to listen to scrollView events
local function scrollViewListener( event )
    local eventPhase = event.phase
    if (eventPhase ) then
		if (eventPhase == "began") then
			yScrollStart = event.y
		end
		if (eventPhase == "ended") then
			yScrollEnd = event.y
			local tmp = yScrollStart or 0
			local totalMoved = yScrollEnd - tmp
			if ( totalMoved > 128 ) then
				-- print ("REFRESH NEEDED: " .. totalMoved)
				update()
			end
		end
    end
end

local scrollView = widget.newScrollView{
    left = 0, top = -30, width = display.contentCenterX * 2, height = display.contentCenterY * 2,
    scrollWidth = 768, scrollHeight = 240,
    hideBackground = true, maskFile = "mask.png",
    topPadding=30, bottomPadding=30,
    horizontalScrollDisabled = true,
    listener = scrollViewListener
}


function addQuest()
	print ("Adding quest '"..addQuestName.."'")
	local qDesc = newQuest.description
	local qDetails = newQuest.details
	if (qDesc == "") then
		print (" generating random quest name")
		rand = math.random( 100 )
		qDesc = "New Quest " .. rand
		qDetails = "New Quest " .. rand .. " Details"
		print (" generate random quest name: " .. qDesc)
	end

	--local newQuest = QuestClass.new(cName)
	--print (" questNameTF='"..qName.."', questDescTB='"..qDesc.."'")
	--if (newQuest and qDesc) then
	--	newQuest:setDescription(qDesc)
	--end
    QuestList:addQuest(newQuest)
    local qc = QuestList:getQuestCount()
    print("Quest count now " .. qc)
end

--Create the scene
function scene:create( event )
	local group = self.view

	print ("new_quest:createScene - New Quest Type=" .. newQuestType)
	
	local background = display.newImage("images/treasure-map.jpg") 
	-- background.x = display.contentWidth / 2
 -- 	background.y = display.contentHeight / 2
 	background.x = scrollView.width / 2
 	background.y = scrollView.height / 2
 	background:scale(0.8, 0.8)
 	background.alpha = 0.5
 	group:insert(background)
	
	-- Create title bar to go at the top of the screen
	local titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	titleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	scrollView:insert ( titleBar )
	-- create embossed text to go on toolbar
	local titleText = display.newEmbossedText( "New Quest", display.contentCenterX, titleBar.y, 
												native.systemFontBold, 20 )
	scrollView:insert ( titleText )

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
		onPress =  function() composer.gotoScene( "quests" ); end,
		x =  buttonWidth + rightPadding,
		y = titleBarHeight/2,
	}
	scrollView:insert(backButton)

	local isAndroid = "Android" == system.getInfo( "platformName" )
	local inputFontSize = 18

	if ( isAndroid ) then
	    inputFontSize = inputFontSize - 4
	end

	print ("new_quest:createScene - " , newQuestType)

	if (newQuestType == 'new') then 
		print ("new_quest:createScene - New Quest" )
		local questNameText = display.newText( { text = "Quest Name: ", 
										 x= leftPadding, y = yStart + inputFontSize * .5, 
										 font = native.systemFontBold, fontSize = inputFontSize
									   } )
		questNameText.anchorX = 0 -- left align
		questNameText:setFillColor( 1, 0, 0)
		group:insert( questNameText )


		local questDescText = display.newText( { text = "Description: ", 
										 x= leftPadding, y = yStart + inputFontSize * .5 + 30, 
										 font = native.systemFontBold, fontSize = inputFontSize
									   } )
		questDescText.anchorX = 0 -- left align
		questDescText:setFillColor( 1, 0, 0)
		scrollView:insert( questDescText )

		local questKeywordsText = display.newText( { text = "Keywords: ", 
										 x= leftPadding, y = yStart + inputFontSize * .5 + 230, 
										 font = native.systemFontBold, fontSize = inputFontSize
									   } )
		questKeywordsText.anchorX = 0 -- left align
		questKeywordsText:setFillColor( 1, 0, 0)
		scrollView:insert( questKeywordsText )
	else
		print ("new_quest:createScene - New Random Quest" )
		local questOverviewHeader = display.newText( { text = "Quest Overview", 
										 x= leftPadding, y = yStart + inputFontSize * .5, 
										 font = native.systemFontBold, fontSize = inputFontSize
									   } )
		questOverviewHeader.anchorX = 0 -- left align
		questOverviewHeader:setFillColor( 1, 0, 0)
		scrollView:insert( questOverviewHeader )
		local questDetailsHeader = display.newText( { text = "Quest Details", 
										 x= leftPadding, y = yStart + 100 + inputFontSize * .5 , 
										 font = native.systemFontBold, fontSize = inputFontSize
									   } )
		questDetailsHeader.anchorX = 0 -- left align
		questDetailsHeader:setFillColor( 1, 0, 0)
		scrollView:insert( questDetailsHeader )
	end

	local addButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Add",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress =  function() addQuest( ); composer.gotoScene( "quests" ); end,
		x =  buttonWidth + rightPadding,
		y = display.contentHeight - 100,
	}
	scrollView:insert(addButton)

	local randomQuestButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Random",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() update ( ); composer.gotoScene( "new_quest" ); end,
		scaleX = 0.2,
		isVisible = true,
		x = 130,
		y = display.contentHeight - 100,
	}
	scrollView:insert(randomQuestButton)

	group:insert(scrollView)

end

function scene:show( event )
	local group = self.view

	print("new_quest:show: newQuestType = ", newQuestType)

	if (newQuestType == 'new') then 
		-- Create text field
		questNameTF = native.newTextField( display.contentWidth - rightPadding, yStart + inputFontSize * 0.5, 150, tHeight)
		questNameTF:addEventListener( "userInput", textListener )
		questNameTF.placeholder = "Quest Name"
		questNameTF.anchorX = 1 -- right align

		-- Create text box
		questDescTB = native.newTextBox( display.contentWidth - rightPadding, 
											yStart + (tHeight * 5 * 0.5) + 60, 
											display.contentWidth - leftPadding - rightPadding, 
											tHeight * 5)
		questDescTB:addEventListener( "userInput", textListener )
		questDescTB.placeholder = "Add Notes Here"
		questDescTB.anchorX = 1 -- right align
		questDescTB.isEditable = true
		questDescTB.text = "Add quest notes here..."
	else
		newQuest = Randomizer:generateQuest()
		if (questGoodnessText ~= nil) then
			questGoodnessText:removeSelf()
			questDetailsText:removeSelf()
		end
		questGoodnessText = display.newText( { text = newQuest.description, 
										 x= leftPadding, y = yStart + 50 + inputFontSize * .5, 
										 font = native.systemFontBold, fontSize = inputFontSize +2
									   } )
		questGoodnessText.anchorX = 0 -- left align
		questGoodnessText:setFillColor( 0, 0, 0)
		group:insert( questGoodnessText )

		questDetailsText = display.newText( { text = newQuest.details, 
										 x= leftPadding, y = yStart + 150 + inputFontSize * .5, 
										 font = native.systemFontBold, fontSize = inputFontSize +2
									   } )
		questDetailsText.anchorX = 0 -- left align
		questDetailsText:setFillColor( 0, 0, 0)
		group:insert( questDetailsText )

	end
	
	-- native.setKeyboardFocus( questNameTF )
end

function scene:destroy( event )
	local group = self.view

	print("new_quest:destroy called")
	-- remove any native objects, since widget objects will be cleaned automatically, but native ones won't
	if questNameTF then
		questNameTF:removeSelf()
		questNameTF = nil
	end

	if questKeywords then
		questKeywords:removeSelf()
		questKeywords = nil
	end

	if questDescTB then
		questDescTB:removeSelf()
		questDescTB = nil
	end

	if questGoodnessText then
		questGoodnessText:removeSelf()
		questGoodnessText = nil
	end

	if questDetailsText then
		group.questDetailsText:removeSelf()
		questDetailsText = nil
	end
end


--Add the createScene listener
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
