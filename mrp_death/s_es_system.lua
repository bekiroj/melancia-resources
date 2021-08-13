mysql = exports.mrp_mysql

function playerDeath(totalAmmo, killer, killerWeapon)
	if getElementData(source, "dbid") then
		if getElementData(source, "SavasEtkinlik") then return end
		if getElementData(source, "adminjailed") then
		
			local x, y, z = getElementPosition(source)
			local int = getElementInterior(source)
			local dim = getElementDimension(source)
			spawnPlayer(source, x, y, z, 270, getElementModel(source), int, dim, getPlayerTeam(source))
			setCameraInterior(source, int)
			setCameraTarget(source)
			
			exports.mrp_logs:dbLog(source, 34, source, "died in admin jail")
		elseif getElementData(source, "pd.jailtimer") then
			local x, y, z = getElementPosition(source)
			local int = getElementInterior(source)
			local dim = getElementDimension(source)
			spawnPlayer(source, x, y, z, 270, getElementModel(source), int, dim, getPlayerTeam(source))
			setCameraInterior(source, int)
			setCameraTarget(source)
			
			exports.mrp_logs:dbLog(source, 34, source, "Hücrede öldü")
		else
			local affected = { }
			table.insert(affected, source)
			local killstr = ' öldü'
			if (killer) then
				if getElementType(killer) == "player" then
					if (killerWeapon) then
						killstr = ', '..getPlayerName(killer):gsub("_", " ").. ' tarafından öldürüldü! ('..getWeaponNameFromID ( killerWeapon )..')'
					else
						killstr = ' öldü'
					end
					table.insert(affected, killer)
				else
				killstr = ' got killed by an unknown source'
				table.insert(affected, "Unknown")
				end
			end
			-- Remove seatbelt if theres one on
			if 	(getElementData(source, "seatbelt") == true) then
				exports.mrp_anticheat:changeProtectedElementDataEx(source, "seatbelt", false, true)
			end
			
			if 	(getElementData(source, "fishing") == true) then
				exports.mrp_anticheat:changeProtectedElementDataEx(source, "fishing", false, true)
				triggerClientEvent("fishing:killTimers", source)
			end
			
			if 	(getElementData(source, "restrain") == true) then
				exports.mrp_anticheat:changeProtectedElementDataEx(source, "restrain", false, true)
			end
			
			--pavlov
			local id = getElementData(source, "dbid") -- account:character:id
			if id then
				local preparedQuery = "UPDATE `characters` SET `isDead`='1' WHERE `id`='"..id.."' "
				dbExec(mysql:getConnection(), preparedQuery)
			end
			setElementData(source, "dead", 1)
			local victimDropItem = false
			if (killer) then
				changeDeathViewTimer = setTimer(changeDeathView, 3000, 1, source, victimDropItem, false)
			elseif (killer == source) then
				changeDeathViewTimer = setTimer(changeDeathView, 3000, 1, source, victimDropItem, true)
			else
				changeDeathViewTimer = setTimer(changeDeathView, 3000, 1, source, victimDropItem, true)
			end
			outputChatBox("#00a8ff[!]#ffffff Baygınsınız. belirtilen saniye sonra ayılacaksınız.", source, 255,255,255,true)
			triggerEvent("changeDeathView", source, source)
			
			exports.mrp_logs:dbLog(source, 34, affected, killstr)
			exports.mrp_anticheat:changeProtectedElementDataEx(source, "lastdeath", " [KILL] "..getPlayerName(source):gsub("_", " ") .. killstr, true)
		end
	end
end
addEventHandler("onPlayerWasted", getRootElement(), playerDeath)

--pavlov
function changeDeathView(source, victimDropItem, isSuicide)
	if isPedDead(source) then
		local x, y, z = getElementPosition(source)
		local rx, ry, rz = getElementRotation(source)
		local x,y,z = getElementPosition(source)
		local int = getElementInterior(source)
		local dim = getElementDimension(source)
		local skin = getElementModel(source)
		local team = getPlayerTeam(source)
		setPedHeadless(source, false)
		setCameraInterior(source, int)
		spawnPlayer(source, x, y, z, 0, skin, int, dim, team)
		local isSuicide = isSuicide
		triggerClientEvent(source,"es-system:lowerTimer", source, isSuicide)
		triggerClientEvent("Emekleme:Emeklet",source,"Ekle")	
	end
end
addEvent("changeDeathView", true)
addEventHandler("changeDeathView", getRootElement(), changeDeathView)

function acceptDeath(thePlayer, victimDropItem)
	if getElementData(thePlayer, "dead") == 1 then
		if victimDropItem then
			local x, y, z = getElementPosition(thePlayer)
			for key, item in pairs(exports["mrp_items"]:getItems(thePlayer)) do 
				itemID = tonumber(item[1])
				local ammo = false
				if itemID == 116 then 
					ammo = exports.mrp_global:explode( ":", item[2]  )[2]
				end
				local keepammo = false
				if itemID == 116 or itemID == 115 or itemID == 134 then
					triggerEvent("dropItemOnDead", thePlayer, itemID, item[2], x, y, z, ammo, false)
				end
			end
		end
		
		fadeCamera(thePlayer, true)
		--outputChatBox("Respawning...", thePlayer)
		if isTimer(changeDeathViewTimer) == true then
			killTimer(changeDeathViewTimer)
		end
		respawnPlayer(thePlayer, victimDropItem)
	else
		outputChatBox("Baygin Değilsiniz!", thePlayer, 255, 0, 0)
		respawnPlayer(thePlayer, victimDropItem) -- Fix these bug
	end
end
addEvent("es-system:acceptDeath", true)
addEventHandler("es-system:acceptDeath", getRootElement(), acceptDeath)
--addCommandHandler("acceptdeath", acceptDeath)
--addCommandHandler("spawn", acceptDeath)

function logMe( message )
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	exports.mrp_global:sendMessageToAdmins(message)
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function logMeNoWrn( message )
	local logMeBuffer = getElementData(getRootElement(), "killog") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "killog", logMeBuffer)
end

function readLog(thePlayer)
	if exports.mrp_integration:isPlayerTrialAdmin(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "killog") or { }
		outputChatBox("Recent kill list:", thePlayer, 205, 201, 165)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer, 205, 201, 165, true)
		end
		outputChatBox("  END", thePlayer, 205, 201, 165)
	end
end
addCommandHandler("showkills", readLog)

function respawnPlayer(thePlayer, victimDropItem)
	if (isElement(thePlayer)) then
		if  getElementData(thePlayer, "KafesDovusu") then return end	
		if (getElementData(thePlayer, "loggedin") == 0) then
			exports.mrp_global:sendMessageToAdmins("AC0x0000004: "..getPlayerName(thePlayer):gsub("_", " ").." died while not in character, triggering blackfade.")
			return
		end
		
		setPedHeadless(thePlayer, false)	
		
		local cost = math.random(175, 500)		
		local tax = exports.mrp_global:getTaxAmount()
		
		exports.mrp_global:giveMoney( getTeamFromName("Los Santos Acil Servisleri"), math.ceil((1-tax)*cost) )
		exports.mrp_global:takeMoney( getTeamFromName("Los Santos Hükümeti"), math.ceil((1-tax)*cost) )
			
		dbExec(mysql:getConnection(), "UPDATE characters SET deaths = deaths + 1 WHERE charactername='" .. (getPlayerName(thePlayer)) .. "'")

		setCameraInterior(thePlayer, 0)

		setCameraTarget(thePlayer, thePlayer)
		
		local death = getElementData(thePlayer, "lastdeath")
		if removedWeapons ~= nil then
			logMe(death)
			exports.mrp_global:sendMessageToAdmins("/showkills to view lost weapons.")
			logMeNoWrn("#FF0033 Lost Weapons: " .. removedWeapons)
		else
			logMe(death)
		end
		
		local theSkin = getPedSkin(thePlayer)
		local theTeam = getPlayerTeam(thePlayer)
		
		local fat = getPedStat(thePlayer, 21)
		local muscle = getPedStat(thePlayer, 23)

		setElementData(thePlayer, "dead", 0)
		if getElementData(source, "hunger") <= 0 then
			exports.mrp_anticheat:changeProtectedElementDataEx(source, "hunger", 5)
		end
		if getElementData(source, "thirst") <= 0 then
			exports.mrp_anticheat:changeProtectedElementDataEx(source, "thirst", 5)
		end
		triggerEvent("kaydet:aclikvesusuzluk", source, source)
		local id = getElementData(thePlayer, "dbid") -- account:character:id
		if id then
			local preparedQuery = "UPDATE `characters` SET `isDead`='0' WHERE `id`='"..id.."' "
			dbExec(mysql:getConnection(), preparedQuery)
		end
		 
		--spawnPlayer(thePlayer, 1176.892578125, -1323.828125, 14.04377746582, 275)--, theTeam)
		local x,y,z = getElementPosition(thePlayer)
		local int = getElementInterior(thePlayer)
		local dim = getElementDimension(thePlayer)
		local skin = getElementModel(thePlayer)
		local team = getPlayerTeam(thePlayer)

		setCameraInterior(thePlayer, int)
		setCameraTarget(thePlayer, thePlayer)

		spawnPlayer(thePlayer, x, y, z, 0, skin, int, dim, team)
				
		setPedStat(thePlayer, 21, fat)
		setPedStat(thePlayer, 23, muscle)

		fadeCamera(thePlayer, true, 6)
		triggerClientEvent(thePlayer, "fadeCameraOnSpawn", thePlayer)
		triggerEvent("updateLocalGuns", thePlayer)
		triggerEvent("social-system:makecuffanim", thePlayer)
		triggerClientEvent("Emekleme:Emeklet",source,"Kaldır")
		setElementHealth(thePlayer, 10)
	end
end

function recoveryPlayer(thePlayer, commandName, targetPlayer, duration)
	if not (targetPlayer) or not (duration) then
		outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Nick / ID] [Hours]", thePlayer, 255, 194, 14)
	else
		local targetPlayer, targetPlayerName = exports.mrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
		if targetPlayer then
			local logged = getElementData(thePlayer, "loggedin")
	
			if (logged==1) then
				local theTeam = getPlayerTeam(thePlayer)
				local factionType = getElementData(theTeam, "type")
				
				if (factionType==4) or (exports.mrp_integration:isPlayerTrialAdmin(thePlayer) == true) then
						local dimension = getElementDimension(thePlayer)
							totaltime = tonumber(duration)
							if totaltime < 12 then
								local money = exports.mrp_bank:takeBankMoney(targetPlayer, 100*totaltime)
								if not money then
									outputChatBox("This player does not have enough money in their bank to be placed in recovery.", thePlayer, 255, 0, 0)
									return 
								end
								exports.mrp_global:giveMoney( getTeamFromName("Los Santos Fire Department"), 100*totaltime )
								local dbid = getElementData(targetPlayer, "dbid")
								dbExec(mysql:getConnection(), "UPDATE characters SET recovery='1' WHERE id = " .. dbid)
								setElementFrozen(targetPlayer, true)
								outputChatBox("You have successfully put " .. targetPlayerName .. " in recovery for " .. duration .. " hour(s) and charged $".. 100*totaltime ..".", thePlayer, 255, 0, 0)
								exports.mrp_global:sendMessageToAdmins("AdmWrn: " .. targetPlayerName .. " was put in recovery for " .. duration .. " hour(s) by " .. getPlayerName(thePlayer):gsub("_"," ") .. ".")
								outputChatBox("You were put in recovery by " .. getPlayerName(thePlayer) .. " for " .. duration .. " hour(s) and charged $".. 100*totaltime ..".", targetPlayer, 255, 0, 0)
								exports.mrp_logs:dbLog(thePlayer, 4, targetPlayer, "RECOVERY " .. duration)
								local r = getRealTime()
								if r.hour + duration >= 24 then
									local timeString = ("%04d%02d%02d%02d%02d%02d"):format(r.year+1900, r.month + 1, r.monthday + 1, r.hour + duration - 24,r.minute, r.second)
									dbExec(mysql:getConnection(), "UPDATE characters SET recoverytime='" ..timeString.. "' WHERE id = " .. dbid)
								else
									local timeString = ("%04d%02d%02d%02d%02d%02d"):format(r.year+1900, r.month + 1, r.monthday, r.hour + duration,r.minute, r.second)
									dbExec(mysql:getConnection(), "UPDATE characters SET recoverytime='" ..timeString.. "' WHERE id = " .. dbid) 
								end
							else
								outputChatBox("You cannnot put someone in recovery for that much time.", thePlayer, 255, 0, 0)
							end
				else
					outputChatBox("You have no basic medic skills, contact the ES.", thePlayer, 255, 0, 0)
				end
			else
				outputChatBox("The player is not logged in.", thePlayer, 255,0,0)
			end
		end
	end
end
addCommandHandler("recovery", recoveryPlayer)

function prescribe(thePlayer, commandName, ...)
    local team = getPlayerTeam(thePlayer)
	if (getTeamName(team)=="Los Santos Fire Department") then
		if not (...) then
			outputChatBox("SYNTAX /" .. commandName .. " [prescription value]", thePlayer, 255, 184, 22)
		else
			local itemValue = table.concat({...}, " ")
			itemValue = tonumber(itemValue) or itemValue
			if not(itemValue=="") then
				exports.mrp_global:giveItem( thePlayer, 132, itemValue )
				outputChatBox("The prescription '" .. itemValue .. "' has been processed.", thePlayer, 0, 255, 0)
				exports.mrp_global:sendMessageToAdmins(getPlayerName(thePlayer):gsub("_"," ") .. " has made a prescription with the value of: " .. itemValue .. ".")
				exports.mrp_logs:dbLog(thePlayer, 4, thePlayer, "PRESCRIPTION " .. itemValue)
			end
		end
	end
end
addCommandHandler("prescribe", prescribe)

-- /revive
function revivePlayerFromPK(thePlayer, commandName, targetPlayer)
	if (exports.mrp_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (targetPlayer) then
			outputChatBox("SYNTAX: /" .. commandName .. " [Player Partial Name / ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.mrp_global:findPlayerByPartialNick(thePlayer, targetPlayer)
			
			if targetPlayer then
				if getElementData(targetPlayer, "dead") == 1 then
					triggerClientEvent(targetPlayer,"es-system:closeRespawnButton",targetPlayer)
					triggerClientEvent(targetPlayer,"es-system:closeCountdownLabel",targetPlayer)
					--fadeCamera(thePlayer, true)
					--outputChatBox("Respawning...", thePlayer)
					if isTimer(changeDeathViewTimer) == true then
						killTimer(changeDeathViewTimer)
					end
					
					local x,y,z = getElementPosition(targetPlayer)
					local int = getElementInterior(targetPlayer)
					local dim = getElementDimension(targetPlayer)
					local skin = getElementModel(targetPlayer)
					local team = getPlayerTeam(targetPlayer)
					
					setPedHeadless(targetPlayer, false)
					setCameraInterior(targetPlayer, int)
					setCameraTarget(targetPlayer, targetPlayer)
					setElementData(targetPlayer, "dead", 0)	
					if getElementData(targetPlayer, "hunger") <= 0 then
						exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "hunger", 5)
					end
					if getElementData(targetPlayer, "thirst") <= 0 then
						exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "thirst", 5)
					end
					triggerEvent("kaydet:aclikvesusuzluk", targetPlayer, targetPlayer)
					local id = getElementData(targetPlayer, "dbid") -- account:character:id
					if id then
						local preparedQuery = "UPDATE `characters` SET `isDead`='0' WHERE `id`='"..id.."' "
						dbExec(mysql:getConnection(), preparedQuery)
					end
					spawnPlayer(targetPlayer, x, y, z, 0)--, team)
					
					setElementModel(targetPlayer,skin)
					setPlayerTeam(targetPlayer, team)
					setElementInterior(targetPlayer, int)
					setElementDimension(targetPlayer, dim)
					triggerEvent("updateLocalGuns", targetPlayer)
					triggerEvent("social-system:makecuffanim", targetPlayer)
					local adminTitle = tostring(exports.mrp_global:getPlayerAdminTitle(thePlayer))
					exports.mrp_global:sendMessageToAdmins("Adm: "..getPlayerName(thePlayer):gsub("_", " ").." isimli yetkili "..targetPlayerName.." isimli oyuncuyu canlandırdı.")
					outputChatBox("You have been revived by "..tostring(exports.mrp_global:getPlayerAdminTitle(thePlayer)).." "..tostring(getPlayerName(thePlayer):gsub("_"," "))..".", targetPlayer, 0, 255, 0)
					outputChatBox("You have revived "..tostring(getPlayerName(targetPlayer):gsub("_"," "))..".", thePlayer, 0, 255, 0)
					-- exports.global:sendMessageToAdmins("AdmCmd: "..tostring(exports.global:getPlayerAdminTitle(thePlayer)).." "..getPlayerName(thePlayer).." revived "..tostring(getPlayerName(targetPlayer))..".")
					-- exports.logs:dbLog(thePlayer, 4, targetPlayer, "REVIVED from PK")
					triggerClientEvent("Emekleme:Emeklet",targetPlayer,"Kaldır")
				else
					outputChatBox(tostring(getPlayerName(targetPlayer):gsub("_"," ")).." is not dead.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("revive", revivePlayerFromPK, false, false)

function stabilizePlayer(thePlayer)
	if (isElement(thePlayer)) then
		
		if (getElementData(thePlayer, "loggedin") == 0) then
			exports.mrp_global:sendMessageToAdmins("AC0x0000004: "..getPlayerName(thePlayer):gsub("_", " ").." died while not in character, triggering blackfade.")
			return
		end
		
		setPedHeadless(thePlayer, false)	
			
		dbExec(mysql:getConnection(), "UPDATE characters SET deaths = deaths + 1 WHERE charactername='" .. (getPlayerName(thePlayer)) .. "'")

		setCameraInterior(thePlayer, 0)

		setCameraTarget(thePlayer, thePlayer)
		
		local theSkin = getPedSkin(thePlayer)
		local theTeam = getPlayerTeam(thePlayer)
		
		local fat = getPedStat(thePlayer, 21)
		local muscle = getPedStat(thePlayer, 23)

		setElementData(thePlayer, "dead", 0)
		if getElementData(source, "hunger") <= 0 then
			exports.mrp_anticheat:changeProtectedElementDataEx(source, "hunger", 5)
		end
		if getElementData(source, "thirst") <= 0 then
			exports.mrp_anticheat:changeProtectedElementDataEx(source, "thirst", 5)
		end
		triggerEvent("kaydet:aclikvesusuzluk", source, source)
		local id = getElementData(thePlayer, "dbid") -- account:character:id
		if id then
			local preparedQuery = "UPDATE `characters` SET `isDead`='0' WHERE `id`='"..id.."' "
			dbExec(mysql:getConnection(), preparedQuery)
		end
		 
		--spawnPlayer(thePlayer, 1176.892578125, -1323.828125, 14.04377746582, 275)--, theTeam)
		local x,y,z = getElementPosition(thePlayer)
		local int = getElementInterior(thePlayer)
		local dim = getElementDimension(thePlayer)
		local skin = getElementModel(thePlayer)
		local team = getPlayerTeam(thePlayer)

		setCameraInterior(thePlayer, int)
		setCameraTarget(thePlayer, thePlayer)


		spawnPlayer(thePlayer, x, y, z, 0, skin, int, dim, team)


		setPedStat(thePlayer, 21, fat)
		setPedStat(thePlayer, 23, muscle)

		fadeCamera(thePlayer, true, 6)
		
		triggerClientEvent("Emekleme:Emeklet",thePlayer,"Kaldır")
		
		triggerClientEvent(thePlayer,"es-system:closeRespawnButton",thePlayer)
		triggerClientEvent(thePlayer,"es-system:closeCountdownLabel",thePlayer)
		triggerClientEvent(thePlayer, "fadeCameraOnSpawn", thePlayer)
		triggerEvent("updateLocalGuns", thePlayer)
		triggerEvent("social-system:makecuffanim", thePlayer)
	end
end
addEvent("es-system:makeStabilize", true)
addEventHandler("es-system:makeStabilize", root, stabilizePlayer)