local miktar = 625
function pay(thePlayer)
	if getElementData(thePlayer, "vip") == 1 then
		miktar = 650
	elseif getElementData(thePlayer, "vip") == 2 then
		miktar = 675
	elseif getElementData(thePlayer, "vip") == 3 then
		miktar = 700
	elseif getElementData(thePlayer, "vip") == 4 then
		miktar = 725
	end
	exports.mrp_global:giveMoney(thePlayer, miktar)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan "..miktar.."₺ kazandınız!", thePlayer, 0, 255, 0, true)
end
addEvent("alcohol:pay", true)
addEventHandler("alcohol:pay", getRootElement(), pay)

function stopJob(thePlayer)
	local pedVeh = getPedOccupiedVehicle(thePlayer)
	removePedFromVehicle(thePlayer)
	respawnVehicle(pedVeh)
end
addEvent("alcohol:exitVeh", true)
addEventHandler("alcohol:exitVeh", getRootElement(), stopJob)

function alcoholAnti(thePlayer, seat, door)
	local vehicleModel = getElementModel(source)
	local vehicleJob = getElementData(source, "job")
	local playerJob = getElementData(thePlayer, "job")
	if vehicleModel == 456 and vehicleJob == 9 then
	   	if seat ~= 0 then
	    	cancelEvent()
			outputChatBox("[!] #FFFFFFMeslek aracına binemezsiniz.",thePlayer, 255, 0, 0, true)
	   	elseif seat == 0 then
	   		if playerJob ~= 9 then
	   			cancelEvent()
	   			outputChatBox("[!] #FFFFFFBu araca binmek meslekte olmanız gerekmektedir.", thePlayer, 255, 0, 0, true)
	   		end
	   	end
	end
end
addEventHandler("onVehicleStartEnter", getRootElement(), alcoholAnti)