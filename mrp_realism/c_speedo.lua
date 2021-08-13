local width, height = guiGetScreenSize()
local font = exports.mrp_fonts:getFont("Modern", 18)
local fuel = 0

function dxDrawShadowText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
	dxDrawText(text, x1 - 1, y1, x2 - 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1 + 1, y1, x2 + 1, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1 - 1, x2, y2 - 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1 + 1, x2, y2 + 1, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1 - 2, y1, x2 - 2, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1 + 2, y1, x2 + 2, y2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1 - 2, x2, y2 - 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1 + 2, x2, y2 + 2, tocolor(0, 0, 0, 150), scale, font, alignX, alignY)
	dxDrawText(text, x1, y1, x2, y2, color, scale, font, alignX, alignY)
end

function drawSpeedo()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if (vehicle) then
		speed = exports.mrp_global:getVehicleVelocity(vehicle, getLocalPlayer())
		local x = width
		local y = height
		local ax, ay = x - 180, y/2
		dxDrawShadowText("Hız:", ax, ay-50, 5, 5, tocolor(230, 230, 230, 255), 1, font, "left", "top", false, false, false, true, false)
		dxDrawShadowText(tostring(math.floor(speed)).." km/s", ax+50, ay-50, 5, 5, tocolor(230, 230, 230, 180), 1, font, "left", "top", false, false, true, true, false)
		speed = speed - 100
		nx = x + math.sin(math.rad(-(speed)-150)) * 90
		ny = y + math.cos(math.rad(-(speed)-150)) * 90
	end
end
setTimer(drawSpeedo, 0, 0)

function drawFuel()
	local vehicle = getPedOccupiedVehicle(getLocalPlayer())
	if (vehicle) then
		local x = width
		local y = height
		local FuelPer = (fuel/exports["mrp_vehicle_fuel"]:getMaxFuel(vehicle))*100
		local ax, ay = x - 180, y/2
		if FuelPer > 100 then
			FuelPer = fuel 
		end
		dxDrawShadowText("Yakıt:", ax, ay-20, 5, 5, tocolor(230, 230, 230, 255), 1, font, "left", "top", false, false, false, true, false)
		dxDrawShadowText(tostring(math.floor(getElementData(vehicle, "fuel") or 0)).." lt", ax+75, ay-20, 5, 5, tocolor(230, 230, 230, 180), 1, font, "left", "top", false, false, true, true, false)
	end
end
setTimer(drawFuel, 0, 0)

function syncFuel(ifuel)
	if not (ifuel) then
		fuel = 100
	else
		fuel = ifuel
	end
end
addEvent("syncFuel", true)
addEventHandler("syncFuel", getRootElement(), syncFuel)