-- 
-- Abstract: GameMastery app, Home Screen
--  
-- Version: 1.0
-- 
--

local composer = require ( "composer" )
local widget = require ( "widget" )
FileUtil = require ("FileUtil")
CampaignList = require ("CampaignList")
local CampaignClass = require ( "campaign" )
uiTools = require("uiTools")

manageNpc = require("manageNpc")
manageThing = require("manageThing")
managePlace = require("managePlace")
manageQuest = require("manageQuest")

--Create a storyboard scene for this module
local scene = composer.newScene()

local welcomeTitleText
local newCampBtn
local titleText
local shown=nil

local cBtns = {}
local gBtns = {}
local cBtnNameList

local buttonsDisabled

cBtnsFlag = false
gBtnsFlag = false

local generateBtn

-- Function to handle button events
local function handleTButtonEvent( event )
 
    if ( "ended" == event.phase ) then
        print( "Tools Button was pressed and released" )
        composer.gotoScene("tools", { effect = "fade", time = 400})
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

local function toggleCamp( on )
	if on == true then
		if not cBtnsFlag then

			print("showing camp buttons")
	    	for i=1,#cBtns do
	    		cBtns[i].alpha = 1.0
		    	cBtns[i].isEnabled=true
	    	end
	    	cBtnsFlag = true
	    else
	    	toggleCamp(false)
	    end
    else
    	print("hiding camp buttons")
    	for i=1,#cBtns do
	    	cBtns[i].alpha = 0
	    	cBtns[i].isEnabled=false
	    end
	    cBtnsFlag = false
    end
end


local function toggleGen( on ) 
	if on == true then
		print("on is true <---------  gBtnsFlag is " .. tostring(gBtnsFlag))
		if not gBtnsFlag then
			print("showing gen buttons")
	    	for i=1,#gBtns do
	    		gBtns[i].alpha = 1
	    		gBtns[i].isEnabled=true
	    	end	    
	    	gBtnsFlag = true
	    else
	    	toggleGen( false )
	    end
	    
    else
    	print("hiding gen buttons")
    	for i=1,#gBtns do
	    	gBtns[i].alpha = 0
	    	gBtns[i].isEnabled=false
	    end
	    gBtnsFlag = false
		
    end
end

local function tapListener( event )
 
 	if buttonsDisabled == true then return true end

    -- Code executed when the button is tapped
    if event then
   		print( "Campaign Object tapped: " .. tostring(event.target) )  
   		toggleCamp(true)
   		toggleGen(false)
   	end
    		-- "event.target" is the tapped object
    
    

    return true
end


local function tapListenerG( event )
	if buttonsDisabled == true then return true end
 
    -- Code executed when the button is tapped
    if event then
    	print( "Generate Object tapped: " .. tostring(event.target) )  
    	toggleGen(true)
    	toggleCamp(false)
    end
    		-- "event.target" is the tapped object
    return true
end



local function addBtns( btnNames, x, y, orient )
	local btns = {}
	if orient == 'right' then
		labOrient = 'left'
	else
		labOrient = 'right'
	end


	for i=1,#btnNames do
		print ("Creating button for "..btnNames[i][1])
		btns[i] = widget.newButton(
	    {
	        label = btnNames[i][1], labelAlign=labOrient,
	        onPress = btnNames[i][2],
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


local function gotoCampaign( campaign )
	print("Transitioning to campaign view")
	print("*** "..campaign.name.."*** called, id:" .. campaign.id);

	composer.gotoScene("editCampaign", { effect = "fade", time = 400, params = { campaign = campaign }})

end

local function newCampaign( )
	print("Transitioning to campaign view")
	local name = Randomizer:generateNpcName()
	newCampaign = CampaignClass.new(name)
	newCampaign.description = 'notes'
	print("NEW "..newCampaign.name.." called, id:" .. newCampaign.id);

	composer.gotoScene("editCampaign", { effect = "fade", time = 400, params = { campaign = newCampaign }})

end

local function loadSavedCampaigns( group )
	print(currentScene .. ":loadSavedCampaigns() called")

	CampaignList:reloadCampaigns()
	local cc = CampaignList:getCampaignCount()
	-- cBtnNameList = {{'new', function() print("New Campaign fxn() called..."); composer.showOverlay( "newCampaign", popOptions ); end}}
	cBtnNameList = {{'new', function() print("About to add new campaign..."); newCampaign(); end}}


	print ("loadSavedCampaigns(): currentCampaign = " .. appSettings.currentCampaign)
 	for i = 1, cc do
 		if i < 5 then
 			local c = CampaignList:getCampaign( i )
 			if tonumber(appSettings.currentCampaign) == i then 
 				cName = "[ " .. c.name .. " ]"
 			else
 				cName = c.name
 			end
 			cBtnNameList[i+1] = {cName, function() gotoCampaign(c); end}
 		end
 	end

 	cBtns = addBtns(cBtnNameList,
					campBtnX+75, campBtnY, 'right')
	
    for i=1, #cBtns do
    	cBtns[i].alpha = 0
    	cBtns[i].isEnabled=false
		group:insert(cBtns[i])
	end
end



--Create the scene
function scene:create( event )
	local group = self.view

	currentScene = "home"
	print(currentScene .. ":createScene")
	
	buttonsDisabled = false

	appSettings = { fileVersion = 1, 
					appName = "GameMastery", 
					appVersion = GAMEMASTERY_VERSION, 
					campaignCounter=0,
					questCounter=0,
					encounterCounter=0,
					initiativeCounter=0,
	}

	cBtnsFlag = false
	gBtnsFlag = false



	FileUtil:initializeSettingsFileIfNotExists("settings.cfg", appSettings)
	readResult = FileUtil:loadSettingsFile("settings.cfg", appSettings)

	initPage(group)

	campBtnX = 90
	campBtnY = display.contentHeight/2 + yOffset + titleBarHeight/2

	local campaignsBtn = widget.newButton(
    {
        label = "Campaigns", font=btnFont, fontSize=btnFontSize-4, emboss = false,
        defaultFile= "images/gamemastery/button_celticspears_square.png",
        overFile= "images/gamemastery/button_celticspears_square.png",
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        x = campBtnX, y = campBtnY, width=180, height=180
    })

	campaignsBtn:addEventListener( "tap", tapListener )  -- Add a "tap" listener to the object

	group:insert(campaignsBtn)

	if overGroup then overGroup:removeSelf() end
	overGroup = display.newGroup()
	overGroup.x=display.contentCenterX
	overGroup.y=display.contentCenterY


	toolBtnX = 90
	toolBtnY = display.contentHeight/2 + yOffset + titleBarHeight/2

	local toolsBtn = widget.newButton(
    {
        label = "Tools", emboss = false, font=btnFont, fontSize=btnFontSize-4,
        defaultFile= "images/gamemastery/button_celticspears_square.png",
        overFile= "images/gamemastery/button_celticspears_square.png",
        onEvent = handleTButtonEvent,
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
        x = display.contentWidth-90, y = display.contentHeight-90,
      	height=180, width=180
    })

	group:insert(toolsBtn)

	genBtnX = display.contentWidth-90
	genBtnY = 90 + yOffset*2 + titleBarHeight
   
    generateBtn = widget.newButton(
    {
        label = "  Quick\nGenerate", emboss = false, font=btnFont, fontSize=btnFontSize-4,
        defaultFile= "images/gamemastery/button_celticspears_square.png",
        overFile= "images/gamemastery/button_celticspears_square.png",
        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

        x = genBtnX, y = genBtnY, height=180, width=180
    })

	generateBtn:addEventListener( "tap", tapListenerG)  -- Add a "tap" listener to the object
	group:insert(generateBtn)

	loadSavedCampaigns(group);
	

	gBtns = addBtns({ 
				{'NPC', function() buttonsDisabled=true; manageNpc.openNewNpcDialog(overGroup, function() buttonsDisabled=false; end); end}, 
				{'Place',function() buttonsDisabled=true; managePlace.openNewPlaceDialog(overGroup, function() buttonsDisabled=false; end); end},
				{'Thing',function() buttonsDisabled=true; manageThing.openNewThingDialog(overGroup, function() buttonsDisabled=false; end); end},
				{'Quest',function() buttonsDisabled=true; manageQuest.openNewQuestDialog(overGroup, function() buttonsDisabled=false; end); end}},
			genBtnX-140, genBtnY, 'left')

	for i=1, #gBtns do
    	gBtns[i].alpha = 0
    	gBtns[i].isEnabled=false
		group:insert(gBtns[i])
	end

	group:insert(overGroup)
end




function scene:show( event )
	local group = self.view


	CampaignList:loadCampaigns()

	currentScene = "home"
	if not shown then
		print(currentScene .. ":SHOW")		
		shown=1
	else
		print(currentScene .. ":show skipped")
		toggleCamp(false)
		loadSavedCampaigns(group);
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

end	



--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )


return scene
