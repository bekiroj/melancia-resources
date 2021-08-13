addCommandHandler("kornalar",
	function(player, cmd)
			if player:getData("korna:mechanic") then 
				exports["mrp_infobox"]:addBox(player, "error", "Bu panel zaten şu anda ekranında")
			return end  
			triggerClientEvent(player, "korna:gui", player, false, false, true)
		end
)

addEvent("mechanic:givekorna", true)
addEventHandler("mechanic:givekorna", root,	function(plr, upid,veh, price)

	exports.mrp_global:sendLocalMeAction(plr, "etrafında bulunan raftan bir havalı korna alır.")
	if exports["mrp_items"]:giveItem(plr, upid, 1) then
	exports.mrp_global:takeMoney(plr, price)
	exports["mrp_infobox"]:addBox(plr, "buy", "Envanterinize bir adet Havalı Korna geldi.")
	else
		exports["mrp_infobox"]:addBox(plr, "error", "Envanterinde yeterli alan yok.")
	end
end)

