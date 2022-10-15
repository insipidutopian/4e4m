-- 
-- Abstract: 4e DM Assistant app, Dice Tool Screen
--  
-- Version: 1.0
-- 
--
-- This file is used to 

local composer = require ( "composer" )
local customdice = require ( "custom_dice" )
local widget = require ( "widget" )
local campaign = require ( "campaign" )

local strings = require("stringTools")
local CustomDiceList = require("CustomDiceList")

--Create a composer scene for this module
local scene = composer.newScene()

local text1, text2

local centerX = display.contentCenterX
local centerY = display.contentCenterY
local customDice
local bonusValue

local resultString
local resultStringDesc
local resultStringDice


local customDiceCount = 0
local customDiceLimit = 15
local numCustomDiceCols = 3
local numCustomDicePerColumn = 5

--Create the scene
function scene:create( event )
	local group = self.view

	

end

function scene:show( event )

	local group = self.view


	print("dice_tool: scene:show")
	if event.phase == "will" then
		print(currentScene .. ":SHOW WILL PHASE")

		CustomDiceList:loadCustomDice()
		customDiceCount = CustomDiceList:getCustomDiceCount()

		-- Create title bar to go at the top of the screen
		local titleBar = display.newRect( display.contentCenterX, titleBarHeight/2, display.contentWidth, titleBarHeight )
		titleBar:setFillColor( titleGradient ) 
		group:insert ( titleBar )

		-- create embossed text to go on toolbar
		local titleText = display.newEmbossedText( "Dice", display.contentCenterX, titleBar.y, 
													native.systemFontBold, 20 )
		group:insert ( titleText )

		

		if navGroup then navGroup:removeSelf() end
		navGroup = display.newGroup(group)

		local backBtn = widget.newButton(
	    {   
	        label = "Back", font=btnFont, fontSize=btnFontSize, emboss = false,
	        shape = "circle", radius = 50*0.9, cornerRadius = 2, strokeWidth = 4,
	        labelColor = { default={.6,0,0,1}, over={0.7,0.0,0,1} },
	        fillColor = { default={0,0,0,1}, over={0.1,0.1,0.1,0.4} },
	        strokeColor = { default={0.7,0,0,1}, over={0.7,0.0,0,1} },
	        onPress = function()  composer.gotoScene("tools", { effect = "fade", time = 400, params = {campaign = currentCampaign}}) end,
	    	x = 60,
	      	y = display.contentHeight-60
	    })
	    navGroup:insert(backBtn)


		-- here's our content --
		local yStart = titleBarHeight + yPadding 
		local buttonCount = 0

		ssk.easyIFC:presetPush( group, "appButton", 30 + rightPadding,  yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2), 60, 30, "d4",
			function() print("Inititive_tool:add"); rollDie(4); end,
			{labelHorizAlign="center", labelSize=12} )

		buttonCount = buttonCount + 1

		ssk.easyIFC:presetPush( group, "appButton", 30 + rightPadding,  yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2), 60, 30, "d6",
			function() print("Inititive_tool:add"); rollDie(6); end,
			{labelHorizAlign="center", labelSize=12} )

		buttonCount = buttonCount + 1

		ssk.easyIFC:presetPush( group, "appButton", 30 + rightPadding,  yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2), 60, 30, "d8",
			function() print("Inititive_tool:add"); rollDie(8); end,
			{labelHorizAlign="center", labelSize=12} )

		buttonCount = buttonCount + 1

		ssk.easyIFC:presetPush( group, "appButton", 30 + rightPadding,  yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2), 60, 30, "d10",
			function() print("Inititive_tool:add"); rollDie(10); end,
			{labelHorizAlign="center", labelSize=12} )

		buttonCount = buttonCount + 1

		ssk.easyIFC:presetPush( group, "appButton", 30 + rightPadding,  yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2), 60, 30, "d12",
			function() print("Inititive_tool:add"); rollDie(12); end,
			{labelHorizAlign="center", labelSize=12} )

		buttonCount = buttonCount + 1

		ssk.easyIFC:presetPush( group, "appButton", 30 + rightPadding,  yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2), 60, 30, "d20",
			function() print("Inititive_tool:add"); rollDie(20); end,
			{labelHorizAlign="center", labelSize=12} )

		buttonCount = buttonCount + 1

		ssk.easyIFC:presetPush( group, "appButton", 30 + rightPadding,  yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2), 60, 30, "d30",
			function() print("Inititive_tool:add"); rollDie(30); end,
			{labelHorizAlign="center", labelSize=12} )

		buttonCount = buttonCount + 1

		ssk.easyIFC:presetPush( group, "appButton", 30 + rightPadding,  yStart + (buttonCount * (yPadding + buttonHeight)) + (buttonHeight / 2), 60, 30, "d100",
			function() print("Inititive_tool:add"); rollDie(100); end,
			{labelHorizAlign="center", labelSize=12} )

		y = yStart + ((buttonCount+1) * (yPadding + buttonHeight)) + (buttonHeight / 2)
		

		local wsHeight = 270
		if largeFormat then
			wsHeight = 450
			numCustomDiceCols = 6
			numCustomDicePerColumn = 11
		end
		customDiceLimit = numCustomDicePerColumn * numCustomDiceCols


		customDiceLayerNames = {"worksheet","customdice1"}
		if customDiceCount > customDiceLimit then
			customDiceLayerNames[3] = "customdice2"
		end
		--local pc = ssk.easyIFC:quickPagecontrols(sceneGroup, customDiceLayerNames, display.contentCenterX, fullh/2, 150, fullw-20, _ORANGE_)
		local customDicePC = ssk.easyIFC:newPagecontrols( { 
			layernames = customDiceLayerNames,
			x = display.contentCenterX,
			y = y + wsHeight/2,
			h = wsHeight,
			w = fullw-20,
			backgroundColor  = {0.2,0.1,0.1},
			roundedRect = true},
			group )


		local pcLayers = customDicePC:getLayers()
		local decoration1 = display.newImage(pcLayers['background'],  'images/gamemastery/120x60-ul-corner-red.png', 
			customDicePC.x - customDicePC['w']/2 , customDicePC.y - customDicePC['h']/2)
		decoration1.anchorX = 0
		decoration1.anchorY = 0

		local decoration2 = display.newImage(pcLayers['background'],'images/gamemastery/120x60-lr-corner-red.png', 
		(customDicePC.x - customDicePC['w']/2) + (customDicePC['w']-120), 
		(customDicePC.y - customDicePC['h']/2) + customDicePC['h']-60)
		decoration2.anchorX = 0
		decoration2.anchorY = 0

		local worksheetTitle = customDicePC:addObjectToLayer( 'worksheet', 
			ssk.easyIFC:presetLabel( pcLayers['worksheet'], "title", "Custom Dice Worksheet ", 
				display.contentCenterX, 30, {width=340, align="center"}))

		local cd1Title = customDicePC:addObjectToLayer( 'customdice1', 
			ssk.easyIFC:presetLabel( pcLayers['customdice1'], "title", "Custom Dice Roller", 
				display.contentCenterX, 30, {width=340, align="center"}))		
		
		local lastDieType = 0
		local lastDieCount = 0
		local lastDieString = ""

		local function saveCustomDice()
			print("Saving custom dice: " .. customDice.text .. " as " .. customDiceNameTF.text)
			local diceText = customDice.text
			if bonusValue > 0 then
				diceText = diceText .. " +" .. bonusValue
			elseif bonusValue < 0 then
				diceText = diceText .. " " .. bonusValue
			end
			cDice = customdice.new(customDiceNameTF.text, diceText)
			
			CustomDiceList:addCustomDice(cDice)
			print("Custom Dice saved.")
		end

		local function resetCustomDice()
			local lastDieType = 0
			local lastDieCount = 0
			bonusValue = 0
			local lastDieString = ""
			customDice.text = ""
		end

		local function rollCustomDice(diceToRoll)
			local diceString = customDice.text
			if not diceToRoll then
				print("Rolling Custom Dice: " .. customDice.text)
				resultStringDesc.text = customDice.text 
				print("bonus val is " .. tostring(bonusValue))
				if bonusValue > 0 then
					resultStringDesc.text = resultStringDesc.text .. " +" .. bonusValue
					diceString = diceString .. " +" .. bonusValue
				elseif bonusValue < 0 then
					resultStringDesc.text = resultStringDesc.text .. " " .. bonusValue
					diceString = diceString .. " " .. bonusValue
				end
			else
				print("Rolling custom dice: " .. diceToRoll)
				resultStringDesc.text = diceToRoll
				diceString = diceToRoll
			end
			
			local diceResultsString = ""
			local result = 0
			local negBon = 0

			local function addDiceResults(rollResults)
				if diceResultsString == "" then
					diceResultsString = tostring(rollResults)
				else
					diceResultsString = diceResultsString .. " + " .. tostring(rollResults)
				end
				result = result + rollResults
			end

			if string.match(diceString, "-%d+") then
				negBon = string.match(diceString, "-%d+")
				print("gotta subtract the bonus " .. negBon)
				negBon = tonumber(string.match(negBon, "%d+"))
				
				local tmpDice = strings.split(diceString, "-")
				diceString = tmpDice[1]
			end
				
			local dice = strings.split(diceString, "+")
			print("got " .. tostring(#dice) .. " dice sets")
			for i=1, #dice do
				local die = string.match(dice[i], "%S+")
				print(i .. ": " .. dice[i])
				if string.match(die, "%d+d%d+") then
					print("Dice: " .. die)
					local multiDice = strings.split(die, "d")
					for j=1, multiDice[1] do
						addDiceResults( rollDie(multiDice[2]) )
					end
				elseif string.match(die, "d%d+") then
					print("dice: 1" .. die)
					local dieType = string.match(die, "%d+")
					addDiceResults( rollDie(tonumber(dieType)) )
				else
					print("Bonus: " .. die)
					result = result + tonumber(die)
					diceResultsString = diceResultsString .. " +" .. die
				end

				
				

			end

			if negBon > 0 then
				print("subtracting " .. negBon .. " from " .. result)
				result = result - negBon
				if result == 0 then
					result = 1
				end
				diceResultsString = diceResultsString .. " -" .. negBon
				print("result is " .. result)
			end

			resultString.text = result
			resultStringDice.text = diceResultsString
			if not diceToRoll then
				resultStringDesc.text = customDice.text
				if bonusValue > 0 then
					print("Adding + to description text")
					resultStringDesc.text = resultStringDesc.text .. " +" .. bonusValue
				elseif bonusValue < 0 then
					print("Adding - to description text")
					resultStringDesc.text = resultStringDesc.text .. " " .. bonusValue
				end
			else
				resultStringDesc.text = diceToRoll
			end
			
		end

		local function onReleased( dType )
			--local die = "4"
			print("Adding custom die d" .. dType)
			if customDice.text == "" then
				customDice.text = "d" .. dType
				lastDieCount = 1
				lastDieType = dType
				lastDieString = ""
			else
				if dType == lastDieType then
					lastDieCount = lastDieCount + 1
					if lastDieString == "" then
						customDice.text = lastDieCount .. "d" .. dType
					else
						customDice.text = lastDieString .. " + " .. lastDieCount .. "d" .. dType
					end
				else
					lastDieCount = 1
					lastDieType = dType
					lastDieString = customDice.text
					customDice.text = customDice.text .. " + d" .. dType
				end
			end
		end

		y = 60 
		if customDiceCount < customDiceLimit*2 then
			customDicePC:addObjectToLayer( 'worksheet', 
				ssk.easyIFC:presetLabel( pcLayers['worksheet'], "appLabel", "Custom Name:", display.contentCenterX - 120, y, 
				{width=160, align="right"}))


			print("pcLayers['worksheet'] is : " .. tostring(pcLayers['worksheet']))
			local nameSquare = customDicePC:addObjectToLayer( 'worksheet', 
				display.newRoundedRect(pcLayers['worksheet'], display.contentCenterX+30, y, 124, 24, 4 ))
			nameSquare.fill = {0.1,0.1,0.1}

			customDiceNameTF = customDicePC:addObjectToLayer( 'worksheet', 
				ssk.easyIFC:presetTextInput(pcLayers['worksheet'], "default", "", display.contentCenterX+30, y, 
				{listener=uiTools.textFieldListener, width = 120}))


		
			customDicePC:addObjectToLayer( 'worksheet', 
				ssk.easyIFC:presetPush( pcLayers['worksheet'], "appButton", display.contentCenterX+125, y , 60, 30, "Save",
					function() print("Saving custom dice"); saveCustomDice(); composer.gotoScene("dice_tool", { effect = "fade", time = 400, params = {campaign = currentCampaign}}); end,
					{labelHorizAlign="center", labelSize=12} ))
		else
			customDicePC:addObjectToLayer( 'worksheet', 
				ssk.easyIFC:presetLabel( pcLayers['worksheet'], "appLabel", "Max Custom Dice Reached", display.contentCenterX, y, 
				{width=250}))
		end

		y = y + 40
		local butSpace = 50
		local but1xloc = display.contentCenterX - (butSpace*3) + butSpace/2
		local d4 = customDicePC:addObjectToLayer( 'worksheet', ssk.easyIFC:newButton( pcLayers['worksheet'] , 
			{unselImgSrc="images/dice/d4.png", x = but1xloc, y = y, w=40,h=40, onRelease = function() onReleased(4); end}))
		local d6 = customDicePC:addObjectToLayer( 'worksheet', ssk.easyIFC:newButton( pcLayers['worksheet'] , 
			{unselImgSrc="images/dice/d6.png", x = but1xloc+50, y = y, w=40,h=40, onRelease = function() onReleased(6); end}))
		local d8 = customDicePC:addObjectToLayer( 'worksheet', ssk.easyIFC:newButton( pcLayers['worksheet'] , 
			{unselImgSrc="images/dice/d8.png", x = but1xloc+100, y = y, w=40,h=40, onRelease = function() onReleased(8); end}))
		local d10 = customDicePC:addObjectToLayer( 'worksheet', ssk.easyIFC:newButton( pcLayers['worksheet'] , 
			{unselImgSrc="images/dice/d10.png", x = but1xloc+150, y = y, w=40,h=40, onRelease = function() onReleased(10); end}))
		local d12 = customDicePC:addObjectToLayer( 'worksheet', ssk.easyIFC:newButton( pcLayers['worksheet'] , 
			{unselImgSrc="images/dice/d12.png", x = but1xloc+200, y = y, w=40,h=40, onRelease = function() onReleased(12); end}))
		local d20 = customDicePC:addObjectToLayer( 'worksheet', ssk.easyIFC:newButton( pcLayers['worksheet'] , 
			{unselImgSrc="images/dice/d20.png", x = but1xloc+250, y = y, w=40,h=40, onRelease = function() onReleased(20); end}))


		y = y + 40 
		customDice = customDicePC:addObjectToLayer( 'worksheet', 
			ssk.easyIFC:presetLabel( pcLayers['worksheet'], "title", "", display.contentCenterX, y, 
				{width=260, align="center"}))
		
		y = y + 90
		if largeFormat then
			y = y + 185
		end
		customDicePC:addObjectToLayer( 'worksheet', 
			ssk.easyIFC:presetPush( pcLayers['worksheet'] , "appButton", 50 + rightPadding, y , 60, 30, "Reset",
				function() print("Resetting custom dice"); resetCustomDice(); end,
				{labelHorizAlign="center", labelSize=12} ))

		customDicePC:addObjectToLayer( 'worksheet', 
			ssk.easyIFC:presetPush( pcLayers['worksheet'] , "appButton", 120 + rightPadding, y , 60, 30, "Test",
				function() print("Testing custom dice"); rollCustomDice(); end,
				{labelHorizAlign="center", labelSize=12} ))
		
		bonusValue = 0
		local function bonusValueString()
			if bonusValue > 0 then
				return "+" .. bonusValue
			else
				return bonusValue
			end
		end

		local bonusValueTF = customDicePC:addObjectToLayer( 'worksheet', 
			ssk.easyIFC:presetLabel( pcLayers['worksheet'], "title", bonusValueString(), 220 + rightPadding, y))
		

		customDicePC:addObjectToLayer( 'worksheet', 
			ssk.easyIFC:presetPush( pcLayers['worksheet'] , "appButton", 180 + rightPadding, y , 30, 30, "-",
				function() print("Subtracting from bonus"); bonusValue = bonusValue - 1; bonusValueTF.text = bonusValueString(); end,
				{labelHorizAlign="center", labelSize=12} ))
		customDicePC:addObjectToLayer( 'worksheet', 
			ssk.easyIFC:presetPush( pcLayers['worksheet'] , "appButton", 260 + rightPadding, y , 30, 30, "+",
				function() print("Adding to bonus"); bonusValue = bonusValue + 1; bonusValueTF.text = bonusValueString(); end,
				{labelHorizAlign="center", labelSize=12} ))


		for i=1, customDiceCount do
			print("custom dice button: " .. CustomDiceList.cdList[i].name .. ", dice=" .. CustomDiceList.cdList[i].dice)
			cdbx = 65
			cdby = 30 + 35*i
			--numCustomDiceCols
			--numCustomDicePerColumn
			local function getRowNumber(position)
				local row = position % numCustomDicePerColumn 
				if row == 0 then
					return numCustomDicePerColumn
				else
					return row
				end
				--return 1
			end

			local function getColumnNumber(position)
				local pos = position
				if position > customDiceLimit then
					pos = position - customDiceLimit
				end
				for i=1, numCustomDiceCols do
					if position/numCustomDicePerColumn <= i then
						return i
					end
				end

				return 1
			end

			cdbx = 65 + (108 * (getColumnNumber(i) - 1))
			cdby = 30 + (35 * getRowNumber(i) )
			-- if i > 5 then
			-- 	if i > 10 then
			-- 		cdbx = cdbx + 216
			-- 		cdby = 30 + 35*(i-10)
			-- 	else
			-- 		cdbx = cdbx + 108
			-- 		cdby = 30 + 35*(i-5)
			-- 	end
				
			-- end

			print("i=" .. i .. ", col=" .. getColumnNumber(i) .. ", row=" .. getRowNumber(i))

			local cdLayerName = 'customdice1'
			if i > customDiceLimit then
				cdLayerName = 'customdice2'
			end
			customDicePC:addObjectToLayer( cdLayerName, 
				ssk.easyIFC:presetPush( pcLayers['customdice1'] , "appButton", cdbx, cdby , 100, 30, CustomDiceList.cdList[i].name,
				function() print("Testing custom dice"); rollCustomDice(CustomDiceList.cdList[i].dice); end,
				{labelHorizAlign="center", labelSize=12} ))
		end

		customDicePC:showLayers()

		-- resultLabel = display.newText( "Roll Result: ", display.contentWidth - 140 , 100, 
		--						native.systemFontBold, 28 )
		resultLabel = ssk.easyIFC:presetLabel( group, "title", "Roll Result: ", display.contentWidth - 140 , 100, 
				{width=260, align="center"})
		resultLabel:setFillColor( 1, 0, 0)
		--group:insert( resultLabel )

		
		local bonusSquare = display.newRoundedRect(group, display.contentWidth - 140 , 240, 200, 200, 4 )
		bonusSquare.fill = {0.1,0.1,0.1}

		resultString = display.newText( "", display.contentWidth - 140 , 240, 
							native.systemFontBold, 100 )		
		resultString:setFillColor( 0.6,0.0,0.0 )
		group:insert( resultString )

		resultStringDesc = display.newText( "", display.contentWidth - 140 , 310, 
							native.systemFontBold, 20 )
		group:insert(resultStringDesc)

		resultStringDice = display.newText( "", display.contentWidth - 140 , 170, 
							native.systemFontBold, 20 )
		group:insert(resultStringDice)


	else
		print("scene:show DID phase")
	end

end

function scene:hide( event )
	print ("dice_tool: scene:hide started")
	local group = self.view

	if customDiceNameTF then
		customDiceNameTF:removeSelf()
		customDiceNameTF = nil
	end

	if navGroup then
 		navGroup:removeSelf()
 	end

end

function rollDie( dieType ) 
	print("rolling die: " .. dieType)
	-- roll the die
	rand = math.random( dieType )
	
	print("  rolled a " .. rand)
	-- set the screen text
	resultString.text = rand

	resultStringDesc.text = ""
	resultStringDice.text = ""

	return rand
end

--Add the Scene listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )

return scene
