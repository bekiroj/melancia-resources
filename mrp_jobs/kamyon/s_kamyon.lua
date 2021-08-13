local miktar = 550
function kamyonparaVer(thePlayer)
	if getElementData(thePlayer, "vip") == 1 then
		miktar = 575
	elseif getElementData(thePlayer, "vip") == 2 then
		miktar = 600
	elseif getElementData(thePlayer, "vip") == 3 then
		miktar = 625
	elseif getElementData(thePlayer, "vip") == 4 then
		miktar = 650
	end
	exports.mrp_global:giveMoney(thePlayer, miktar)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan ₺"..miktar.." kazandınız!", thePlayer, 0, 255, 0, true) -- 520
end
addEvent("kamyonparaVer", true)
addEventHandler("kamyonparaVer", getRootElement(), kamyonparaVer)

function kamyonBitir(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
	setVehicleLocked(pedVeh, false)
	setElementPosition(thePlayer, 2215.3779296875, -2656.1875, 13.546875)
	setElementRotation(thePlayer, 0, 0, 270.43533325195)
end
addEvent("kamyonBitir", true)
addEventHandler("kamyonBitir", getRootElement(), kamyonBitir)

function kamyonAnti(thePlayer, seat, door)
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	if vehicleModel == 455 and vehicleJob == 11 then
	   	if seat ~= 0 then
	    	cancelEvent()
			outputChatBox("[!] #FFFFFFMeslek aracına binemezsiniz.",thePlayer, 255, 0, 0, true)
	   	elseif seat == 0 then
	   		if playerJob ~= 11 then
	   			cancelEvent()
	   			outputChatBox("[!] #FFFFFFBu araca binmek meslekte olmanız gerekmektedir.", thePlayer, 255, 0, 0, true)
	   		end
	   	end
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), kamyonAnti)