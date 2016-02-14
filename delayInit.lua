local composer = require ( "composer")
local scene = composer.newScene()

local myHeight = 140
local buttonHeight = 40
local ySpace = 20
local tHeight = 40
local widget = require ( "widget" )
local delayButton
local delayTypeRadio
local afterRB
local untilRB

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
		onPress =  function() delayInits(delayTypeRadio, delayUntilTF.text); composer.hideOverlay( "scene", popOptions ); end,
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
	afterRB = widget.newSwitch{ x=rightPadding+ radioWidth/2, y=startY, style="radio", id="afterRB", initialSwitchState=true, }
	afterRB:setState ({ isOn = true } )
	delayTypeRadio:insert(afterRB)

	startY = startY + buttonHeight/2 + ySpace

	untilRB = widget.newSwitch{ x=rightPadding+ radioWidth/2, y=startY, style="radio", id="untilRB", }
	delayTypeRadio:insert(untilRB)
	group:insert( delayTypeRadio )

	local enemyText = display.newText( "Until",   rightPadding+radioWidth, startY, native.systemFontBold, 18 )
	enemyText.anchorX= 0
	enemyText:setFillColor( 0, 0, 0 )
	group:insert( enemyText )

	-- Create text field
	delayUntilTF = native.newTextField( display.contentCenterX+10, startY + inputFontSize * 0.3, 150, tHeight)
	delayUntilTF.placeholder = "(24)"
	group:insert(delayUntilTF)



end

function delayInits( radType, delayUntil )
	print ("delayInits(!)")
	print ("radType=" .. delayTypeRadio.x)
	if (afterRB.isOn) then
		print("Delay until after, called")
		local curInit =  InitiativeList:getOffsetInitiative(1);
		if (curInit) then
			local nextInit = InitiativeList:getOffsetInitiative(2);
			if (nextInit) then
				print ("Delaying until after " .. nextInit.name .. "'s' initiative...")
				curInit.initVal = nextInit.initVal + nextInit.initBon
				curInit.initBon = 0
				InitiativeList:updateInitiative(2, curInit)
				InitiativeList:updateInitiative(1, nextInit)
				InitiativeList:sortInitiatives( )
			end
		end
	end
	if (untilRB.isOn ) then
		print ("Delay until called")
	
		if (delayUntil) then
			if (type(delayUntil)~='number') then
				print ("delayUntil is not a number")
				delayUntil = 0
			end
		else
			delayUntil = 0
		end
		print ("delayUntil=" .. delayUntil)
		InitiativeList:sortInitiatives( )

	end
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
