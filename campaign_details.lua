-- 
-- Abstract: 4e DM Assistant app, Campaign Details Screen
--  
-- Version: 2.0
-- 
--

local composer = require ( "composer" )
local widget = require ( "widget" )
CampaignList = require ("CampaignList")

local scene = composer.newScene()

local campaignNameText, campaignDescriptionText, questListDisplay, campaignKeywordsHeaderText, campaignKeywordsText
local currentCampaign
local centerX = display.contentCenterX
local centerY = display.contentCenterY

-- Create title bar to go at the top of the screen
local titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
local titleText = display.newEmbossedText( "Campaign Details", display.contentCenterX, titleBar.y, 
											native.systemFontBold, 20 )

--Create the scene
function scene:create( event )
	local group = self.view
	print("Entered campaign_details scene")
	-- currentCampaign = CampaignList:getCampaign( i )

	local background = display.newImage("images/world-map.jpg") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background:scale(0.9,0.8)
 	background.alpha = 0.5
 	group:insert(background)

	titleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( titleBar )
	-- create embossed text to go on toolbar
	group:insert ( titleText )

	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0

	local backButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Back",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress =  function() composer.gotoScene( "campaigns" ); end,
		x =  buttonWidth + rightPadding,
		y = titleBarHeight/2,
	}
	group:insert(backButton)
 	
end


function scene:show( event )
	local group = self.view

	print("campaign_details:show")

	local i = CampaignList:getCurrentCampaignIndex()
	if (i==-1) then
		i=1
		print ("Setting current campaign from -1 to 1")
	end

	print ("Current campaign number=" .. i)
	currentCampaign = CampaignList:getCurrentCampaign()

	titleText.text = currentCampaign.name
	if campaignNameText then
		campaignNameText:removeSelf()
	end
	campaignNameText = display.newText(currentCampaign.name, centerX, 50, native.systemFontBold, 16 )
	campaignNameText:setFillColor( 1, 0, 0)
	group:insert( campaignNameText )

	if campaignDescriptionText then
		campaignDescriptionText:removeSelf()
	end
	campaignDescriptionText = display.newText(currentCampaign.description, centerX, 70, native.systemFontBold, 16 )
	campaignDescriptionText:setFillColor( 0, 0, 0)
	group:insert( campaignDescriptionText )

	if campaignKeywordsHeaderText then
		campaignKeywordsHeaderText:removeSelf()
	end
	campaignKeywordsHeaderText = display.newText('Keywords: ', rightPadding, 90, native.systemFontBold, 16 )
	campaignKeywordsHeaderText:setFillColor( 0, 0, 0)
	campaignKeywordsHeaderText.anchorX=0.0
	group:insert( campaignKeywordsHeaderText )

	local keywords = ""

	print ("keywords: " .. keywords) 
	if ( currentCampaign.keywords ~= nil and #currentCampaign.keywords == 0 ) then
		currentCampaign:addKeyword('foo')
	end
	print ("keywords = " .. currentCampaign.keywords[1])

	if (currentCampaign.keywords) then
		for i = 1, #currentCampaign.keywords do
			keywords = keywords .. currentCampaign.keywords[i] .. ", "
			print ("keywords += " .. keywords)
		end
	end
	campaignKeywordsText = display.newText(keywords, rightPadding+campaignKeywordsHeaderText.contentWidth, 90, native.systemFontBold, 16 )
	campaignKeywordsText:setFillColor( 0, 0, 0)
	campaignKeywordsText.anchorX=0.0
	group:insert( campaignKeywordsText )

	

end


function scene:destroy( event )
	print ("campaign_details: scene:destroy started")
	local group = self.view

	if titleText then
		titleText:removeSelf()
		titleText = nil
	end

	if titleBar then
		titleBar:removeSelf()
		titleBar = nil
	end

	if campaignKeywordsText then
		campaignKeywordsText:removeSelf()
		campaignKeywordsText = nil
	end

	if campaignKeywordsHeaderText then
		campaignKeywordsHeaderText:removeSelf()
		campaignKeywordsHeaderText = nil
	end

	if campaignNameText then
		campaignNameText:removeSelf()
		campaignNameText = nil
	end

	if campaignDescriptionText then
		campaignDescriptionText:removeSelf()
		campaignDescriptionText = nil
	end

	print("campaigns:exitScene")
end	


--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )


return scene
