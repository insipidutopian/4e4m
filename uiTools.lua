-- uiTools.lua
local composer = require ("composer")
local widget = require ( "widget" )
CampaignList = require ("CampaignList")


local uiTools = {}
 
print( "uiTools.lua has been loaded" )
 
local debug = true


function uiTools.createInputTextBox( x, y, height, width, listener) 
	print("createInputTextBox() called")
	tb = native.newTextBox( x, y, height, width )
	-- tb.hasBackground = false
	tb.isEditable = true
	tb.font = native.newFont(mainFont, mainFontSize-2)
	tb:setTextColor(.6,0,0,1)
	tb:addEventListener( "userInput", listener )
	return tb
end


function uiTools.textListener( event )

    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
        print( "begin editing....")
 
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        -- Output resulting text from "defaultField"
        print( "ended editing: " ..  event.target.text )
        native.setKeyboardFocus( nil )
 
    elseif ( event.phase == "editing" ) then
    	if debug then
	        print( "new: " .. event.newCharacters )
	        -- print( "old: " .. event.oldText )
	        print( "sp: " .. event.startPosition )
	        print( "et:" .. event.text )
	    end
    end
end


function uiTools.toggleEditable( textBox, updateFunction, isEditable )
		if isEditable then
			print( "textbox now enabled" )
			textBox.isEditable = true
			native.setKeyboardFocus( textBox )
		else
			print( "textbox now disabled" )
			textBox.isEditable = false
			updateFunction( textBox.text)
			native.setKeyboardFocus( nil )
		end
end


function uiTools.toggleEditableOld( textBox, updateFunction )
	if textBox then
		isEditable = textBox.isEditable
		print("ToggleEditable() called, textbox state is: " .. tostring( isEditable ))
		if isEditable then
			print("tbie: " .. tostring( textBox.isEditable ))
			textBox.isEditable = false
			print("tbie: " .. tostring( textBox.isEditable ))
		else
			textBox.isEditable = true
		end
	end
	
	if textBox.isEditable then
		print( "textbox now enabled" )
		native.setKeyboardFocus( textBox )
	else
		print( "textbox now disabled" )
		updateFunction( textBox.text)
		native.setKeyboardFocus( nil )

	end

end

function uiTools.createAndInsertButton(group, options)
								  
							--[[  { buttonName=currentCampaign.npcList[i].name, 
									x=80, y=10 + 20*i,
									width=150, align="right",
									onPress=function() print("pressed button") end; 
								  })--]]
	print("create and Insert Button called.")
	--print("createAndInsertButton() group is " .. group)
	print("createAndInsertButton() buttonName is " .. options.buttonName)
	print("createAndInsertButton() x=" .. options.x .. " y=" .. options.y)

	newButton = widget.newButton(
	{   label = options.buttonName,
        --onPress = options.onPress,
        onPress = function() composer.showOverlay(options.onPressScene, 
        			{ isModal=true, 
        			  params = options.onPressParams }); end,
        emboss = false,
        shape = "roundedRect", width = options.width, height = 15, cornerRadius = 2,
        hasBackground = false,
        font=btnFont, fontSize=btnFontSize*0.7,
        left = options.x , top = options.y,
        width = options.width, height=15,
        labelAlign=options.align,
        labelColor = { default={.6,0,0,1}, over={0.4,0.0,0,1} },
        fillColor = { default={0,0,0,1}, over={0.1,0,1,1} }
	})
	group:insert(newButton)


end

return uiTools