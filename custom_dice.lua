-------------------------------------------------
--
-- custom_dice.lua
--
-- class for CustomDice objects.
--
-------------------------------------------------
 
local custom_dice = {}
local custom_dice_mt = { __index = custom_dice }	-- metatable
 
function custom_dice.new( name, dice)	-- constructor
	print ("custom_dice.new() called")
	local newCustomDice = {
		id = 0,
		name = name or "dice",
		dice = dice or "",
	}
	
	print ("custom_dice.new - creating name=" .. newCustomDice.name .. ", dice=" .. newCustomDice.dice)
	
	return setmetatable( newCustomDice, custom_dice_mt )
end
 
function custom_dice.newCustomDice( custom_dice )	-- constructor
	print ("custom_dice.newCustomDice() called")
	local newCustomDice = {
		id = custom_dice.id,
		name = custom_dice.name or "dice",
		dice = custom_dice.dice or "",
	}
	print ("custom_dice.newCustomDice - creating name=" .. newCustomDice.name .. ", dice=" .. newCustomDice.dice)
	
	return setmetatable( newCustomDice, custom_dice_mt )
end

return custom_dice