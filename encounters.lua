-- 
-- Abstract: 4e DM Assistant app, Encounters Screen
--  
-- Version: 2.0
-- 
-- Sample code is MIT licensed, see http://www.coronalabs.com/links/code/license
-- Copyright (C) 2010 Corona Labs Inc. All Rights Reserved.
--
-- This file is used to display the corresponding screen content when the user clicks the tab bar. 

local storyboard = require ( "composer" )
--local storyboard = require ( "storyboard" )

--Create a storyboard scene for this module
local scene = storyboard.newScene()

-- create embossed text to go on toolbar
-- local titleText = display.newEmbossedText( "Encounters", display.contentCenterX, titleBar.y, 
-- 											native.systemFontBold, 20 )

--Create the scene
function scene:create( event )
	local group = self.view
	

	local background = display.newImage("images/dragon01.jpg") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background:scale(0.5,0.5)
 	background.alpha = 0.5
 	group:insert(background)

	--Create a text object that displays the current scene name and insert it into the scene's view
	-- local screenText = display.newText( "Encounters", display.contentCenterX, 50, native.systemFontBold, 18 )
	-- local myFoo = display.newT
	-- screenText:setFillColor( 0 )
	-- group:insert( screenText )

	-- Create title bar to go at the top of the screen
	local titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
	titleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( titleBar )
	-- create embossed text to go on toolbar
	local titleText = display.newEmbossedText( "Encounters", display.contentCenterX, titleBar.y, 
												native.systemFontBold, 20 )
	group:insert ( titleText )

end

--Add the createScene listener
scene:addEventListener( "create", scene )

return scene
