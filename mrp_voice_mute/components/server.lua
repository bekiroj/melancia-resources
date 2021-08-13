function muteVoice(thePlayer, commandName, targetPlayer, ...)
	if exports.mrp_integration:isPlayerTrialAdmin(thePlayer) or exports.mrp_integration:isPlayerSupporter(thePlayer) then
	    local targetPlayer, targetPlayerName = exports.mrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)	
		if targetPlayer then
			if not getElementData(targetPlayer, "voicemute") then 

			exports['mrp_admins']:addAdminHistory(targetPlayer, thePlayer, "Susturma Cezası", 8, 1)
			setElementData(targetPlayer, "voicemute", true)
			exports["mrp_infobox"]:addBox(thePlayer, "success", getPlayerName(targetPlayer).." adlı oyuncuyu susturdunuz.")
			exports["mrp_infobox"]:addBox(targetPlayer, "error", getPlayerName(targetPlayer).." isimli yetkili sizi susturdu.")
			exports.mrp_global:sendMessageToAdmins("AdmCMD: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun mikrofonunu susturdu.")
			else
			setElementData(targetPlayer, "voicemute", nil)		
			exports["mrp_infobox"]:addBox(thePlayer, "success", getPlayerName(targetPlayer).." adlı oyuncuyunun susturmasını kaldırdınız.")
			exports["mrp_infobox"]:addBox(targetPlayer, "success", getPlayerName(targetPlayer).." isimli yetkili susturma cezanızı kaldırdı. Bir dahakine dikkat edin.")
			exports.mrp_global:sendMessageToAdmins("AdmCMD: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili " .. getPlayerName(targetPlayer):gsub("_", " ") .. " isimli oyuncunun mikrofonunun susturmasını kaldırdı.")			
			end
		else
			exports["mrp_infobox"]:addBox(thePlayer, "error", "Kullanımı: /voicemute [Karakter Adı & ID]")
		end
	end
end
addCommandHandler("mical", muteVoice)