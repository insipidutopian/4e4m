-- delayInit.lua
InitiativeList = require ( "InitiativeList" )
local initiative = require ( "initiative" )
local widget = require ( "widget" )

-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist


delayInit = {}


local selectedDelayType = "oneTurn"
local delayUntil = 1

local updateFunction




function delayInit.openDelayInitDialog(group, params, onSave)
	updateFunction = onSave
	print("openDelayInitDialog() called ")
	local function onClose( self, onComplete )
		print("dialog onClose() called")
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local function closeTray( event )
		print("tray closeTray() called")
		updateFunction()
		onClose( dialog, function() dialog.frame:close() end )
	end



	local function delayInitiative(  )
		print("delayInitiative() called")
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

		updateFunction()

		closeTray()
	end
	

	centerX=0
	centerY=0
	local image = "images/gamemastery/dialog_celticspears_tall3.png"
	if largeFormat then
		image = "images/gamemastery/dialog_celticspears_tall2.png"
	end

	local width, height = ssk.misc.getImageSize( image )
	print("IMAGE W=" .. tostring(width) .. ", H=" .. tostring(height))
	if not group then group = display.newGroup(); end
	dialog = ssk.dialogs.custom.create( group, 0, 0, 
	         { width = width,
	           height = height,
	           softShadow = true,
	           softShadowOX = 8,
	           softShadowOY = 8,
	           softShadowBlur = 6,
	           closeOnTouchBlocker = false, 
	           blockerFill = _WHITE_,
	           blockerAlpha = 0.15,
	           softShadowAlpha = 0.3,
	           blockerAlphaTime = 100,
	           onClose = onClose,
	           trayImage = image,
           	   shadowImage = image } )

	local textWidth = width - 80
	local textHeight = height - 200
	local textYOffset = 0

	if largeFormat then
		textYOffset = 50
	end



	-- Handle press events for the buttons
	local function onSwitchPress( event )
	    local switch = event.target
	    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
	    selectedDelayType = switch.id
	end

	y = textYOffset + textHeight / -2
	ssk.easyIFC:presetLabel( dialog, "title", "Delay Until:", 0, y)
	local rightPadding = -120 

	local radioWidth=40

	y = y + 40

	ssk.easyIFC:presetLabel( dialog, "appLabel", "After next Initiative ", 70+rightPadding+radioWidth*2, y, {align="left", width=200})

	local nextInit = InitiativeList:getOffsetInitiative(2)
	local afterText = ssk.easyIFC:presetLabel( dialog, "appLabel", "After " .. nextInit.name, 70+rightPadding+radioWidth*2, y+32, {align="left", width=200})

	local delayTypeRadio = display.newGroup( )
	local radioOneTurn = widget.newSwitch{ x=rightPadding+ radioWidth/2, y=y, style="radio", id="oneTurn", initalSwitchState=true, onPress = onSwitchPress }
	radioOneTurn:setState ({ isOn = true } )
	dialog:insert(radioOneTurn)
	local radioUntil = widget.newSwitch{ x=rightPadding+ radioWidth/2, y=y+32, style="radio", id="until", onPress = onSwitchPress }
	dialog:insert(radioUntil)

	

	dialog:insert( delayTypeRadio )



    y=y+80; 
 	
 	local function stepperListener( event )
		local statusText = "Stepper\nevent.value = " .. string.format( "%02d", event.value )
		print ("Stepper press: " .. statusText)
		local init = InitiativeList:getInitiative(tonumber(event.value))
		afterText.text = "After " .. init.name

		selectedDelayType = "until"
		radioUntil:setState ({ isOn = true } )

		delayUntil = tonumber(event.value)
	end

	local nn = InitiativeList:getCurrentInitiativeIndex()+1
	if (nn > InitiativeList:getInitiativeCount()) then
		nn = 1
	end
	print ("nn="..nn)
	local newStepper = widget.newStepper {
	    x = 0,
	    y = y,
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
	
	dialog:insert( newStepper )

	

	-- 
    -- Buttons
    -- 
	y = textYOffset + textHeight / 2 - textYOffset
	ssk.easyIFC:presetPush( dialog, "appButton", 0, y, 80, 30, "Delay", 
		function() delayInitiative(); end )


	ssk.easyIFC:presetPush( dialog, "appButton", 0, y+50, 80, 30, "Close", closeTray )

	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function delayInit.openDialog(group, onSave)
	updateFunction = onSave
	print("delayInit.openDialog() called, onsave=" .. tostring(onSave))
	delayInit.openDelayInitDialog(group, nil, onSave)
end

return delayInit