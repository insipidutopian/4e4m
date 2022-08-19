-- local composer = require ( "composer" )
local composer = require ( "composer" )
local scene = composer.newScene()
local myHeight = 100
local buttonHeight = 40
local widget = require ( "widget" )
local currentOverlay = "npcGen"
local npc = require ( "npc" )

local npcName
local npcRace
local npcNotes

local newNpc

function scene:create( event )
	local group = self.view
	print("overlay:" .. currentOverlay.. ":createScene")
	
	
end

function addToCampaign(newNpc)
	print("Adding New NPC to Campaign, name is " .. newNpc.name)
	CampaignList:addNpcToCampaign(newNpc)
end


function showNpc( g )
	
	print("showNpc() called")


	if npcName then npcName:removeSelf() end;

	npcName = display.newText({
	    text = "Name: ".. newNpc.name,     
	    x = 170,
	    y = display.contentCenterY + 40 - myHeight,
	    width = 320,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    
	    align = "left" 
	})
	npcName:setFillColor( 0.6, 0, 0 )
	-- print("Inserting name")
	g:insert(npcName)

	if npcRace then npcRace:removeSelf() end;
	npcRace = display.newText({
	    text = "Race: ".. newNpc.race,     
	    x = 170,
	    y = display.contentCenterY + 60 - myHeight,
	    width = 320,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left" 
	})
	npcRace:setFillColor( 0.6, 0, 0 )
	-- print("Inserting npcRace")
	g:insert(npcRace)


	if npcNotes then npcNotes:removeSelf() end;
	npcNotes = display.newText({
	    text = "Notes: ".. newNpc.notes,     
	    x = 170,
	    y = display.contentCenterY + 100 - myHeight, anchorY = 0,
	    width = 320,
	    height = 60,
	    font = mainFont,   
	    fontSize = mainFontSize,
	    align = "left" 
	})
	npcNotes:setFillColor( 0.6, 0, 0 )
	-- print("Inserting npcNotes")
	g:insert(npcNotes)


	--composer.hideOverlay( currentOverlay, popOptions ); 
end

function scene:show( event )
	local group = self.view

	print("overlay:" .. currentOverlay.. ":showScene")

 	if (event.params) then
		print("event.params")
		if (event.params.npc) then
			print("event.params.npc: " .. event.params.npc.name)
			newNpc = event.params.npc
		end
	end

	local blackout = display.newRect( display.contentCenterX, display.contentCenterY + titleBarHeight, 
		display.contentWidth, display.contentHeight - titleBarHeight)
	blackout:setFillColor( 0,0,0,1 ) 
	group:insert (blackout)

	local overlayBox = display.newRect( display.contentCenterX, display.contentCenterY, 
		display.contentWidth, myHeight *2)
	overlayBox:setFillColor( .6,0,0,1 ) 
	group:insert (overlayBox)

	local overlayBoxInner = display.newRect( display.contentCenterX, display.contentCenterY, 
		display.contentWidth-6, (myHeight *2) - 6)
	overlayBoxInner:setFillColor( 0,0,0,1 ) 
	group:insert (overlayBoxInner)

	local overlayTitle = display.newText("NPC: " .. newNpc.name, 
		display.contentCenterX, display.contentCenterY + 20 - myHeight , 
		btnFont, btnFontSize )
	overlayTitle:setFillColor( 0.6, 0, 0 )
	group:insert(overlayTitle)

	

	local cancelButton = widget.newButton
	{
		label = "Cancel",
		onPress =  function() composer.hideOverlay( currentOverlay, popOptions ); end,
        shape = "roundedRect", width = 60, height = 20, cornerRadius = 2,
        labelColor = { default={.6,0,0,1}, over={0.4,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0,0,0,1} },
        strokeColor = { default={0,0,0,1}, over={0,0,0,1} },
        strokeWidth = 2,
        font=btnFont, fontSize=btnFontSize*0.7,
        left = 80, top = display.contentCenterY - 30 + myHeight
	}
	group:insert(cancelButton)

	local addBtn = widget.newButton {
        label = "Update", --labelAlign=labOrient,
        onPress = function() addToCampaign(newNpc); end,
        emboss = false,
        shape = "roundedRect", width = 60, height = 20, cornerRadius = 2,
        labelColor = { default={.6,0,0,1}, over={0.4,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0,0,0,1} },
        strokeColor = { default={0,0,0,1}, over={0,0,0,1} },
        strokeWidth = 2,
        font=btnFont, fontSize=btnFontSize*0.7,
        left = display.contentCenterX, top = display.contentCenterY - 30 + myHeight
    }
	group:insert(addBtn)

	local startY = titleBarHeight + buttonHeight/2

	showNpc( group );


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
