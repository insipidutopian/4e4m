local composer = require ( "composer" )
local scene = composer.newScene()
local myHeight = 100
local buttonHeight = 40
local widget = require ( "widget" )
local currentOverlay = "newCampaign"
local campaign = require ( "campaign" )

local selectedCampaign

local campaignName
local campaignSystem
local campaignNotes

function scene:create( event )
	local group = self.view
	print("overlay:" .. currentOverlay.. ":createScene")
	
	
end

function addCampaign( c )

 	print ("addCampaign() - adding campaign ==" .. c.name)
	if (c.description) then
		print ("addCampaign() -    description ==" .. c.description)
	end
	c.id = CampaignList.getNewCampaignId()

	print("New campaign ID: " .. c.id)
	--self.cList[#self.cList+1] = c
	--print ("addCampaign() - " .. #self.cList .. " campaigns now found after add.")

	--print ("addCampaign() - Writing Campaigns to disk" )
	CampaignList:writeCampaignFile(c)
end

function showCampaign( g )
	
	print("showCampaign() called")



	local name = Randomizer:generateName()
	local notes = "Click to add campaign notes" 
	local system = "5e" 

	selectedCampaign = campaign.new(name)
	selectedCampaign.description = notes

	if campaignName then campaignName:removeSelf() end;

	campaignName = display.newText({
	    text = "CampaignName: ".. name,     
	    x = 170,
	    y = display.contentCenterY + 40 - myHeight,
	    width = 320,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    
	    align = "left" 
	})
	campaignName:setFillColor( 0.6, 0, 0 )
	-- print("Inserting name")
	g:insert(campaignName)

	if campaignSystem then campaignSystem:removeSelf() end;
	campaignSystem = display.newText({
	    text = "System: ".. system,     
	    x = 170,
	    y = display.contentCenterY + 60 - myHeight,
	    width = 320,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left" 
	})
	campaignSystem:setFillColor( 0.6, 0, 0 )
	-- print("Inserting campaignSystem")
	g:insert(campaignSystem)


	if campaignNotes then campaignNotes:removeSelf() end;
	campaignNotes = display.newText({
	    text = "Notes: ".. notes,     
	    x = 170,
	    y = display.contentCenterY + 100 - myHeight, anchorY = 0,
	    width = 320,
	    height = 60,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left" 
	})
	campaignNotes:setFillColor( 0.6, 0, 0 )
	-- print("Inserting campaignNotes")
	g:insert(campaignNotes)


	--composer.hideOverlay( currentOverlay, popOptions ); 
end

function scene:show( event )
	local group = self.view

	print("overlay:" .. currentOverlay.. ":showScene")

 	--  showNpc( group )

	local blackout = display.newRect( display.contentCenterX, display.contentCenterY + titleBarHeight, 
		display.contentWidth, display.contentHeight - titleBarHeight)
	blackout:setFillColor( 0,0,0,1 ) 
	group:insert (blackout)

	local overlayBox = display.newRect( display.contentCenterX, display.contentCenterY, 
		display.contentWidth, myHeight *2)
	overlayBox:setFillColor( .6,0,0,1 ) 
	group:insert (overlayBox)

	local overlayBoxInner = display.newRect( display.contentCenterX, display.contentCenterY, 
		display.contentWidth-6, (myHeight *2) - 6)
	overlayBoxInner:setFillColor( 0,0,0,1 ) 
	group:insert (overlayBoxInner)

	local overlayTitle = display.newText("New Campaign", 
		display.contentCenterX, display.contentCenterY + 20 - myHeight , 
		btnFont, btnFontSize )
	overlayTitle:setFillColor( 0.6, 0, 0 )
	group:insert(overlayTitle)


	local cancelButton = widget.newButton
	{
		label = "Cancel",
		onPress =  function() composer.hideOverlay( currentOverlay, popOptions ); end,
        shape = "roundedRect", width = 60, height = 20, cornerRadius = 2,
        labelColor = { default={.6,0,0,1}, over={0.4,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0,0,0,1} },
        strokeColor = { default={0,0,0,1}, over={0,0,0,1} },
        strokeWidth = 2,
        font=btnFont, fontSize=btnFontSize*0.7,
        left = 80, top = display.contentCenterY - 30 + myHeight
	}
	group:insert(cancelButton)

	local addBtn = widget.newButton {
        label = "Add Campaign", --labelAlign=labOrient,
        onPress = function() print("Add Campaign"); addCampaign(selectedCampaign); composer.hideOverlay( currentOverlay, popOptions ); composer.gotoScene("home"); end,
        emboss = false,
        shape = "roundedRect", width = 60, height = 20, cornerRadius = 2,
        labelColor = { default={.6,0,0,1}, over={0.4,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0,0,0,1} },
        strokeColor = { default={0,0,0,1}, over={0,0,0,1} },
        strokeWidth = 2,
        font=btnFont, fontSize=btnFontSize*0.7,
        left = display.contentCenterX, top = display.contentCenterY - 30 + myHeight
    }
	group:insert(addBtn)

	local startY = titleBarHeight + buttonHeight/2

	showCampaign(group);

end


function scene:hide( event )
	local group = self.view

	print("overlay:" .. currentOverlay.. ":hideScene")

	composer.gotoScene( "home" );
end	


--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", resetInit )
scene:addEventListener( "show", resetInit )
scene:addEventListener( "hide", resetInit )

return scene
