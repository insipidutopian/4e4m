-- 
-- GameMastery app, Campaign Settings Screen
--  
-- 
--

local composer = require ( "composer" )
local widget = require ( "widget" )
CampaignList = require ("CampaignList")
local campaign = require ( "campaign" )
local manageParty = require("manageParty")
local PartyMember = require("partyMember")



local scene = composer.newScene()

local currentScene = "manageCampaignSettings"

local currentCampaign

local campaignsGroup
local overlayGroup
local navGroup

local campaignName
local campaignSystem
local campaignCalendar
local campaignDate

local campaignsX = display.contentWidth
local campaignsY = display.contentHeight-150

local campaignsYStart 

local textXOffset = 60
local textWidth = campaignsX - 40 - textXOffset
local textHeight = campaignsY - 40
local textYOffset = 0
local textBoxHeight = 80

-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist


local function saveCampaign( )
	print("saveCampaign() called, campaign ID is " .. currentCampaignId)
	--newCampaign = Campaign.new(campaignNameTextField.text, campaign.description, campaignSystem.text, campaignDate.date)
	

	if (currentCampaignId == 0) then
		--CampaignList:addCampaignToCampaign(newCampaign)
		print("ERROR: Campaign must already exist!")
	else
		if not currentCampaign then
			print("ERROR: Campaign must exist!")
		else
			currentCampaign:setName(campaignName.text)
			currentCampaign:setSystem(campaignSystem.text)
			currentCampaign:setCalendar(campaignCalendar.text)
			currentCampaign:setDate(campaignDate.text)
			--newCampaign.id = currentCampaignId
			CampaignList:updateCampaign(currentCampaign)
		end
	end
end

local function deleteCampaign(campaign)
	ssk.misc.easyAlert("Delete Campaign?", "ARE YOU SURE?", { 
		{ "Yes", function() CampaignList:removeCampaign(currentCampaign); composer.gotoScene("home", { effect = "fade", time = 400}); end } , 
		{ "No", nil}})
end


local function hideTextFields( )
	print("--==[ HIDING TEXT FIELDS ]==--")
	campaignName.isVisible = false
	campaignSystem.isVisible = false
	campaignDate.isVisible = false
	campaignCalendar.isVisible = false
end


local function showTextFields()

	campaignName.isVisible = true
	campaignSystem.isVisible = true
	campaignCalendar.isVisible = true
	campaignDate.isVisible = true

end


local function reloadPartyTable()
	currentPartyTable:deleteAllRows();

	print("Campaign has " .. tostring(#currentCampaign.partyMemberList) .. " members.")
	for i=0, #currentCampaign.partyMemberList do
		local isCategory = false
		local rowColor = { default={0.1,0.1,0.1}, over = {0.3,0.3,0.3}}
		local lineColor = {0.5,0.5,0.5}
		if i == 0 then
			isCategory = true
			rowColor = { default={1,0,0}, over = {1,1,1}}
			lineColor = {0,0,0}
			currentPartyTable:insertRow(
			{
				isCategory = isCategory,
				rowHeight = 20,
				rowColor = rowColor,
				lineColor = lineColor,
				params = { partyMember = PartyMember.new("Name", "", "Class", "Race", "Level") }
			})
		else
			currentPartyTable:insertRow(
			{
				isCategory = isCategory,
				rowHeight = 20,
				rowColor = rowColor,
				lineColor = lineColor,
				params = { partyMember = currentCampaign.partyMemberList[i] }
			})
		end
	end
end

local function refreshCampaignSettingsPage()
	if not campaignName then
		showTextFields()
	end
	reloadPartyTable()
end



--Create the scene
function scene:create( event )
	local group = self.view

	print(currentScene .. ":createScene")


	local yStart = titleBarHeight + yPadding 
	local buttonCount = 0

	currentCampaign = CampaignList:getCurrentorNewCampaign()

	ssk.easyIFC:presetLabel( group, "appLabel", "Campaign Settings: ", 160 , yStart + 10)

	

	campaignsYStart = -campaignsY/2 +40
	
end

function scene:show( event )
	local group = self.view
	print(currentScene .. ":show")
	
	
	if event.phase == "will" then
		print(currentScene .. ":SHOW WILL PHASE")

		currentCampaign = CampaignList:getCurrentorNewCampaign()

		if campaignsGroup then campaignsGroup:removeSelf() end
		campaignsGroup = display.newGroup(group)
		campaignsGroup.x=display.contentWidth/2
		campaignsGroup.y=display.contentHeight/2
		group:insert(campaignsGroup)

		local campaignsSquare = display.newRect(campaignsGroup, 0, 20, campaignsX, campaignsY)
		campaignsSquare.stroke = {0.6,0,0}
		campaignsSquare.strokeWidth = 2
		campaignsSquare.fill = {0,0,0}

		

		if largeFormat then
			textBoxHeight = 130
		end

		currentCampaignId = currentCampaign.id
		y = (campaignsY / -2) + 100
		x = textWidth/4
		


		ssk.easyIFC:presetLabel( campaignsGroup, "appLabel", "Name:", -x - textXOffset/2, y, {align="left", width=textWidth/2})
		local titleSquare = display.newRoundedRect(campaignsGroup, x-40 - textXOffset/2, y, -6+textWidth/2+80, 24, 4 )
		titleSquare.fill = {0.1,0.1,0.1}
		campaignName = ssk.easyIFC:presetTextInput(campaignsGroup, "title", currentCampaign.name, x-40 - textXOffset/2, y, 
		 		{listener=uiTools.textFieldListener, width=70+textWidth/2})
		
	    y=y+25; 
	    
	    ssk.easyIFC:presetLabel( campaignsGroup, "appLabel", "System:", -x - textXOffset/2, y, {align="left", width=textWidth/2})
	    local systemSquare = display.newRoundedRect(campaignsGroup, x - textXOffset/2, y, -6+textWidth/2, 24, 4 )
		systemSquare.fill = {0.1,0.1,0.1}
		campaignSystem = ssk.easyIFC:presetTextInput(campaignsGroup, "default", currentCampaign.system, x - textXOffset/2, y, 
				{listener=uiTools.textFieldListener, width=-10+textWidth/2})
		y=y+25; 
	    ssk.easyIFC:presetLabel( campaignsGroup, "appLabel", "Calendar:", -x - textXOffset/2, y, {align="left", width=textWidth/2})
	    local calSquare = display.newRoundedRect(campaignsGroup, x - textXOffset/2, y, -6+textWidth/2, 24, 4 )
		calSquare.fill = {0.1,0.1,0.1}
		campaignCalendar = ssk.easyIFC:presetTextInput(campaignsGroup, "default", currentCampaign.calendar, x - textXOffset/2, y, 
				{listener=uiTools.textFieldListener, width=-10+textWidth/2})

		y=y+25; 
	    ssk.easyIFC:presetLabel( campaignsGroup, "appLabel", "Current Date:", -x - textXOffset/2, y, {align="left", width=textWidth/2})
	    local dateSquare = display.newRoundedRect(campaignsGroup, x - textXOffset/2, y, -6+textWidth/2, 24, 4 )
		dateSquare.fill = {0.1,0.1,0.1}
		campaignDate = ssk.easyIFC:presetTextInput(campaignsGroup, "default", currentCampaign.date, x- textXOffset/2, y, 
			{listener=uiTools.textFieldListener, width=-10+textWidth/2})



		y=y+25;
		ssk.easyIFC:presetLabel( campaignsGroup, "appLabel", "Current Party:", -x - textXOffset/2, y, {align="left", width=textWidth/2})
		--
		-- Party Info
		--
		local function onRowRender( event )
	 		local row = event.row -- get the row group
			print("onRowRender " .. row.index)
			if row.params.partyMember then
				print("... ", row.params.partyMember.name);
			end

			local align = { "left", "left", "right", "left"}
			local x = {0, 180, 260, 310}


	 		local rowHeight = row.contentHeight
	 		local rowWidth = row.contentWidth -- save these in case bounds change on add'l row adds

	 		local options = {
	 			fontSize = mainFontSize,
	 			font = mainFont,
	 			y = rowHeight * 0.5
	 		}


	 		for i=1, 3 do -- foreach column:
	 			if i == 1 then
	 				options.text = row.params.partyMember.name
	 			elseif i == 2 then
	 				options.text = row.params.partyMember.class
				elseif i == 3 then
					options.text = row.params.partyMember.level
				end
	 			options.x = x[i]
	 			options.align = align[i]
	 			
	 			if not row.isCategory and i==3 then
	 				options.x = options.x+20
	 			end

	 			local rowText = display.newText(options)
	 			rowText.anchorX = 0

	 			if row.isCategory then
	 				rowText:setFillColor(0,0,0)
	 			else
	 				rowText:setFillColor(0.8,0,0)
	 			end
	 			row:insert(rowText)
	 		end

	 		if largeFormat then
	 			options.text = row.params.partyMember.race
	 			options.x = x[4]
	 			options.align = align[4]

	 			local rowText = display.newText(options)
	 			rowText.anchorX = 0

	 			if row.isCategory then
	 				rowText:setFillColor(0,0,0)
	 			else
	 				rowText:setFillColor(0.8,0,0)
	 			end
	 			row:insert(rowText)
	 		end

	 		
	 	end


		local function onRowTouch( event )
	 		--print("A Row was touched! target = " .. tostring(event.target))
	 		print("A Row was touched! index = " .. tostring(event.target.index) .. ", phase is " .. event.phase)
	 		print("You touched " .. currentCampaign.partyMemberList[event.target.index-1].name)
	 		hideTextFields()
	 		manageParty.openExistingPartyMemberDialog( 
	 			overlayGroup, currentCampaign.partyMemberList[event.target.index-1], refreshCampaignSettingsPage)
	 	end

	 	-- local tableHeight = 20 + #currentCampaign.partyMemberList * 20
	 	-- if #currentCampaign.partyMemberList > 6 then
	 	-- 	tableHeight = 7 * 20
	 	-- elseif #currentCampaign.partyMemberList == 0 then
	 	-- 	tableHeight = 2 * 20
	 	-- end

	 	y = y + 15
		currentPartyTable = widget.newTableView(
		{
			left = textWidth/-2 - textXOffset/2,
			--left = 0,
			top = y,
			height = 140,
			width = textWidth,
			onRowRender = onRowRender,
			onRowTouch = onRowTouch,
			listener = scrollViewListener,
			backgroundColor = {0,0,0}
		})

		campaignsGroup:insert(currentPartyTable)

		-- load currentPartyTable
		reloadPartyTable()

		y = y + 140 + 25
		ssk.easyIFC:presetPush( campaignsGroup, "appButton", 0 - textXOffset/2, y, 200, 30, "Add Party Member", 
			function() hideTextFields(); manageParty.openNewPartyMemberDialog( overlayGroup, refreshCampaignSettingsPage); end )


		y = (campaignsY / 2) - 50
		ssk.easyIFC:presetPush( campaignsGroup, "appButton", -50 - textXOffset/2, y, 80, 30, "Delete", function() deleteCampaign(campaign); end )
		ssk.easyIFC:presetPush( campaignsGroup, "appButton", 50 - textXOffset/2, y, 80, 30, "Save", saveCampaign )

	    if navGroup then navGroup:removeSelf() end
		navGroup = display.newGroup(group)
		local homeBtn = widget.newButton(
	    {   
	        label = "Home", font=btnFont, fontSize=btnFontSize, emboss = false,
	        shape = "circle", radius = 50*0.9, cornerRadius = 2, strokeWidth = 4,
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
	        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
	        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
	        onPress = function()  composer.gotoScene("home", { effect = "fade", time = 400}) end,
	    	x = display.contentWidth-60,
	      	y = display.contentHeight-60
	    })
		navGroup:insert(homeBtn)

		local backBtn = widget.newButton(
	    {   
	        label = "Back", font=btnFont, fontSize=btnFontSize, emboss = false,
	        shape = "circle", radius = 50*0.9, cornerRadius = 2, strokeWidth = 4,
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
	        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
	        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
	        onPress = function()  composer.gotoScene("editCampaign", { effect = "fade", time = 400, params = {campaign = currentCampaign}}) end,
	    	x = 60,
	      	y = display.contentHeight-60
	    })
	    navGroup:insert(backBtn)


		--if not overlayGroup then 
			overlayGroup = display.newGroup(); 
			overlayGroup.x=display.viewableContentWidth/2
			overlayGroup.y=display.viewableContentHeight/2
			group:insert(overlayGroup)
		--end

	else	
		print(currentScene .. ":SHOW DID PHASE")
		local function tapListener( event )
		    if event then
		    	print( "tapped: " .. tostring(event.target) )  
		    	if event.target.name then
		    		print("Pressed " .. event.target.name .. " Navigation Button")
		    		composer.gotoScene("manage" .. event.target.name, { effect = "fade", time = 400, params = {campaign = currentCampaign}})
		    	end
		    	--do stuff
		    end
	   	 	return true
		end

		settingsButton = widget.newButton(
	    {
	        label = "Settings", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/settings-selected.png",
	        overFile= "images/gamemastery/icons/settings.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 170, height=60, width=60
	    })
	    --settingsButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
	    settingsButton.name = "CampaignSettings"
		navGroup:insert(settingsButton)

		encountersButton = widget.newButton(
	    {
	        label = "Encounters", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/encounters.png",
	        overFile= "images/gamemastery/icons/encounters-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 250, height=60, width=60
	    })

		encountersButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		encountersButton.name = "Encounters"
		navGroup:insert(encountersButton)

		eventsButton = widget.newButton(
	    {
	        label = "Events", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/events.png",
	        overFile= "images/gamemastery/icons/events-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 330, height=60, width=60
	    })

		eventsButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		eventsButton.name = "Events"
		navGroup:insert(eventsButton)

		npcsButton = widget.newButton(
	    {
	        label = "NPCs", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/npcs.png",
	        overFile= "images/gamemastery/icons/npcs-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 410, height=60, width=60
	    })

		npcsButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		npcsButton.name = "Npcs"
		navGroup:insert(npcsButton)

		questsButton = widget.newButton(
	    {
	        label = "Quests", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/quests.png",
	        overFile= "images/gamemastery/icons/quests-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 490, height=60, width=60
	    })

		questsButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		questsButton.name = "Quests"
		navGroup:insert(questsButton)

		placesButton = widget.newButton(
	    {
	        label = "Places", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/places.png",
	        overFile= "images/gamemastery/icons/places-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 570, height=60, width=60
	    })

		placesButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		placesButton.name = "Places"
		navGroup:insert(placesButton)

		thingsButton = widget.newButton(
	    {
	        label = "Things", emboss = false, font=btnFont, fontSize=btnFontSize-4, labelYOffset = 38,
	        defaultFile= "images/gamemastery/icons/things.png",
	        overFile= "images/gamemastery/icons/things-selected.png",
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },

	        x = display.contentWidth - 40, y = 650, height=60, width=60
	    })

		thingsButton:addEventListener( "tap", tapListener)  -- Add a "tap" listener to the object
		thingsButton.name = "Things"
		navGroup:insert(thingsButton)
	end
end


function scene:destroy( event )
	print(currentScene .. ":destroy started")
	local group = self.view

	print(currentScene .. ":exitScene")
end	

function scene:hide( event )
	print(currentScene .. ":hide started")
	local group = self.view

	

	if event.phase == "will" then
		campaignsGroup:removeSelf()
		navGroup:removeSelf()
	--elseif event.phase == "did" then
		
	end
end	


--Add the createScene, enterScene, and exitScene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene)
scene:addEventListener( "destroy", scene )


return scene
