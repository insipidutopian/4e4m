-- uiTools.lua
local composer = require ("composer")
local widget = require ( "widget" )
CampaignList = require ("CampaignList")


local uiTools = {}
 
print( "uiTools.lua has been loaded" )
 
-- local debug = true


function uiTools.createInputTextBox( x, y, height, width, listener, updateFunction) 
	print("createInputTextBox() called")
	tb = native.newTextBox( x, y, height, width )
	-- tb.hasBackground = false
	tb.isEditable = true
	tb.font = native.newFont(mainFont, mainFontSize-2)
	tb:setTextColor(.6,0,0,1)
	tb:addEventListener( "userInput", listener )
	tb["updateFunction"] = updateFunction
	tb:setReturnKey('next')
	return tb
end

function uiTools.createInputTextField( x, y, height, width, listener, updateFunction) 
	print("createInputTextBox() called")
	tf = native.newTextField( x, y, height, width )
	-- tf.hasBackground = false
	tf.isEditable = true
	tf.font = native.newFont(mainFont, mainFontSize-2)
	tf:setTextColor(.6,0,0,1)
	tf:addEventListener( "userInput", listener )
	tf["updateFunction"] = updateFunction
	return tf
end


function uiTools.textFieldListener( event )

    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
        if debugFlag then print( "TF begin editing...."); end
 
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        if debugFlag then print( "TF ended editing: " ..  event.target.text ); end
        if (event.target["updateFunction"] ~= nil) then
        	if debugFlag then print("TF Calling update function!!!!"); end
        	event.target["updateFunction"]()
		end
        --native.setKeyboardFocus( nil )
 
    elseif ( event.phase == "editing" ) then
    	if debugFlag then
    		if event.newCharacters == '\t' then
    			print("new: TAB")
    		else
	        	print( "TF new: " .. event.newCharacters )
	        end
	        print( "TF sp: " .. event.startPosition )
	        print( "TF et:" .. event.text )
	    end
    end
end

function uiTools.textBoxListener( event )

    if ( event.phase == "began" ) then
        -- User begins editing "defaultField"
        if debugFlag then print( "TBox begin editing...."); end
 
    elseif ( event.phase == "ended" or event.phase == "submitted" ) then
        if debugFlag then print( "TBox ended editing: " ..  event.target.text ); end
        if (event.target["updateFunction"] ~= nil) then
        	if debugFlag then print("TF Calling update function!!!!"); end
        	event.target["updateFunction"]()
		end
        --native.setKeyboardFocus( nil )
 
    elseif ( event.phase == "editing" ) then
    	if debugFlag then
    		--print("NEW CHAR BYTE=" .. tostring(string.byte(event.newCharacters)))
    		--if event.newCharacters == '\t' then
    		--	return
    		-- 	print("new: TAB")
    			
    		-- 	--throw an ended event
    		-- 	event.target:dispatchEvent( { phase="editing", newCharacters='\b',
    		-- 		startPosition = event.startPosition-1, text = string.sub(event.text, 1, string.len(event.text) - 1) })
    		-- 	event.target:dispatchEvent( { phase="ended", target=event.target } )
    		--else
	        	print( "new: " .. event.newCharacters )
	        --end
	        print( "sp: " .. event.startPosition )
	        print( "et:" .. event.text )
	    end
    end
end

function uiTools.toggleTFEditable( textField, updateFunction, isEditable )
		if isEditable then
			if debugFlag then print( "textfield now enabled" ); end
			textField.isEditable = true
			native.setKeyboardFocus( textBox )
		else
			print( "textfield now disabled" )
			textField.isEditable = false
			updateFunction( textField.text)
			native.setKeyboardFocus( nil )
		end
end

function uiTools.toggleTBEditable( textBox, updateFunction, isEditable )
		if isEditable then
			if debugFlag then print( "textbox now enabled" ); end
			textBox.isEditable = true
			native.setKeyboardFocus( textBox )
		else
			if debugFlag then print( "textbox now disabled" ); end
			textBox.isEditable = false
			updateFunction( textBox.text)
			native.setKeyboardFocus( nil )
		end
end

function uiTools.createAndInsertButtonForSceneChange(group, options)
	if debugFlag then print("create and Insert Button called."); end
	if debugFlag then print("createAndInsertButtonForSceneChange() group is " .. tostring(group)); end
	if debugFlag then print("createAndInsertButtonForSceneChange() buttonName is " .. options.buttonName); end
	if debugFlag then print("createAndInsertButtonForSceneChange() x=" .. options.x .. " y=" .. options.y); end

	newButton = widget.newButton(
	{   label = options.buttonName,
        onPress = function() composer.gotoScene(options.onPressScene); end,
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
	return newButton

end

function uiTools.createAndInsertButtonForOverlay(group, options)
	if debugFlag then print("create and Insert Button called."); end
	if debugFlag then print("createAndInsertButtonForOverlay() group is " .. tostring(group)); end
	if debugFlag then print("createAndInsertButtonForOverlay() buttonName is " .. options.buttonName); end
	if debugFlag then print("createAndInsertButtonForOverlay() x=" .. options.x .. " y=" .. options.y); end

	newButton = widget.newButton(
	{   label = options.buttonName,
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
	if group then print(tostring(group)); group:insert(newButton); end
	return newButton

end

return uiTools