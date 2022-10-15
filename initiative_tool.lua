-- 
-- GameMastery, Initiative Screen
--  
--

local composer = require ( "composer" )
local widget = require ( "widget" )
local initiative = require ( "initiative" )
local initList = require ( "InitiativeList")
local RandGenUtil = require ("RandGenUtil")

local addInit = require ("addInit")
local delayInit = require ("delayInit")

--Create a composer scene for this module
local scene = composer.newScene()

-- local background
local titleText, InitiativeListDisplay
local RoundTimeText, TurnTimeText

local navGroup
local overlayGroup

-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist

local initListRowHeight = 40
local initListHeight = initListRowHeight*14
local initListRect

local initiatives = {}
initialYOffset = 40
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
	local phase = event.phase
    if ( event.phase == "moved" ) then
        local dX = event.x - event.xStart
        --print( event.x, event.xStart, dX )
        if ( dX > 10 ) then
            --swipe right
            local spot = RIGHT
            if ( event.target.x == LEFT ) then
                spot = CENTER
            end
             swipeDirection = "swipeRight"
        elseif ( dX < -10 ) then
            --swipe left
            local spot = LEFT
            if ( event.target.x == RIGHT ) then
                spot = CENTER
            end
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

local function addInitiativeReturned()
	print("addInitiativeReturned called")
	composer.gotoScene("initiative_tool")
end

local function delayInitiativeReturned()
	print("delayInitiativeReturned called")
	composer.gotoScene("initiative_tool")
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
		print( "Released row: " .. ri )
		if ri -1 <= 1+initList:getInitiativeCount() then
			--composer.showOverlay( "addInit", { params = { initNumber = ri-1, } })
			addInit.openAddInitDialog( overlayGroup, { initNumber = ri-1, iOffset = row.params.iOffset }, addInitiativeReturned); 
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
		row.nameText = ssk.easyIFC:presetLabel( group, "appLabel", " --== Round " .. params.roundMarker .. " End ==--", 
			row.contentWidth/2, 19, {align="left", width=260})
		row:insert( row.nameText )
		return true
	end

	row.nameText = ssk.easyIFC:presetLabel( group, "appLabel", params.name, 30, 19, {align="left", width=160, anchorX=0})

	print ("initSlot= " .. params.initSlot)
	row.orderText = ssk.easyIFC:presetLabel( group, "appLabel", params.initSlot, 30, 19, {align="left", width=60, anchorX=0})

	if params.isHeader == true then
		print ("Header row")
		row.initText = display.newEmbossedText( params.initVal, 12, 0, mainFont, mainFontSize )
		row.nameText:setFillColor( 0 )
		row.initText:setFillColor( 0 )

	else
		local initStr = ((params.initVal or 0) + (params.initBon or 0)).. " (" .. (params.initVal or 0) .. "+" .. (params.initBon or 0) .. ")"
		row.initText = ssk.easyIFC:presetLabel( group, "appLabel", initStr, 240, 19, {align="left", width=100, anchorX=0})
		-- row.initText = display.newEmbossedText( initStr, 12, 0,  mainFont, mainFontSize )

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


--Create the scene
function scene:create( event )
	print ("initiative_tool:scene:create")
	local group = self.view

	currentScene = "initiative_tool"

	roundTime = "0:00"

	initListRect = ssk.display.newRect( group, display.contentWidth / 2, 30+titleBarHeight + initialYOffset + initListHeight/2, 
			{ w = fullw, h = initListHeight, alpha=.2, fill = _GREY_ } )
	

	
end




function scene:show( event )
	local group = self.view


	print("initiative_tool: scene:show")
	if event.phase == "will" then
		print(currentScene .. ":SHOW WILL PHASE")


		

		InitiativeList:loadInitiative()
		if InitiativeList:getInitiativeCount() > 11 then 
			print("Initiative Limit Reached")
			ssk.easyIFC:presetPush( group, "disabledAppButton", 30 + rightPadding,  titleBarHeight + titleBarHeight/2, 60, 30, "Add New", 
				--function() print ("initiative_tool:add"); composer.showOverlay( "addInit", popOptions ); print ("ƒ calling initiative_tool:add"); end,
				 -- function() print("Inititive_tool:add"); addInit.openDialog( overlayGroup, addInitiativeReturned); end,
				 nil, {labelHorizAlign="center", labelSize=12} )
		else
			print("Initiative Count is " .. tostring(InitiativeList:getInitiativeCount()) )
		

			ssk.easyIFC:presetPush( group, "appButton", 30 + rightPadding,  titleBarHeight + titleBarHeight/2, 60, 30, "Add New", 
				--function() print ("initiative_tool:add"); composer.showOverlay( "addInit", popOptions ); print ("ƒ calling initiative_tool:add"); end,
				 function() print("Inititive_tool:add"); addInit.openDialog( overlayGroup, addInitiativeReturned); end,
				 {labelHorizAlign="center", labelSize=12} )
		end

		ssk.easyIFC:presetPush( group, "appButton", (display.contentWidth / 2) - 35, titleBarHeight + titleBarHeight/2, 60, 30, "Next", 
				function() print ("initiative_tool:next"); InitiativeList:nextInitiative(); composer.gotoScene( "initiative_tool" ); end,
				{labelHorizAlign="center", labelSize=12} )


		ssk.easyIFC:presetPush( group, "appButton", (display.contentWidth / 2) + 35,  titleBarHeight + titleBarHeight/2, 60, 30, "Delay", 
				--function() print ("initiative_tool:delay"); composer.showOverlay( "delayInit", popOptions ); end,
				function() print ("initiative_tool:delay"); delayInit.openDialog( overlayGroup, delayInitiativeReturned); end,
				{labelHorizAlign="center", labelSize=12} )


		ssk.easyIFC:presetPush( group, "appButton", fullw - (30 + rightPadding),  titleBarHeight + titleBarHeight/2, 60, 30, "Reset", 
				function() print ("initiative_tool:reset"); composer.showOverlay( "resetInit", popOptions ); end,
				{labelHorizAlign="center", labelSize=12} )



		if (InitiativeListDisplay) then
			InitiativeListDisplay:removeSelf()
			InitiativeListDisplay = nil
		end


		InitiativeListDisplay = widget.newTableView
		{
			--top = 12+titleBarHeight + initialYOffset,
			--isLocked=true,
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
			isCategory = false
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
			InitiativeListDisplay.x = display.contentCenterX
			InitiativeListDisplay.y = 150+titleBarHeight + initialYOffset + initListHeight/2
			InitiativeListDisplay.height=initListHeight+220
		else
			print "landscape"
			rntx = 100
			rnty = 100
			
			InitiativeListDisplay.width=320
			InitiativeListDisplay.height=initListHeight
			InitiativeListDisplay.y = display.contentCenterY
			InitiativeListDisplay.x = display.contentWidth - 160
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

		-- local t = InitiativeListDisplay:getRowAtIndex(2) -- top row showing
		-- print("top row index is: " .. t.index)
		--InitiativeListDisplay:scrollToIndex( 1, 0 )

		
		
		overlayGroup = display.newGroup(); 
		overlayGroup.x=display.viewableContentWidth/2
		overlayGroup.y=display.viewableContentHeight/2
		group:insert(overlayGroup)
		

		if navGroup then navGroup:removeSelf() end
		navGroup = display.newGroup(group)

		local backBtn = widget.newButton(
	    {   
	        label = "Back", font=btnFont, fontSize=btnFontSize, emboss = false,
	        shape = "circle", radius = 50*0.9, cornerRadius = 2, strokeWidth = 4,
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
	        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
	        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
	        onPress = function()  composer.gotoScene("tools", { effect = "fade", time = 400, params = {campaign = currentCampaign}}) end,
	    	x = 60,
	      	y = display.contentHeight-60
	    })
	    navGroup:insert(backBtn)

	else
		print( currentScene .. ":SHOW DID PHASE")
	end
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

 	-- if initListRect then
 	-- 	initListRect:removeSelf()
 	-- 	initListRect = nil
 	-- end
 	if navGroup then
 		navGroup:removeSelf()
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
			params = { iOffset = i, name = init.name, initVal = init.initVal, initBon = init.initBon, iType = init.iType, initSlot = init.initSlot or 0, initBonusSaved=""}
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
				default = { 1, 1, 1, 1},
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
