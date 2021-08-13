addCommandHandler("spoilerler",
	function(player, cmd)
			if player:getData("spoiler:mechanic") then 
				exports["mrp_infobox"]:addBox(player, "error", "Bu panel zaten şu anda ekranında")
			return end  
			triggerClientEvent(player, "spoiler:gui", player, false, false, true)
		end
)

addEvent("mechanic:givespoiler", true)
addEventHandler("mechanic:givespoiler", root,	function(plr, upid,veh, price)

	exports.mrp_global:sendLocalMeAction(plr, "aracın arkasına geçerek spoilerları yavaşça tornavidayla sabitlemeye başlar.")
	exports.mrp_global:applyAnimation(plr, "CAR_CHAT", "car_talkm_loop", 6000, false, true, false)
	triggerClientEvent ( "play:drill", plr)
	exports["mrp_progressbar"]:drawProgressBar("Spoiler", "Sabitleniyor..",plr, 255, 255, 255, 6000)

	setTimer(function()
	if addVehicleUpgrade(veh, upid) then
	exports.mrp_global:takeMoney(plr, price)
	exports["mrp_infobox"]:addBox(plr, "success", "Başarıyla spoileri araca montelediniz.")
	exports['mrp_vehicle']:saveVehicleMods(veh)
	else
		exports["mrp_infobox"]:addBox(plr, "error", "Bir şeyler ters gitti.")
	end
	end, 6000,1)
end)

