-- 
-- Abstract: GameMastery app, Home Screen
--  
-- Version: 1.0
-- 
--

local composer = require ( "composer" )
local widget = require ( "widget" )
FileUtil = require ("FileUtil")

local newCampBtn


--Create a storyboard scene for this module
local scene = composer.newScene()

local welcomeTitleText


local titleText
local shown=nil

local cBtns = {}
local gBtns = {}
local 
cBtnsFlag = false
gBtnsFlag = false



-- Function to handle button events
local function handleCButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Campaigns Button was pressed and released" )
    end
end

-- Function to handle button events
local function handleTButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Tools Button was pressed and released" )
        composer.gotoScene("tools")
    end
end

-- Function to handle button events
local function handleGButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Generate Button was pressed and released" )
    end
end

local function getBtnY( center, numBtns, i)
	-- body
	y = center-15-(numBtns*15)+(25*i)
	return y
end

local function getBtnX( mainButtonX, orient, numBtns, i)
	x = mainButtonX
	fiveX = {-14, -6, 0, -6, -14}
	fourX = {-9, -4, -4, -9 }

	--right orientation
	if numBtns == 1 then
		return x
	elseif numBtns == 2 then
		if orient == 'right' then
			return x+fourX[i+1]
		end
		return x-fourX[i+1]
	elseif numBtns == 3 then
		if orient == 'right' then
			return x+fiveX[i+1]
		end
		return x-fiveX[i+1]
	elseif numBtns == 4 then
		if orient == 'right' then
			return x+fourX[i]
		end
		return x-fourX[i]
	elseif numBtns == 5 then
		if orient == 'right' then
			return x+fiveX[i]
		end
		return x-fiveX[i]
	end
	
	return x
	
end


local function addBtns( btnNames, x, y, orient )
	local btns = {}
	if orient == 'right' then
		labOrient = 'left'
	else
		labOrient = 'right'
	end


	for i=1,#btnNames do
		print ("Creating button for "..btnNames[i])
		btns[i] = widget.newButton(
	    {
	        label = btnNames[i], labelAlign=labOrient,
	        onPress = function() print(btnNames[i] .. " Pressed"); end,
	        emboss = false,
	        -- Properties for a rounded rectangle button
	        shape = "roundedRect", width = 60, height = 20, cornerRadius = 2,
	        labelColor = { default={.6,0,0,1}, over={0.4,0.0,0,1} },
	        fillColor = { default={0,0,0,1}, over={0,0,0,1} },
	        strokeColor = { default={0,0,0,1}, over={0,0,0,1} },
	        strokeWidth = 4,
	        font=btnFont, fontSize=btnFontSize*0.7,
	        left = getBtnX(x,orient, #btnNames, i), top = getBtnY(y, #btnNames, i)
	    })
	end

    return btns
end

--Create the scene
function scene:create( event )
	local group = self.view

	currentScene = "home"
	print(currentScene .. ":createScene")
	

	appSettings = { fileVersion = 1, 
					appName = "GameMastery", 
					appVersion = "1.0.1", 
					campaignCounter=0,
					questCounter=0,
					encounterCounter=0,
					initiativeCounter=0,
	}



	local function tapListener( event )
	 
	    -- Code executed when the button is tapped
	    print( "Campaign Object tapped: " .. tostring(event.target) )  
	    		-- "event.target" is the tapped object

	    if cBtnsFlag == true then
	    	for i=1,#cBtns do
	    		cBtns[i].alpha = 0
	    		cBtns[i].isEnabled=false
	    	end
	    	cBtnsFlag = false
	    else
	    	for i=1,#cBtns do
		    	cBtns[i].alpha = 1.0
		    	cBtns[i].isEnabled=true
		    end
	    	cBtnsFlag = true
	    end

	    return true
	end

	local function tapListenerG( event )
	 
	    -- Code executed when the button is tapped
	    print( "Generate Object tapped: " .. tostring(event.target) )  
	    		-- "event.target" is the tapped object

	    if gBtnsFlag == true then
	    	for i=1,#gBtns do
	    		gBtns[i].alpha = 0
	    		gBtns[i].isEnabled=false
	    	end
    		gBtnsFlag = false
	    	
	    else
	    	for i=1,#gBtns do
		    	gBtns[i].alpha = 1.0
		    	gBtns[i].isEnabled=true
		    end
	    	gBtnsFlag = true
	    end

	    return true
	end


	FileUtil:initializeSettingsFileIfNotExists("settings.cfg", appSettings)
	readResult = FileUtil:loadSettingsFile("settings.cfg", appSettings)

	initPage(group)

	campBtnX = 90
	campBtnY = display.contentHeight/2 + yOffset + titleBarHeight/2

	local campaignsBtn = widget.newButton(
    {
        label = "Campaigns", font=btnFont, fontSize=btnFontSize, emboss = false,
        shape = "circle", radius = 70, cornerRadius = 2, strokeWidth = 2,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
        x = campBtnX, y = campBtnY
    })

	campaignsBtn:addEventListener( "tap", tapListener )  -- Add a "tap" listener to the object

	group:insert(campaignsBtn)


	toolBtnX = 90
	toolBtnY = display.contentHeight/2 + yOffset + titleBarHeight/2

	local toolsBtn = widget.newButton(
    {
        label = "Tools",
        onEvent = handleTButtonEvent,
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "circle",
        radius = 70,
        cornerRadius = 2,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
        strokeWidth = 2,
        font=btnFont,
        fontSize=btnFontSize,
        x = display.contentWidth-90,
      	y = display.contentHeight-90
    })

	group:insert(toolsBtn)

	genBtnX = display.contentWidth-90
	genBtnY = 90 + yOffset*2 + titleBarHeight

	local generateBtn = widget.newButton(
    {
        label = "  Quick\nGenerate",
        emboss = false,
        -- Properties for a rounded rectangle button
        shape = "circle",
        radius = 70,
        cornerRadius = 2,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
        strokeWidth = 2,
        font=btnFont,
        fontSize=btnFontSize,
        x = genBtnX,
      	y = genBtnY
    })
   
	group:insert(generateBtn)


	--btns = addBtns({'new','Salemish','Darkness Ascends', 'Ripharial\'s Legacy'})
	cBtns = addBtns({'new','Salemish','Darkness Ascends', 'IV', 'Five is a really long title '},
					campBtnX+75, campBtnY, 'right')
	
	generateBtn:addEventListener( "tap", tapListenerG)  -- Add a "tap" listener to the object
    for i=1, #cBtns do
    	cBtns[i].alpha = 0
    	cBtns[i].isEnabled=false
		group:insert(cBtns[i])
	end

	gBtns = addBtns({'NPC','Place','Thing'},
					genBtnX-140, genBtnY, 'left')

	for i=1, #gBtns do
    	gBtns[i].alpha = 0
    	gBtns[i].isEnabled=false
		group:insert(gBtns[i])
	end
end




function scene:show( event )
	local group = self.view

	currentScene = "home"
	if not shown then
		print(currentScene .. ":SHOW")		

		

		shown=1
	else
		print(currentScene .. ":show skipped")
	end
end


function scene:destroy( event )
	print(currentScene .. ":destroy")

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
	print(currentScene .. ":hide")

	--[[if titleText then
		titleText:removeSelf()
		titleText = nil
	end--]]

end	



--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene
