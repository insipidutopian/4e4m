-- local composer = require ( "composer" )
local composer = require ( "composer" )
local scene = composer.newScene()
local myHeight = 100
local buttonHeight = 40
local widget = require ( "widget" )
local currentOverlay = "placeGen"

local placeName
local placeType

function scene:create( event )
	local group = self.view
	print("overlay:" .. currentOverlay.. ":createScene")
	
	
end




function showPlace( g )
	
	print("showPlace() called")

	local plType = Randomizer:generatePlaceType()
	local name = Randomizer:generatePlaceName("" .. plType)
	
	
	if placeName then placeName:removeSelf() end;

	placeName = display.newText({
	    text = "Name: ".. name,     
	    x = 170,
	    y = display.contentCenterY + 40 - myHeight,
	    width = 320,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    
	    align = "left" 
	})
	placeName:setFillColor( 0.6, 0, 0 )
	g:insert(placeName)


	if placeType then placeType:removeSelf() end;
	placeType = display.newText({
	    text = "Notes: ".. plType,     
	    x = 170,
	    y = display.contentCenterY + 100 - myHeight, anchorY = 0,
	    width = 320,
	    height = 60,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left" 
	})
	placeType:setFillColor( 0.6, 0, 0 )
	print("Inserting placeType")
	g:insert(placeType)


	--composer.hideOverlay( currentOverlay, popOptions ); 
end

function scene:show( event )
	local group = self.view

	print("overlay:" .. currentOverlay.. ":showScene")

 	--  showPlace( group )

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

	local overlayTitle = display.newText("Random Place", 
		display.contentCenterX, display.contentCenterY + 20 - myHeight , 
		btnFont, btnFontSize )
	overlayTitle:setFillColor( 0.6, 0, 0 )
	group:insert(overlayTitle)

	local rerollButton = widget.newButton
	{
		label = "Reroll",
		onPress =  function() showPlace( group ); end,
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
        onPress = function() print("Adding to Campaign"); end,
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

	showPlace( group );

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
