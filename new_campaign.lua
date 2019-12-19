-- 
-- Abstract: 4e DM Assistant app, New Campaign Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to  

local composer = require ( "composer" )
local widget = require ( "widget" )
local CampaignClass = require ( "campaign" )


--Create a scene for this module
local scene = composer.newScene()
local campaignNameTF, campaignDescTB
local campaignNameText, campaignDescText

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local tHeight = 30
local yStart = titleBarHeight + yPadding 

local campaigns = {}

local addCampaignName = ""

local function textListener( event )

	if ( event.phase == "ended" or event.phase == "submitted" ) then
        -- do something with campaignNameTF's text
        if (event.text) then
        	print ("user input ended or submitted, text="..event.text)
        else
        	print ("user input ended or submitted, nil text")
        end
    end
end

function addCampaign()
	print ("Adding campaign '"..addCampaignName.."'")
	local cName = '' 
	local cDesc = ''
	if (campaignNameTF ~= nil) then
		cName = campaignNameTF.text 
		cDesc = campaignDescTB.text
	end

	if (cName == "") then
		print (" generating random campaign name")
		rand = math.random( 100 )
		cName = "New Campaign " .. rand
		cDesc = "New Campaign " .. rand .. " Description"
		print (" generate random campaign name: " .. cName)
	end

	local newCampaign = CampaignClass.new(cName)
	print (" campaignNameTF='"..cName.."', campaignDescTB='"..cDesc.."'")
	if (newCampaign and cDesc) then
		newCampaign:setDescription(cDesc)
	end
    CampaignList:addCampaign(newCampaign)
    local cc = CampaignList:getCampaignCount()
    print("Campaign count now " .. cc)
end

--Create the scene
function scene:create( event )
	local group = self.view
	
	print("new_campaign:create called")
	local background = display.newImage("images/dragon01.jpg") 
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
	local titleText = display.newEmbossedText( "New Campaign", display.contentCenterX, titleBar.y, 
												native.systemFontBold, 20 )
	group:insert ( titleText )

	--Create a text object that displays the current scene name and insert it into the scene's view
	-- local screenText = display.newText( "New Campaign", centerX, 50, native.systemFontBold, 18 )
	-- screenText:setFillColor( 1, 0, 0 )
	-- group:insert( screenText )

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

	local isAndroid = "Android" == system.getInfo( "platformName" )
	local inputFontSize = 18

	if ( isAndroid ) then
	    inputFontSize = inputFontSize - 4
	end

	
	local campaignNameText = display.newText( { text = "Campaign Name: ", 
									 x= leftPadding, y = yStart + inputFontSize * .5, 
									 font = native.systemFontBold, fontSize = inputFontSize
								   } )
	campaignNameText.anchorX = 0 -- left align
	campaignNameText:setFillColor( 1, 0, 0)
	group:insert( campaignNameText )


	local campaignDescText = display.newText( { text = "Description: ", 
									 x= leftPadding, y = yStart + inputFontSize * .5 + 30, 
									 font = native.systemFontBold, fontSize = inputFontSize
								   } )
	campaignDescText.anchorX = 0 -- left align
	campaignDescText:setFillColor( 1, 0, 0)
	group:insert( campaignDescText )

	local campaignKeywordsText = display.newText( { text = "Keywords: ", 
									 x= leftPadding, y = yStart + inputFontSize * .5 + 230, 
									 font = native.systemFontBold, fontSize = inputFontSize
								   } )
	campaignKeywordsText.anchorX = 0 -- left align
	campaignKeywordsText:setFillColor( 1, 0, 0)
	group:insert( campaignKeywordsText )


	local addButton = widget.newButton
	{
		defaultFile = "buttonRedSmall.png",
		overFile = "buttonRedSmallOver.png",
		label = "Add",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		emboss = true,
		onPress =  function() addCampaign( ); composer.gotoScene( "campaigns" ); end,
		x =  buttonWidth + rightPadding,
		y = display.contentHeight - 100,
	}
	group:insert(addButton)



end

function scene:show( event )
	local group = self.view

	print("new_campaign:show called")
	-- Create text field
	if ( campaignNameTF == nil  ) then
		campaignNameTF = native.newTextField( display.contentWidth - rightPadding, yStart + inputFontSize * 0.5, 150, tHeight)
		campaignNameTF:addEventListener( "userInput", textListener )
		campaignNameTF.placeholder = "Campaign Name"
		campaignNameTF.anchorX = 1 -- right align
		group:insert(campaignNameTF)
	end

	if ( campaignDescTB == nil  ) then
		-- Create text box
		campaignDescTB = native.newTextBox( display.contentWidth - rightPadding, 
											yStart + (tHeight * 5 * 0.5) + 60, 
											display.contentWidth - leftPadding - rightPadding, 
											tHeight * 5)
		campaignDescTB:addEventListener( "userInput", textListener )
		campaignDescTB.placeholder = "Add Notes Here"
		campaignDescTB.anchorX = 1 -- right align
		campaignDescTB.isEditable = true
		campaignDescTB.text = "Add campaign notes here..."
		
		group:insert(campaignDescTB)
	end

	
	-- native.setKeyboardFocus( campaignNameTF )
end

function scene:hide( event )
	print ("new_campaign: scene:destroy started")
	local group = self.view

	-- remove any native objects, since widget objects will be cleaned automatically, but native ones won't
	if campaignNameTF then
		campaignNameTF:removeSelf()
		campaignNameTF = nil
	end

	if campaignKeywords then
		campaignKeywords:removeSelf()
		campaignKeywords = nil
	end

	if campaignDescTB then
		campaignDescTB:removeSelf()
		campaignDescTB = nil
	end


	print("new_campaign: scene:hide finished")
end	



--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )



return scene
