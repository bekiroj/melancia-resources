addCommandHandler("jantlar",
	function(player, cmd)
			if player:getData("wheel:mechanic") then 
				exports["mrp_infobox"]:addBox(player, "error", "Bu panel zaten şu anda ekranında")
			return end  
			triggerClientEvent(player, "jant:gui", player, false, false, true)
		end
)


addCommandHandler("jantbug",
	function(player)
		player:setData("wheel:mechanic", nil)
	end
)

addEvent("mechanic:givewheel", true)
addEventHandler("mechanic:givewheel", root,	function(plr, upid,veh, price)

	exports.mrp_global:sendLocalMeAction(plr, "eğilerek aracın jantlarını yavaşça montelemeye başlar.")
	exports.mrp_global:applyAnimation(plr, "CAR", "Fixn_Car_Loop", 6000, false, true, false)
	triggerClientEvent ( "play:drill", plr)
	exports["mrp_progressbar"]:drawProgressBar("Jant", "Monte ediliyor..",plr, 255, 255, 255, 6000)

	setTimer(function()
	if addVehicleUpgrade(veh, upid) then
	exports.mrp_global:takeMoney(plr, price)
	exports["mrp_infobox"]:addBox(plr, "success", "Başarıyla jantı araca montelediniz.")
	exports.mrp_global:applyAnimation(plr, "CAR", "Fixn_Car_Out", 6000, false, true, false)
	
	exports['mrp_vehicle']:saveVehicleMods(veh)
	else
		exports["mrp_infobox"]:addBox(plr, "error", "Bir şeyler ters gitti.")
	end
	end, 6000,1)
end)

