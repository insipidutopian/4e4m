local composer = require ( "composer")
local scene = composer.newScene()

local myHeight = 140
local buttonHeight = 40
local ySpace = 20
local tHeight = 40
local widget = require ( "widget" )
local delayButton
local selectedDelayType = "oneTurn"
InitiativeList = require ( "InitiativeList" )
local delayTypeRadio
local radioOneTurn
local radioUntil
local afterText
local delayUntil = 1

local initList = require ( "InitiativeList")

local delayUntilTF

function scene:create( event )
	print("delayInit:scene:create")
	local group = self.view
	
	local popTitleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	popTitleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( popTitleBar )
	-- create embossed text to go on toolbar
	local popTitleText = display.newEmbossedText( "Delay Initiative", display.contentCenterX, titleBarHeight/2, 
												native.systemFontBold, 20 )
	group:insert ( popTitleText )
end


function delayInitiative( )
	local initNumber = InitiativeList:getCurrentInitiativeIndex()
	local newInitNumber = delayUntil
	print ("Delaying init slot " .. initNumber .. ": type " .. selectedDelayType)
	if selectedDelayType == "until" then
		print ("Delaying init slot " .. initNumber .. " to slot " .. newInitNumber)
		local tmp = InitiativeList:getCurrentInitiativeIndex()
		InitiativeList:delayInitiative(newInitNumber)
	else
		print ("Delaying init slot " .. initNumber .. " to slot " .. initNumber+1)
		if (initNumber+1 > #InitiativeList.iList ) then
			print "********Delaying past end of round***********"
		end
		InitiativeList:delayInitiative()
	end
	
	composer.hideOverlay( "scene", popOptions );
	--storyboard.hideOverlay( "delayInit", popOptions )
end


-- Handle press events for the buttons
local function onSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
    selectedDelayType = switch.id
end

local function stepperListener( event )
		local statusText = "Stepper\nevent.value = " .. string.format( "%02d", event.value )
		print ("Stepper press: " .. statusText)
		local init = InitiativeList:getInitiative(tonumber(event.value))
		afterText.text = "After " .. init.name
		selectedDelayType = "until"
		radioUntil:setState ({ isOn = true } )

		delayUntil = tonumber(event.value)
	end


function scene:show( event )
	local group = self.view

	print("delayInit:scene:show")

	local sceneBox = display.newRect( display.contentCenterX, myHeight/2+ titleBarHeight, display.contentWidth, myHeight )
	sceneBox:setFillColor( titleGradient ) 

	group:insert (sceneBox)

	local delayButton = widget.newButton
	{
		defaultFile = "buttonGreySmall.png",
		overFile = "buttonGreySmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "Delay",
		emboss = true,
		onPress =  function() delayInitiative(); end,
		-- onPress =  function() delayInits(delayTypeRadio, delayUntilTF.text); composer.hideOverlay( "scene", popOptions ); end,
		x = display.contentCenterX - (buttonWidth + rightPadding),
		y = myHeight+buttonHeight/2,
	}
	group:insert(delayButton)

	local cancelButton = widget.newButton
	{
		defaultFile = "buttonGreySmall.png",
		overFile = "buttonGreySmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "Cancel",
		emboss = true,
		onPress =  function() composer.hideOverlay( "scene", popOptions ); end,
		x = display.contentCenterX + (buttonWidth + rightPadding),
		y = myHeight+buttonHeight/2,
	}
	group:insert(cancelButton)

	local startY = titleBarHeight + buttonHeight/2


	local radioWidth=40

	local afterInitText = display.newText( "After Next Initiative",  rightPadding+radioWidth, startY, native.systemFontBold, 18 )
	afterInitText.anchorX= 0
	afterInitText:setFillColor( 0, 0, 0 )
	group:insert( afterInitText )


	delayTypeRadio = display.newGroup( )
	radioOneTurn = widget.newSwitch{ x=rightPadding+ radioWidth/2, y=startY, style="radio", id="oneTurn", initalSwitchState=true,  onPress = onSwitchPress}
	radioOneTurn:setState ({ isOn = true } )
	delayTypeRadio:insert(radioOneTurn)

	startY = startY + buttonHeight/2 + ySpace

	radioUntil = widget.newSwitch{ x=rightPadding+ radioWidth/2, y=startY, style="radio", id="until",  onPress = onSwitchPress }
	delayTypeRadio:insert(radioUntil)
	group:insert( delayTypeRadio )

	local nextInit = InitiativeList:getOffsetInitiative(2)
	afterText = display.newText( "After "..nextInit.name,   rightPadding+radioWidth, startY, native.systemFontBold, 18 )
	afterText.anchorX= 0
	afterText:setFillColor( 0, 0, 0 )
	group:insert( afterText )


	local nn = InitiativeList:getCurrentInitiativeIndex()+1
	if (nn > InitiativeList:getInitiativeCount()) then
		nn = 1
	end
	print ("nn="..nn)
	local newStepper = widget.newStepper {
	    left = 24,
	    top = 112,
	    initialValue = nn,
	    minimumValue = 1,
	    maximumValue = InitiativeList:getInitiativeCount(),
		timerIncrementSpeed = 500,
		changeSpeedAtIncrement = 4,
	    onPress = stepperListener
	}
	local nn = InitiativeList:getCurrentInitiativeIndex()+1
	if (nn > InitiativeList:getInitiativeCount()) then
		nn = 1
	end
	
	group:insert( newStepper )
	newStepper.x = display.contentCenterX

end



function scene:hide( event )
	print ("delayInit:scene:hide called")
	local group = self.view

	InitiativeList:sortInitiatives( )
	composer.gotoScene( "initiative_tool" );
	--print("scene:exitScene")
end	


--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
