local mysql = exports.mrp_mysql
addEvent("kaydet:dakikavesaat", true)
function veriKaydetDakikaveSaat(client)
	local minutesplayed = getElementData(client, "minutesPlayed")
	local hoursplayed = getElementData(client, "hoursplayed")
	local id = getElementData(client, "dbid") -- account:character:id
	if id then
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `minutesPlayed`='"..minutesplayed.."' WHERE `id`='"..id.."' ")
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `hoursplayed`='"..hoursplayed.."' WHERE `id`='"..id.."' ")
	end
end
addEventHandler("kaydet:dakikavesaat",getRootElement(), veriKaydetDakikaveSaat)

addEvent("kaydet:seviyevesaat", true)
function veriKaydetSeviyeveAmac(client)
	local level = getElementData(client, "level")
	local hoursaim = getElementData(client, "hoursaim")
	local id = getElementData(client, "dbid") -- account:character:id
	if id then
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `level`='"..level.."' WHERE `id`='"..id.."' ")
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `hoursaim`='"..hoursaim.."' WHERE `id`='"..id.."' ")
	end
end
addEventHandler("kaydet:seviyevesaat",getRootElement(), veriKaydetSeviyeveAmac)

local setHunger = function(thePlayer, commandName, targetPlayerName, hunger)
	if exports.mrp_integration:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not hunger then
			outputChatBox("SÖZDİZİMİ: /" .. commandName .. " [Oyuncu Adı / ID] [Açlık]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.mrp_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Oyuncu henüz giriş yapmadı.", thePlayer, 255, 0, 0 )
			else
				setElementData(targetPlayer, "hunger", tonumber(hunger))
				dbExec(mysql:getConnection(), "UPDATE characters SET hunger='"..tonumber(hunger).."' WHERE id='"..getElementData(targetPlayer, "dbid").."'")
				exports["mrp_infobox"]:addBox(thePlayer, "success", targetPlayerName .. " isimli oyuncunun açlığı %" .. hunger .. " olarak değiştirilmiştir.")
				exports["mrp_infobox"]:addBox(targetPlayer, "info", "Açlığınız bir yetkili tarafından %" .. hunger .. " olarak değiştirilmiştir.")
			end
		end
	end
end
addCommandHandler("sethunger", setHunger)

local setThirst = function(thePlayer, commandName, targetPlayerName, thirst)
	if exports.mrp_integration:isPlayerAdmin(thePlayer) then
		if not targetPlayerName or not thirst then
			outputChatBox("SÖZDİZİMİ: /" .. commandName .. " [Oyuncu Adı / ID] [Susuzluk]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.mrp_global:findPlayerByPartialNick( thePlayer, targetPlayerName )
			if not targetPlayer then
			elseif getElementData( targetPlayer, "loggedin" ) ~= 1 then
				outputChatBox( "Oyuncu henüz giriş yapmadı.", thePlayer, 255, 0, 0 )
			else
				setElementData(targetPlayer, "thirst", tonumber(thirst))
				dbExec(mysql:getConnection(), "UPDATE characters SET thirst='"..tonumber(thirst).."' WHERE id='"..getElementData(targetPlayer, "dbid").."'")
				exports["mrp_infobox"]:addBox(thePlayer, "success", targetPlayerName .. " isimli oyuncunun susuzluğu %" .. thirst .. " olarak değiştirilmiştir.")
				exports["mrp_infobox"]:addBox(targetPlayer, "info", "Susuzluğunuz bir yetkili tarafından %" .. thirst .. " olarak değiştirilmiştir.")
			end
		end
	end
end
addCommandHandler("setthirst", setThirst)

local info = function(player, cmd)
	if getElementData(player, "loggedin") == 1 then
		local hoursplayed = getElementData(player, "hoursplayed") or "N/AS"
		local hoursaim = getElementData(player, "hoursaim") or "N/A"
		outputChatBox('[Melancia]#D0D0D0 Oynama Saatin:'..hoursplayed..' / Level atlamak için '..hoursaim..' saat oyunda durmanız gerek.',player,195,184,116,true)
	end
end
addCommandHandler("level", info)