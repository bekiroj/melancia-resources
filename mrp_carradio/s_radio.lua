function syncRadio(station)
	local vehicle = getPedOccupiedVehicle(source)
	exports.mrp_anticheat:changeProtectedElementDataEx(vehicle, "vehicle:radio", station, true)
	exports.mrp_anticheat:changeProtectedElementDataEx(vehicle, "vehicle:radio:old", station, true)
end
addEvent("car:radio:sync", true)
addEventHandler("car:radio:sync", getRootElement(), syncRadio)

function syncRadio(vol)
	local vehicle = getPedOccupiedVehicle(source)
	exports.mrp_anticheat:changeProtectedElementDataEx(vehicle, "vehicle:radio:volume", vol, true)
	exports.mrp_global:sendLocalMeAction(source, "adjusts the radio volume.")
end
addEvent("car:radio:vol", true)
addEventHandler("car:radio:vol", getRootElement(), syncRadio)

addCommandHandler ( "srd",
function ( p )
	if exports.mrp_integration:isPlayerTrialAdmin ( p ) then
		local x, y, z = getElementPosition ( p )
		
		for i,v in ipairs ( getElementsByType ( "vehicle" ) ) do
			local vx, vy, vz = getElementPosition ( v )
			local distance = getDistanceBetweenPoints3D ( x, y, z, vx, vy, vz )
			
			if distance < 200 then
				exports.mrp_anticheat:changeProtectedElementDataEx ( v, "vehicle:radio:volume", 0, true )
			end
		end
		
		exports.mrp_global:sendMessageToAdmins ( "AdmWrn: " .. getPlayerName ( p ):gsub("_", " ") .. " has turned all radios off in district " .. getZoneName( x, y, z, false ) .. "." )
	end
end )