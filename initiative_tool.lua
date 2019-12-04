-- 
-- Abstract: 4e DM Assistant app, Initiative Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to  

local composer = require ( "composer" )
--local composer = require ( "composer" )
local widget = require ( "widget" )
local initiative = require ( "initiative" )
local initList = require ( "InitiativeList")
local RandGenUtil = require ("RandGenUtil")

--Create a composer scene for this module
local scene = composer.newScene()

local titleBar, initBar, titleText, background, InitiativeListDisplay
local RoundTimeText, TurnTimeText

local initiatives = {}
initBarHeight = 40
initGradient = {
	type = 'gradient',
	color1 = { 51/255, 51/255, 51/255, 255/255 }, 
	color2 = { 5/255, 5/255, 5/255, 255/255 },
	direction = "down"
}

local roundTime = "0:00"

local popOptions =
{
    effect = "fade",
    time = 100,
    params =
        {
            sample_var = "anything parameter to send",
            theme = "another parameter to send",
            data = "another parameter to send"
        },
    isModal = true
}
local LEFT = 50
local CENTER = display.contentCenterX
local RIGHT = display.contentWidth - 50
local swipeDirection = ""




-- Keep track of time in seconds


--local clockText = display.newText("20:00", display.contentCenterX, 80, native.systemFontBold, 80)
--clockText:setFillColor( 0.7, 0.7, 1 )

local function updateTime()
	-- decrement the number of seconds
	roundTimeElapsed = roundTimeElapsed + 1
	turnTimeElapsed = turnTimeElapsed + 1
	
	-- time is tracked in seconds.  We need to convert it to minutes and seconds	
	local hours = math.floor( roundTimeElapsed / 3600 )
	local minutes = math.floor( roundTimeElapsed / 60 )
	local seconds = roundTimeElapsed % 60

	
	local timeDisplay = string.format( "Round Time: %02d:%02d", minutes, seconds )
	if roundTimeElapsed > 3600 then
		minutes = math.floor( roundTimeElapsed / 60 ) % 60
		timeDisplay = string.format( "Round Time: %02d:%02d", hours, minutes )	
	end

	hours = math.floor( turnTimeElapsed / 3600 )
	minutes = math.floor( turnTimeElapsed / 60 )
	seconds = turnTimeElapsed % 60

	local turnTimeDisplay = string.format( "Turn Time: %02d:%02d", minutes, seconds )


	if turnTimeElapsed > 3600 then
		minutes = math.floor( turnTimeElapsed / 60 ) % 60
		turnTimeDisplay = string.format( "Turn Time: %02d:%02d", hours, minutes )	
	end
	-- make it a string using string format.  
	
	if (RoundTimeText) then
		RoundTimeText.text = timeDisplay
	end
	if (TurnTimeText) then
		TurnTimeText.text = turnTimeDisplay
	end

end

-- run them timer
local countDownTimer = timer.performWithDelay( 1000, updateTime, roundTimeElapsed )



local function handleSwipe( event )
	--print ("handleSwipe event fired")
	local phase = event.phase
	--= event.target
	--print ("handleSwipe:phase=" .. phase)
	-- if ( phase == "swipeRight" ) then
	-- 	print ( "Swiped!!!!")
	-- 	InitiativeList:nextInitiative(); 
	-- 	composer.gotoScene( "initiative_tool" );
	-- 	return
	-- elseif ( phase == "swipeLeft") then
	-- 	InitiativeList:previousInitiative(); 
	-- 	composer.gotoScene( "initiative_tool" );
	-- 	return
	-- end
    if ( event.phase == "moved" ) then
        local dX = event.x - event.xStart
        --print( event.x, event.xStart, dX )
        if ( dX > 10 ) then
            --swipe right
            local spot = RIGHT
            if ( event.target.x == LEFT ) then
                spot = CENTER
            end
            --transition.to( event.target, { time=500, x=spot } )
            --print ("titlebar swiped right")
            swipeDirection = "swipeRight"
        elseif ( dX < -10 ) then
            --swipe left
            local spot = LEFT
            if ( event.target.x == RIGHT ) then
                spot = CENTER
            end
            --transition.to( event.target, { time=500, x=spot } )
            --print ("titlebar swiped right")
            swipeDirection = "swipeLeft"
        end
    elseif ( event.phase == "ended" ) then
    	print ("handleSwipe: " .. swipeDirection .. " detected")

    	if ( swipeDirection == "swipeRight" ) then
			print ( "Swiped!!!!")
			InitiativeList:nextInitiative(); 
			composer.gotoScene( "initiative_tool" );
			return
		elseif ( swipeDirection == "swipeLeft") then
			InitiativeList:previousInitiative(); 
			composer.gotoScene( "initiative_tool" );
			return
		end
    end
    return true
end



--Create the scene
function scene:create( event )
	print ("initiative_tool:scene:create")
	local group = self.view

	currentScene = "initiative_tool"

	roundTime = "0:00"

	
	background = display.newImage("images/dice01.jpg") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background:scale(1.0, 1.0)
 	background.alpha = 0.5
 	group:insert(background)

--	roundTimeElapsed = 3590
	
	-- Create title bar to go at the top of the screen
	titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	titleBar:setFillColor( titleGradient ) 
	group:insert ( titleBar )
	titleBar:addEventListener("touch", handleSwipe)

	-- create embossed text to go on toolbar
	titleText = display.newEmbossedText( "Roll Initiative!", display.contentCenterX, titleBar.y, 
												native.systemFontBold, 20 )
	group:insert ( titleText )

	-- Create Initiative Toolbar to go at the top of the Init screen
	initBar = display.newRect( display.contentCenterX, titleBarHeight + titleBarHeight/2, display.contentWidth, initBarHeight )
	initBar:setFillColor( initGradient ) 
	group:insert ( initBar )

	-- if (standalone == "false") then 
	-- local backButton = widget.newButton
	-- {
	-- 	defaultFile = "buttonRedSmall.png",
	-- 	overFile = "buttonRedSmallOver.png",
	-- 	labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
	-- 	label = "Back",
	-- 	emboss = true,
	-- 	onPress =  function() composer.gotoScene( "tools" ); end,
	-- 	x = buttonWidth + rightPadding,
	-- 	y = titleBarHeight/2,
	-- }
	-- group:insert(backButton)
	-- end

	local backButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "Back",
		emboss = true,
		onPress =  function() composer.gotoScene( "tools" ); end,
		x = buttonWidth + rightPadding,
		y = titleBarHeight/2,
	}
	group:insert(backButton)


	local addButton = widget.newButton
	{
		defaultFile = "buttonGreySquare.png",
		overFile = "buttonGreySquareOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "+",
		emboss = true,
		onPress =  function() print ("initiative_tool:add"); composer.showOverlay( "addInit", popOptions ); print ("finished calling initiative_tool:add"); end,
		x = squareButtonWidth + rightPadding,
		y = titleBarHeight + initBarHeight/2,
	}
	group:insert(addButton)


	local nextButton = widget.newButton
	{
		defaultFile = "buttonGreySquare.png",
		overFile = "buttonGreySquareOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "->",
		emboss = true,
		onPress = function() print ("initiative_tool:next"); InitiativeList:nextInitiative(); composer.gotoScene( "initiative_tool" ); end,
		x = squareButtonWidth + rightPadding + squareButtonWidth*2 + rightPadding*2,
		y = titleBarHeight + initBarHeight/2,
	}
	group:insert(nextButton)

	local delayButton = widget.newButton
	{
		defaultFile = "buttonGreySmall.png",
		overFile = "buttonGreySmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "Delay",
		emboss = true,
		onPress =  function() print ("initiative_tool:delay"); composer.showOverlay( "delayInit", popOptions ); end,
		x = squareButtonWidth + rightPadding + squareButtonWidth + rightPadding + buttonWidth*2 + rightPadding,
		y = titleBarHeight + initBarHeight/2,
	}
	group:insert(delayButton)

	local resetButton = widget.newButton
	{
		defaultFile = "buttonGreySmall.png",
		overFile = "buttonGreySmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "Reset",
		emboss = true,
		onPress =  function() print ("initiative_tool:reset"); composer.showOverlay( "resetInit", popOptions ); end,
		x = squareButtonWidth + rightPadding + squareButtonWidth*2 + rightPadding*2 + 
			buttonWidth + rightPadding*2 + buttonWidth*2 + rightPadding*2,
		y = titleBarHeight + initBarHeight/2,
	}
	group:insert(resetButton)

end



 


-- Hande row touch events
local function onRowTouch( event )
	print ("onRowTouch event caught: " .. event.phase)
	local phase = event.phase
	local row = event.target
	
	if ( phase == "swipeRight" ) then
		print ( "Swiped!!!!")
		InitiativeList:nextInitiative(); 
		composer.gotoScene( "initiative_tool" );
		return
	elseif ( phase == "swipeLeft") then
		InitiativeList:previousInitiative(); 
		composer.gotoScene( "initiative_tool" );
		return
	end

	if (row.index == nil) then
		ri = -1
		return
	else
		ri = row.index
	end
	print( "Touched row: " .. ri )
	if "press" == phase then
		print( "Pressed row: " .. ri )
		--print ( "x0 = " .. event.xStart )
	elseif "release" == phase then
		if ri -1 <= 1+InitiativeList:getInitiativeCount() then
			composer.showOverlay( "addInit", { params = { initNumber = ri-1, } })
		else
			print ("storyboard.showOverlay( { params = { initNumber = " .. ri-1 .. ", } })")
		end
		print( "Tapped and/or Released row: " .. ri )
	end
end




-- Handle row rendering
local function onRowRender( event )
	print ("  Rendering Row ")
	local phase = event.phase
	local row = event.row
	local id = row.index
	
	local groupContentHeight = row.contentHeight

	local params = row.params


	if params.roundMarker  then
		print ("Rendering Row Marker!")
		row.nameText = display.newEmbossedText( " --== Round " .. params.roundMarker .. " End ==--" , 12, 0, native.systemFontBold, 10 )
		row.nameText.anchorY = 0.5
		row.nameText:setFillColor( 0,0,0 )
		row.nameText.y = 19
		row.nameText.x = row.contentWidth/2
		row:insert( row.nameText )
		return true
	end

	row.nameText = display.newEmbossedText( params.name, 12, 0, native.systemFontBold, 16 )
	row.nameText.anchorX = 0
	row.nameText.anchorY = 0.5
	row.nameText:setFillColor( 0 )
	row.nameText.y = 19

	--if params.initSlot then
		print ("initSlot= " .. params.initSlot)
		row.orderText = display.newEmbossedText( params.initSlot, 12, 0, native.systemFontBold, 16 )
		row.orderText.anchorX = 0
		row.orderText.anchorY = 0.5
		row.orderText:setFillColor( 0 )
		row.orderText.y = 19
	--end

	if params.isHeader == true then
		print ("Header row")
		row.initText = display.newEmbossedText( params.initVal, 12, 0, native.systemFont, 16 )
		row.nameText:setFillColor( 0 )
		row.initText:setFillColor( 0 )

	else
		local initStr = ((params.initVal or 0) + (params.initBon or 0)).. " (" .. (params.initVal or 0) .. "+" .. (params.initBon or 0) .. ")"
		row.initText = display.newEmbossedText( initStr, 12, 0, native.systemFont, 14 )

		row.rightArrow = display.newImageRect( "rowArrow.png", 15 , 10, 10 )
		row.rightArrow.x = display.contentWidth - 20
		row.rightArrow.y = 19
		row:insert( row.rightArrow )
		if (params.iType == "enemy") then
			row.nameText:setFillColor( .75,.13,.13 )
			row.initText:setFillColor( .75,.13,.13 )
		else
			row.nameText:setFillColor( .13,.45,.13 )
			row.initText:setFillColor( .13,.45,.13 )
		end
	end

	row.initText.anchorX = 0
	row.initText.anchorY = 0.5
	row.initText.y = 19
	if ( system.orientation == "portrait") or (system.orientation == "portraitUpsideDown") then
		row.initText.x =  240
		row.nameText.x = 60
		row.orderText.x = 20
		if params.isHeader == true then
			row.orderText.x = 5
		end
	else
		row.initText.x =  340
		row.nameText.x = 220
		row.orderText.x = 160
		if params.isHeader == true then
			row.orderText.x = 145
		end
	end
	
	if row.initSlot then 
		row:insert( row.orderText )
	end
	row:insert( row.orderText )
	row:insert( row.nameText )
	row:insert( row.initText )
	return true

	
	
end



function scene:show( event )
	local group = self.view

	print("initiative_tool: scene:show")



	background:scale(1.0, 1.0)

	if (InitiativeListDisplay) then
		InitiativeListDisplay:removeSelf()
		InitiativeListDisplay = nil
	end

	

	--InitiativeListDisplay:addEventListener("touch", handleSwipe)
	InitiativeListDisplay = widget.newTableView
	{
		top = titleBarHeight + initBarHeight,
--		width = 320, 
--		height = 410,
		hideBackground = true,
		maskFile = "mask-320x448.png",
		onRowRender = onRowRender,
		onRowTouch = onRowTouch,
	}
	

	InitiativeList:loadInitiative()
	InitiativeList:sortInitiativesBySlot( )
	InitiativeList:orderInitiatives( )
 	local cc = InitiativeList:getInitiativeCount()


	InitiativeListDisplay:insertRow
	{
		height = 24,
		rowColor = { default={ 0.8, 0.8, 0.8, 0.8 } },
		lineColor = { 0.5, 0.5, 0.5 },
		params = { isHeader = true, name = "Name", initVal = "Init", initSlot = "Order", initBon = "", iType="", initBonusSaved="" },
		isCategory = true
	}

 	for i = 1, cc do
		showInitiative(i)
 	end


 	roundNum = InitiativeList:getRoundNumber()


	--todo
	
	if RoundTimeText then
		RoundTimeText.text = ""
		--RoundTimeText = nil
	end
	if TurnTimeText then
		TurnTimeText.text = ""
	end

 	if (initiativeFoundText) then
 		initiativeFoundText.text = ""
 		--initiativeFoundText = nil
 	end
	if RoundNumberText then
		RoundNumberText.text = ""
		--RoundNumberText = nil
	end

	
	
	print( "Current Orientation: " .. system.orientation )
	if ( system.orientation == "portrait") or (system.orientation == "portraitUpsideDown") then
		print "portrait"
		rntx = display.contentCenterX
		rnty = display.contentHeight - 10
		titleBar.x = display.contentCenterX
		titleBar.width = display.contentWidth

		initBar.x = display.contentCenterX
		initBar.width =  display.contentWidth
		titleText.x = display.contentCenterX
	else
		print "landscape"
		rntx = 100
		rnty = 100
		
		titleBar.x = display.contentCenterX - 50
		titleBar.width = display.contentWidth - 100

		initBar.x = display.contentCenterX -100
		initBar.width =  display.contentWidth -50
		titleText.x = display.contentCenterX -50

		InitiativeListDisplay.width=320
		InitiativeListDisplay.height=display.contentHeight
		InitiativeListDisplay.y = display.contentCenterY
		InitiativeListDisplay.x = display.contentWidth - 160
		initBar.width = display.contentWidth - 320
		initBar.x = (display.contentWidth - 320)/2

		titleBar.width = display.contentWidth - 320
		titleBar.x = (display.contentWidth - 320)/2
		titleText.x = (display.contentWidth - 320)/2
	end
	
	RoundTimeText = display.newText("Round Time: ".. roundTime, rntx, rnty+30, native.systemFontBold, 16 )
	RoundTimeText:setFillColor( 1, 0, 0)
	TurnTimeText = display.newText("Turn Time: ".. roundTime, rntx, rnty+60, native.systemFontBold, 16 )
	TurnTimeText:setFillColor( 1, 0, 0)

	RoundNumberText = display.newText("Round: "..roundNum, rntx, rnty, native.systemFontBold, 16 )
	RoundNumberText:setFillColor( 1, 0, 0)
	group:insert( RoundNumberText )
	group:insert( RoundTimeText)
	group:insert( TurnTimeText)
	group:insert( InitiativeListDisplay )



	-- for i = 1, 50 do
	-- 	entityName = RandGenUtil.generateAdversary()
	-- 	--print("Random: " .. entityName)
	-- end
end




function scene:hide( event )
	print ("initiative_tool: scene:hide started")
	local group = self.view

	if InitiativeListDisplay then
		InitiativeListDisplay:removeSelf()
		InitiativeListDisplay = nil
	end
	if RoundNumberText then
		RoundNumberText:removeSelf()
		RoundNumberText = nil
	end
	if RoundTimeText then
		RoundTimeText:removeSelf()
		RoundTimeText = nil
	end
if TurnTimeText then
		TurnTimeText:removeSelf()
		TurnTimeText = nil
	end

 	if (initiativeFoundText) then
 		initiativeFoundText:removeSelf()
 		--initiativeFoundText = nil
 	end


	print("initiative_tool: scene:hide finished")
end	


--Add the initiative at i to the InitiativeListDisplay in the scene
function showInitiative( i )
	print ("initiative_tool:showInitiative() called")

	local init = InitiativeList:getOffsetInitiative( i )
	if init then
		print ("INSERT ROW CALLED")
		InitiativeListDisplay:insertRow
		{
			height = 24,
			rowColor = 
			{ 
				default = { 1, 1, 1, 0 },
			},
			lineColor = { 0.5, 0.5, 0.5 },
			params = { name = init.name, initVal = init.initVal, initBon = init.initBon, iType = init.iType, initSlot = init.initSlot or 0, initBonusSaved=""}
		}
	else 
		print ("error finding initiative " .. i)
	end
	if InitiativeList:isLast(i) then
		print ("-== round ".. InitiativeList:getRoundNumber() .. " boundary ==-")
		InitiativeListDisplay:insertRow
		{
			height = 6,
			rowColor = 
			{ 
				default = { 1, 1, 1, 0},
			},
			lineColor = { 0.5, 0.5, 0.5 },
			params = { isHeader = true, roundMarker = InitiativeList:getRoundNumber() },
			isCategory = true
		}
	end
end



--Create a new initiative
function createInitiative()	
	print ("initiative_tool:createInitiative() called")
	rand = math.random( 100 )
	local newInitiative = initiative.new("initiative"..rand)
	InitiativeListDisplay:insertRow
	{
		height = 24,
		rowColor = 
		{ 
			default = { 1, 1, 1, 0 },
		},
		isCategory = false,
		lineColor = { 0.5, 0.5, 0.5 },
		listener = onRowTouch,
		params = { name = newInitiative.name }
	}
	return newInitiative
end


-- JTW: 2/4/16: this is the problem...overlayBegan/Ended are deprecated
-- see docs for change
function scene:overlayBegan( event )
   print( "The overlay scene is showing: " .. event.sceneName )
   print( "We get custom params too! " .. event.params.sample_var )
end

function scene:overlayEnded( event )
   print( "The following overlay scene was removed: " .. event.sceneName )
	if (event.sceneName == "delayInit") then
   		InitiativeList:sortInitiativesBySlot( )
	else
   		InitiativeList:sortInitiatives( )
	end
   
   	InitiativeList:orderInitiatives( )
   
   --brute force a refresh of the list
   composer.gotoScene( "initiative_tool" )
end
-- / JTW:


--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

--scene:addEventListener( "overlayBegan" )
--scene:addEventListener( "overlayEnded" )

return scene
