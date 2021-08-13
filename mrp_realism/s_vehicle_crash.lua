function throwPlayerThroughWindow(x, y, z)  
end
addEvent("crashThrowPlayerFromVehicle", true)
addEventHandler("crashThrowPlayerFromVehicle", getRootElement(), throwPlayerThroughWindow)

function unhookTrailer(thePlayer)
   if (isPedInVehicle(thePlayer)) then
        local theVehicle = getPedOccupiedVehicle(thePlayer)
        if theVehicle then
            detachTrailerFromVehicle(theVehicle) 
        end
   end
end
addCommandHandler("detach", unhookTrailer)
addCommandHandler("unhook", unhookTrailer)

local noBelt = { [431] = true, [437] = true }
function seatbelt(thePlayer)
	if getPedOccupiedVehicle(thePlayer) then
		local theVehicle = getPedOccupiedVehicle(thePlayer)
		if (getVehicleType(theVehicle) == "BMX" or getVehicleType(theVehicle) == "Bike") or (noBelt[getElementModel(theVehicle)] and getVehicleOccupant(theVehicle, 0) ~= thePlayer) then
			outputChatBox("Garip ... Bu araçta emniyet kemeri yok!", thePlayer, 255, 0, 0)
		else
			if 	(getElementData(thePlayer, "seatbelt") == true) then
				exports.mrp_anticheat:changeProtectedElementDataEx(thePlayer, "seatbelt", false, true)
				--outputChatBox("Emniyet kemerini çıkarttın.", thePlayer, 255, 0, 0)
				exports.mrp_global:sendLocalMeAction(thePlayer, "kemerin kilidini açarak kemeri çıkartır.")
			else
				exports.mrp_anticheat:changeProtectedElementDataEx(thePlayer, "seatbelt", true, true)
				--outputChatBox("Emniyet kemerini taktın.", thePlayer, 0, 255, 0)
				exports.mrp_global:sendLocalMeAction(thePlayer, "emniyet kemerinin ucunu çekerek kilitler.")
			end
		end
	end
end
addCommandHandler("seatbelt", seatbelt)
addCommandHandler("belt", seatbelt)
addEvent('realism:seatbelt:toggle', true)
addEventHandler('realism:seatbelt:toggle', root, seatbelt)

function removeSeatbelt(thePlayer)
	if getElementData(thePlayer, "seatbelt") and not isPedInVehicle(thePlayer) then
		exports.mrp_anticheat:changeProtectedElementDataEx(thePlayer, "seatbelt", false, true)
		exports.mrp_global:sendLocalMeAction(thePlayer, "kemerin kilidini açarak kemeri çıkartır.")
	end
end
addEventHandler("onVehicleExit", getRootElement(), removeSeatbelt)

function seatbeltFix()
	local counter = 0
	for _, thePlayer in ipairs(getElementsByType("player")) do
		exports.mrp_anticheat:changeProtectedElementDataEx(thePlayer, "seatbelt", false, true)
		counter = counter + 1
	end
	--outputDebugString("Fixed for " .. counter .. " players")
end
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), seatbeltFix)