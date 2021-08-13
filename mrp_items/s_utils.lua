﻿restrictedWeapons = {}
for i=0, 15 do
	restrictedWeapons[i] = true
end

mysql = exports.mrp_mysql

function elKoy(plr, commandName, targetName, weaponSerial)
	if getElementData(plr, "faction") == 1 or getElementData(plr, "faction") == 78 then
		if not (targetName) or (not weaponSerial) then
			return outputChatBox("|| Melancia || /" .. commandName .. " [Oyuncu İsmi/ID] [Silah Seriali]", plr, 255, 194, 14)
		end
		local targetPlayer, targetPlayerName = exports.mrp_global:findPlayerByPartialNick(plr, targetName)
		if not targetPlayer then
			return outputChatBox("[!] #ffffffKişi bulunamadı.", plr, 255, 0, 0, true)
		end
		local itemSlot = exports['mrp_items']:getItems(targetPlayer)
		for i, v in ipairs(itemSlot) do
			if exports.mrp_global:explode(":", v[2])[2] and (exports.mrp_global:explode(":", v[2])[2] == weaponSerial) then
				if not v[1] == 115 or restrictedWeapons[tonumber(exports.mrp_global:explode(":", v[2])[1])] then
					return outputChatBox("[!] #ffffffBu komut sadece silahlar için kullanılabilir!", plr, 255, 0, 0, true)
				end
				local eskiHak = (#tostring(exports.mrp_global:explode(":", v[2])[5])>0 and exports.mrp_global:explode(":", v[2])[5]) or 3
				eskiHak = not restrictedWeapons[tonumber(exports.mrp_global:explode(":", v[2])[1])] and eskiHak or "-"
				yeniHak = eskiHak - 1
				silahAdi = tostring(exports.mrp_global:explode(":", v[2])[3])
				local checkString = string.sub(exports.mrp_global:explode(":", v[2])[3], -4) == " (D)"
				if checkString then
					return outputChatBox("[!] #ffffffBu komut Duty silahlarında kullanılamaz!", plr, 255, 0, 0, true)
				end
				exports.mrp_global:takeItem(targetPlayer, 115, v[2])
				if (yeniHak) > 0 then
					eren = exports.mrp_global:explode(":",v[2])[1]..":"..exports.mrp_global:explode(":",v[2])[2]..":"..exports.mrp_global:explode(":",v[2])[3].."::"..yeniHak
					exports.mrp_global:giveItem(targetPlayer, 115, eren)
					local suffix = "kişi"
					for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul Emniyet Müdürlüğü"))) do
						outputChatBox("[İEM]#ffffff "..getPlayerName(plr):gsub("_", " ").." isimli polis memuru "..getPlayerName(targetPlayer):gsub("_", " ").." isimli kişinin silahına el koydu!",arrayPlayer,100,100,255,true)
					end
					for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul İl Jandarma Komutanlığı"))) do
						outputChatBox("[JANDARMA]#ffffff "..getPlayerName(plr):gsub("_", " ").." isimli memur "..getPlayerName(targetPlayer):gsub("_", " ").." isimli kişinin silahına el koydu!",lscsdplayer,74,104,44,true)
					end
					outputChatBox("[!] #ffffff"..targetPlayerName.." adlı kişinin, "..exports.mrp_global:explode(":", v[2])[3].." silahına el koydunuz. Kalan silah hakkı: "..(yeniHak).."", plr, 0, 55, 255, true)
					outputChatBox("[!] #ffffff"..getPlayerName(plr).." adlı kişi "..exports.mrp_global:explode(":", v[2])[3].." silahınıza el koydu. Kalan silah hakkınız: "..(yeniHak).."", targetPlayer, 0, 55, 255, true)
					return
				else
					for k, arrayPlayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul Emniyet Müdürlüğü"))) do
						outputChatBox("[İEM]#ffffff "..getPlayerName(plr):gsub("_", " ").." isimli polis memuru "..getPlayerName(targetPlayer):gsub("_", " ").." isimli kişinin silahına el koydu!",arrayPlayer,100,100,255,true)
					end
					for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul İl Jandarma Komutanlığı"))) do
						outputChatBox("[JANDARMA]#ffffff "..getPlayerName(plr):gsub("_", " ").." isimli memur "..getPlayerName(targetPlayer):gsub("_", " ").." isimli kişinin silahına el koydu!",lscsdplayer,74,104,44,true)
					end
					outputChatBox("[!] #ffffff"..targetPlayerName.." adlı kişinin, "..exports.mrp_global:explode(":", v[2])[3].." silahına el koydunuz. Silah silindi.", plr, 0, 55, 255, true)		
					outputChatBox("[!] #ffffff"..getPlayerName(plr).." adlı kişi"..exports.mrp_global:explode(":", v[2])[3].." silahınıza el koydu. GG EASY BOY!", targetPlayer, 0, 55, 255, true)		
					return
				end
			end
		end
	end
end
addCommandHandler("elkoy", elKoy)

function setHak(plr, commandName, targetName, weaponSerial, yeniHak)
	if exports.mrp_integration:isPlayerDeveloper(plr) then
		local yeniHak = tonumber(yeniHak)
		if not (targetName) or (not weaponSerial) or not yeniHak or (yeniHak and yeniHak < 0) then
			return outputChatBox("|| Melancia Roleplay || /" .. commandName .. " [Oyuncu İsmi/ID] [Silah Seriali] [Yeni Hak]", plr, 255, 194, 14)
		end
		local targetPlayer, targetPlayerName = exports.mrp_global:findPlayerByPartialNick(plr, targetName)
		if not targetPlayer then
			return outputChatBox("[!] #ffffffKişi bulunamadı.", plr, 255, 0, 0, true)
		end
		local itemSlot = exports['mrp_items']:getItems(targetPlayer)
		for i, v in ipairs(itemSlot) do
			if exports.mrp_global:explode(":", v[2])[2] and (exports.mrp_global:explode(":", v[2])[2] == weaponSerial) then
				if not v[1] == 115 or restrictedWeapons[tonumber(exports.mrp_global:explode(":", v[2])[1])] then
					return outputChatBox("[!] #ffffffBu komut sadece silahlar için kullanılabilir!", plr, 255, 0, 0, true)
				end
				local eskiHak = (#tostring(exports.mrp_global:explode(":", v[2])[5])>0 and exports.mrp_global:explode(":", v[2])[5]) or 3
				eskiHak = not restrictedWeapons[tonumber(exports.mrp_global:explode(":", v[2])[1])] and eskiHak or "-"
				silahAdi = tostring(exports.mrp_global:explode(":", v[2])[3])
				local checkString = string.sub(exports.mrp_global:explode(":", v[2])[3], -4) == " (D)"
				if checkString then
					return outputChatBox("[!] #ffffffBu komut Duty silahlarında kullanılamaz!", plr, 255, 0, 0, true)
				end
				exports.mrp_global:takeItem(targetPlayer, 115, v[2])
				eren = exports.mrp_global:explode(":",v[2])[1]..":"..exports.mrp_global:explode(":",v[2])[2]..":"..exports.mrp_global:explode(":",v[2])[3].."::"..yeniHak
				exports.mrp_global:giveItem(targetPlayer, 115, eren)
				local suffix = "yetkili"
				outputChatBox("[!] #ffffff"..targetPlayerName.." adlı kişinin, "..explode(":", v[2])[3].." silahının hakkı "..yeniHak.." olarak değiştirildi.", plr, 0, 55, 255, true)
				outputChatBox("[!] #ffffff"..getPlayerName(plr).." adlı "..suffix..", "..explode(":", v[2])[3].." silahınızın hakkını "..yeniHak.." olarak değiştirdi.", targetPlayer, 0, 55, 255, true)
				return
			end
		end
	end
end
addCommandHandler("sethak", setHak)

function vehKit(thePlayer)
end
addEvent("tamir->aracTamirEt",true)
addEventHandler("tamir->aracTamirEt", root, vehKit)


function kitYardim(thePlayer)
    outputChatBox("[-]#f9f9f9 Tamir kiti kullanırken aracınızın motorunu kapalı durumda olsun.",thePlayer,255,102,102,true)
    outputChatBox("[-]#f9f9f9 Tamir kiti kullanırken aracınızı hareket ettirmeye çalışmayın.",thePlayer,255,102,102,true)
    outputChatBox("-#f9f9f9 Başka bir sorun yok, iyi oyunlar.",thePlayer,255,102,102,true)
end
addCommandHandler("kityardim", kitYardim)

function krikoKit(thePlayer)
	
	local veh = getPedOccupiedVehicle(thePlayer)

	if (veh) then
				if not (veh) then
					outputChatBox("[-]#f9f9f9 Araçtan ayrıldığın için işlemin iptal edildi.", thePlayer, 255, 102, 102, true)
				return end
				
				if getElementData(thePlayer, "kriko:durum") then
					outputChatBox("[-]#f9f9f9 Aracını çevirmek için krikonu kullanıyorsun, lütfen sabırla bekle.", thePlayer, 255, 102, 102, true)
				return end
			
				setTimer(function()
				
				local rx, ry, rz = getVehicleRotation(veh)
				setVehicleRotation(veh, 0, ry, rz)
				outputChatBox("[-]#f9f9f9 Başarıyla aracınız çevirildi, dikkatli kullanın.", thePlayer, 107, 156, 255, true)
				setElementFrozen(veh, false)
				setElementFrozen(thePlayer, false)
				
				setElementData(thePlayer, "kriko:durum", false)
				end, 15000, 1) 
				setElementData(thePlayer, "kriko:durum", true)
				outputChatBox("[-]#f9f9f9 Aracını çevirmek için kriko kullanıyorsun, lütfen 15 saniye sabırla bekle.", thePlayer, 107, 156, 255,true)
				setElementFrozen(thePlayer, true)
				setElementFrozen(veh, true)
	else
		outputChatBox("[-]#f9f9f9 Bu işlemi yapabilmek için araçta olman gerekiyor.", thePlayer, 255, 102, 102, true)
	end
end
addEvent("tamir->aracKrikoKit",true)
addEventHandler("tamir->aracKrikoKit", root, krikoKit)