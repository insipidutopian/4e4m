-- addInit.lua
InitiativeList = require ( "InitiativeList" )
local initiative = require ( "initiative" )
local widget = require ( "widget" )


addInit = {}


-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist
local selectedEntityType = "player"

local updateFunction

local init = nil




function addInit.openAddInitDialog(group, params, onSave)
	updateFunction = onSave
	print("openAddInitDialog() called ")
	local function onClose( self, onComplete )
		print("dialog onClose() called")
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local function closeTray( event )
		print("tray closeTray() called")
		updateFunction()
		onClose( dialog, function() dialog.frame:close() end )
	end


	local function findInitByRow( rowNum )
		local offsetIni = -1

		local currentInitIndex = InitiativeList:getCurrentInitiativeIndex()
		local initCount = InitiativeList:getInitiativeCount()

		print ("%%% findInitByRow(): current init is " .. currentInitIndex .. ", looking for init at row #" .. rowNum)
				
		if (currentInitIndex + rowNum == initCount+2) then
			print ("  init at row #" .. rowNum .. " is the row boundary, skipping...")
			init = nil
		else 
			print ("  init at row #" .. rowNum .. " is not a boundary.")
			offsetIni = rowNum
			if ( rowNum + currentInitIndex > initCount +1) then
				offsetIni = rowNum - 1
			end
		end

		return offsetIni

	end

	local function deleteInitiativeEntity ( initToDelete )
		print ("Deleting initiative at Slot #" .. initToDelete.initSlot)
		--local initSlot = findInitByRow(initNumToMod)
		print ("  Deleting Init: " .. initToDelete.name)
		
		InitiativeList:deleteInitiative(initToDelete)
		InitiativeList:writeInitiativeFile()

		updateFunction()

		closeTray()

	end



	local function addInitiativeEntity( entityName, entityType, entityInit, entityBonus )
		print("addInitiative() called")
		if entityInit == nil or entityInit == "" then
			entityInit = math.random(20)+1
		end
		if entityBonus == nil or entityBonus == "" then
			entityBonus = math.random(2) + math.random(2)
		end

		print("addInitiativeEntity: name=" .. entityName .. ", entityType=" .. entityType .. ", entityInit=" .. entityInit .. ", entityBonus=" .. entityBonus)
		if entityName == "" then
			if entityType == "player" then
				entityName = Randomizer.generateNpcName()
			else
				entityName = Randomizer.generateAdversary()
			end
		end

		print("addInitiativeEntity - adding '".. entityName .. "' with init=" .. entityInit)
		print("addInitiativeEntity - adding type=".. entityType)
		
		local newInit = initiative.new(entityName)
		newInit.iType = entityType
		newInit.initVal = tonumber(entityInit)
		newInit.initBon = tonumber(entityBonus)
		newInit.initBonusSaved = newInit.initBon or 2
		InitiativeList:addInitiative(newInit)

		updateFunction()

		closeTray()
	end

	local function modifyInitiativeEntity( newInit, entityName, entityType, entityInit, entityBonus )
		print ("Modifying initiative #" .. newInit.initSlot)

		local initSlot = newInit.initSlot
		print ("modifyInitiativeEntity(): found init slot " .. initSlot)

		print ("modifyInitiativeEntity(): found init slot " .. newInit.name)
		
		if entityInit == nil then
			entityInit = math.random(20)+1
		end

		if entityInit == "text" then
			entityInit = math.random(20)+1
		else
			entityInit = tonumber(entityInit)
		end
		if entityBonus == "text" then
			entityBonus = math.random(2) + math.random(2)
		else
			entityBonus = tonumber(entityBonus)
		end

		if entityName == "text" then
			if entityType == "player" then
				entityName = Randomizer.generateNpcName()
			else
				entityName = Randomizer.generateAdversary()
			end
		end

		print("modifyInitiativeEntity - modifying '".. entityName .. "' with init=" ..  entityInit)
		print("modifyInitiativeEntity - modifying type=".. entityType)
		
		-- local newInit = initiative.new(entityName)
		newInit.name = entityName
		newInit.iType = entityType
		newInit.initVal = entityInit
		newInit.initBon = entityBonus
		newInit.initBonusSaved = entityBonus
		InitiativeList:updateInitiative(newInit.initSlot, newInit)

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
	local textBoxHeight = 80

	if largeFormat then
		textYOffset = 50
		textBoxHeight = 130
	end


	if params then
		print ("Entering scene to Modify, not add!")
		print ("Need to find params.initNumber for row index " .. tostring(params.iOffset))
		--init = InitiativeList:getInitiative(params.initNumber)
		init = InitiativeList:getOffsetInitiative(params.iOffset)
		print ("Modifying " .. init.iType .. " " .. init.name)
	else
		init = nil
	end
	

	-- Handle press events for the radios
	local function onRadioSwitch( event )
	    local switch = event.target
	    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
	    selectedEntityType = switch.id
	end

	y = textYOffset + textHeight / -2
	
	local nameSquare = display.newRoundedRect(dialog, 0, y, textWidth+4, 24, 4 )
	nameSquare.fill = {0.1,0.1,0.1}
	nameTF = ssk.easyIFC:presetTextInput(dialog, "title", "", 0, y, 
			{listener=uiTools.textFieldListener, placeholder = "(Name)", width = textWidth, keyboardFocus=true, selectedChars={0,99}})
	
	y = y + 45
	myHeight = 0
	local rightPadding = -120 

	local radioWidth=40

	ssk.easyIFC:presetLabel( dialog, "appLabel", "Player ", 20+rightPadding+radioWidth*2, y, {align="left", width=100})

	ssk.easyIFC:presetLabel( dialog, "appLabel", "Enemy ", 20+rightPadding+radioWidth*2, y+32, {align="left", width=100})

	local playerRadio = display.newGroup( )
	local rad1 = widget.newSwitch{ x=rightPadding+ radioWidth/2, y=y, style="radio", id="player", initalSwitchState=true, onPress = onRadioSwitch }
	rad1:setState ({ isOn = true } )
	dialog:insert(rad1)
	local rad2 = widget.newSwitch{ x=rightPadding+ radioWidth/2, y=y+32, style="radio", id="enemy", onPress = onRadioSwitch }
	dialog:insert(rad2)

	

	group:insert( playerRadio )

	--ssk.easyIFC:presetLabel( dialog, "appLabel", "Player ", 20+rightPadding+radioWidth*2, y, {align="left", width=100})

	local boxSize = 75
	if largeFormat then
		boxSize = 100
	end
	print("BOXSIZE = " .. boxSize)
    y=y+100; 
    ssk.easyIFC:presetLabel( dialog, "appLabel", "Initiative Bonus: ", 0, y, {align="left", width=textWidth})
    local bonusSquare = display.newRoundedRect(dialog, 70, y, boxSize+2, boxSize+2, 4 )
	bonusSquare.fill = {0.1,0.1,0.1}
    bonusTF = ssk.easyIFC:presetTextInput(dialog, "giant", "+1", 70, y, 
			{listener=uiTools.textFieldListener, width=boxSize/2})
   
 
 	y=y+15 + boxSize
    ssk.easyIFC:presetLabel( dialog, "appLabel", "Initiative Roll: ", 0, y, {align="left", width=textWidth})
    local rollSquare = display.newRoundedRect(dialog, 70, y, boxSize+2, boxSize+2, 4 )
	rollSquare.fill = {0.1,0.1,0.1}
    rollTF = ssk.easyIFC:presetTextInput(dialog, "giant", "", 70, y, 
			{listener=uiTools.textFieldListener, width=boxSize/2})

	if init then
		if init.iType == "player" then
			rad1:setState ({ isOn = true } )
		else 
			rad2:setState ({ isOn = true } )
		end
		nameTF.text = init.name
		rollTF.text = init.initVal
		bonusTF.text = init.initBon
	end

	-- 
    -- Buttons
    -- 

	y = textYOffset + textHeight / 2 - textYOffset
	if init then -- We loaded an init, so we're modifying
		selectedEntityType = init.iType
		xLoc = display.contentCenterX - (buttonWidth + rightPadding)
		yLoc = myHeight+buttonHeight/2
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Modify", 
			function() modifyInitiativeEntity(init, nameTF.text, selectedEntityType, rollTF.text, bonusTF.text); end)
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Delete", 
			function() deleteInitiativeEntity(init); end)
	else
		xLoc = display.contentCenterX - (buttonWidth + rightPadding)
		yLoc = myHeight+buttonHeight/2
		ssk.easyIFC:presetPush( dialog, "appButton", 0, y, 80, 30, "Add", 
			function() addInitiativeEntity(nameTF.text, selectedEntityType, rollTF.text, bonusTF.text); end )
	end

	
	--ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Delete", function() deleteNpc(npc); end )
	--ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Add", addInitiativeEntity )

	ssk.easyIFC:presetPush( dialog, "appButton", 0, y+50, 80, 30, "Close", closeTray )

	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function addInit.openDialog(group, onSave)
	updateFunction = onSave
	print("addInit.openDialog() called, onsave=" .. tostring(onSave))
	addInit.openAddInitDialog(group, nil, onSave)
end

return addInit