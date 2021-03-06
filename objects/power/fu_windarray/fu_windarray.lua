function init()
	storage.checkticks = 0
	storage.truepos = isn_getTruePosition()
end

function update(dt)
	storage.checkticks = storage.checkticks + 1
	if storage.checkticks >= 10 then
		storage.checkticks = 0
		isn_getCurrentPowerOutput()
	end
end

function isn_getCurrentPowerOutput(divide)
	if isn_powerGenerationBlocked == true then
	  animator.setAnimationState("meter", "0")
	  return 0
	end
	
	local generated = 0
	local genmult = 2
	local location = isn_getTruePosition()
	local wind = world.windLevel(location)

	generated = wind 
	generated = math.abs(generated,30)
	
	
	if generated >= 16 then 
	  animator.setAnimationState("meter", "4")
	elseif generated >= 12  then 
	  animator.setAnimationState("meter", "3")
	elseif generated >= 6  then 
	  animator.setAnimationState("meter", "2")	  
	elseif generated >= 2 then 
	  animator.setAnimationState("meter", "1")
	else 
	  animator.setAnimationState("meter", "0")
	end
	
	local divisor = isn_countPowerDevicesConnectedOnOutboundNode(0)
	if divisor < 1 then return 0 end
	
	if divide == true then return generated / divisor
	else return generated end
end

function onNodeConnectionChange()
	if isn_checkValidOutput() == true then object.setOutputNodeLevel(0, true)
	else object.setOutputNodeLevel(0, false) end
end

function isn_powerGenerationBlocked()
	if world.underground(location) == true then return true end -- it's underground
	if world.liquidAt(location) == true then return true end -- it's submerged in liquid
	if world.tileIsOccupied(location,false) == true then return true end -- there's a wall in the way
	if world.windLevel(location) < 0.2 then return true end -- not enough wind
end

function isn_getTruePosition()
	if storage.truepos ~= nil then return storage.truepos
	else
		storage.truepos = {entity.position()[1] + math.random(2,3), entity.position()[2] + 1}
		return storage.truepos
	end
end