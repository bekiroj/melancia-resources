function isPedAiming ( thePedToCheck )
	if isElement(thePedToCheck) then
		if getElementType(thePedToCheck) == "player" or getElementType(thePedToCheck) == "ped" then
			
			if getPedTask(thePedToCheck, "secondary", 0) == "TASK_SIMPLE_USE_GUN" then
				return true
			end
		end
	end
	return false
end

function nisanFPS(target)
		if isPedAiming(getLocalPlayer()) then
			if getFPSLimit () ~= 60 then
				setFPSLimit(60)
			end
			
		else
			if getFPSLimit () ~= 100 then
				setFPSLimit(100)
			end
		end
end
addEventHandler("onClientRender", getRootElement(), nisanFPS)

function extinguisherInfinite(weapon, ammo)
	if weapon == 42 and ammo == 4500 then
		triggerServerEvent("fdextinguisher:supply", resourceRoot, getLocalPlayer())
	end
end
addEventHandler ( "onClientPlayerWeaponFire", getLocalPlayer(), extinguisherInfinite )