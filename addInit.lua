-- 
-- Abstract: 4e DM Assistant app, Thing Generator Tool Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to  

local composer = require ( "composer" )
-- local storyboard = require ( "storyboard" )
local widget = require ( "widget" )
InitiativeList = require ( "InitiativeList" )
local initiative = require ( "initiative" )
local RandGenUtil = require ("RandGenUtil")


--Create a storyboard scene for this module
local scene = composer.newScene()

local myHeight = 240
local buttonHeight = 40
local ySpace = 20
local tHeight = 40
local widget = require ( "widget" )
local addButton
local selectedEntityType = "player"
local nameTF
local initNumToMod = -1
local init

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

--Create the scene
function scene:create( event )
	print ("addInit:scene:create called")
	local group = self.view
	
	local popTitleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	popTitleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( popTitleBar )
	-- create embossed text to go on toolbar
	local popTitleText = display.newEmbossedText( "Add Initiative", display.contentCenterX, titleBarHeight/2, 
												native.systemFontBold, 20 )
	group:insert ( popTitleText )


	
end

function deleteInitiativeEntity (  )
	print ("Deleting initiative at Slot #" .. initNumToMod)
	--local initSlot = findInitByRow(initNumToMod)
	print ("  Deleting Init #" .. initNumToMod)
	
	--print ("modifyInitiativeEntity(): found init slot " .. initSlot)
	InitiativeList:deleteInitiative(initNumToMod)
	InitiativeList:writeInitiativeFile()

	--storyboard.hideOverlay( "addInit", popOptions )
	composer.hideOverlay( "addInit", popOptions )

end


function addInitiativeEntity( entityName, entityType, entityInit, entityBonus )
	if entityInit == nil or entityInit == "" then
		entityInit = math.random(20)+1
	end
	if entityBonus == nil or entityBonus == "" then
		entityBonus = math.random(2) + math.random(2)
	end

	print("addInitiativeEntity: name=" .. entityName .. ", entityType=" .. entityType .. ", entityInit=" .. entityInit .. ", entityBonus=" .. entityBonus)
	if entityName == "" then
		if entityType == "player" then
			entityName = RandGenUtil.generateName()
		else
			entityName = RandGenUtil.generateAdversary()
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

	composer.hideOverlay( "addInit", popOptions )
	--storyboard.hideOverlay( "addInit", popOptions )
end

function modifyInitiativeEntity( newInit, entityName, entityType, entityInit, entityBonus )
	print ("Modifying initiative #" .. initNumToMod)

	local initSlot = findInitByRow(initNumToMod)
	print ("modifyInitiativeEntity(): found init slot " .. initSlot)
	
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
			entityName = RandGenUtil.generateName()
		else
			entityName = RandGenUtil.generateAdversary()
		end
	end

	print("modifyInitiativeEntity - modifying '".. entityName .. "' with init=" ..  0)
	print("modifyInitiativeEntity - modifying type=".. entityType)
	
	--local newInit = initiative.new(entityName)
	newInit.name = entityName
	newInit.iType = entityType
	newInit.initVal = entityInit
	newInit.initBon = entityBonus
	newInit.initBonusSaved = entityBonus
	InitiativeList:updateInitiative(initNumToMod, newInit)

	--storyboard.hideOverlay( "addInit", popOptions )
	composer.hideOverlay( "addInit", popOptions )
end

-- Handle press events for the buttons
local function onSwitchPress( event )
    local switch = event.target
    print( "Switch with ID '"..switch.id.."' is on: "..tostring(switch.isOn) )
    selectedEntityType = switch.id
end


--function addInit:enterScene( event )
function scene:show( event )
	local group = self.view

	print("addInit:show")

	if event.params then
		if event.params.initNumber then
			print ("Entering scene to Modify, not add!")
			--load the details of the initiative at initNumber 
			
			local iniSlot = findInitByRow( event.params.initNumber )
			print ("Found ini slot " .. iniSlot .. " to modify.")
			if (iniSlot > -1 ) then

				init = InitiativeList:getOffsetInitiative(iniSlot)
				print ("Modifying " .. init.iType .. " " .. init.name)
				initNumToMod = iniSlot
			end
		end
	else
		init = nil
	end

	local addInitBox = display.newRect( display.contentCenterX, myHeight/2+ titleBarHeight, display.contentWidth, myHeight )
	addInitBox:setFillColor( titleGradient ) 

	group:insert (addInitBox)


	local startY = titleBarHeight + buttonHeight/2
	-- Create text field
	nameTF = native.newTextField( 85, startY + inputFontSize * 0.5, 150, tHeight)
	if init then
		nameTF.text = init.name
	else
		nameTF.placeholder = "(Name)"
	end


	group:insert(nameTF)
	if init then -- We loaded an init, so we're modifying
		selectedEntityType = init.iType
		local modifyButton = widget.newButton
		{
			defaultFile = "buttonGreySmall.png",
			overFile = "buttonGreySmallOver.png",
			labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
			label = "Update",
			emboss = true,
			-- todo: modifyInitiativeEntity...
			onPress =  function() modifyInitiativeEntity(init, nameTF.text, selectedEntityType, initTF.text, initBonusTF.text); end,
			x = display.contentCenterX - (buttonWidth + rightPadding),
			y = myHeight+buttonHeight/2,
		}
		group:insert(modifyButton)
	else
		local addButton = widget.newButton
		{
			defaultFile = "buttonGreySmall.png",
			overFile = "buttonGreySmallOver.png",
			labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
			label = "Add",
			emboss = true,
			onPress =  function() addInitiativeEntity(nameTF.text, selectedEntityType, initTF.text, initBonusTF.text); end,
			x = display.contentCenterX - (buttonWidth + rightPadding),
			y = myHeight+buttonHeight/2,
		}
		group:insert(addButton)
	end

	local cancelButton = widget.newButton
	{
		defaultFile = "buttonGreySmall.png",
		overFile = "buttonGreySmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "Cancel",
		emboss = true,
		onPress =  function() composer.hideOverlay( "addInit", popOptions ); end,
		--onPress =  function() storyboard.hideOverlay( "addInit", popOptions ); end,
		x = display.contentCenterX + (buttonWidth + rightPadding),
		y = myHeight+buttonHeight/2,
	}
	group:insert(cancelButton)
	
	if init then
		local deleteButton = widget.newButton
		{
			defaultFile = "buttonGreySmall.png",
			overFile = "buttonGreySmallOver.png",
			labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
			label = "Delete",
			emboss = true,
			onPress =   function() deleteInitiativeEntity(init); end,
			x = display.contentCenterX + (buttonWidth + rightPadding)+ (buttonWidth*2 + rightPadding),
			y = myHeight+buttonHeight/2,
		}
		group:insert(deleteButton)
	end



	


	startY = startY + buttonHeight/2 + ySpace

	local radioWidth=40

	local playerText = display.newText( "Player",  rightPadding+radioWidth, startY, native.systemFontBold, 18 )
	playerText.anchorX= 0
	playerText:setFillColor( 0, 0, 0 )
	group:insert( playerText )


	local playerRadio = display.newGroup( )
	local rad1 = widget.newSwitch{ x=rightPadding+ radioWidth/2, y=startY, style="radio", id="player", initalSwitchState=true, onPress = onSwitchPress }
	rad1:setState ({ isOn = true } )
	playerRadio:insert(rad1)
	local rad2 = widget.newSwitch{ x=display.contentCenterX, y=startY, style="radio", id="enemy", onPress = onSwitchPress }
	playerRadio:insert(rad2)

	if init then
		if init.iType == "player" then
			rad1:setState ({ isOn = true } )
		else 
			rad2:setState ({ isOn = true } )
		end
	end

	group:insert( playerRadio )

	local enemyText = display.newText( "Enemy",  display.contentCenterX + radioWidth/2, startY, native.systemFontBold, 18 )
	enemyText.anchorX= 0
	enemyText:setFillColor( 0, 0, 0 )
	group:insert( enemyText )

	startY = startY + buttonHeight/2 + ySpace

	local initiativeText = display.newText( "Initiative",  rightPadding, startY, native.systemFontBold, 18 )
	initiativeText.anchorX= 0
	initiativeText:setFillColor( 0, 0, 0 )
	group:insert( initiativeText )

	-- Create text field
	initTF = native.newTextField( 120, startY + inputFontSize * 0.5, 50, tHeight)
	if init then
		initTF.text = tostring(init.initVal)
	else
		initTF.placeholder = "(10)"
	end
	group:insert (initTF)

	startY = startY + buttonHeight/2 + ySpace

	local bonusText = display.newText( "Bonus",  rightPadding, startY, native.systemFontBold, 18 )
	bonusText.anchorX= 0
	bonusText:setFillColor( 0, 0, 0 )
	group:insert( bonusText )

	-- Create text field
	initBonusTF = native.newTextField( 120, startY + inputFontSize * 0.5, 50, tHeight)
	if init then
		initBonusTF.text = tostring(init.initBon)
	else
		initBonusTF.placeholder = "(0)"
	end
	group:insert (initBonusTF)

end

--function addInit:exitScene( event )
function scene:hide( event )
	local group = self.view



	print("addInit:exitScene")

	composer.gotoScene( "initiative_tool" );
end	

--Add the createScene listener
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
return scene
