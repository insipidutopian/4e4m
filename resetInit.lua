-- local composer = require ( "composer" )
local composer = require ( "composer" )

InitiativeList = require ( "InitiativeList" )

local resetInit = composer.newScene()
local myHeight = 100
local buttonHeight = 40
local ySpace = 20
local tHeight = 40
local widget = require ( "widget" )
local resetEnemiesFlag = "true"

--local checkboxButton

local nameTF

function resetInit:create( event )
	local group = self.view
	
	local popTitleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	popTitleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( popTitleBar )
	-- create embossed text to go on toolbar
	local popTitleText = display.newEmbossedText( "Reset Initiative", display.contentCenterX, titleBarHeight/2, 
												native.systemFontBold, 20 )
	group:insert ( popTitleText )
end



-- Handle press events for the checkbox
local function onSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
    resetEnemiesFlag = tostring(switch.isOn)
end

function resetCurrentInitiatives( ) 
	print ("Resetting Initiatives - " .. resetEnemiesFlag)
	 if resetEnemiesFlag == "true" then
    	InitiativeList:removeEnemyInitiatives()
    end

    InitiativeList:resetInitiatives()
	composer.hideOverlay( "resetInit", popOptions ); 
end

function resetInit:show( event )
	local group = self.view

	print("resetInit:enterScene")

	local resetInitBox = display.newRect( display.contentCenterX, myHeight/2+ titleBarHeight, display.contentWidth, myHeight )
	resetInitBox:setFillColor( titleGradient ) 

	group:insert (resetInitBox)

	local resetButton = widget.newButton
	{
		defaultFile = "buttonGreySmall.png",
		overFile = "buttonGreySmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "Reset",
		emboss = true,
		onPress =  function() resetCurrentInitiatives(resetEnemiesFlag); end,
		x = display.contentCenterX - (buttonWidth + rightPadding),
		y = myHeight+buttonHeight/2,
	}
	group:insert(resetButton)

	local cancelButton = widget.newButton
	{
		defaultFile = "buttonGreySmall.png",
		overFile = "buttonGreySmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "Cancel",
		emboss = true,
		onPress =  function() composer.hideOverlay( "resetInit", popOptions ); end,
		x = display.contentCenterX + (buttonWidth + rightPadding),
		y = myHeight+buttonHeight/2,
	}
	group:insert(cancelButton)

	local startY = titleBarHeight + buttonHeight/2



	local bonusText = display.newText( "Remove all enemies",  rightPadding+30, startY, native.systemFontBold, 18 )
	bonusText.anchorX= 0
	bonusText:setFillColor( 0, 0, 0 )
	group:insert( bonusText )



	-- Create the widget
	local checkboxButton = widget.newSwitch
	{
	    x = rightPadding*2,
	    y = startY,
	    style = "checkbox",
	    id = "Checkbox",
	    onPress = onSwitchPress
	}
	checkboxButton:setState ({ isOn = true } )
	group:insert ( checkboxButton )
end


function resetInit:hide( event )
	local group = self.view

	if nameTF then
		nameTF:removeSelf()
		nameTF = nil
	end

	print("resetInit:exitScene")

	composer.gotoScene( "initiative_tool" );
end	


--Add the createScene, enterScene, and exitScene listeners
resetInit:addEventListener( "create", resetInit )
resetInit:addEventListener( "show", resetInit )
resetInit:addEventListener( "hide", resetInit )

return resetInit
