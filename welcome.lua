-- 
-- Abstract: 4e DM Assistant app, Welcome Screen
--  
-- Version: 1.0
-- 


local composer = require ( "composer" )
local widget = require ( "widget" )
local mainFont = "fonts/kellunc.ttf"
local ASGFont = "fonts/Aclonica.ttf"


--Create a storyboard scene for this module
local scene = composer.newScene()

local welcomeTitleText
local LEFT_PADDING = 10

local widgetGroup = display.newGroup()
local sSelf = nil

local titleBar
local titleText
background = nil
local shown=nil
	




--Create the scene
function scene:create( event )
	local group = self.view

	currentScene = "welcome"
	print("welcome:createScene")
	
	background = display.newImage("images/coat-of-arms3.png") 
	background.x = display.contentWidth / 2
 	background.y = display.contentHeight / 2
 	background:scale(1.6, 1.6)
 	background.alpha = 0.7
 	group:insert(background)
	

	appSettings = { fileVersion = 1, 
					appName = "GameMastery", 
					appVersion = GAMEMASTERY_VERSION, 
					campaignCounter=0,
					questCounter=0,
					encounterCounter=0,
					initiativeCounter=0,
					currentCampaign=-1,
	}

	FileUtil:initializeSettingsFileIfNotExists("settings.cfg", appSettings)
	readResult = FileUtil:loadSettingsFile("settings.cfg", appSettings)


	--FileUtil:writeSettingsFile("settings.cfg", appSettings)
	
	-- Create title bar to go at the top of the screen
	titleBar = display.newRect( display.contentCenterX, titleBarHeight/2 + yOffset/2, 
		display.contentWidth, titleBarHeight + yOffset )
	titleBar:setFillColor( titleGradient ) 
	-- titleBar.y = display.screenOriginY + titleBar.contentHeight * 0.5
	group:insert ( titleBar )
	
	-- create embossed text to go on toolbar
	titleText = display.newEmbossedText( "Welcome", display.contentCenterX, titleBar.y, 
												mainFont, 20 )

	asgText1 =display.newEmbossedText( "An app by", display.contentCenterX, display.contentCenterY - 80, 
												ASGFont, 20 ) 
	asgText1:setFillColor( 0.3 ,0.2, 0.2   )
	asgText = display.newEmbossedText( "App Slinger's", display.contentCenterX, display.contentCenterY - 20, 
												ASGFont, 50 )
	asgText:setFillColor( 0,0,0 )
	asgText2 = display.newEmbossedText( "Guild", display.contentCenterX, display.contentCenterY + 30, 
												ASGFont, 50 )
	asgText2:setFillColor( 0,0,0 )
	group:insert ( titleText )
	group:insert ( asgText )
	group:insert ( asgText2 )
	group:insert (asgText1)
	

end


local function listener2( event )
	print( "listener2 called" )
	
	if titleBar then
		titleBar:removeSelf()
		titleBar = nil
	end

	if titleText then
		titleText.text = appSettings["appName"]
		titleText:setFillColor(0.6,0,0 )
	end

	
	if background then
		background:removeSelf()
		background = nil
	end

	if background2 then
		background2:removeSelf()
		background2 = nil
	end

	
	if asgText then
		asgText:removeSelf()
		asgText = nil
	end
	if asgText1 then
		asgText1:removeSelf()
		asgText1 = nil
	end
	if asgText2 then
		asgText2:removeSelf()
		asgText2 = nil
	end
	if welcomeText then
		welcomeText:removeSelf()
		welcomeText = nil
	end

	if versionText then
		versionText:removeSelf()
		versionText = nil
	end

	display.setDefault( "background", 0, 0, 0 )

	composer.gotoScene( "home" );

end

local function listener1( event )
	print( "listener called" )
	local group = scene.view

	welcomeText = display.newText( appSettings["appName"] , 
			display.contentCenterX, display.contentCenterY - 45, mainFont, 20 )
	welcomeText:setFillColor( 1, 1, 1)

    versionText = display.newText( " v" .. GAMEMASTERY_VERSION, 
			display.contentCenterX, display.contentCenterY + 45, mainFont, 18 )
	versionText:setFillColor( 1, 1, 1)

	print("welcome:show")

	--group:removeSelf(background)

	background2 = display.newImage("images/d20red2.png") 
 	background2.x = display.contentWidth / 2
 	background2.y = display.contentHeight / 2
 	background2:scale(2.0, 2.0)
 	background2.alpha = 1.0
  	group:insert(background2)
	group:insert( welcomeText )
	group:insert( versionText )
	timer.performWithDelay( 500*delayMultiplier, listener2 )
end

function scene:show( event )
	local group = self.view

	if shown then
		print("welcome:show")

		--cleanSelf()

		titleBar.x = display.contentCenterX
		titleBar.y = titleBarHeight/2
		titleBar.width = display.contentWidth

		titleText.x = display.contentCenterX
		asgText.x = display.contentCenterX


		timer.performWithDelay( 200*delayMultiplier, listener1 )
	else
		shown=1
	end
end


function scene:destroy( event )
	print("welcome:destroy")

	if welcomeTitleText then
		welcomeTitleText:removeSelf()
		welcomeTitleText = nil
	end

	if welcomeText then
		welcomeText:removeSelf()
		welcomeText = nil
	end


end	



function scene:hide( event )
	print("welcome:hide")

	if welcomeTitleText then
		welcomeTitleText:removeSelf()
		welcomeTitleText = nil
	end

	if welcomeText then
		welcomeText:removeSelf()
		welcomeText = nil
	end


end	



--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene
