local storyboard = require ( "storyboard" )

local popup = storyboard.newScene()

local myHeight = 400

function popup:createScene( event )
	local group = self.view
	
	local popTitleBar = display.newRect( display.contentCenterX, myHeight/2, display.contentWidth, myHeight )
	popTitleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( popTitleBar )
	-- create embossed text to go on toolbar
	local popTitleText = display.newEmbossedText( "Pop!", display.contentCenterX, titleBarHeight/2, 
												native.systemFontBold, 20 )
	group:insert ( popTitleText )
end

function popup:enterScene( event )
	local group = self.view

	print("popup:enterScene")
end


function popup:exitScene( event )
	local group = self.view


	print("popup:exitScene")
end	


--Add the createScene, enterScene, and exitScene listeners
popup:addEventListener( "createScene", popup )
popup:addEventListener( "enterScene", popup )
popup:addEventListener( "exitScene", popup )

return popup
