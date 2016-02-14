-- 
-- Abstract: 4e DM Assistant app, Campaigns Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to display the corresponding screen content when the user clicks the tab bar. 

--local storyboard = require ( "storyboard" )
local storyboard = require ( "composer" )
local widget = require ( "widget" )
local campaign = require ( "campaign" )
CampaignList = require ("CampaignList")


--Create a storyboard scene for this module
local scene = storyboard.newScene()

local campaignsFoundText, campaignListDisplay
local LEFT_PADDING = 10
local centerX = display.contentCenterX
local centerY = display.contentCenterY

local widgetGroup = display.newGroup()

local backButton
-- local itemSelected = display.newText( "You selected", 0, 0, native.systemFontBold, 24 )
-- itemSelected:setFillColor( 0 )
-- itemSelected.x = display.contentWidth + itemSelected.contentWidth * 0.5
-- itemSelected.y = display.contentCenterY
-- widgetGroup:insert( itemSelected )


--Handle the back button release event
local function onBackRelease()
	--Transition in the list, transition out the item selected text and the back button

	-- The table x origin refers to the center of the table in Graphics 2.0, so we translate with half the object's contentWidth
	transition.to( campaignListDisplay, { x = campaignListDisplay.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
	transition.to( campaignsFoundText, { x = campaignsFoundText.contentWidth, time = 400, transition = easing.outExpo } )
	-- transition.to( itemSelected, { x = display.contentWidth + itemSelected.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
	transition.to( backButton, { alpha = 0, time = 400, transition = easing.outQuad } )
	-- transition.to( newCampaignButton, { x = newCampaignButton.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
	
end


--Create the scene
function scene:create( event )
	local group = self.view

	print("campaigns:createScene")
	
	local background = display.newImage("images/world-map.jpg") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background:scale(0.8, 0.8)
 	background.alpha = 0.5
 	group:insert(background)
	
	--Create the back button
	backButton = widget.newButton
	{
		width = 298,
		height = 56,
		label = "Back", 
		labelYOffset = - 1,
		onRelease = onBackRelease
	}
	backButton.alpha = 0
	backButton.x = display.contentCenterX
	backButton.y = display.contentHeight - backButton.contentHeight
	widgetGroup:insert( backButton )


	--Create a text object that displays the current scene name and insert it into the scene's view
	-- local screenText = display.newText( "Campaign", centerX, 50, native.systemFontBold, 18 )
	-- screenText:setFillColor( 1, 0, 0 )
	-- group:insert( screenText )
-- 	screenText.x = display.contentWidth / 2 - 210;
--	screenText.y = display.contentHeight - 20;


	
	-- Create title bar to go at the top of the screen
	local titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	titleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( titleBar )
	-- create embossed text to go on toolbar
	local titleText = display.newEmbossedText( "Campaigns", display.contentCenterX, titleBar.y, 
												native.systemFontBold, 20 )
	group:insert ( titleText )
	
	local newCampaignButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Add",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress = function() storyboard.gotoScene( "new_campaign" ); end,
		scaleX = 0.2,
		isVisible = true,
		x = display.contentWidth - buttonWidth - leftPadding,
		y = titleBarHeight/2,
	}
	group:insert(newCampaignButton)
end



-- Hande row touch events
local function onRowTouch( event )
	print ("onRowTouch event caught")
	local phase = event.phase
	local row = event.target
	
	if "press" == phase then
		print( "Pressed row: " .. row.index )

	elseif "release" == phase then
		-- Update the item selected text
		local c = CampaignList:getCampaign( row.index )
		-- itemSelected.text = c.name
		 
		CampaignList:setCurrentCampaignIndex( row.index )
		
		--Transition out the list, transition in the item selected text and the back button
		storyboard.gotoScene( "campaign_details" )

		-- The table x origin refers to the center of the table in Graphics 2.0, so we translate with half the object's contentWidth
		-- transition.to( campaignListDisplay, { x = - campaignListDisplay.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
		-- transition.to( campaignsFoundText, { x = - campaignsFoundText.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
		-- transition.to( itemSelected, { x = display.contentCenterX, time = 400, transition = easing.outExpo } )
		-- transition.to( backButton, { alpha = 1, time = 400, transition = easing.outQuad } )
		-- transition.to( newCampaignButton, { x = - newCampaignButton.contentWidth * 0.5, time = 400, transition = easing.outExpo } )
		
		print( "Tapped and/or Released row: " .. row.index )
	end
end


-- Handle row rendering
local function onRowRender( event )
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
		rowTitle = display.newText( row, "Campaign " .. row.index, 0, 0, native.systemFontBold, 16 )
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




function scene:show( event )
	local group = self.view

	print("campaigns:enterScene")
	-- Create a tableView
	campaignListDisplay = widget.newTableView
	{
		top = 38,
		width = 320, 
		height = 448,
		hideBackground = true,
		maskFile = "mask-320x448.png",
		onRowRender = onRowRender,
		onRowTouch = onRowTouch,
	}


	--if ( #campaigns == 0 ) then
	--	for i = 1, 5 do
	--		campaigns[i] = createCampaign()
	--	end
	--end
	CampaignList:loadCampaigns()
	
 	local cc = CampaignList:getCampaignCount()

 	for i = 1, cc do
		showCampaign(i)
 	end

	campaignsFoundText = display.newText(cc.." Campaigns found.", centerX, display.contentHeight - 100, native.systemFontBold, 16 )
	campaignsFoundText:setFillColor( 1, 0, 0)
	group:insert( campaignsFoundText )
	group:insert( campaignListDisplay )
end

function scene:destroy( event )
	local group = self.view

	if campaignListDisplay then
		campaignListDisplay:removeSelf()
		campaignListDisplay = nil
	end
	if campaignsFoundText then
		campaignsFoundText:removeSelf()
		campaignsFoundText = nil
	end
	print("campaigns:exitScene")
end	

function showCampaign( i )

	local c = CampaignList:getCampaign( i )
	campaignListDisplay:insertRow
	{
		height = 72,
		rowColor = 
		{ 
			default = { 1, 1, 1, 0 },
		},
		lineColor = { 0.5, 0.5, 0.5 },
		params = { name = c.name }
	}
end

function createCampaign()	
	rand = math.random( 100 )
	local newCampaign = campaign.new("campaign"..rand)
	campaignListDisplay:insertRow
	{
		height = 72,
		rowColor = 
		{ 
			default = { 1, 1, 1, 0 },
		},
		isCategory = false,
		lineColor = { 0.5, 0.5, 0.5 },
		listener = onRowTouch,
		params = { name = newCampaign.name }
	}
	return newCampaign
end




--Insert widgets/images into a group



--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )

return scene
