local storyboard = require ( "storyboard" )

local addInit = storyboard.newScene()
local myHeight = 140
local buttonHeight = 40
local ySpace = 20
local tHeight = 40
local widget = require ( "widget" )
local addButton

local nameTF

function addInit:createScene( event )
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

function addInit:enterScene( event )
	local group = self.view

	print("addInit:enterScene")

	local addInitBox = display.newRect( display.contentCenterX, myHeight/2+ titleBarHeight, display.contentWidth, myHeight )
	addInitBox:setFillColor( titleGradient ) 

	group:insert (addInitBox)

	local addButton = widget.newButton
	{
		defaultFile = "buttonGreySmall.png",
		overFile = "buttonGreySmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "Delay",
		emboss = true,
		onPress =  function() storyboard.hideOverlay( "addInit", popOptions ); end,
		x = display.contentCenterX - (buttonWidth + rightPadding),
		y = myHeight+buttonHeight/2,
	}
	group:insert(addButton)

	local cancelButton = widget.newButton
	{
		defaultFile = "buttonGreySmall.png",
		overFile = "buttonGreySmallOver.png",
		labelColor = { default={ 1, 1, 1 }, over={ 0, 0, 0, 0.5 } },
		label = "Cancel",
		emboss = true,
		onPress =  function() storyboard.hideOverlay( "addInit", popOptions ); end,
		x = display.contentCenterX + (buttonWidth + rightPadding),
		y = myHeight+buttonHeight/2,
	}
	group:insert(cancelButton)

	local startY = titleBarHeight + buttonHeight/2


	local radioWidth=40

	local playerText = display.newText( "After Next Initiative",  rightPadding+radioWidth, startY, native.systemFontBold, 18 )
	playerText.anchorX= 0
	playerText:setFillColor( 0, 0, 0 )
	group:insert( playerText )


	local playerRadio = display.newGroup( )
	local rad1 = widget.newSwitch{ x=rightPadding+ radioWidth/2, y=startY, style="radio", id="rad1", initalSwitchState=true, }
	rad1:setState ({ isOn = true } )
	playerRadio:insert(rad1)

	startY = startY + buttonHeight/2 + ySpace

	local rad2 = widget.newSwitch{ x=rightPadding+ radioWidth/2, y=startY, style="radio", id="rad2", }
	playerRadio:insert(rad2)
	group:insert( playerRadio )

	local enemyText = display.newText( "Until",   rightPadding+radioWidth, startY, native.systemFontBold, 18 )
	enemyText.anchorX= 0
	enemyText:setFillColor( 0, 0, 0 )
	group:insert( enemyText )

	-- Create text field
	nameTF = native.newTextField( display.contentCenterX+10, startY + inputFontSize * 0.3, 150, tHeight)
	nameTF.placeholder = "(24)"



end


function addInit:exitScene( event )
	local group = self.view

	if nameTF then
		nameTF:removeSelf()
		nameTF = nil
	end


	print("addInit:exitScene")
end	


--Add the createScene, enterScene, and exitScene listeners
addInit:addEventListener( "createScene", addInit )
addInit:addEventListener( "enterScene", addInit )
addInit:addEventListener( "exitScene", addInit )

return addInit
