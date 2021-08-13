----------------------[JAIL]--------------------
function jailPlayer(thePlayer, commandName, who, minutes, ...)
	if (exports.mrp_integration:isPlayerTrialAdmin(thePlayer)) then
		local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("Kullanım: /" .. commandName .. " [Oyuncu İsim/ID] [Süre (60 = 1 saat)] [Sebep]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.mrp_global:findPlayerByPartialNick(thePlayer, who)
			local reason = table.concat({...}, " ")
			
			if (targetPlayer) then
				local playerName = getPlayerName(thePlayer)
				local jailTimer = getElementData(targetPlayer, "jailtimer")
				local accountID = getElementData(targetPlayer, "account:id")
				
				if isTimer(jailTimer) then
					killTimer(jailTimer)
				end
				
				if (isPedInVehicle(targetPlayer)) then
					exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "realinvehicle", 0, false)
					removePedFromVehicle(targetPlayer)
				end
				detachElements(targetPlayer)
				
				if (minutes>=999) then
					dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='1', adminjail_by='" .. (playerName) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (accountID) .. "'")
					minutes = "Sınırsız"
					exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailtimer", true, false)
				else
					dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='0', adminjail_by='" .. (playerName) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (tonumber(accountID)) .. "'")
					local theTimer = setTimer(timerUnjailPlayer, 60000, 1, targetPlayer)
					setElementData(targetPlayer, "jailtimer", theTimer, false)
					exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailserved", 0, false)
					exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailtimer", theTimer, false)
				end
				exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "adminjailed", true, false)
				exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailreason", reason, false)
				exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailtime", minutes, false)
				exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailadmin", getPlayerName(thePlayer), false)
				
				local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")

				addAdminHistory(targetPlayer, thePlayer, reason, 0 , (tonumber(minutes) and ( minutes == 999 and 0 or minutes ) or 0))
				
				local adminTitle = exports.mrp_global:getAdminTitle1(thePlayer)
				if (hiddenAdmin==1) then
					adminTitle = "Hidden admin"
				end
				
				if commandName == "sjail" then
					if tonumber(minutes) then
						exports.mrp_global:sendMessageToAdmins("[Sessiz Ceza]: " .. adminTitle .. " İsimli Admin " .. targetPlayerName .. " İsimli oyuncuyu " .. minutes .. " dakika cezalandırdı.")
						exports.mrp_global:sendMessageToAdmins("[Sessiz Ceza]: Sebep: " .. reason)
						exports.mrp_logs:dbLog(thePlayer, 4, targetPlayer,commandName.." for "..minutes.." mins, reason: "..reason)
					else
						exports.mrp_global:sendMessageToAdmins("[[Sessiz Ceza]: " .. adminTitle .. " İsimli Admin " .. targetPlayerName .. " İsimli oyuncuyu "..minutes.." dakika cezalandırdı.")
						exports.mrp_global:sendMessageToAdmins("[Sessiz Ceza]: Sebep: " .. reason)
						exports.mrp_logs:dbLog(thePlayer, 4, targetPlayer,commandName.." "..minutes..", reason: "..reason)
					end
				else
					if tonumber(minutes) then
						outputChatBox("(( " .. targetPlayerName .. " cezalandırıldı. Süre: " .. minutes .. " dk. Sebep: "..reason.." ))", root, 194, 54, 22)

					else
						outputChatBox("(( " .. targetPlayerName .. " cezalandırıldı. Süre: " .. minutes .. " dk. Sebep: "..reason.." ))", root, 194, 54, 22)
					end
				end
				
				setElementDimension(targetPlayer, 65400+getElementData(targetPlayer, "playerid"))
				setElementInterior(targetPlayer, 6)
				setCameraInterior(targetPlayer, 6)
				setElementPosition(targetPlayer, 263.821807, 77.848365, 1001.0390625)
				setPedRotation(targetPlayer, 267.438446)
				
				toggleControl(targetPlayer,'next_weapon',false)
				toggleControl(targetPlayer,'previous_weapon',false)
				toggleControl(targetPlayer,'fire',false)
				toggleControl(targetPlayer,'aim_weapon',false)
				setPedWeaponSlot(targetPlayer,0)
				
			end
		end
	end
end
addCommandHandler("jail", jailPlayer, false, false)
addCommandHandler("sjail", jailPlayer, false, false)

--OFFLINE JAIL BY MAXIME--------------------
function offlineJailPlayer(thePlayer, commandName, who, minutes, ...)
	if (exports.mrp_integration:isPlayerTrialAdmin(thePlayer)) then
		local minutes = tonumber(minutes) and math.ceil(tonumber(minutes))
		if not (who) or not (minutes) or not (...) or (minutes<1) then
			outputChatBox("Kullanım: /" .. commandName .. " [Kullanıcı İsmi] [Dakika (60 = 1 Saat)] [Sebep]", thePlayer, 255, 194, 14)
		else
			-- If player is still online
			local reason = table.concat({...}, " ")
			local onlinePlayers = getElementsByType("player")
			for _, player in ipairs(onlinePlayers) do
				if who:lower() == getElementData(player, "account:username"):lower() then
					local commandNameTemp = "jail"
					if commandName:lower() == "sojail" then
						commandNameTemp = "sjail"
					end
					jailPlayer(thePlayer, commandNameTemp, getPlayerName(player):gsub(" ", "_"), minutes, reason)
					return true
				end
			end
			local accounts, characters = exports.mrp_auth:getTableInformations()
			local row = {}
			for index, value in ipairs(accounts) do
				if value.username == who then
					row.id = value.id
					row.username = value.username
					row.mtaserial = value.mtaserial
					row.admin = value.admin
				end
			end
			local accountID = false
			local accountUsername = false
			if row then
				accountID = row["id"] 
				accountUsername = row["username"] 
			else
				outputChatBox("Kullanıcı ismi bulunamadı!", thePlayer, 255, 0, 0)
				return false
			end
			
			local playerName = getPlayerName(thePlayer)
			
			if (minutes>=999) then
				dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='1', adminjail_by='" .. (playerName) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (accountID) .. "'")
				minutes = 9999999
			else
				dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail='1', adminjail_time='" .. (minutes) .. "', adminjail_permanent='0', adminjail_by='" .. (playerName) .. "', adminjail_reason='" .. (reason) .. "' WHERE id='" .. (tonumber(accountID)) .. "'")
			end
			
			local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
			addAdminHistory(accountID, thePlayer, reason, 0 , (tonumber(minutes) and ( minutes == 999 and 0 or minutes ) or 0))
			
			local adminTitle = exports.mrp_global:getAdminTitle1(thePlayer)
			if (hiddenAdmin==1) then
				adminTitle = "Hidden admin"
			end
			
			if commandName == "sojail" then
				exports.mrp_global:sendMessageToAdmins("[Sessiz-Ceza]: " .. adminTitle .. " İsimli Admin " .. accountUsername .. " İsimli oyuncuyu " .. minutes .. " dakika cezalandırdı.")
				exports.mrp_global:sendMessageToAdmins("[Sessiz-Ceza]: Sebep: " .. reason)
			else
				outputChatBox("[ADMIN-CEZA]: " .. adminTitle .. " İsimli Admin " .. accountUsername .. " İsimli oyuncuyu " .. minutes .. " dakika cezalandırdı.", root, 255, 0, 0)
				outputChatBox("[ADMIN-CezA]: Sebep: " .. reason, root, 255, 0, 0)
			end
			exports.mrp_logs:dbLog(thePlayer, 4, thePlayer,commandName.." "..accountUsername.." for "..minutes.." mins, reason: "..reason)
		end
	end
end
addCommandHandler("ojail", offlineJailPlayer, false, false)
addCommandHandler("sojail", offlineJailPlayer, false, false)

function timerUnjailPlayer(jailedPlayer)
	if(isElement(jailedPlayer)) then
		local timeServed = getElementData(jailedPlayer, "jailserved")
		local timeLeft = getElementData(jailedPlayer, "jailtime")
		local accountID = getElementData(jailedPlayer, "account:id")
		if (timeServed) then
			exports.mrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailserved", timeServed+1, false)
			local timeLeft = timeLeft - 1
			exports.mrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailtime", timeLeft, false)
		
			if (timeLeft<=0) and not (getElementData(jailedPlayer, "pd.jailtime")) then
				local query = dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time='0', adminjail='0' WHERE id='" .. (accountID) .. "'")
				exports.mrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailtimer", false, false)
				exports.mrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "adminjailed", false, false)
				exports.mrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailreason", false, false)
				exports.mrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailtime", false, false)
				exports.mrp_anticheat:changeProtectedElementDataEx(jailedPlayer, "jailadmin", false, false)
				setElementPosition(jailedPlayer, 1520.2783203125, -1700.9189453125, 13.546875)
				setPedRotation(jailedPlayer, 303)
				setElementDimension(jailedPlayer, 0)
				setElementInterior(jailedPlayer, 0)
				setCameraInterior(jailedPlayer, 0)
				toggleControl(jailedPlayer,'next_weapon',true)
				toggleControl(jailedPlayer,'previous_weapon',true)
				toggleControl(jailedPlayer,'fire',true)
				toggleControl(jailedPlayer,'aim_weapon',true)
				outputChatBox("Cezan bitti, bir dahakine daha dikkatli ol!", jailedPlayer, 0, 255, 0)
				
				local gender = getElementData(jailedPlayer, "gender")
				local genderm = "his"
				if (gender == 1) then
					genderm = "her"
				end
				exports.mrp_global:sendMessageToAdmins("[JAIL]: " .. getPlayerName(jailedPlayer):gsub("_", " ") .. " has served " .. genderm .. " jail time.")
				--triggerClientEvent(jailedPlayer, "updateAdminJailCounter", jailedPlayer, nil)
			else
				local query = dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time='" .. (timeLeft) .. "' WHERE id='" .. (accountID) .. "'")
				local theTimer = setTimer(timerUnjailPlayer, 60000, 1, jailedPlayer)
				setElementData(jailedPlayer, "jailtimer", theTimer, false)
				local jailCounter = {}
				jailCounter.minutesleft = timeLeft
				jailCounter.reason = getElementData(jailedPlayer, "jailreason")
				jailCounter.admin = getElementData(jailedPlayer, "jailadmin")
				--triggerClientEvent(jailedPlayer, "updateAdminJailCounter", jailedPlayer, jailCounter)
			end
		end
	end
end
addEvent("admin:timerUnjailPlayer", false)
addEventHandler("admin:timerUnjailPlayer", getRootElement(), timerUnjailPlayer)

function unjailPlayer(thePlayer, commandName, who)
	if (exports.mrp_integration:isPlayerTrialAdmin(thePlayer)) then
		if not (who) then
			outputChatBox("Kullanım: /" .. commandName .. " [Oyuncu ismi/ID]", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.mrp_global:findPlayerByPartialNick(thePlayer, who)
			
			if (targetPlayer) then
				local jailed = getElementData(targetPlayer, "jailtimer", nil)
				local username = getPlayerName(thePlayer)
				local accountID = getElementData(targetPlayer, "account:id")
				
				if not (jailed) then
					outputChatBox(targetPlayerName .. " is not jailed.", thePlayer, 255, 0, 0)
				else
					local query = dbExec(mysql:getConnection(), "UPDATE accounts SET adminjail_time='0', adminjail='0' WHERE id='" .. (accountID) .. "'")

					if isTimer(jailed) then
						killTimer(jailed)
					end
					exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailtimer", false, false)
					exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "adminjailed", false, false)
					exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailreason", false, false)
					exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailtime", false, false)
					exports.mrp_anticheat:changeProtectedElementDataEx(targetPlayer, "jailadmin", false, false)
					setElementPosition(targetPlayer, 1520.2783203125, -1700.9189453125, 13.546875)
					setPedRotation(targetPlayer, 303)
					setElementDimension(targetPlayer, 0)
					setCameraInterior(targetPlayer, 0)
					setElementInterior(targetPlayer, 0)
					toggleControl(targetPlayer,'next_weapon',true)
					toggleControl(targetPlayer,'previous_weapon',true)
					toggleControl(targetPlayer,'fire',true)
					toggleControl(targetPlayer,'aim_weapon',true)
					local hiddenAdmin = getElementData(thePlayer, "hiddenadmin")
					
					local adminTitle = exports.mrp_global:getAdminTitle1(thePlayer)
					if (hiddenAdmin==1) then
						adminTitle = "Hidden admin"
					end
			
					outputChatBox("You were unjailed by "..adminTitle..", behave next time!", targetPlayer, 0, 255, 0)
					exports.mrp_global:sendMessageToAdmins("[ADMIN-CEZA]: " .. targetPlayerName .. " İsimli oyuncunun "..adminTitle.." tarafından cezası sonlandırıldı.")
					exports.mrp_logs:dbLog(thePlayer, 4, targetPlayerName,commandName)
				end
			end
		end
	end
end
addCommandHandler("unjail", unjailPlayer, false, false)

function jailedPlayers(thePlayer, commandName)
	if (exports.mrp_integration:isPlayerTrialAdmin(thePlayer)) then
		outputChatBox("----- Jailed -----", thePlayer, 255, 194, 15)
		local players = exports.mrp_pool:getPoolElementsByType("player")
		local count = 0
		for key, value in ipairs(players) do
			if getElementData(value, "adminjailed") then
				if tonumber(getElementData(value, "jailtime")) then
					outputChatBox("[Ceza] " .. getPlayerName(value) .. ", jailed by " .. tostring(getElementData(value, "jailadmin")) .. ", served " .. tostring(getElementData(value, "jailserved")) .. " minutes, " .. tostring(getElementData(value,"jailtime")) .. " minutes left", thePlayer, 255, 194, 15)
					outputChatBox("[Ceza] Sebep: " .. tostring(getElementData(value, "jailreason")), thePlayer, 255, 194, 15)
				else
					outputChatBox("[Ceza] " .. getPlayerName(value) .. ", jailed by " .. tostring(getElementData(value, "jailadmin")) .. ", Sınırsız,", thePlayer, 255, 194, 15)
					outputChatBox("[Ceza] Sebep: " .. tostring(getElementData(value, "jailreason")), thePlayer, 255, 194, 15)
				end
				count = count + 1
			elseif getElementData(value, "jailed") then
				outputChatBox("[ARREST] ".. getPlayerName(value).. " || Cell:"..getElementData(value, "jail:cell").." || Prisoner ID:".. tostring(getElementData(value, "jail:id")) .." || Use /arrest for more info.", thePlayer, 0, 102, 255)
				count = count + 1
			end
		end
		
		if count == 0 then
			outputChatBox("There is no one jailed.", thePlayer, 255, 194, 15)
		end
	end
end
addCommandHandler("jailed", jailedPlayers, false, false)