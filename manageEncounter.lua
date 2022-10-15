-- manageEncounter.lua
local Encounter = require("encounter")
local json = require "json"
local widget = require ( "widget" )

local DDM     = require "lib.DropDownMenu"
local RowData = require "lib.RowData"

local funx = require("scripts.funx")
local textrender = require("scripts.textrender.textrender")
local textStyles = funx.loadTextStyles("assets/textstyles.txt", system.ResourceDirectory)

manageEncounter = {}


-- Common SSK Helper Modules
local easyIFC = ssk.easyIFC;local persist = ssk.persist

local newEncounter
local encounterName
local encounterNotes
local featuresOfTheArea
local tactics
local rewards
local currentEncounterId
local entitiesText

local updateFunction
local encounterTypeDDM
local advTitle
local encounterThingsList
local addEntitiesBtn

local trapPicker
local trapDataLoaded = false
local trapList = {}

local monsterPicker
local monsterDataLoaded = false
local monsterList = {}

local skillPicker
local skillDataLoaded = false
local skillList = {}


local pickerWheelWidth = display.contentWidth - 100
local pickerWheelHeight = 300

local columnData =
{
    {
        align = "left",
        --width = 226,
        startIndex = 2,
        labels = { "Random" },
        data = {}
    }
}

local skillColumnData =
{
    {
        align = "left",
        width = 3*pickerWheelWidth/4,
        startIndex = 2,
        labels = { "Random" },
        data = {}
    },
    {
        align = "right",
        width = pickerWheelWidth/4,
        labelPadding = 10,
        startIndex = 10,
        labels = { }
    }
}

-- Image sheet options and declaration
local options = {
    frames = 
    {
        { x=0, y=0, width=pickerWheelWidth, height=pickerWheelHeight}
    },
    sheetContentWidth = pickerWheelWidth,
    sheetContentHeight = pickerWheelHeight,
    x = display.contentCenterX-20
}
local skillOptions = {
    frames = 
    {
        { x=0, y=0, width=3*pickerWheelWidth/4, height=pickerWheelHeight},
        { x=2*pickerWheelWidth/2, y=0, width=pickerWheelWidth/4, height=pickerWheelHeight }
    },
    sheetContentWidth = pickerWheelWidth,
    sheetContentHeight = pickerWheelHeight,
    x = display.contentCenterX-20
}
local pickerWheelSheet = graphics.newImageSheet( "images/gamemastery/picker_celticspears_square.png", options )
local skillPickerWheelSheet = graphics.newImageSheet( "images/gamemastery/picker_celticspears_square.png", skillOptions )


local function updateEncounter()
	print("Updating Encounter")
	print("         Encounter Name:  " .. newEncounter.name)
end

function manageEncounter.openViewEncounterDialog(encounter, group, showRerollButton, onSave)
	updateFunction = onSave
	print("openViewEncounterDialog() called, Encounter is " .. encounter.name)
	local thisEncounter = Encounter.newEncounter(encounter)
	print("openViewEncounterDialog() called, Encounter is " .. thisEncounter.name)
	
	local function onClose( self, onComplete )
		print("dialog onClose() called")
		transition.to( self, { y = centerY + fullh, transition = easing.inBack, onComplete = onComplete } )
	end

	local function closeTray( event )
		print("tray closeTray() called")
		updateFunction()
		onClose( dialog, function() dialog.frame:close() end )
	end

	local function rerollEncounter( event )
		print("Rerolling Encounter")
		tType = Randomizer:generateEncounterType()
		newEncounter = Randomizer:generateEncounter(tType)
		encounterNameTextField:setText(newEncounter.name)
		--encounterRaceTextField:setText(newEncounter.race)
		encounterNotes:setText(newEncounter.description)
	end

	local function rerollRewards()
		print("Rerolling Rewards")
		rewards.text = Randomizer:generateReward(2, 1)
	end

	

	local function loadTrapData()
		--if not trapDataLoaded then
			local fData = FileUtil:loadAppFile('srd_5e_traps.json')
			if (fData and fData ~= "") then
				--print("Got data: " .. fData)
				--entitiesText.text = fData

				local c = json.decode(fData)
				print("Read " .. #c .. " traps from srd_5e_traps.json")
				
				for i=1, #c do
					print("Trap: " .. c[i].name)
					trapList[c[i].name] = c[i]
					trapList[c[i].name].entityType="Trap"
					columnData[1].labels[i] = c[i].name
				end
				trapPicker = widget.newPickerWheel(
				{
				    --x = display.contentCenterX+200,
				    top = -100,
				    left = -pickerWheelWidth/2,
				    fontSize = 14,
				    width=pickerWheelWidth,
				    rowHeight = 30,
				    style = "resizable",
				    font = "fonts/kellunc.ttf",
				    fontColor = {0.6,0.0,0.0,0.6},
				    fontColorSelected = {0.6,0.0,0.0,1},
				    columnColor = {0,0,0},
				    columns = columnData,
				    sheet = pickerWheelSheet,
			    	overlayFrame = 1,
			    	backgroundFrame = 2,
			    	separatorFrame = 3
				})  
				trapDataLoaded = true
			else
				print("File was empty")
			end
		--end
	end

	local function loadMonsterData()
		--if not trapDataLoaded then
			local fData = FileUtil:loadAppFile('srd_5e_monsters.json')
			if (fData and fData ~= "") then
				--print("Got data: " .. fData)
				--entitiesText.text = fData

				local c = json.decode(fData)
				print("Read " .. #c .. " monsters from srd_5e_monsters.json")
				
				for i=1, #c do
					print("Monster: " .. c[i].name)
					monsterList[c[i].name] = c[i]
					monsterList[c[i].name].entityType="Monster"
					columnData[1].labels[i] = c[i].name
				end
				monsterPicker = widget.newPickerWheel(
				{
				    --x = display.contentCenterX+200,
				    top = -100,
				    left = -pickerWheelWidth/2,
				    fontSize = 14,
				    width=pickerWheelWidth,
				    rowHeight = 30,
				    style = "resizable",
				    font = "fonts/kellunc.ttf",
				    fontColor = {0.6,0.0,0.0,0.6},
				    fontColorSelected = {0.6,0.0,0.0,1},
				    columnColor = {0,0,0},
				    columns = columnData,
				    sheet = pickerWheelSheet,
			    	overlayFrame = 1,
			    	backgroundFrame = 2,
			    	separatorFrame = 3
				})  
				monsterDataLoaded = true
			else
				print("File was empty")
			end
		--end
	end

	local function loadSkillData()
		
		local fData = FileUtil:loadAppFile('srd_5e_skills.json')
		if (fData and fData ~= "") then
			local c = json.decode(fData)
			print("Read " .. #c .. " skills from srd_5e_skills.json")
			
			for i=1, #c do
				print("Skill: " .. c[i].name)
				skillList[c[i].name] = c[i]
				skillList[c[i].name].entityType="Skill"
				skillColumnData[1].labels[i] = c[i].name
			end
			for i=1, 30 do
				skillColumnData[2].labels[i] = "DC " .. i
			end
			skillPicker = widget.newPickerWheel(
			{
			    --x = display.contentCenterX+200,
			    top = -100,
			    left = -pickerWheelWidth/2,
			    fontSize = 14,
			    width=pickerWheelWidth,
			    rowHeight = 30,
			    style = "resizable",
			    font = "fonts/kellunc.ttf",
			    fontColor = {0.6,0.0,0.0,0.6},
			    fontColorSelected = {0.6,0.0,0.0,1},
			    columnColor = {0,0,0},
			    columns = skillColumnData,
			    sheet = skillPickerWheelSheet,
		    	overlayFrame = 1,
		    	backgroundFrame = 2,
		    	separatorFrame = 3
			})  
			skillDataLoaded = true
		else
			print("File was empty")
		end
	
	end

	local function saveEncounterToCampaign( )
		print("saveEncounterToCampaign() called, encounter ID is " .. currentEncounterId)
		newEncounter = Encounter.new(encounterNameTextField.text, "", encounterNotes.text)
		newEncounter.featuresOfTheArea = featuresOfTheArea.text
		newEncounter.tactics = tactics.text
		newEncounter.rewards = rewards.text
		newEncounter.type = encounterTypeDDM.getCurrentlySelectedValue()
		newEncounter.entities = thisEncounter.entities
		--currentCampaign = CampaignList:getCurrentCampaign()
		if (currentEncounterId == 0) then
			CampaignList:addEncounterToCampaign(newEncounter)
		else
			newEncounter.id = currentEncounterId
			CampaignList:updateEncounterForCampaign(newEncounter)
		end
		updateFunction()

		closeTray()
	end

	local function deleteEncounter(encounter)
		CampaignList:removeEncounterFromCampaign(encounter)
		updateFunction()
		closeTray()
	end

	local function updateEncounterType()
		local encounterType = encounterTypeDDM:getCurrentlySelectedValue()
		print("Encounter Type now: " .. encounterType)
		if encounterType == 'Combat' then
			advTitle:setText('Enemies')
			thisEncounter.type = "Combat"
		elseif encounterType == 'Social' then
			advTitle:setText('Skill Challenge')
			thisEncounter.type = "Social"
		elseif encounterType == 'Exploration' then
			advTitle:setText('Exploration')
			thisEncounter.type = "Exploration"
		end
	end

	local function addMonsterToEnemies()
		local values = monsterPicker:getValues()
		 
		-- Get the value for each column in the wheel, by column index
		local monsterName = values[1].value

		print("Adding Monster : " .. monsterName)
		print("  " .. monsterList[monsterName].name .. ": " .. monsterList[monsterName].meta)
		
		return thisEncounter:addEntity(monsterList[monsterName])

	end

	local function addTrapToEnemies()
		local values = trapPicker:getValues()
		 
		-- Get the value for each column in the wheel, by column index
		local trapName = values[1].value
		--local npcBackground = values[2].value

		print("Adding trap : " .. trapName)
		print("  " .. trapList[trapName].name .. ": " .. trapList[trapName].type)
		
		return thisEncounter:addEntity(trapList[trapName])

	end

	local function addSkillToEnemies()
		local values = skillPicker:getValues()
		 
		-- Get the value for each column in the wheel, by column index
		local skillName = values[1].value
		local dc = values[2].value

		print("Adding skill : " .. skillName)
		print("  " .. skillList[skillName].name .. ": " .. dc)
		
		local skill = skillList[skillName]
		skill['dc'] = dc
		return thisEncounter:addEntity(skill)

	end

	local function removeEntity(entity)
		print("removeEntity() called: " .. entity.name)
		thisEncounter:removeEntity(entity)
	end

	local function showResult(result)
		print("showResult()")
		local showResultGroup = display.newGroup()
		dialog:insert(showResultGroup)
		
		local addStuffBG = display.newRect(0, 0, 200,100)
		addStuffBG.fill = { 0.8, 0.1, 0.1 }

		showResultGroup:insert(addStuffBG)
		display.newImage(showResultGroup,  'images/gamemastery/120x60-ul-corner-black.png', 
		-42 , -20)
		display.newImage(showResultGroup,  'images/gamemastery/120x60-lr-corner-black.png', 
		42 , 20)

		local resultString = ""
		if type(result) == "string" then
			resultString = result
		elseif type(result) == "boolean" then
			if result then
				resultString = "Success"
			else
				resultString = "Failed"
			end
		end

		local cl = ssk.easyIFC:presetLabel(showResultGroup, "darkText", resultString, 0, 0) 
			
		timer.performWithDelay( 1200, function() showResultGroup:removeSelf(); end)
	end

	local function loadEncounterEntities()
		encounterThingsList:deleteAllRows();
		
		local visibleCellCount = #thisEncounter.entities + 1
		if visibleCellCount > 6 then visibleCellCount = 6; end
		encounterThingsList.height = visibleCellCount * 25
		encounterThingsList.y = -90 + visibleCellCount * 12.5
		addEntitiesBtn.y = -50 + visibleCellCount  * 25

		local headerName = "Trap Name"
		if thisEncounter.type == "Combat" then 
			headerName = "Enemy Name"
		elseif thisEncounter.type == "Social" then
			headerName = "Skill Name"
		end
		if #thisEncounter.entities == 0 then headerName = "Adversaries"; end
		encounterThingsList:insertRow({
	        isCategory = true,
	        rowHeight  = 25,
	        rowColor   = {default=_RED_, over={.1,.1,.1,1}},
	        lineColor  = _BLACK_,
	        params     = { value = headerName } 
	      })
		for i=1, #thisEncounter.entities do
			print("Loading entity: " .. thisEncounter.entities[i].name )
			local rowTitle = thisEncounter.entities[i].name
			if thisEncounter.type == "Social" then
				rowTitle = rowTitle .. " (" .. thisEncounter.entities[i].dc .. ")"
			end			

			encounterThingsList:insertRow({
				isCategory = false,
		        rowHeight  = 25,
		        rowColor   = {default=_BLACK_, over={.1,.1,.1,1}},
		        lineColor  = _BLACK_,
		        params     = { value = rowTitle} 
			})

		end

	end

	local function showAddStuff()
		print("ShowAddStuff pushed")
		local addStuffGroup = display.newGroup()
		dialog:insert(addStuffGroup)
		--encounterBuilderPC['Adversaries']:insert(addStuffGroup)
		local addStuffBG = display.newRect(0, 0, display.contentWidth -20,300)
		addStuffBG.fill = _BLACK_
		addStuffGroup:insert(addStuffBG)

		local encounterType = encounterTypeDDM:getCurrentlySelectedValue()

		if encounterType == 'Combat' then
			print("Combat Encounter")
			local cl = ssk.easyIFC:presetLabel(addStuffGroup, "title", "Add Enemies", 0, -130)
			loadMonsterData()
			addStuffGroup:insert(monsterPicker)
			if trapPicker then trapPicker:removeSelf( ); end
			if skillPicker then skillPicker:removeSelf( ); end

			ssk.easyIFC:presetPush( addStuffGroup, "appButton", -70, 85, 120, 30, 
				"Add", function() showResult(addMonsterToEnemies() ); loadEncounterEntities(); end )
		elseif encounterType == 'Exploration' then
			local el = ssk.easyIFC:presetLabel(addStuffGroup, "title", "Add Traps", 0, -130) 
			loadTrapData()
			addStuffGroup:insert(trapPicker)
			if monsterPicker then monsterPicker:removeSelf( ); end
			if skillPicker then skillPicker:removeSelf( ); end
			ssk.easyIFC:presetPush( addStuffGroup, "appButton", -70, 85, 120, 30, 
				"Add", function() showResult(addTrapToEnemies() ); loadEncounterEntities(); end )
		elseif encounterType == 'Social' then
			local sl = ssk.easyIFC:presetLabel(addStuffGroup, "title", "Add Challenges", 0, -130) 
			loadSkillData()
			addStuffGroup:insert(skillPicker)
			if trapPicker then trapPicker:removeSelf( ); end
			if monsterPicker then monsterPicker:removeSelf(); end

			ssk.easyIFC:presetPush( addStuffGroup, "appButton", -70, 85, 120, 30, 
				"Add", function() showResult(addSkillToEnemies() ); loadEncounterEntities(); end )
		end

		

		ssk.easyIFC:presetPush( addStuffGroup, "appButton", 70, 85, 120, 30, 
			"Close", function() addStuffGroup:removeSelf(); end )



	end

	

	local image = "images/gamemastery/dialog_celticspears_tall3.png"
	if largeFormat then
		image = "images/gamemastery/dialog_celticspears_tall2.png"
	end

	centerX=0
	centerY=0
	local width, height = ssk.misc.getImageSize( image )
	print("IMAGE W=" .. tostring(width) .. ", H=" .. tostring(height))
	if not group then group = display.newGroup(); end
	dialog = ssk.dialogs.custom.create( group, 0, 0, 
	         { width = width,
	           height = height,
	           softShadow = true,
	           softShadowOX = 8,
	           softShadowOY = 8,
	           softShadowBlur = 6,
	           closeOnTouchBlocker = false, 
	           blockerFill = _WHITE_,
	           blockerAlpha = 0.15,
	           softShadowAlpha = 0.3,
	           blockerAlphaTime = 100,
	           onClose = onClose,
	           trayImage = image,
           	   shadowImage = image } )

	local textWidth = width - 80
	local textHeight = height - 200
	local textYOffset = 0
	local textBoxHeight = 80

	if largeFormat then
		textYOffset = 50
		textBoxHeight = 130
	end



	y = textYOffset + textHeight / -2
	currentEncounterId = encounter.id
	local titleSquare = display.newRoundedRect(dialog, 0, y-10, textWidth+4, 24, 4 )
	titleSquare.fill = {0.1,0.1,0.1}
	local focus = false
	if encounter.name == "" then
		focus = true
	end
	encounterNameTextField = ssk.easyIFC:presetTextInput(dialog, "title", encounter.name, 0, y-10, 
			{listener=uiTools.textFieldListener, width=textWidth, placeholder='Encounter Name', keyboardFocus=focus})
	

	y=y+10
	local ebHeight = 300
	local encounterBuilderLayerNames = {"Description", "Parameters", "Features of the Area", "Adversaries", "Tactics", "Rewards"}
	local encounterBuilderPC = ssk.easyIFC:newPagecontrols( { 
			layernames = encounterBuilderLayerNames,
			x = 0,
			y = y + ebHeight/2,
			h = ebHeight,
			w = width-60,
			backgroundColor  = {0.2,0.1,0.1},
			roundedRect = true},
			dialog )
	local ebLayers = encounterBuilderPC:getLayers()
	local decoration1 = display.newImage(ebLayers['background'],  'images/gamemastery/120x60-ul-corner-red.png', 
		encounterBuilderPC.x - encounterBuilderPC['w']/2 , encounterBuilderPC.y - encounterBuilderPC['h']/2)
	decoration1.anchorX = 0
	decoration1.anchorY = 0

	local decoration2 = display.newImage(ebLayers['background'],'images/gamemastery/120x60-lr-corner-red.png', 
	(encounterBuilderPC.x - encounterBuilderPC['w']/2) + (encounterBuilderPC['w']-120), 
	(encounterBuilderPC.y - encounterBuilderPC['h']/2) + encounterBuilderPC['h']-60)
	decoration2.anchorX = 0
	decoration2.anchorY = 0
	
	local descTitle = encounterBuilderPC:addObjectToLayer( 'Description', 
    	ssk.easyIFC:presetLabel(ebLayers['Description'], "title", "Description", encounterBuilderPC['w']/2, 30) )
	local descSquare = encounterBuilderPC:addObjectToLayer( 'Description', 
		display.newRoundedRect(ebLayers['Description'], encounterBuilderPC['w']/2, ebHeight/2, width-80, ebHeight - 80, 4 ))
	descSquare.fill = {0.1,0.1,0.1}

	encounterNotes = encounterBuilderPC:addObjectToLayer( 'Description', 
		ssk.easyIFC:presetTextBox(encounterBuilderPC['Description'], "default", encounter.description, encounterBuilderPC['w']/2, ebHeight/2, 
		{listener=uiTools.textFieldListener, width = width-80, height = ebHeight - 80}))

	local paramsTitle = encounterBuilderPC:addObjectToLayer( 'Parameters', 
    	ssk.easyIFC:presetLabel(ebLayers['Parameters'], "title", "Parameters", encounterBuilderPC['w']/2, 30) )
	
	if thisEncounter.type == "" then
		thisEncounter.type = "Combat"
	end
	local typeLabel = encounterBuilderPC:addObjectToLayer( 'Parameters', 
    	ssk.easyIFC:presetLabel(ebLayers['Parameters'], "appLabel", "Type", 40, 100) )
	encounterTypeDDM = ssk.easyIFC:presetDropDownMenu( ebLayers['Parameters'], "default", thisEncounter.type, display.contentCenterX,
  			100,  { dataList={"Combat", "Exploration", "Social"}, onRowSelected=updateEncounterType})
	encounterBuilderPC:addObjectToLayer( 'Parameters',
		encounterTypeDDM['tableGroup'])
	-- encounterTypeDDM:getCurrentlySelectedValue()

	local function showTFs()
		encounterNameTextField.isVisible = true
	end

	local function hideTFs()
		encounterNameTextField.isVisible = false
	end

	local function showEntityDetails(entity)
		print("showEntityDetails() called: " .. entity.name)
		hideTFs()
		local showEntityGroup = display.newGroup()
		dialog:insert(showEntityGroup)
		local yOffset = -60
		local w = display.contentWidth - 20
		local h = display.contentHeight - 120
		local showEntityBG = display.newImageRect( "images/parchment-paper.jpeg", w, h ) --display.newRect(0, yOffset, w, h)
		--showEntityBG.fill = _GREY_
		showEntityBG.y = -50
		showEntityGroup:insert(showEntityBG)


		local mytext = "<h1>" .. entity.name .. "</h1>"
		if entity.entityType == "Trap" then
			print("Displaying entityType Trap")
			mytext = mytext .. "<body><p><i>" .. entity.type .. "</i></p><hr>"
			mytext = mytext .. "<h3>Description</h3><p>" .. entity.description .. "</p>"
			mytext = mytext .. "<h3>Detection</h3><p>" .. entity.detection .. "</p>"
			mytext = mytext .. "<h3>Disabling</h3><p>" .. entity.mitigation .. "</p>"
			mytext = mytext .. "<h3>Trap Effects</h3><p>" .. entity.triggering .. "</p>"
		elseif entity.entityType == "Skill" then
			mytext = mytext .. "<p><i>" .. entity.attribute .. "</i></p><hr>"
			mytext = mytext .. "<p>" .. entity.description .. "</p>"
		elseif entity.entityType == "Monster" then
			print("Displaying entityType Monster")
			mytext = mytext .. "<p><i>" .. entity.meta .. "</i></p><hr>"
			--mytext = mytext .. "<img src=\"" .. "tmp.file\""
			mytext = mytext .. "<p><b>Armor Class:</b> " .. entity.AC .. "<br/>"
			mytext = mytext .. "<b>Hit Points:</b> " .. entity.HP .. "<br/>"
			mytext = mytext .. "<b>Speed:</b> " .. entity.Speed .. "</p><hr>"
			mytext = mytext .. "<p class=\"Stats\"><b>STR:</b> 8 <b>DEX:</b> 15 <b>CON:</b> 14 <b>INT:</b> 11 <b>WIS:</b> 9 <b>CHA:</b> 6</p><hr>"
			if entity.Skills then mytext = mytext .. "<p><b>Skills:</b>" .. entity.Skills .. "</p>"; end
			if entity.SavingThrows then mytext = mytext .. "<p><b>Saving Throws:</b>" .. entity.SavingThrows .. "</p>"; end
			if entity.DamageImmunities then mytext = mytext .. "<p><b>Damage Immunities:</b>" .. entity.DamageImmunities .. "</p>"; end
			if entity.ConditionImmunities then mytext = mytext .. "<p><b>Condition Immunities:</b>" .. entity.ConditionImmunities .. "</p>"; end
			mytext = mytext .. "<p><b>Senses:</b>" .. entity.Senses .. "</p>"
			mytext = mytext .. "<p><b>Languages:</b> " .. entity.Languages .. "</p>"
			mytext = mytext .. "<p><b>Challenge:</b>" .. entity.Challenge .. "</p><hr>"
			if entity.Traits then mytext = mytext .. entity.Traits; end
			mytext = mytext .. "<h2>Actions</h2>" .. entity.Actions
			if entity.LegendaryActions then mytext = mytext .. "<h2>Legendary Actions</h2>" .. entity.LegendaryActions; end
			local img
			local function networkListener( event )
			    if ( event.isError ) then
			        print ( "Network error - download failed" )
			    else
			        event.target.alpha = 0
			        transition.to( event.target, { alpha = 1.0 } )
			        event.target.height = 200
			        event.target.width = 200
			        if event.phase == "ended" then showEntityGroup:insert(event.target); end
			    end
			 
			    print ( "event.response.fullPath: ", event.response.fullPath )
			    print ( "event.response.filename: ", event.response.filename )
			    print ( "event.response.baseDirectory: ", event.response.baseDirectory )
			    
			end
			  
			img = display.loadRemoteImage( entity.img_url, "GET", networkListener, "tmp.file", system.TemporaryDirectory, 
				0, (h/-2) + 120 + yOffset)
		end
		local params = {
			text =  mytext,
			width = w - 40,  
			maxHeight = 0,	-- Set to zero, otherwise rendering STOPS after this amount!
			isHTML = true,
			useHTMLSpacing = true,
			textstyles = textStyles, --loaded above

			-- The higher these are, the faster a row is wrapped
			minCharCount = 10,	-- 	Minimum number of characters per line. Start low. Default is 5
			minWordLen = 2,	
			cacheDir = nil,
			cacheToDB = false,	-- true is default, for fast caches using sql database
		}

		print("Rendering text: " .. mytext)
		local textblock = textrender.autoWrappedText(params)
		-- Make the textblock a scrolling text block
		local options = {
			maxVisibleHeight = h-310,
			parentTouchObject = nil,
			
			hideBackground = true,
			backgroundColor = {1,1,1},	-- hidden by the above line
			
			-- Show an icon over scrolling fields: values are "over", "bottom", anything else otherwise defaults to top+bottom
			scrollingFieldIndicatorActive = true,
			-- "over", "bottom", else top and bottom
			scrollingFieldIndicatorLocation = "",
			-- image files
			scrollingFieldIndicatorIconOver = "scripts/textrender/assets/scrolling-indicator-1024.png",
			scrollingFieldIndicatorIconDown = "scripts/textrender/assets/scrollingfieldindicatoricon-down.png",
			scrollingFieldIndicatorIconUp = "scripts/textrender/assets/scrollingfieldindicatoricon-up.png",
			pageItemsFadeOutOpeningTime = 300,
			pageItemsFadeInOpeningTime = 500,
			pageItemsPrefadeOnOpeningTime = 500,

		}

		local textblock = textblock:fitBlockToHeight( options )
		local yAdjustment = textblock.yAdjustment
		textblock.x = w/-2 + 20
		local startY = (h/2) - 40
		textblock.y = 200 + yOffset + startY/-1
		
		showEntityGroup:insert(textblock)

		

		ssk.easyIFC:presetPush( showEntityGroup, "appButton", -70, yOffset + startY, 120, 30, 
			"Close", function() showEntityGroup:removeSelf(); showTFs(); end )
		ssk.easyIFC:presetPush( showEntityGroup, "appButton", 70, yOffset + startY, 120, 30, 
			"Delete", function() removeEntity(entity); loadEncounterEntities(); showEntityGroup:removeSelf(); showTFs(); end )

	end

	local function onRowTouch(event)
		if event.phase == "press" then
			print("A Row was touched! index = " .. tostring(event.target.index) .. ", phase is " .. event.phase)
	 		print("You touched " .. thisEncounter.entities[event.target.index-1].name)
	 		showEntityDetails(thisEncounter.entities[event.target.index-1])
	 	end
	end

	--The trees around a small hamlet begin to form fearsome-looking faces. While initially harmless, small animals and eventually children begin to disappear. An evil druid and their dryad companions want the land the hamlet resides on, and will do anything to take it. 


	local function onRowRender(event)
		local row = event.row -- get the row group
		print("onRowRender " .. row.index)
		if row.params.value then
			print("... ", row.params.value);
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

	 	options.text = row.params.value
		options.x = x[1]
		options.align = align[1]
		
		if not row.isCategory  then
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

	--end

	advTitle = encounterBuilderPC:addObjectToLayer( 'Adversaries', 
    	ssk.easyIFC:presetLabel(ebLayers['Adversaries'], "title", "Adversaries", encounterBuilderPC['w']/2, 30) )
	entitiesText = encounterBuilderPC:addObjectToLayer( 'Adversaries', 
		ssk.easyIFC:presetLabel(ebLayers['Adversaries'], "default", "", encounterBuilderPC['w']/2, 70) )
	
	local visibleCellCount = #thisEncounter.entities + 1
	encounterThingsList = encounterBuilderPC:addObjectToLayer( 'Adversaries', 
		widget.newTableView{
        x = encounterBuilderPC['w']/2,
        y = 70 + visibleCellCount * 12.5,
        width = 250,
        height = visibleCellCount * 25,
        noLines = noLines,
        backgroundColor = _LIGHTGREY_,
        onRowTouch = onRowTouch,
        onRowRender = onRowRender,
    })
    
    
    
    addEntitiesBtn = encounterBuilderPC:addObjectToLayer('Adversaries',
    	ssk.easyIFC:presetPush( dialog, "appButton", encounterBuilderPC['w']/2,95 + visibleCellCount * 25, 80, 30, "Add", 
    		showAddStuff ))
    loadEncounterEntities()
	local descTitle = encounterBuilderPC:addObjectToLayer( 'Features of the Area', 
    	ssk.easyIFC:presetLabel(ebLayers['Features of the Area'], "title", "Features of the Area", 15+encounterBuilderPC['w']/2, 30) )
	
	local featuresSquare = encounterBuilderPC:addObjectToLayer( 'Features of the Area', 
		display.newRoundedRect(ebLayers['Features of the Area'], encounterBuilderPC['w']/2, ebHeight/2, width-80, ebHeight - 80, 4 ))
	featuresSquare.fill = {0.1,0.1,0.1}
	featuresOfTheArea = encounterBuilderPC:addObjectToLayer( 'Features of the Area', 
		ssk.easyIFC:presetTextBox(encounterBuilderPC['Features of the Area'], "default", encounter.featuresOfTheArea, encounterBuilderPC['w']/2, ebHeight/2, 
		{listener=uiTools.textFieldListener, width = width-80, height = ebHeight - 80}))

	local descTitle = encounterBuilderPC:addObjectToLayer( 'Tactics', 
    	ssk.easyIFC:presetLabel(ebLayers['Tactics'], "title", "Tactics", encounterBuilderPC['w']/2, 30) )
	local tacticsSquare = encounterBuilderPC:addObjectToLayer( 'Tactics', 
		display.newRoundedRect(ebLayers['Tactics'], encounterBuilderPC['w']/2, ebHeight/2, width-80, ebHeight - 80, 4 ))
	tacticsSquare.fill = {0.1,0.1,0.1}
	tactics = encounterBuilderPC:addObjectToLayer( 'Tactics', 
		ssk.easyIFC:presetTextBox(encounterBuilderPC['Tactics'], "default", encounter.tactics, encounterBuilderPC['w']/2, ebHeight/2, 
		{listener=uiTools.textFieldListener, width = width-80, height = ebHeight - 80}))
	
	local descTitle = encounterBuilderPC:addObjectToLayer( 'Rewards', 
    	ssk.easyIFC:presetLabel(ebLayers['Rewards'], "title", "Rewards", encounterBuilderPC['w']/2, 30) )
	local rewardsSquare = encounterBuilderPC:addObjectToLayer( 'Rewards', 
		display.newRoundedRect(ebLayers['Rewards'], encounterBuilderPC['w']/2, ebHeight/2 - 15, width-80, ebHeight - 110, 4 ))
	rewardsSquare.fill = {0.1,0.1,0.1}
	rewards = encounterBuilderPC:addObjectToLayer( 'Rewards', 
		ssk.easyIFC:presetTextBox(encounterBuilderPC['Rewards'], "default", encounter.rewards, encounterBuilderPC['w']/2, ebHeight/2 -15, 
		{listener=uiTools.textFieldListener, width = width-80, height = ebHeight - 110}))
	local randomButton = encounterBuilderPC:addObjectToLayer( 'Rewards', 
		ssk.easyIFC:presetPush( dialog, "appButton", encounterBuilderPC['w']/2 -75, ebHeight-50, 80, 30, "Reroll", rerollRewards))
	
	encounterBuilderPC.showLayers()

	y = textYOffset + textHeight / 2 - textYOffset
	if showRerollButton then
		--rerollEncounter(nil)
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Reroll", rerollEncounter )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", saveEncounterToCampaign )
	else
		ssk.easyIFC:presetPush( dialog, "appButton", -50, y, 80, 30, "Delete", function() deleteEncounter(encounter); end )
		ssk.easyIFC:presetPush( dialog, "appButton", 50, y, 80, 30, "Save", saveEncounterToCampaign )
	end

	y = y + 40;
	ssk.easyIFC:presetPush( dialog, "appButton", 0, y, 120, 30, "Close", closeTray )


	ssk.easyIFC.easyFlyIn( dialog, { delay = 250, time = 500, sox = 0, soy = fullh } )
end

function manageEncounter.openNewEncounterDialog(group, onSave)
	updateFunction = onSave
	print("openNewEncounterDialog() called, onsave=" .. tostring(onSave))
	--local type = Randomizer:generateEncounterType()
	newEncounter = Encounter.new("", "") --Randomizer:generateEncounter(type)
	manageEncounter.openViewEncounterDialog(newEncounter, group, true, onSave)
end

return manageEncounter