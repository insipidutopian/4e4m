-- 
-- Abstract: 4e DM Assistant app, Campaign Details Screen
--  
-- Version: 1.0
-- 
--

local composer = require ( "composer" )
local widget = require ( "widget" )
CampaignList = require ("CampaignList")

local scene = composer.newScene()

local currentScene = "__TEMPLATE__"


--Create the scene
function scene:create( event )
	local group = self.view

	print(currentScene .. ":createScene")


	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0

	local homeBtn = widget.newButton(
    {
        label = "Home", font=btnFont, fontSize=btnFontSize, emboss = false,
        shape = "circle", radius = 70*0.9, cornerRadius = 2, strokeWidth = 4,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
        onPress = function()  composer.gotoScene("home", { effect = "fade", time = 400}) end,
    	x = display.contentWidth-90,
      	y = display.contentHeight-90
    })

	group:insert(homeBtn)

 	
end


function scene:show( event )
	local group = self.view

	if not shown then
		print(currentScene .. ":SHOW")		
		shown=1
	else
		print(currentScene .. ":show skipped")
	end
end


function scene:destroy( event )
	print(currentScene .. ":destroy started")
	local group = self.view


	print(currentScene .. ":exitScene")
end	


--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "destroy", scene )


return scene
