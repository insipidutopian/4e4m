-- local composer = require ( "composer" )
local composer = require ( "composer" )
local scene = composer.newScene()
local myHeight = 140
local buttonHeight = 40
local widget = require ( "widget" )
local currentOverlay = "questGen"
local quest = require ( "quest" )

local questName
local questType

local newQuest

function scene:create( event )
	local group = self.view
	print("overlay:" .. currentOverlay.. ":createScene")
	
	
end


function addToCampaign(newQuest)
	print("Adding New Quest to Campaign, name is " .. newQuest.name)
	CampaignList:addQuestToCampaign(newQuest)
end

function showQuest( g )
	
	print("showQuest() called")

	local qType = Randomizer:generateQuestType()
	newQuest = Randomizer:generateQuest("" .. qType)
	
	

	if questName then questName:removeSelf() end;

	questName = display.newText({
	    text = "Name: ".. newQuest.description,     
	    x = 170,
	    y = display.contentCenterY + 60 - myHeight,
	    width = 310,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    
	    align = "left" 
	})
	questName:setFillColor( 0.6, 0, 0 )
	g:insert(questName)


	if questType then questType:removeSelf() end;
	questType = display.newText({
	    text = newQuest.details,     
	    x = 170,
	    y = display.contentCenterY + 140 - myHeight, anchorY = 0,
	    width = 310,
	    height = 100,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left" 
	})
	questType:setFillColor( 0.6, 0, 0 )
	print("Inserting questType")
	g:insert(questType)


	--composer.hideOverlay( currentOverlay, popOptions ); 
end

function scene:show( event )
	local group = self.view

	print("overlay:" .. currentOverlay.. ":showScene")

 	--  showQuest( group )

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

	local overlayTitle = display.newText("Random Quest", 
		display.contentCenterX, display.contentCenterY + 20 - myHeight , 
		btnFont, btnFontSize )
	overlayTitle:setFillColor( 0.6, 0, 0 )
	group:insert(overlayTitle)

	local rerollButton = widget.newButton
	{
		label = "Reroll",
		onPress =  function() showQuest( group ); end,
		shape = "roundedRect", width = 60, height = 20, cornerRadius = 2,
        labelColor = { default={.6,0,0,1}, over={0.4,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0,0,0,1} },
        strokeColor = { default={0,0,0,1}, over={0,0,0,1} },
        strokeWidth = 2,
        font=btnFont, fontSize=btnFontSize*0.7,
        left = 20, top =  display.contentCenterY - 30 + myHeight
    }
	group:insert(rerollButton)

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
        label = "Add To Campaign", --labelAlign=labOrient,
        onPress = function() addToCampaign(newQuest); end,
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

	showQuest( group );

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
