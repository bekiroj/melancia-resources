local miktar = 700
function tirparaVer(thePlayer)
	if getElementData(thePlayer, "vip") == 1 then
		miktar = 725
	elseif getElementData(thePlayer, "vip") == 2 then
		miktar = 750
	elseif getElementData(thePlayer, "vip") == 3 then
		miktar = 775
	elseif getElementData(thePlayer, "vip") == 4 then
		miktar = 800
	end
	exports.mrp_global:giveMoney(thePlayer, miktar)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan ₺"..miktar.." kazandınız!", thePlayer, 0, 255, 0, true) -- 520
end
addEvent("tirparaVer", true)
addEventHandler("tirparaVer", getRootElement(), tirparaVer)

function tirBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setVehicleLocked(pedVeh, false)
	setElementPosition(thePlayer, 2273.498046875, -2348.6064453125, 13.546875)
	setElementRotation(thePlayer, 0, 0, 316)
end
addEvent("tirBitir", true)
addEventHandler("tirBitir", getRootElement(), tirBitir)

function dorseOlustur()
	local vehShopData = exports["mrp_vehicle_manager"]:getInfoFromVehShopID(1012)
	local veh = createVehicle(435, 2267.8115234375, -2401.49609375, 14.040822982788, 0, 0, 312.48352050781)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "dbid", -1, true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "fuel", exports["mrp_fuel-system"]:getMaxFuel(veh), false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "plate", "TIR", true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "Impounded", 0)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "engine", 0, false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "oldx", x, false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "oldy", y, false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "oldz", z, false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "faction", -1)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "job", 6, false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "handbrake", 0, true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "tirMeslek", 1, true)
	
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "brand", vehShopData.vehbrand, true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "maximemodel", vehShopData.vehmodel, true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "year", vehShopData.vehyear, true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "vehicle_shop_id", vehShopData.id, true)
	
	return veh
end
addEvent("tir:dorseOlustur", true)
addEventHandler("tir:dorseOlustur", root, dorseOlustur)


function dorseOlustur2()
	local vehShopData = exports["mrp_vehicle_manager"]:getInfoFromVehShopID(1012)
	local veh = createVehicle(435, -1687.44921875, 25.59375, 4.0749635696411, 0, 0, 47.428588867188)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "dbid", -1, true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "fuel", exports["mrp_fuel-system"]:getMaxFuel(veh), false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "plate", "TIR", true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "Impounded", 0)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "engine", 0, false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "oldx", x, false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "oldy", y, false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "oldz", z, false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "faction", -1)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "job", 6, false)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "handbrake", 0, true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "tirMeslek", 1, true)
	
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "brand", vehShopData.vehbrand, true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "maximemodel", vehShopData.vehmodel, true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "year", vehShopData.vehyear, true)
	exports.mrp_anticheat:changeProtectedElementDataEx(veh, "vehicle_shop_id", vehShopData.id, true)
	
	return veh
end
addEvent("tir:dorseOlustur2", true)
addEventHandler("tir:dorseOlustur2", root, dorseOlustur2)


function dorseSil()
	if getElementData(source, "tirMeslek") == 1 then
		destroyElement(source)
	end
end
addEventHandler("onTrailerDetach", getRootElement(), dorseSil)

function tirAnti(thePlayer, seat, door)
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	if vehicleModel == 515 and vehicleJob == 10 then
	   	if seat ~= 0 then
	    	cancelEvent()
			outputChatBox("[!] #FFFFFFMeslek aracına binemezsiniz.",thePlayer, 255, 0, 0, true)
	   	elseif seat == 0 then
	   		if playerJob ~= 10 then
	   			cancelEvent()
	   			outputChatBox("[!] #FFFFFFBu araca binmek meslekte olmanız gerekmektedir.", thePlayer, 255, 0, 0, true)
	   		end
	   	end
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), tirAnti)