-- 
-- Abstract: 4e DM Assistant app, Initiative Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to  

local storyboard = require ( "storyboard" )
local widget = require ( "widget" )
local initiative = require ( "initiative" )
local initList = require ( "InitiativeList")

--Create a storyboard scene for this module
local scene = storyboard.newScene()


local text1, text2

local centerX = display.contentCenterX
local centerY = display.contentCenterY

local initiatives = {}
local LEFT_PADDING = 10
initBarHeight = 40
initGradient = {
	type = 'gradient',
	color1 = { 51/255, 51/255, 51/255, 255/255 }, 
	color2 = { 5/255, 5/255, 5/255, 255/255 },
	direction = "down"
}


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

--Create the scene
function scene:createScene( event )
	local group = self.view
	
	local background = display.newImage("images/swords01.jpg") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 1.3
 	background:scale(0.8, 0.8)
 	background.alpha = 0.5
 	group:insert(background)
	
	-- Create title bar to go at the top of the screen
	local titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	titleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( titleBar )
	-- create embossed text to go on toolbar
	local titleText = display.newEmbossedText( "Initiative", display.contentCenterX, titleBar.y, 
												native.systemFontBold, 20 )
	group:insert ( titleText )

	-- Create Initiative Toolbar to go at the top of the Init screen
	local initBar = display.newRect( display.contentCenterX, titleBarHeight + titleBarHeight/2, display.contentWidth, initBarHeight )
	initBar:setFillColor( initGradient ) 
	group:insert ( initBar )


	local backButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "Back",
		emboss = true,
		onPress =  function() storyboard.gotoScene( "tools" ); end,
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
		onPress =  function() storyboard.showOverlay( "addInit", popOptions ); end,
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
		onPress = function() InitiativeList:nextInitiative(); storyboard.gotoScene( "initiative_tool" ); end,
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
		onPress =  function() storyboard.showOverlay( "delayInit", popOptions ); end,
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
		onPress =  function() storyboard.showOverlay( "resetInit", popOptions ); end,
		x = squareButtonWidth + rightPadding + squareButtonWidth*2 + rightPadding*2 + 
			buttonWidth + rightPadding*2 + buttonWidth*2 + rightPadding*2,
		y = titleBarHeight + initBarHeight/2,
	}
	group:insert(resetButton)

end

-- Hande row touch events
local function onRowTouch( event )
	print ("onRowTouch event caught")
	local phase = event.phase
	local row = event.target
	print( "Touched row: " .. row.index )

	if "press" == phase then
		print( "Pressed row: " .. row.index )

	elseif "release" == phase then
		if row.index -1 <= InitiativeList:getInitiativeCount() then
			storyboard.showOverlay( "addInit", { params = { initNumber = row.index-1, } })
		end
		print( "Tapped and/or Released row: " .. row.index )
	end
end


-- Handle row rendering
local function onRowRender( event )
	local phase = event.phase
	local row = event.row
	local id = row.index
	
	local groupContentHeight = row.contentHeight

	local params = row.params
   	--row.bg = display.newRect( 0, 0, display.contentWidth, 38 )
   	--row.bg.anchorX = 0
	--row.bg.anchorY = 0
	--row.bg:setFillColor( 1, 1, 1 )
	--row:insert( row.bg )


	if params.roundMarker  then
		print ("Rendering Row Marker!")
		row.nameText = display.newEmbossedText( " --== Round " .. params.roundMarker .. " End ==--" , 12, 0, native.systemFontBold, 10 )
		--row.nameText.anchorX = 0
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
	row.nameText.x = 100

	if params.isHeader == true then
		print ("Header row")
		row.initText = display.newEmbossedText( params.initVal, 12, 0, native.systemFont, 16 )
		row.nameText:setFillColor( 0 )
		row.initText:setFillColor( 0 )
	else
		local initStr = (params.initVal + params.initBon) .. " (" .. params.initVal .. "+" .. params.initBon .. ")"
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
	row.initText.x = 10
	

	row:insert( row.nameText )
	row:insert( row.initText )
	return true
	
end



function scene:enterScene( event )
	local group = self.view

	print("initiatives:enterScene")
	-- Create a tableView
	InitiativeListDisplay = widget.newTableView
	{
		top = titleBarHeight + initBarHeight,
		width = 320, 
		height = 410,
		hideBackground = true,
		maskFile = "mask-320x448.png",
		onRowRender = onRowRender,
		onRowTouch = onRowTouch,
	}


	InitiativeListDisplay:insertRow
	{
		height = 24,
		rowColor = { default={ 0.8, 0.8, 0.8, 0.8 } },
		lineColor = { 0.5, 0.5, 0.5 },
		params = { isHeader = true, name = "Name", initVal = "Init"  },
		isCategory = true
	}

	InitiativeList:loadInitiative()
	InitiativeList:sortInitiatives( )
 	local cc = InitiativeList:getInitiativeCount()

 	for i = 1, cc do
		showInitiative(i)
 	end

 	roundNum = InitiativeList:getRoundNumber()
	initiativeFoundText = display.newText("Round: "..roundNum, centerX, display.contentHeight - 70, native.systemFontBold, 16 )
	initiativeFoundText:setFillColor( 1, 0, 0)
	group:insert( initiativeFoundText )
	group:insert( InitiativeListDisplay )
end

function scene:exitScene( event )
	local group = self.view

	if InitiativeListDisplay then
		InitiativeListDisplay:removeSelf()
		InitiativeListDisplay = nil
	end
	if initiativeFoundText then
		initiativeFoundText:removeSelf()
		initiativeFoundText = nil
	end
	print("initiative:exitScene")
end	

function showInitiative( i )

	local c = InitiativeList:getOffsetInitiative( i )
	if c then
		InitiativeListDisplay:insertRow
		{
			height = 24,
			rowColor = 
			{ 
				default = { 1, 1, 1, 0 },
			},
			lineColor = { 0.5, 0.5, 0.5 },
			params = { name = c.name, initVal = c.initVal, initBon = c.initBon, iType = c.iType }
		}
	else 
		print ("error finding initiative " .. i)
	end
	if InitiativeList:isLast(i) then
		print ("-- round boundary --")
		InitiativeListDisplay:insertRow
		{
			height = 6,
			rowColor = 
			{ 
				default = { 1, 1, 1, 0},
			},
			lineColor = { 0.5, 0.5, 0.5 },
			params = { isHeader = true, roundMarker = InitiativeList:getRoundNumber() }
		}
	end
end

function createInitiative()	
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

function scene:overlayBegan( event )
   print( "The overlay scene is showing: " .. event.sceneName )
   --print( "We get custom params too! " .. event.params.sample_var )
end

function scene:overlayEnded( event )
   print( "The following overlay scene was removed: " .. event.sceneName )
   InitiativeList:sortInitiatives( )
   
   --brute force a refresh of the list
   storyboard.gotoScene( "initiative_tool" )
end

--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "createScene", scene )
scene:addEventListener( "enterScene", scene )
scene:addEventListener( "exitScene", scene )

scene:addEventListener( "overlayBegan" )
scene:addEventListener( "overlayEnded" )

return scene
