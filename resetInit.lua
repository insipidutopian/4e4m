-- resetInit.lua
InitiativeList = require ( "InitiativeList" )
local initiative = require ( "initiative" )
local widget = require ( "widget" )

-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist


resetInit = {}


local resetEnemiesFlag = "true"

local updateFunction




function resetInit.openResetInitDialog(group, params, onSave)
	updateFunction = onSave
	print("openResetInitDialog() called ")
	local function onClose( self, onComplete )
		print("dialog onClose() called")
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local function closeTray( event )
		print("tray closeTray() called")
		updateFunction()
		onClose( dialog, function() dialog.frame:close() end )
	end



	function resetCurrentInitiatives( ) 
		print ("Resetting Initiatives - " .. resetEnemiesFlag)
		 if resetEnemiesFlag == "true" then
	    	InitiativeList:removeEnemyInitiatives()
	    end

	    InitiativeList:resetInitiatives()
		composer.hideOverlay( "resetInit", popOptions ); 
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

	function resetCurrentInitiatives( ) 
		print ("Resetting Initiatives - " .. resetEnemiesFlag)
		 if resetEnemiesFlag == "true" then
	    	InitiativeList:removeEnemyInitiatives()
	    end

	    InitiativeList:resetInitiatives()
		
		updateFunction()

		closeTray()
	end

	-- Handle press events for the buttons
	local function onSwitchPress( event )
	    local switch = event.target
	    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
	    selectedDelayType = switch.id
	end

	y = textYOffset + textHeight / -2
	

	ssk.easyIFC:presetLabel( dialog, "appLabel", "Remove all enemies", 0, y, {align="left", width=200})

	
	local checkboxButton = widget.newSwitch
	{
	    x = 50 + width/-2,
	    y = y,
	    style = "checkbox",
	    id = "Checkbox",
	    onPress = onSwitchPress
	}
	checkboxButton:setState ({ isOn = true } )
	dialog:insert ( checkboxButton )


    y=y+80; 
 	
	

	-- 
    -- Buttons
    -- 
	y = textYOffset + textHeight / 2 - textYOffset
	ssk.easyIFC:presetPush( dialog, "appButton", 0, y, 80, 30, "Reset", 
		function() resetCurrentInitiatives(); end )


	ssk.easyIFC:presetPush( dialog, "appButton", 0, y+50, 80, 30, "Close", closeTray )

	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function resetInit.openDialog(group, onSave)
	updateFunction = onSave
	print("resetInit.openDialog() called, onsave=" .. tostring(onSave))
	resetInit.openResetInitDialog(group, nil, onSave)
end

return resetInit