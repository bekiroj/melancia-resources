local timerLoadAllInteriors = 60000

addEvent("onPlayerInteriorChange", true)
intTable = {}
safeTable = {}
mysql = exports.mrp_mysql

-- Small hack
function setElementDataEx(source, field, parameter, streamtoall, streamatall)
	exports.mrp_anticheat:changeProtectedElementDataEx( source, field, parameter, streamtoall, streamatall)
end
-- End small hack

function switchGroundSnow( toggle )
	--if getResourceState ( getResourceFromName( "shader_snow_ground" ) ) == "running" then
	--	triggerClientEvent( thePlayer, "switchGoundSnow", thePlayer, toggle)
	--end
end

function SmallestID() -- finds the smallest ID in the SQL instead of auto increment
	local query = dbQuery(mysql:getConnection(), "SELECT MIN(e1.id+1) AS nextID FROM interiors AS e1 LEFT JOIN interiors AS e2 ON e1.id +1 = e2.id WHERE e2.id IS NULL")
	local result = dbPoll(query, -1)
	if result then
		local id = tonumber(result[1]["nextID"]) or 1
		return id
	end
	return false
end

function findProperty(thePlayer, dimension)
	local dbid = dimension or (thePlayer and getElementDimension( thePlayer ) or 0)
	if dbid and tonumber(dbid) and tonumber(dbid) > 0 then
		dbid = tonumber(dbid) 
		local foundInterior = exports.mrp_pool:getElement("interior", dbid)
		if foundInterior then
			local interiorEntrance = getElementData(foundInterior, "entrance")
			local interiorExit = getElementData(foundInterior, "exit")
			local interiorStatus = getElementData(foundInterior, "status")
			return dbid, interiorEntrance, interiorExit, interiorStatus[INTERIOR_TYPE], foundInterior
		end
	end
	return 0
end

function cleanupProperty( id, donotdestroy)
	if id > 0 then
		
		local resE = getResourceRootElement( getResourceFromName( "elevators" ) )
		if resE then
			call( getResourceFromName( "mrp_elevators" ), "delElevatorsFromInterior", "MAXIME" , "PROPERTYCLEANUP",  id ) 
		end
		
		if not donotdestroy then
			local res1 = getResourceRootElement( getResourceFromName( "mrp_object_system" ) )
			if res1 then
				exports['mrp_object_system']:removeInteriorObjects( tonumber(id) )
			end
		end
		
		if safeTable[id] then
			local safe = safeTable[id]
			call( getResourceFromName( "mrp_items" ), "clearItems", safe )
			if safe and isElement(safe) then
				destroyElement(safe)
			end
			safeTable[id] = nil
		end
		
		setTimer ( function () 
			call( getResourceFromName( "mrp_items" ), "deleteAllItemsWithinInt", id, 0, "CLEANUPINT" ) 
		end, 3000, 1)
		
	end
end

function sellProperty(thePlayer, commandName, bla)
	if bla then
		outputChatBox("Burayı başka bir oyuncuya satmak için /sell kullanın.", thePlayer, 255, 0, 0)
		return
	end
	  
	local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
	if dbid > 0 then
		if interiorType == 2 then
			outputChatBox("Kamu mülkünü satamazsın.", thePlayer, 255, 0, 0)
		elseif interiorType ~= 3 and commandName == "unrent" then
			outputChatBox("Kiraladığın bir mülkü satamazsın.", thePlayer, 255, 0, 0)
		else
			local interiorStatus = getElementData(interiorElement, "status")
			if interiorStatus[INTERIOR_OWNER] == getElementData(thePlayer, "dbid") or ( getElementData(thePlayer, "factionleader") > 0 and interiorStatus[INTERIOR_FACTION] == getElementData(thePlayer, "faction")) then
				publicSellProperty(thePlayer, dbid, true, true, false)
				cleanupProperty(dbid, true)
				exports.mrp_logs:dbLog(thePlayer, 37, { "in"..tostring(dbid) } , "SELLPROPERTY "..dbid)
				local addLog = dbExec(mysql:getConnection(),"INSERT INTO `interior_logs` (`intID`, `action`, `actor`) VALUES ('"..tostring(dbid).."', '"..commandName.."', '"..getElementData(thePlayer, "account:id").."')") or false
				if not addLog then
					outputDebugString("Failed to add interior logs.")
				end
			else
				outputChatBox("Kendine ait olmayan bir mülkü satamazsın", thePlayer, 255, 0, 0)
			end
		end
	else 
		outputChatBox("Bir mülkün içerisinde değilsin.", thePlayer, 255, 0, 0)
	end
end
addCommandHandler("sellproperty", sellProperty, false, false)
addCommandHandler("unrent", sellProperty, false, false)

function publicSellProperty(thePlayer, dbid, showmessages, givemoney, CLEANUP)
	local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer, dbid )
	local query = dbExec(mysql:getConnection(),"UPDATE interiors SET owner=-1, faction=0, locked=1, safepositionX=NULL, safepositionY=NULL, safepositionZ=NULL, safepositionRZ=NULL WHERE id='" .. dbid .. "'")
	if query then
		local interiorStatus = getElementData(interiorElement, "status")
		if getElementDimension(thePlayer) == dbid and not CLEANUP then
			setElementInterior(thePlayer, entrance[INTERIOR_INT])
			setCameraInterior(thePlayer, entrance[INTERIOR_INT])
			setElementDimension(thePlayer, entrance[INTERIOR_DIM])
			setElementPosition(thePlayer, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])
			exports.mrp_anticheat:changeProtectedElementDataEx(thePlayer, "interiormarker", false, false, false)
		end

		if safeTable[dbid] then
			local safe = safeTable[dbid]
			if safe then
				exports['mrp_items']:clearItems(safe)
				destroyElement(safe)
				safeTable[dbid] = nil
			end
		end
		
		if interiorType == 0 or interiorType == 1 then
			if interiorType == 1 then
				dbExec(mysql:getConnection(),"DELETE FROM interior_business WHERE intID='" .. dbid .. "'")
			end

			local gov = getTeamFromName("İstanbul Büyükşehir Belediyesi")

			if interiorStatus[INTERIOR_OWNER] == getElementData(thePlayer, "dbid") then
				local money = math.ceil(interiorStatus[INTERIOR_COST] * 2/3)		
				if givemoney then
					exports.mrp_global:giveMoney(thePlayer, money)
					if exports.mrp_global:takeMoney(gov, money, true) then
					end
				end
				
				if showmessages then
					if CLEANUP == "FORCESELL" then
						exports.mrp_global:sendMessageToAdmins("[INTERIOR]: "..exports.mrp_global:getPlayerFullIdentity(thePlayer).." has force-sold interior #"..dbid.." ("..getElementData(interiorElement,"name")..").") 
					else
						outputChatBox("Mülkünüzü sattınız " .. exports.mrp_global:formatMoney(money) .. exports.mrp_pool:getServerMoneyType(thePlayer).."", thePlayer, 0, 255, 0)
					end
				end
				
				-- take all keys
				call( getResourceFromName( "mrp_items" ), "deleteAll", interiorType == 0 and 4 or 5, dbid )
	
				--triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])
			elseif interiorStatus[INTERIOR_FACTION] == getElementData(thePlayer, "faction") then
				local money = math.ceil(interiorStatus[INTERIOR_COST] * 2/3)		
				local faction = exports.mrp_factions:getTeamFromFactionID(interiorStatus[INTERIOR_FACTION])
				if givemoney and faction then
					exports.mrp_global:giveMoney(faction, money)
					if exports.mrp_global:takeMoney(gov, money, true) then
						--exports.mrp_bank:addBankTransactionLog(-getElementData(gov, "id"), -interiorStatus[INTERIOR_FACTION], money, 3 , "Interior sold to Government", getElementData(interiorElement, "name").." (ID: "..getElementData(interiorElement, "dbid")..")" )
					end
				end
				
				if showmessages then
					if CLEANUP == "FORCESELL" then
						exports.mrp_global:sendMessageToAdmins("[INTERIOR]: "..exports.mrp_global:getPlayerFullIdentity(thePlayer).." has force-sold interior #"..dbid.." ("..getElementData(interiorElement,"name")..").") 
					elseif faction then
						outputChatBox("Mülkünüzü sattınız " .. exports.mrp_global:formatMoney(money) .. exports.mrp_pool:getServerMoneyType(thePlayer).." (Bankaya havale yapıldı: '"..getTeamName(faction).."')", thePlayer, 0, 255, 0)
					end
				end
				
				-- take all keys
				call( getResourceFromName( "mrp_items" ), "deleteAll", interiorType == 0 and 4 or 5, dbid )
			else
				if showmessages then
					if CLEANUP == "FORCESELL" then
						exports.mrp_global:sendMessageToAdmins("[INTERIOR]: "..exports.mrp_global:getPlayerFullIdentity(thePlayer).." has force-sold interior #"..dbid.." ("..getElementData(interiorElement,"name")..").") 
					else
						outputChatBox("Bu mülkü sahipsiz olarak ayarladınız.", thePlayer, 0, 255, 0)
					end
				end
			end
		else
			if showmessages then
				if CLEANUP == "FORCESELL" then
					exports.mrp_global:sendMessageToAdmins("[INTERIOR]: "..exports.mrp_global:getPlayerFullIdentity(thePlayer).." has force-sold interior #"..dbid.." ("..getElementData(interiorElement,"name")..").") 
				else
					outputChatBox("Artık bu mülkü kiralamıyorsunuz.", thePlayer, 0, 255, 0)
				end
			end
			-- take all keys
			call( getResourceFromName( "mrp_items" ), "deleteAll", interiorType == 0 and 4 or 5, dbid )
			--triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])
		end	
		realReloadInterior(dbid, {thePlayer})
	else
		outputChatBox("Error 504914 - Teknik desteğe ulaşın", thePlayer, 255, 0, 0)
	end
end

function unownProperty(intid, reason) --This function is meant to be used by the system or to be triggered from UCP remotely. Works similarly to the publicSellProperty however, it's simplier. / MAXIME / 2015.1.11
	if intid and tonumber(intid) then
		intid = tonumber(intid)
	else 
		return false, "Interior is missing or invalid"
	end
	--Existed or not, we take all keys anyway.
	call( getResourceFromName( "mrp_items" ), "deleteAll", 4 , intid )
	call( getResourceFromName( "mrp_items" ), "deleteAll", 5 , intid )
	--Clean up NPC, ATMs, dancers, etc in the interior but don't destroy objects if it's a custom interior.
	cleanupProperty(intid, true)

	--Now we process in database first.
	local int = dbPoll(dbQuery(mysql:getConnection(), "SELECT id, type FROM interiors WHERE id="..intid.." LIMIT 1"), -1)
	if int and int.id ~= nil then
		dbExec(mysql:getConnection(),"UPDATE interiors SET owner=-1, faction=0, locked=1, safepositionX=NULL, safepositionY=NULL, safepositionZ=NULL, safepositionRZ=NULL WHERE id='" .. intid .. "'")
		if int.type == "1" then -- if it's a business, clean up in other table too.
			dbExec(mysql:getConnection(),"DELETE FROM interior_business WHERE intID='" .. intid .. "'")
		end
	else
		return false, "Interior does not existed in database."
	end

	--Alright, it's time to give admins some clues of what just happened
	exports.mrp_logs:dbLog("SYSTEM", 37, { "in"..intid } , reason and reason or "FORCESELL")
	exports["mrp_interior_manager"]:addInteriorLogs(intid, reason and reason or "Forcesold by SYSTEM")

	--Check if interior is loaded in game
	local dbid, entrance, exit, interiorType, interiorElement = findProperty( nil, intid )
	if interiorElement then
		realReloadInterior(intid) --Reload interior and update owner's radar blips.
		return true
	else
		return true, "Interior is not loaded in game so only cleaned up in database."
	end
end

function sellTo(thePlayer, commandName, targetPlayerName)
	-- only works in dimensions
	local dbid, entrance, exit, interiorType, interiorElement = findProperty( thePlayer )
	if dbid > 0 and not isPedInVehicle( thePlayer ) then
		local interiorStatus = getElementData(interiorElement, "status")
		if interiorStatus[INTERIOR_TYPE] == 2 then
			outputChatBox("You cannot sell a government property.", thePlayer, 255, 0, 0)
		elseif not targetPlayerName then
			outputChatBox("SYNTAX: /" .. commandName .. " [partial player name / id]", thePlayer, 255, 194, 14)
			outputChatBox("Sells the Property you're in to that Player.", thePlayer, 255, 194, 14)
			outputChatBox("Ask the buyer to use /pay to recieve the money for the Property.", thePlayer, 255, 194, 14)
		else
			local targetPlayer, targetPlayerName = exports.mrp_global:findPlayerByPartialNick(thePlayer, targetPlayerName)
			if targetPlayer and getElementData(targetPlayer, "dbid") then
				local px, py, pz = getElementPosition(thePlayer)
				local tx, ty, tz = getElementPosition(targetPlayer)
				if getDistanceBetweenPoints3D(px, py, pz, tx, ty, tz) < 10 and getElementDimension(targetPlayer) == getElementDimension(thePlayer) then
					if not exports.mrp_global:canPlayerBuyInterior(targetPlayer) then
						outputChatBox(targetPlayerName .. " zaten çok fazla mülke sahip.", thePlayer, 255, 0, 0)
						outputChatBox((getPlayerName(thePlayer):gsub("_", " ")) .. " maksimum mülke sahipsiniz.", targetPlayer, 255, 0, 0)
						return false
					end
					
					if interiorStatus[INTERIOR_OWNER] == getElementData(thePlayer, "dbid") then
						if getElementData(targetPlayer, "dbid") ~= interiorStatus[INTERIOR_OWNER] then
							if exports.mrp_global:hasSpaceForItem(targetPlayer, 4, dbid) then
								local query = dbExec(mysql:getConnection(),"UPDATE interiors SET owner = '" .. getElementData(targetPlayer, "dbid") .. "', faction=0, lastused=NOW() WHERE id='" .. dbid .. "'")
								if query then							
									local keytype = 4
									if interiorType == 1 then
										keytype = 5
									end

									call( getResourceFromName( "mrp_items" ), "deleteAll", 4, dbid )
									call( getResourceFromName( "mrp_items" ), "deleteAll", 5, dbid )
									exports.mrp_global:giveItem(targetPlayer, keytype, dbid)
									
									--triggerClientEvent(thePlayer, "removeBlipAtXY", thePlayer, interiorType, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])
									--triggerClientEvent(targetPlayer, "createBlipAtXY", targetPlayer, interiorType, entrance[INTERIOR_X], entrance[INTERIOR_Y], entrance[INTERIOR_Z])

									if interiorType == 0 or interiorType == 1 then
										outputChatBox("Mülkünüzü başarıyla sattınız " .. targetPlayerName .. ".", thePlayer, 0, 255, 0)
										outputChatBox((getPlayerName(thePlayer):gsub("_", " ")) .. " sana bu mülkü sattı.", targetPlayer, 0, 255, 0)
									else
										outputChatBox(targetPlayerName .. " kira sözleşmenizi devraldı.", thePlayer, 0, 255, 0)
										outputChatBox("Sen devraldın " .. getPlayerName(thePlayer):gsub("_", " ") .. "' kira sözleşmesini.",  targetPlayer, 0, 255, 0)
									end
									exports.mrp_logs:dbLog(thePlayer, 37, { targetPlayer, "in"..tostring(dbid) } , "SELLPROPERTY "..getPlayerName(thePlayer).." => "..targetPlayerName)
									local adminID = getElementData(thePlayer, "account:id")
									
									realReloadInterior(dbid, {targetPlayer, thePlayer})
									exports["mrp_interior_manager"]:addInteriorLogs(dbid, commandName.." to "..targetPlayerName.."("..getElementData(targetPlayer, "account:username")..")", thePlayer)
								else
									outputChatBox("Error 09002 - Report on Forums.", thePlayer, 255, 0, 0)
								end
							else
								outputChatBox(targetPlayerName .. " envanterinizde anahtar için yeterli alan yok.", thePlayer, 255, 0, 0)
							end
						else
							outputChatBox("Kendi malını kendin satamazsın.", thePlayer, 255, 0, 0)
						end
					else
						outputChatBox("Bu mülk sizin değil.", thePlayer, 255, 0, 0)
					end
				else
					outputChatBox("" .. targetPlayerName .. " kişiye çok uzaktasın.", thePlayer, 255, 0, 0)
				end
			end
		end
	end
end
addCommandHandler("sell", sellTo)
addCommandHandler("mülksat", sellTo)

function realReloadInterior(interiorID, updatePlayers)
	local dbid, entrance, exit, inttype, interiorElement = exports['mrp_interiors']:findProperty( false, interiorID )
	if dbid > 0 then
		if safeTable[dbid] then
			destroyElement(safeTable[dbid])
			safeTable[dbid] = false
		end	
		triggerClientEvent("deleteInteriorElement", interiorElement, tonumber(dbid))
		destroyElement(interiorElement)
		reloadOneInterior(tonumber(dbid), updatePlayers, false)
	end
end

-- CONVERTED
local stats_numberOfInts = 0
local timerDelay = 100
local loadedInteriors = 0
local initializeSoFarDetector = 0
function reloadOneInterior(id, updatePlayers, massLoad)
	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				row = res[1]

				interiorElement = createElement("interior", "int"..tostring(row.id))
				setElementDataEx(interiorElement, "dbid", 	row.id, true)
				setElementDataEx(interiorElement, "entrance", {	server = row.server, row.x, row.y, row.z, row.interiorwithin, row.dimensionwithin, row.angle, 0 }, true)

				setElementDataEx(interiorElement, "interiorsettings", {["ooc"] = false, ["time"] = "auto"})
				
				setElementPosition(interiorElement, tonumber(row.x), tonumber(row.y), tonumber(row.z))
				setElementInterior(interiorElement, tonumber(row.interiorwithin))
				if tonumber(row.type) == 1 then
				 setElementDataEx(interiorElement, "girispara", tonumber(row.girispara), true)
				else
				 setElementDataEx(interiorElement, "girispara", 0, true)
				end
				setElementDataEx(interiorElement, "kasa", tonumber(row.kasa), true)
			
				setElementDimension(interiorElement, tonumber(row.dimensionwithin))
				if row.furniture == 1 then
					setElementDataEx(interiorElement, "furniture_enabled", true)
				else
					setElementDataEx(interiorElement, "furniture_enabled", true)
				end
				
				setElementDataEx(interiorElement, "exit", {row.interiorx, row.interiory, row.interiorz,	row.interior, row.id, row.angleexit, 0	}, true	)
				setElementDataEx(interiorElement, "status",  {	row.type,	row.disabled == 1, 	row.locked == 1, row.owner,		row.cost,	row.supplies, tonumber(row.faction)}, true	)
				setElementDataEx(interiorElement, "name", row.name, true)

				--Inactivity Protection / MAXIME
				if tonumber(row.owner) > 0 and tonumber(row.protected_until) ~= -1 then
					setElementDataEx(interiorElement, "protected_until", tonumber(row.protected_until), true)
				end
				if (row.lastused_sec ~= nil) then
					setElementDataEx(interiorElement, "lastused", tonumber(row.lastused_sec), true)
				end
				if (row.owner_last_login ~= nil) then
					setElementDataEx(interiorElement, "owner_last_login", tonumber(row.owner_last_login), true)
				end


				--Keyless Digital Door Lock / maxime
				if type(row.keypad_lock) ~= "userdata" and tonumber(row.type) ~= 2 and type(row.owner) ~= "userdata" and tonumber(row.owner) and tonumber(row.owner) > 0 then
					--outputDebugString("yes")
					setElementData(interiorElement, "keypad_lock", tonumber(row.keypad_lock), true)
					if type(row.keypad_lock_pw) ~= "userdata" then
						setElementData(interiorElement, "keypad_lock_pw", row.keypad_lock_pw, true)
					end
					if type(row.keypad_lock_auto) ~= "userdata" then
						setElementData(interiorElement, "keypad_lock_auto", tonumber(row.keypad_lock_auto) == 1, true)
					end
				else
					removeElementData(interiorElement, "keypad_lock")
					removeElementData(interiorElement, "keypad_lock_pw")
					removeElementData(interiorElement, "keypad_lock_auto")
				end

				--setElementDataEx(interiorElement, "isLightOn", row.isLightOn == 1, true)
				if row.safepositionX and row.safepositionY and row.safepositionZ ~= nil and row.safepositionRZ then
					setElementDataEx(interiorElement, "safe", {row.safepositionX, row.safepositionY, row.safepositionZ, 0, 0, row.safepositionRZ}, false)
					
					local tempobject = createObject(2332, row.safepositionX,  row.safepositionY, row.safepositionZ, 0, 0, row.safepositionRZ)
					setElementInterior(tempobject, row.interior)
					setElementDimension(tempobject, row.id)
					safeTable[row.id] = tempobject
				else
					setElementDataEx(interiorElement, "safe", false, true)
				end
				
				if row.businessNote then
					setElementDataEx(interiorElement, "business:note", 	row.businessNote , true)
				end
				--outputDebugString( "[INTERIOR] LOADED INT #" .. id.." ("..row.name..")" )

				if updatePlayers then
					if isElement(updatePlayers[2]) then
						if isElement(updatePlayers[1]) then
							triggerClientEvent(updatePlayers[1], "drawAllMyInteriorBlips", updatePlayers[2])
						end
						triggerClientEvent(updatePlayers[2], "drawAllMyInteriorBlips", updatePlayers[2])
					end
				end
				
				whatToReturn = true
				exports.mrp_pool:allocateElement(interiorElement, tonumber(row.id), true)
				if massLoad then
					loadedInteriors = loadedInteriors + 1
					local newInitializeSoFarDetector = math.ceil(loadedInteriors/(stats_numberOfInts/100))
					if loadedInteriors == 1 or loadedInteriors == stats_numberOfInts or initializeSoFarDetector ~= newInitializeSoFarDetector then
						triggerClientEvent("interior:initializeSoFar", root, loadedInteriors, stats_numberOfInts) 
						--outputDebugString("triggered - loadedInteriors:"..loadedInteriors.." - initializeSoFarDetector:"..initializeSoFarDetector.." - newInitializeSoFarDetector:"..newInitializeSoFarDetector)
						initializeSoFarDetector = newInitializeSoFarDetector
					end
				else
					--outputDebugString("interiorElement = "..tostring(interiorElement))
					--triggerClientEvent("interior:schedulePickupLoading", root, interiorElement)
				end
			end
		end,
	mysql:getConnection(), "SELECT (CASE WHEN lastlogin IS NOT NULL THEN TO_SECONDS(lastlogin) ELSE NULL END) AS owner_last_login, interiors.id AS id, interiors.x AS x, interiors.y AS y, interiors.z AS z, interiorwithin, dimensionwithin, angle, interiorx, interiory, interiorz, interior, angleexit, type, disabled, locked, owner, cost, supplies, faction, name, keypad_lock, keypad_lock_pw, keypad_lock_auto,safepositionX, safepositionY, safepositionZ, girispara, kasa, safepositionRZ, businessNote, TO_SECONDS(lastused) AS lastused_sec, (CASE WHEN ((protected_until IS NULL) OR (protected_until > NOW() = 0)) THEN -1 ELSE TO_SECONDS(protected_until) END) AS protected_until FROM `interiors` LEFT JOIN `interior_business` ON `interiors`.`id` = `interior_business`.`intID` LEFT JOIN characters ON interiors.owner=characters.id WHERE interiors.id = '" .. id .."' AND `deleted` = '0'")
end

--[[local threads = { }
function resume()
	for key, value in ipairs(threads) do
		coroutine.resume(value)
	end
end]]


function loadAllInteriors()
	local players = exports.mrp_pool:getPoolElementsByType("player")
	for k, thePlayer in ipairs(players) do
		exports.mrp_anticheat:changeProtectedElementDataEx(thePlayer, "interiormarker", false, false, false)
	end

	dbQuery(
		function(qh)
			local res, rows, err = dbPoll(qh, 0)
			if rows > 0 then
				for index, value in ipairs(res) do
					reloadOneInterior(value.id)
				end
			end
		end,
	mysql:getConnection(), "SELECT `id` FROM `interiors` WHERE `deleted` = '0'")

	setInteriorSoundsEnabled ( false ) -- maxime
end
--setTimer(loadAllInteriors, timerLoadAllInteriors, 1)
addEventHandler("onResourceStart", getResourceRootElement(getThisResource()), loadAllInteriors)

function buyInterior(player, pickup, cost, isHouse, isRentable, isFurniture)
	if not exports.mrp_global:canPlayerBuyInterior(player) then
		outputChatBox("Zaten çok fazla mülkünüz oldu.", player, 255, 0, 0)
		return false
	end

	if isRentable then
		local result = dbPoll(dbQuery(mysql:getConnection(),  "SELECT COUNT(*) as 'cntval' FROM `interiors` WHERE `owner` = " .. getElementData(player, "dbid") .. " AND `type` = 3" ), -1)
		if result then
			local count = tonumber(result['cntval'])
			if count ~= 0 then
				outputChatBox("Zaten başka bir ev kiralıyorsun.", player, 255, 0, 0)
				return
			end
		end
	elseif not exports.mrp_global:hasSpaceForItem(player, 4, 1) then
		outputChatBox("Envanterinizde anahtar için yeterli alan yok.", player, 255, 0, 0)
		return
	end
	if isFurniture == true then
		activeFurniture = 1
	else
		activeFurniture = 0
	end
	if exports.mrp_global:takeMoney(player, cost) then
		if (isHouse) then
			outputChatBox("Tebrikler! Az önce bu evi satın aldınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)
			exports.mrp_global:giveMoney( getTeamFromName("İstanbul Büyük Şehir Belediyesi"), cost )
		elseif (isRentable) then
			outputChatBox("Tebrikler! Az önce bu evi kiraladınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)
		else
			outputChatBox("Tebrikler! Az önce bu işyerini aldınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)
			exports.mrp_global:giveMoney( getTeamFromName("İstanbul Büyük Şehir Belediyesi"), cost )
		end
		
		local charid = getElementData(player, "dbid")
		local pickupid = getElementData(pickup, "dbid")
		dbExec(mysql:getConnection(), "UPDATE interiors SET owner='" .. charid .. "', locked=0, furniture='"..activeFurniture.."', lastused=NOW() WHERE id='" .. pickupid .. "'") 
		
		local interiorEntrance = getElementData(pickup, "entrance")
		
		-- make sure it's an unqiue key
		call( getResourceFromName( "item-system" ), "deleteAll", 4, pickupid )
		call( getResourceFromName( "item-system" ), "deleteAll", 5, pickupid )
		
		if (isHouse) or (isRentable) then
			exports.mrp_global:giveItem(player, 4, pickupid)
		else
			exports.mrp_global:giveItem(player, 5, pickupid)
		end
		exports.mrp_logs:dbLog(thePlayer, 37, { "in"..tostring(pickupid) } , "BUYPROPERTY $"..cost)
		realReloadInterior(tonumber(pickupid), {player})
		exports["mrp_interior_manager"]:addInteriorLogs(pickupid, "Alındı ​​/ Kiralandı, "..exports.mrp_pool:getServerMoneyType(thePlayer) ..exports.mrp_global:formatMoney(cost)..", "..getPlayerName(thePlayer), thePlayer)
	else
		outputChatBox("Üzgünüz, bu mülkü satın alamazsınız.", player, 255, 194, 14)
	end
end

function buypropertyForFaction(interior, cost, isHouse) --Maxime
	local can, reason = exports.mrp_global:canPlayerFactionBuyInterior(source)
	if not can then
		outputChatBox(reason, source, 255, 0, 0)
		return
	end
	local theFaction = can
	if not exports.mrp_global:takeMoney(theFaction, cost) then
		outputChatBox("Birlik kasasından ücret alınamadı.", source, 255, 0, 0)
		return
	end
	local gov = getTeamFromName("İstanbul Büyükşehir Belediyesi")
	local intName = getElementData(interior,"name")
	local factionId = getElementData(theFaction, "id")
	local intId = getElementData(interior, "dbid")
	exports.mrp_global:giveMoney( gov, cost )
	--exports.mrp_bank:addBankTransactionLog(-factionId, -(getElementData(gov, "id")), cost, 3 , "Mülk Satın Alma", intName.." (ID: "..intId..")" )
	
	if not dbExec(mysql:getConnection(), "UPDATE interiors SET owner='-1', faction='"..factionId.."', locked=0, lastused=NOW() WHERE id='" .. intId .. "'") then
		exports.mrp_global:giveMoney(theFaction, cost)
		exports.mrp_global:takeMoney( gov, cost )
		outputChatBox("Internal error code 334INT2.", source, 255, 0, 0)
		return false
	end
	local factionName = getTeamName(theFaction):gsub("_", " ")
	outputChatBox("Tebrikler! Bu mülkü az önce satın aldınız '"..factionName.."' "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.global:formatMoney(cost) .. ".", source, 255, 194, 14)
	local interiorEntrance = getElementData(interior, "entrance")

	call( getResourceFromName( "item-system" ), "deleteAll", isHouse and 4 or 5, intId )
	exports.mrp_global:giveItem(source, isHouse and 4 or 5, intId)
	
	exports.mrp_logs:dbLog(source, 37, { "in"..tostring(intId) } , "BUYPROPERTY $"..cost.." FOR FACTION '"..factionName.."'")
	realReloadInterior(tonumber(intId))
	exports["mrp_interior_manager"]:addInteriorLogs(intId, "'"..factionName.."', "..exports.mrp_pool:getServerMoneyType(thePlayer) ..exports.mrp_global:formatMoney(cost)..", "..getPlayerName(source), source)
	triggerClientEvent(source, "createBlipAtXY", source, interiorEntrance[INTERIOR_TYPE], interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y])
	exports.mrp_achievement:playSoundFx(source)
	return true
end
addEvent( "buypropertyForFaction", true )
addEventHandler( "buypropertyForFaction", root, buypropertyForFaction)

function buyInteriorCash(player, pickup, cost, isHouse, isRentable, isFurniture)
	if not exports.mrp_global:canPlayerBuyInterior(player) then
		outputChatBox("Azami iç mekan sayısına zaten ulaştınız. Maksimum iç mekanınızı F10 -> Premium Özellikler ile genişletebilirsiniz.", player, 255, 0, 0)
		return
	end
	if isFurniture == true then
		activeFurniture = 1
	else
		activeFurniture = 0
	end
	
	if isRentable then
		local result = dbPoll(dbQuery(mysql:getConnection(),  "SELECT COUNT(*) as 'cntval' FROM `interiors` WHERE `owner` = " .. getElementData(player, "dbid") .. " AND `type` = 3" ), -1)
		if result then
			local count = tonumber(result['cntval'])
			if count ~= 0 then
				outputChatBox("Zaten başka bir ev kiralıyorsunuz.", player, 255, 0, 0)
				return
			end
		end
	elseif not exports.mrp_global:hasSpaceForItem(player, 4, 1) then
		outputChatBox("Envanterinizde anahtar için yeterli alan yok.", player, 255, 0, 0)
		return
	end
	
	if exports.mrp_global:takeMoney(player, cost) then
		local charid = getElementData(player, "dbid")
		local pickupid = getElementData(pickup, "dbid")
		local intName = getElementData(pickup, "name")
	
		if (isHouse) then
			outputChatBox("Tebrikler! Az önce bu evi satın aldınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)

		elseif (isRentable) then
			outputChatBox("Tebrikler! Az önce bu mülkü kiraladınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)
		else
			outputChatBox("Tebrikler! Az önce bu işyerini satın aldınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)
		end
		
		
		
		dbExec(mysql:getConnection(), "UPDATE interiors SET owner='" .. charid .. "', locked=0, furniture='"..activeFurniture.."', lastused=NOW()  WHERE id='" .. pickupid .. "'") 
		
		local interiorEntrance = getElementData(pickup, "entrance")
		
		call( getResourceFromName( "mrp_items" ), "deleteAll", isHouse and 4 or 5, pickupid )
		exports.mrp_global:giveItem(player, isHouse and 4 or 5, pickupid)
		
		exports.mrp_logs:dbLog(player, 37, { "in"..tostring(pickupid) } , "BUYPROPERTY $"..cost)
		realReloadInterior(tonumber(pickupid), {player})
		exports["mrp_interior_manager"]:addInteriorLogs(pickupid, "Alındı ​​/ Kiralandı, "..exports.mrp_pool:getServerMoneyType(thePlayer) ..exports.mrp_global:formatMoney(cost)..", "..getPlayerName(player), player)
		triggerClientEvent(player, "createBlipAtXY", player, interiorEntrance[INTERIOR_TYPE], interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y])
	else
		outputChatBox("Üzgünüz, bu mülkü satın alamazsınız.", player, 255, 194, 14)
	end
end
addEvent( "buypropertywithcash", true )
addEventHandler( "buypropertywithcash", root, buyInteriorCash)

function buyInteriorToken(player, pickup, cost, isHouse, isRentable, isFurniture)
	if not exports.mrp_global:canPlayerBuyInterior(player) then
		outputChatBox("Azami iç mekan sayısına zaten ulaştınız. Forum üzerinden ek slot satın alabilirsiniz. ( www.lucyrpg.com )", player, 255, 0, 0)
		return
	end
	if isFurniture == true then
		activeFurniture = 1
	else
		activeFurniture = 0
	end
	
	if isRentable then
		local result = dbPoll(dbQuery(mysql:getConnection(),  "SELECT COUNT(*) as 'cntval' FROM `interiors` WHERE `owner` = " .. getElementData(player, "dbid") .. " AND `type` = 3" ), -1)
		if result then
			local count = tonumber(result['cntval'])
			if count ~= 0 then
				outputChatBox("Zaten başka bir ev kiralıyorsunuz.", player, 255, 0, 0)
				return
			end
		end
	elseif not exports.mrp_global:hasSpaceForItem(player, 4, 1) then
		outputChatBox("Envanterinizde anahtar için yeterli alan yok.", player, 255, 0, 0)
		return
	end
	
	if exports.mrp_global:takeItem(player, 262, 1) then
		local charid = getElementData(player, "dbid")
		local pickupid = getElementData(pickup, "dbid")
		local intName = getElementData(pickup, "name")
	
		if (isHouse) then
			outputChatBox("Tebrikler! Az önce bu evi satın aldınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)

		elseif (isRentable) then
			outputChatBox("Tebrikler! Az önce bu mülkü kiraladınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)
		else
			outputChatBox("Tebrikler! Az önce bu işyerini satın aldınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)
		end
		
		
		
		dbExec(mysql:getConnection(), "UPDATE interiors SET owner='" .. charid .. "', locked=0, furniture='"..activeFurniture.."', lastused=NOW()  WHERE id='" .. pickupid .. "'") 
		
		local interiorEntrance = getElementData(pickup, "entrance")
		
		call( getResourceFromName( "mrp_items" ), "deleteAll", isHouse and 4 or 5, pickupid )
		exports.mrp_global:giveItem(player, isHouse and 4 or 5, pickupid)
		
		exports.mrp_logs:dbLog(player, 37, { "in"..tostring(pickupid) } , "BUYPROPERTY $"..cost)
		realReloadInterior(tonumber(pickupid), {player})
		exports["mrp_interior_manager"]:addInteriorLogs(pickupid, "Alındı ​​/ Kiralandı, "..exports.mrp_pool:getServerMoneyType(thePlayer) ..exports.mrp_global:formatMoney(cost)..", "..getPlayerName(player), player)
	--	triggerClientEvent(player, "createBlipAtXY", player, interiorEntrance[INTERIOR_TYPE], interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y])
	else
		outputChatBox("Üzgünüz, bu mülkü satın alamazsınız.", player, 255, 194, 14)
	end
end
addEvent( "buypropertywithtoken", true )
addEventHandler( "buypropertywithtoken", root, buyInteriorToken)

function buyInteriorBank(player, pickup, cost, isHouse, isRentable)
	if not exports.mrp_global:canPlayerBuyInterior(player) then
		outputChatBox("Azami iç mekan sayısına zaten ulaştınız. Maksimum iç mekanınızı F10 -> Premium Özellikler ile genişletebilirsiniz..", player, 255, 0, 0)
		return
	end
	
	
	if isRentable then
		local result = dbPoll(dbQuery(mysql:getConnection(),  "SELECT COUNT(*) as 'cntval' FROM `interiors` WHERE `owner` = " .. getElementData(player, "dbid") .. " AND `type` = 3" ), -1)
		if result then
			local count = tonumber(result['cntval'])
			if count ~= 0 then
				outputChatBox("Zaten başka bir ev kiralıyorsunuz.", player, 255, 0, 0)
				return
			end
		end
	elseif not exports.mrp_global:hasSpaceForItem(player, 4, 1) then
		outputChatBox("Envanterinizde anahtar için yeterli alan yok.", player, 255, 0, 0)
		return
	end

	if not exports.mrp_bank:takeBankMoney(player, cost) then
		outputChatBox( "You lack the money in your bank to buy this property", player, 255, 0, 0 )
	else
		local charid = getElementData(player, "dbid")
		local pickupid = getElementData(pickup, "dbid")
		local gov = getTeamFromName("İstanbul Büyükşehir Belediyesi")
		local intName = getElementData(pickup, "name")
		if (isHouse) then
			outputChatBox("Tebrikler! Az önce bu evi satın aldınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)
			exports.mrp_global:giveMoney( gov, cost )
		elseif (isRentable) then
			outputChatBox("Tebrikler! Az önce bu mülkü kiraladınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)
		else
			outputChatBox("Tebrikler! Az önce bu işyerini satın aldınız "..exports.mrp_pool:getServerMoneyType(thePlayer) .. exports.mrp_global:formatMoney(cost) .. ".", player, 255, 194, 14)
			exports.mrp_global:giveMoney( gov, cost )
		end
		
		--exports.mrp_bank:addBankTransactionLog(charid, -(getElementData(gov, "id")), cost, 2 , "Mülk Satın Alma", intName.." (ID: "..pickupid..")" )
		
		dbExec(mysql:getConnection(), "UPDATE interiors SET owner='" .. charid .. "', locked=0, lastused=NOW() WHERE id='" .. pickupid .. "'") 
		
		local interiorEntrance = getElementData(pickup, "entrance")
		
		call( getResourceFromName( "mrp_items" ), "deleteAll", isHouse and 4 or 5, pickupid )
		exports.mrp_global:giveItem(player, isHouse and 4 or 5, pickupid)

		exports.mrp_logs:dbLog(player, 37, { "in"..tostring(pickupid) } , "BUYPROPERTY $"..cost)
		realReloadInterior(tonumber(pickupid), {player})
		exports["mrp_interior_manager"]:addInteriorLogs(pickupid, "Bought/rented, $"..exports.mrp_global:formatMoney(cost)..", "..getPlayerName(player), player)
		triggerClientEvent(player, "createBlipAtXY", player, interiorEntrance[INTERIOR_TYPE], interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y])
	end
end
addEvent( "buypropertywithbank", true )
addEventHandler( "buypropertywithbank", root, buyInteriorBank)

function enterInterior(  )
	
	if source and client then
		local canEnter, errorCode, errorMsg = canEnterInterior(source)	-- Checks for disabled and locked ints.
		if canEnter then
			setPlayerInsideInterior( source, client )
		elseif isInteriorForSale(source) then
			local interiorStatus = getElementData(source, "status")
			local cost = interiorStatus[INTERIOR_COST]
			local isHouse = interiorStatus[INTERIOR_TYPE] == 0
			local isRentable = interiorStatus[INTERIOR_TYPE] == 3
			local neighborhood = exports.mrp_global:getElementZoneName(source)
			triggerClientEvent(client, "openPropertyGUI", client, source, cost, isHouse, isRentable, neighborhood)
		else
			outputChatBox(errorMsg, client, 255, 0, 0)
		end
	end
	
end
addEvent("interior:enter", true)
addEventHandler("interior:enter", getRootElement(), enterInterior)

addCommandHandler("girisucret",function(plr, cmd, miktar)
	local dbid, entrance, exit, interiorType, interiorElement = findProperty( plr )

	if dbid > 0 then
		local interiorStatus = getElementData(interiorElement, "status")
		if interiorStatus[INTERIOR_OWNER] == getElementData(plr, "dbid") then

			local interiorStatus = getElementData(interiorElement, "status")
			if interiorStatus[1] == 1 then
				
				if not tonumber(miktar) then
					outputChatBox("[!]#ffffff Bir miktar belirleyiniz.",plr,100,100,255,true)
				return end

				if tonumber(miktar) < 0 or tonumber(miktar) > 250 then
					outputChatBox("[!]#ffffff Maksimum giriş ücretini ₺250 yapabilirsiniz.",plr,100,100,255,true)
				return end

				local intdbid = getElementData(interiorElement, "dbid")
				outputChatBox("[!]#ffffff Giriş ücretini ₺"..tonumber(miktar).." olarak ayarladınız.",plr,100,100,255,true)
				dbExec(mysql:getConnection(), "UPDATE interiors SET girispara =" .. miktar .. " WHERE id = " .. (getElementDimension(plr)) )
				realReloadInterior(intdbid)
			else
				outputChatBox("[!]#ffffff Giriş ücreti sadece iş yerleri için geçerlidir.",plr,100,100,255,true)
			end
		else
			outputChatBox("[!]#ffffff Bu mülkün sahibi değilsiniz.",plr,100,100,255,true)
		end
	end
end)

addCommandHandler("kasa",function(plr,cmd,durum, miktar)
	local dbid, entrance, exit, interiorType, interiorElement = findProperty( plr )
	
	if dbid > 0 then
		local interiorStatus = getElementData(interiorElement, "status")
		if interiorStatus[INTERIOR_OWNER] == getElementData(plr, "dbid") then

			local interiorStatus = getElementData(interiorElement, "status")
			if interiorStatus[1] == 1 then

				if not durum then
					outputChatBox("[!]#ffffff "..cmd.." [Durum/Cek].",plr,100,100,255,true)
				return end

				local intdbid = getElementData(interiorElement, "dbid")

				if durum == "durum" then
					local kasadurum = getElementData(interiorElement, "kasa") or 0
					local test = getElementData(interiorElement, "toplamvergi") or 0
					outputChatBox("[!]#ffffff Kasanızdaki para : ₺"..kasadurum.."",plr,100,100,255,true)
				end

				if durum == "cek" then
					if not tonumber(miktar) then
						outputChatBox("[!]#ffffff Bir miktar belirleyiniz.",plr,100,100,255,true)
					return end

					if tonumber(miktar) < 0 then
						outputChatBox("[!]#ffffff Böyle bir değer giremezsiniz.",plr,100,100,255,true)
					return end

					if getElementData(interiorElement, "kasa") < tonumber(miktar) then
						outputChatBox("[!]#ffffff Çekmek istediğin miktar kasanızda yok.",plr,100,100,255,true)
					return end

					dbExec(mysql:getConnection(),"UPDATE interiors SET kasa = kasa - " .. miktar .. " WHERE id = " .. (getElementDimension(plr)) )
					realReloadInterior(intdbid)
					exports.mrp_global:giveMoney(plr, miktar)
					outputChatBox("[!]#ffffff Kasanızdan ₺"..tonumber(miktar).." çektiniz.",plr,100,100,255,true)
				end
			else
				outputChatBox("[!]#ffffff Bu işlem iş yerleri için geçerlidir.",plr,100,100,255,true)
			end
		else
			outputChatBox("[!]#ffffff Bu mülkün sahibi değilsiniz.",plr,100,100,255,true)
		end
	end
end)

local interiorTimer = {}
function setPlayerInsideInterior(theInterior, thePlayer, teleportTo)
local interiorStatus = getElementData(theInterior, "status")

	if interiorTimer[thePlayer] or not theInterior then
		return false
	end
	if interiorTimer[thePlayer] or not theInterior then
		return false
	end
	
	interiorTimer[thePlayer] = true
	local enter = true
	if not teleportTo then
		local pedCurrentDimension = getElementDimension( thePlayer )
		local interiorEntrance = getElementData(theInterior, "entrance")
		local interiorExit = getElementData(theInterior, "exit")
		local interiorStatus = getElementData(theInterior, "status")
		if (interiorEntrance[INTERIOR_DIM] == pedCurrentDimension) then
			teleportTo = interiorExit
			enter = true
		else
			teleportTo = interiorEntrance
			enter = false
		end 
	end

	local girispara = getElementData(theInterior, "girispara") or 0

	if interiorStatus[1] == 1 then

		if getElementDimension(thePlayer) == 0 then

			if not exports.mrp_global:takeMoney(thePlayer, girispara) then
				outputChatBox("[!]#ffffff Bu işyerine giriş yapabilmek için yeterli paranız bulunmuyor.",thePlayer,100,100,255,true)
			return end

			setElementInterior(thePlayer, teleportTo[INTERIOR_INT])
			setElementDimension(thePlayer, teleportTo[INTERIOR_DIM])
			setElementPosition(thePlayer, teleportTo[INTERIOR_X], teleportTo[INTERIOR_Y], teleportTo[INTERIOR_Z], true)	
			local query = dbExec(mysql:getConnection(),"UPDATE interiors SET kasa = kasa + " .. girispara .. " WHERE id = " .. getElementData( theInterior, "dbid" ) )
			setElementData(theInterior, "kasa", getElementData(theInterior, "kasa") + girispara)

		end
	end
	
		doorGoThru(theInterior, thePlayer)

		triggerClientEvent(thePlayer, "setPlayerInsideInterior", theInterior, teleportTo, theInterior, getElementData(theInterior, "furniture_enabled"))
		
			setCameraInterior(thePlayer, teleportTo[INTERIOR_INT])
			setElementInterior(thePlayer, teleportTo[INTERIOR_INT])
			setElementDimension(thePlayer, teleportTo[INTERIOR_DIM])

			if teleportTo[INTERIOR_ANGLE] then
				setPedRotation(thePlayer, teleportTo[INTERIOR_ANGLE])
			end
			if teleportTo[INTERIOR_DIM] == 0 then
				triggerEvent("s_updateClientTime", thePlayer)
				switchGroundSnow(true)
			else
				switchGroundSnow( false )
			end
			setElementPosition(thePlayer, teleportTo[INTERIOR_X], teleportTo[INTERIOR_Y], teleportTo[INTERIOR_Z], true)	
		
		local dbid = getElementData(theInterior, "dbid") 
		dbExec(mysql:getConnection(),"UPDATE `interiors` SET `lastused`=NOW() WHERE `id`='" .. (dbid) .. "'")

		setElementData(theInterior, "lastused", exports.mrp_datetime:now(), true)

		exports.mrp_logs:dbLog("SYSTEM", 31, { theInterior, thePlayer } , enter and "ENTERED" or "EXITED")
		exports["mrp_interior_manager"]:addInteriorLogs(dbid, enter and "Entered" or "Exited", thePlayer)

		return true
end

addEventHandler("onPlayerInteriorChange", root,
	function( a, b, toDimension, toInterior)	
		if toDimension then
			triggerEvent("frames:loadInteriorTextures", source, toDimension) -- Adams
			setElementDimension(source, toDimension)
		end
		if toInterior then
			setElementInterior(source, toInterior)
		end
		local vehicle = getPedOccupiedVehicle( source )
		if not vehicle then

		end
		

		--setElementFrozen(source, false)
		interiorTimer[source] = false
	end
)

-- NOT CONVERTED 
function setPlayerInsideInterior2(theInterior, thePlayer)
	local teleportTo = nil
	-- does the player want to go in?
	local pedCurrentDimension = getElementDimension( thePlayer )
	local interiorEntrance = getElementData(theInterior, "entrance")
	local interiorExit = getElementData(theInterior, "exit")
	local interiorStatus = getElementData(theInterior, "status")
	if (interiorEntrance[INTERIOR_DIM] == pedCurrentDimension) then
		-- We've passed the feecheck, yet we still want to go inside.
		teleportTo = interiorExit
	else
		-- We'd like to leave this building, kthxhopefullybye.
		--[[if (getElementData(thePlayer, "snake")==true) then
			return
		end]] -- Removed old snake cams
		teleportTo = interiorEntrance
	end
	
	if teleportTo then 
		triggerClientEvent(thePlayer, "setPlayerInsideInterior", theInterior, teleportTo, theInterior, getElementData(theInterior, "furniture_enabled"))
		if teleportTo[INTERIOR_DIM] == 0 then
			triggerEvent("s_updateClientTime", thePlayer)
			switchGroundSnow(true)
		else
			switchGroundSnow(true)
		end
		
		setElementInterior(thePlayer, teleportTo[INTERIOR_INT])
		setElementDimension(thePlayer, teleportTo[INTERIOR_DIM])
		
		doorGoThru(theInterior, thePlayer)
		local dbid = getElementData(theInterior, "dbid") 
		dbExec(mysql:getConnection(),"UPDATE `interiors` SET `lastused`=NOW() WHERE `id`='" .. (dbid) .. "'")
		setElementData(theInterior, "lastused", exports.mrp_datetime:now(), true)
		triggerEvent("frames:loadInteriorTextures", thePlayer, dbid) -- Adams
	end
end

--[[ SAFES ]]
function addSafeAtPosition( thePlayer, x, y, z, rotz )
	local dbid = getElementDimension( thePlayer )
	local interior = getElementInterior( thePlayer )
	if dbid == 0 then
		return 2
	elseif dbid >= 20000 then -- Vehicle Interiors
		local vid = dbid - 20000
		if exports['mrp_vehicle']:getSafe( vid ) then
			outputChatBox("Bu mülkte zaten bir kasa var. Taşımak için /movesafe yazın.", thePlayer, 255, 0, 0)
			return 1
		elseif exports.mrp_global:hasItem( thePlayer, 3, vid ) then
			z = z - 0.5
			rotz = rotz + 180
			if dbExec(mysql:getConnection(), "UPDATE vehicles SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. vid .. "'") then
				if exports['mrp_vehicle']:addSafe( vid, x, y, z, rotz, interior ) then
					return 0
				end
			end
			return 1
		end
	elseif dbid >= 19000 then -- temp vehicle interiors
		return 2
	elseif ((exports.mrp_global:hasItem( thePlayer, 5, dbid ) or exports.mrp_global:hasItem( thePlayer, 4, dbid))) then
		if safeTable[dbid] then
			outputChatBox("Bu mülkte zaten bir kasa var. Taşımak için /movesafe yazın.", thePlayer, 255, 0, 0)
			return 1
		else
			z = z - 0.5
			rotz = rotz + 180
			dbExec(mysql:getConnection(), "UPDATE interiors SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. dbid .. "'")
			local tempobject = createObject(2332, x, y, z, 0, 0, rotz)
			setElementInterior(tempobject, interior)
			setElementDimension(tempobject, dbid)
			safeTable[dbid] = tempobject
			call( getResourceFromName( "item-system" ), "clearItems", tempobject )
			return 0
		end
	end
	return 3
end
function moveSafe ( thePlayer, commandName )
	local x,y,z = getElementPosition( thePlayer )
	local rotz = getPedRotation( thePlayer )
	local dbid = getElementDimension( thePlayer )
	local interior = getElementInterior( thePlayer )
	if (dbid < 19000 and (exports.mrp_global:hasItem( thePlayer, 5, dbid ) or exports.mrp_global:hasItem( thePlayer, 4, dbid))) or (dbid >= 20000 and exports.mrp_global:hasItem(thePlayer, 3, dbid - 20000)) then
		z = z - 0.5
		rotz = rotz + 180
		if dbid >= 20000 and exports['mrp_vehicle']:getSafe(dbid-20000) then
			local safe = exports['mrp_vehicle']:getSafe(dbid-20000)
			dbExec(mysql:getConnection(),"UPDATE vehicles SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. (dbid-20000) .. "'")
			setElementPosition(safe, x, y, z)
			setObjectRotation(safe, 0, 0, rotz)
		elseif dbid > 0 and safeTable[dbid] then
			local safe = safeTable[dbid]
			dbExec(mysql:getConnection(),"UPDATE interiors SET safepositionX='" .. x .. "', safepositionY='" .. y .. "', safepositionZ='" .. z .. "', safepositionRZ='" .. rotz .. "' WHERE id='" .. dbid .. "'") -- Update the name in the sql.
			setElementPosition(safe, x, y, z)
			setObjectRotation(safe, 0, 0, rotz)
		else
			outputChatBox("Bunu yapabilmek için kasaya sahip olmalısın!", thePlayer, 255, 0, 0)
		end
	else
		outputChatBox("Kasayı taşımak için bu mülk anahtarlarına ihtiyacınız var.", thePlayer, 255, 0, 0)
	end
end

addCommandHandler("movesafe", moveSafe)


local function hasKey( source, key )
	if exports.mrp_global:hasItem(source, 4, key) or exports.mrp_global:hasItem(source, 5,key) then
		return true, false
	else
		if getElementData(source, "duty_admin") == 1 then
			return true, true
		else
			return false, false
		end
	end
	return false, false
end


function lockUnlockHouseEvent(player, checkdistance)
	if (player) then
		source = player
	end
	local itemValue = nil
	local found = nil
	local foundpoint = nil
	local minDistance = 5
	local interiorName = ""
	local pPosX, pPosY, pPosZ = getElementPosition(source)
	local dimension = getElementDimension(source)
	
	local canEnter, byAdmin = nil
	
	local possibleInteriors = exports.mrp_pool:getPoolElementsByType("interior")
	for _, interior in ipairs(possibleInteriors) do
		local interiorEntrance = getElementData(interior, "entrance")
		local interiorExit = getElementData(interior, "exit")
		for _, point in ipairs( { interiorEntrance, interiorExit } ) do
			if (point[INTERIOR_DIM] == dimension) then
				local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z]) or 20
				if (distance < minDistance) then
					local interiorID = getElementData(interior, "dbid")
					canEnter, byAdmin = hasKey(source, interiorID)
					if canEnter then -- house found
						found = interior
						foundpoint = point
						itemValue = interiorID
						minDistance = distance
						interiorName = getElementData(interior, "name")
					end
				end
			end
		end
	end

	-- For elevators already
	local possibleElevators = exports.mrp_pool:getPoolElementsByType("elevator")
	for _, elevator in ipairs(possibleElevators) do
		local elevatorEntrance = getElementData(elevator, "entrance")
		local elevatorExit = getElementData(elevator, "exit")
		
		for _, point in ipairs( { elevatorEntrance, elevatorExit } ) do
			if (point[INTERIOR_DIM] == dimension) then
				local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z])
				if (distance < minDistance) then
					if hasKey(source, elevatorEntrance[INTERIOR_DIM]) and elevatorEntrance[INTERIOR_DIM] ~= 0 then
						found = elevator
						foundpoint = point
						itemValue = elevatorEntrance[INTERIOR_DIM]
						minDistance = distance
					elseif hasKey(source, elevatorExit[INTERIOR_DIM]) and elevatorExit[INTERIOR_DIM] ~= 0  then
						found = elevator
						foundpoint = point
						itemValue = elevatorExit[INTERIOR_DIM]
						minDistance = distance
					end
				end
			end
		end
	end
	
	if (checkdistance) then
		return found, minDistance
	end
	if found and itemValue then
		local dbid, entrance, exit, interiorType, interiorElement = findProperty( source, itemValue )
		if getElementData(interiorElement, "keypad_lock") then
			if not (exports.mrp_integration:isPlayerTrialAdmin(source) and getElementData(source, "duty_admin") == 1) then
				exports.mrp_hud:sendBottomNotification(source, "Keyless Digital Door Lock", "This door is keyless, you must use the keypad to access it.")
				return false
			end
		end


		local interiorStatus = getElementData(interiorElement, "status")
		local locked = interiorStatus[INTERIOR_LOCKED] and 1 or 0

		locked = 1 - locked -- Invert status
		
		
		local newRealLockedValue = false
		dbExec(mysql:getConnection(),"UPDATE interiors SET locked='" .. (locked) .. "'  WHERE id='" .. (itemValue) .. "' LIMIT 1") 
		if locked == 0 then
			doorUnlockSound(interiorElement, source)
			if byAdmin then
				if getElementData(source, "hiddenadmin") == 0 then
					local adminTitle = exports.mrp_global:getPlayerAdminTitle(source)
					local adminUsername = getElementData(source, "account:username")
					exports.mrp_global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(source):gsub("_", " ").. " ("..adminUsername..") has unlocked Interior ID #"..itemValue.." without key.")
					exports.mrp_global:sendLocalText(source, " * Kapı şuan kilidi açık *", 255, 51, 102, 30, {}, true)
					exports["mrp_interior_manager"]:addInteriorLogs(itemValue, "unlock without key", source)
				end
			else
				exports.mrp_global:sendLocalMeAction(source, " kilidi açmak için anahtarı kapıya koyar.")
			end
			exports.mrp_logs:dbLog(source, 31, {  "in"..tostring(itemValue) }, "UNLOCK INTERIOR")
		else --shit
			doorLockSound(interiorElement, source)
			newRealLockedValue = true
			if byAdmin then
				if getElementData(source, "hiddenadmin") == 0 then
					local adminTitle = exports.mrp_global:getPlayerAdminTitle(source)
					local adminUsername = getElementData(source, "account:username")
					exports.mrp_global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(source):gsub("_", " ").. " ("..adminUsername..") has locked Interior ID #"..itemValue.." without key.")
					exports.mrp_global:sendLocalText(source, " * Kapı şuan kilitli *", 255, 51, 102, 30, {}, true)
					exports["mrp_interior_manager"]:addInteriorLogs(itemValue, "lock without key", source)
				end
			else 
				exports.mrp_global:sendLocalMeAction(source, " kilitlemek için anahtarı kapıya yerleştirir.")
			end
			exports.mrp_logs:dbLog(source, 31, {  "in"..tostring(itemValue) }, "LOCK INTERIOR")
		end
		
		interiorStatus[INTERIOR_LOCKED] = newRealLockedValue
		exports.mrp_anticheat:changeProtectedElementDataEx(interiorElement, "status", interiorStatus, true)	
	else
		cancelEvent( )
	end
end
addEvent( "lockUnlockHouse",false )
addEventHandler( "lockUnlockHouse", getRootElement(), lockUnlockHouseEvent)

function doorUnlockSound(house, source)
	if (house) then
		if (getElementType(house) == "interior") then
			local interiorEntrance = getElementData(house, "entrance")
			local interiorExit = getElementData(house, "exit")
				
			for index, nearbyPlayer in ipairs(exports.mrp_pool:getPoolElementsByType("player")) do
				if isElement(nearbyPlayer) and getElementData(nearbyPlayer, "loggedin") == 1 then
					for k, v in ipairs({{interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y], interiorEntrance[INTERIOR_Z], interiorEntrance[INTERIOR_DIM]}, {interiorExit[INTERIOR_X], interiorExit[INTERIOR_Y], interiorExit[INTERIOR_Z], interiorExit[INTERIOR_DIM]}}) do
						if getDistanceBetweenPoints3D(v[1], v[2], v[3], getElementPosition(nearbyPlayer)) < 20 and getElementDimension(nearbyPlayer) == v[4] then
							triggerClientEvent(nearbyPlayer, "doorUnlockSound", source, v[1], v[2], v[3])
						end
					end
				end
			end
		else -- It would be 0
			local found = nil
			local minDistance = 20
			local pPosX, pPosY, pPosZ = getElementPosition(source)
			local dimension = getElementDimension(source)

			local possibleInteriors = exports.mrp_pool:getPoolElementsByType("interior")
			for _, interior in ipairs(possibleInteriors) do
				local interiorEntrance = getElementData(interior, "entrance")
				local interiorExit = getElementData(interior, "exit")
				for _, point in ipairs( { interiorEntrance, interiorExit } ) do
					if (point[INTERIOR_DIM] == dimension) then
						local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z]) or 20
						if (distance < minDistance) then
							found = interior
							minDistance = distance
						end
					end
				end
			end
		end	
		if found then				
			triggerEvent("doorUnlockSound", source, found)
		end
	end
end

function doorLockSound(house, source)
	if (house) then
		if (getElementType(house) == "interior") then
			local interiorEntrance = getElementData(house, "entrance")
			local interiorExit = getElementData(house, "exit")
				
			for index, nearbyPlayer in ipairs(exports.mrp_pool:getPoolElementsByType("player")) do
				if isElement(nearbyPlayer) and getElementData(nearbyPlayer, "loggedin") == 1 then
					for k, v in ipairs({{interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y], interiorEntrance[INTERIOR_Z], interiorEntrance[INTERIOR_DIM]}, {interiorExit[INTERIOR_X], interiorExit[INTERIOR_Y], interiorExit[INTERIOR_Z], interiorExit[INTERIOR_DIM]}}) do
						if getDistanceBetweenPoints3D(v[1], v[2], v[3], getElementPosition(nearbyPlayer)) < 20 and getElementDimension(nearbyPlayer) == v[4] then
							triggerClientEvent(nearbyPlayer, "doorLockSound", source, v[1], v[2], v[3])
						end
					end
				end
			end
		else -- It would be 0
			local found = nil
			local minDistance = 20
			local pPosX, pPosY, pPosZ = getElementPosition(source)
			local dimension = getElementDimension(source)

			local possibleInteriors = exports.mrp_pool:getPoolElementsByType("interior")
			for _, interior in ipairs(possibleInteriors) do
				local interiorEntrance = getElementData(interior, "entrance")
				local interiorExit = getElementData(interior, "exit")
				for _, point in ipairs( { interiorEntrance, interiorExit } ) do
					if (point[INTERIOR_DIM] == dimension) then
						local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z]) or 20
						if (distance < minDistance) then
							found = interior
							minDistance = distance
						end
					end
				end
			end
		end	
		if found then				
			triggerEvent("doorLockSound", source, found)
		end
	end
end

function doorGoThru(house, source)
	if (house) then
		if (getElementType(house) == "interior") then
			local interiorEntrance = getElementData(house, "entrance")
			local interiorExit = getElementData(house, "exit")
				
			for index, nearbyPlayer in ipairs(exports.mrp_pool:getPoolElementsByType("player")) do
				if isElement(nearbyPlayer) and getElementData(nearbyPlayer, "loggedin") == 1 then
					for k, v in ipairs({{interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y], interiorEntrance[INTERIOR_Z], interiorEntrance[INTERIOR_DIM]}, {interiorExit[INTERIOR_X], interiorExit[INTERIOR_Y], interiorExit[INTERIOR_Z], interiorExit[INTERIOR_DIM]}}) do
						if getDistanceBetweenPoints3D(v[1], v[2], v[3], getElementPosition(nearbyPlayer)) < 20 and getElementDimension(nearbyPlayer) == v[4] then
							triggerClientEvent(nearbyPlayer, "doorGoThru", source, v[1], v[2], v[3])
						end
					end
				end
			end
		else -- It would be 0
			local found = nil
			local minDistance = 20
			local pPosX, pPosY, pPosZ = getElementPosition(source)
			local dimension = getElementDimension(source)

			local possibleInteriors = exports.mrp_pool:getPoolElementsByType("interior")
			for _, interior in ipairs(possibleInteriors) do
				local interiorEntrance = getElementData(interior, "entrance")
				local interiorExit = getElementData(interior, "exit")
				for _, point in ipairs( { interiorEntrance, interiorExit } ) do
					if (point[INTERIOR_DIM] == dimension) then
						local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z]) or 20
						if (distance < minDistance) then
							found = interior
							minDistance = distance
						end
					end
				end
			end
		end	
		if found then				
			triggerEvent("doorGoThru", source, found)
		end
	end
end

addEvent( "lockUnlockHouseID",true )
addEventHandler( "lockUnlockHouseID", getRootElement(),
	function( id, usingKeypad )
		local hasKey1, byAdmin = hasKey(source, id)
		if id and tonumber(id) and (hasKey1 or usingKeypad) then
			local result = dbPoll(dbQuery(mysql:getConnection(),  "SELECT 1-locked as 'val' FROM interiors WHERE id = " .. id), -1)
			local locked = 0
			if result then
				locked = tonumber( result["val"] )
			end
			local newRealLockedValue = false
			dbExec(mysql:getConnection(),"UPDATE interiors SET locked='" .. locked .. "' WHERE id='" .. id .. "' LIMIT 1")

			if not usingKeypad then
				local dbid, entrance, exit, interiorType, interiorElement = findProperty( source, id )
				--outputDebugString(getElementData(interiorElement, "keypad_lock"))
				if getElementData(interiorElement, "keypad_lock") then
					if not (exports.mrp_integration:isPlayerTrialAdmin(source) and getElementData(source, "duty_admin") == 1) then
						exports.mrp_hud:sendBottomNotification(source, "Keyless Digital Door Lock", "This door is keyless, you must use the keypad to access it.")
						return false
					end
				end

				if locked == 0 then
					if byAdmin then
						if getElementData(source, "hiddenadmin") == 0 then
							local adminTitle = exports.mrp_global:getPlayerAdminTitle(source)
							local adminUsername = getElementData(source, "account:username")
							exports.mrp_global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(source):gsub("_", " ").. " ("..adminUsername..") has unlocked Interior ID #"..id.." without key.")
							exports.mrp_global:sendLocalText(source, " * Kapı kilidi şuan açık *", 255, 51, 102, 30, {}, true)
							exports["mrp_interior_manager"]:addInteriorLogs(id, "unlock without key", source)
						end
					else
						exports.mrp_global:sendLocalMeAction(source, " kilidi açmak için anahtarı kapıya koyar")
					end
					exports.mrp_logs:dbLog(source, 31, {  "in"..tostring(id) }, "UNLOCK INTERIOR")
				else
					newRealLockedValue = true
					if byAdmin then
						if getElementData(source, "hiddenadmin") == 0 then
							local adminTitle = exports.mrp_global:getPlayerAdminTitle(source)
							local adminUsername = getElementData(source, "account:username")
							exports.mrp_global:sendMessageToAdmins("[INTERIOR]: "..adminTitle.." ".. getPlayerName(source):gsub("_", " ").. " ("..adminUsername..") has locked Interior ID #"..id.." without key.")
							exports.mrp_global:sendLocalText(source, " * Kapı şuan kilitli *", 255, 51, 102, 30, {}, true)
							exports["mrp_interior_manager"]:addInteriorLogs(id, "lock without key", source)
						end
					else
						exports.mrp_global:sendLocalMeAction(source, " kilitlemek için anahtarı kapıya yerleştirir.")
					end
					exports.mrp_logs:dbLog(source, 31, {  "in"..tostring(id) }, "LOCK INTERIOR")
				end

				if interiorElement then
					local interiorStatus = getElementData(interiorElement, "status")
					interiorStatus[INTERIOR_LOCKED] = newRealLockedValue
					exports.mrp_anticheat:changeProtectedElementDataEx(interiorElement, "status", interiorStatus, true)
				end
			else
				if locked == 0 then
					exports.mrp_global:sendLocalMeAction(source, "kapının kilidini açar.")
					exports.mrp_logs:dbLog(source, 31, {  "in"..tostring(id) }, "UNLOCK INTERIOR")
				else
					newRealLockedValue = true
					exports.mrp_global:sendLocalMeAction(source, "kapıyı kilitler.")
					exports.mrp_logs:dbLog(source, 31, {  "in"..tostring(id) }, "LOCK INTERIOR")
				end

				local dbid, entrance, exit, interiorType, interiorElement = findProperty( source, id )
				if interiorElement then
					local interiorStatus = getElementData(interiorElement, "status")
					interiorStatus[INTERIOR_LOCKED] = newRealLockedValue
					exports.mrp_anticheat:changeProtectedElementDataEx(interiorElement, "status", interiorStatus, true)
					if newRealLockedValue then
						doorLockSound(interiorElement, source)
					else
						doorUnlockSound(interiorElement, source)
					end
				end
				triggerClientEvent(source, "keypadRecieveResponseFromServer", source, locked == 0 and "unlocked" or "locked", false)
			end
		else
			cancelEvent( )
		end
	end
)


function findParent( element, dimension )
	local dbid, entrance, exit, type, interiorElement = findProperty( element, dimension )
	return interiorElement
end


function playerKnocking(house)
	if (house) then
		if isElement(house) and (getElementType(house) == "interior") then
			local interiorEntrance = getElementData(house, "entrance")
			local interiorExit = getElementData(house, "exit")
				
			for index, nearbyPlayer in ipairs(exports.mrp_pool:getPoolElementsByType("player")) do
				if isElement(nearbyPlayer) and getElementData(nearbyPlayer, "loggedin") == 1 then
					for k, v in ipairs({{interiorEntrance[INTERIOR_X], interiorEntrance[INTERIOR_Y], interiorEntrance[INTERIOR_Z], interiorEntrance[INTERIOR_DIM]}, {interiorExit[INTERIOR_X], interiorExit[INTERIOR_Y], interiorExit[INTERIOR_Z], interiorExit[INTERIOR_DIM]}}) do
						if getDistanceBetweenPoints3D(v[1], v[2], v[3], getElementPosition(nearbyPlayer)) < 20 and getElementDimension(nearbyPlayer) == v[4] then
							triggerClientEvent(nearbyPlayer, "playerKnock", source, v[1], v[2], v[3])
						end
					end
				end
			end
		else -- It would be 0
			local found = nil
			local minDistance = 20
			local pPosX, pPosY, pPosZ = getElementPosition(source)
			local dimension = getElementDimension(source)

			local possibleInteriors = exports.mrp_pool:getPoolElementsByType("interior")
			for _, interior in ipairs(possibleInteriors) do
				local interiorEntrance = getElementData(interior, "entrance")
				local interiorExit = getElementData(interior, "exit")
				for _, point in ipairs( { interiorEntrance, interiorExit } ) do
					if (point[INTERIOR_DIM] == dimension) then
						local distance = getDistanceBetweenPoints3D(pPosX, pPosY, pPosZ, point[INTERIOR_X], point[INTERIOR_Y], point[INTERIOR_Z]) or 20
						if (distance < minDistance) then
							found = interior
							minDistance = distance
						end
					end
				end
			end
		end	
		if found then				
			triggerEvent("onKnocking", source, found)
		end
	end
end
addEvent("onKnocking", true)
addEventHandler("onKnocking", getRootElement(), playerKnocking)

function client_requestHUDinfo()
	-- Client = client
	-- Source = interior element
	if not isElement(source) or (getElementType(source) ~= "interior" and getElementType(source) ~= "elevator") then
		return false
	end
	
	local theVehicle = getPedOccupiedVehicle(client)
	if theVehicle and (getVehicleOccupant ( theVehicle, 0 ) ~= client) then
		return false
	end  
	
	exports.mrp_anticheat:changeProtectedElementDataEx( client, "interiormarker", true, false, false )
	
	local interiorID, interiorName, interiorStatus, interiorEntrance, interiorExit = nil
	if getElementType(source) == "elevator" then
		local playerDimension = getElementDimension(client)
		local elevatorEntranceDimension = getElementData(source, "entrance")[INTERIOR_DIM]
		local elevatorExitDimension = getElementData(source, "exit")[INTERIOR_DIM]
		if playerDimension ~= elevatorEntranceDimension and elevatorEntranceDimension ~= 0 then
			local dbid, entrance, exit, type, interiorElement = findProperty( client, elevatorEntranceDimension )
			if dbid and interiorElement then
				interiorID = getElementData(interiorElement, "dbid")
				interiorName = getElementData(interiorElement,"name")
				interiorStatus = getElementData(interiorElement, "status")
				interiorEntrance = getElementData(interiorElement, "entrance")
				interiorExit = getElementData(interiorElement, "exit")
			end
		elseif elevatorExitDimension ~= 0 then
			local dbid, entrance, exit, type, interiorElement = findProperty( client, elevatorExitDimension )
			if dbid and interiorElement then
				interiorID = getElementData(interiorElement, "dbid")
				interiorName = getElementData(interiorElement,"name")
				interiorStatus = getElementData(interiorElement, "status")
				interiorEntrance = getElementData(interiorElement, "entrance")
				interiorExit = getElementData(interiorElement, "exit")
			end
		end
		if not dbid then
			interiorID = -1
			interiorName = "None"
			interiorStatus = { }
			interiorEntrance = { }
			interiorStatus[INTERIOR_TYPE] = 2
			interiorStatus[INTERIOR_COST] = 0
			interiorStatus[INTERIOR_OWNER] = -1
			interiorEntrance[INTERIOR_FEE] = 0
		end
	else
		interiorName = getElementData(source,"name")
		interiorStatus = getElementData(source, "status")
		interiorEntrance = getElementData(source, "entrance")
		interiorExit = getElementData(source, "exit")
	end
	
	local interiorOwnerName = exports['mrp_cache']:getCharacterName(interiorStatus[INTERIOR_OWNER]) or "None"
	local interiorType = interiorStatus[INTERIOR_TYPE] or 2
	local interiorCost = interiorStatus[INTERIOR_COST] or 0
	local interiorBizNote = getElementData(source, "business:note") or false
	
	triggerClientEvent(client, "displayInteriorName", source, interiorName or "Elevator", interiorOwnerName, interiorType or 2, interiorCost or 0, interiorID or -1, interiorBizNote)
	--INTERIOR PREVIEW / MAXIME
	--[[
	if interiorName == "None" and (interiorType == 3 or interiorType <2) then -- IF FOR SALE INT
		setElementData(client, "official-interiors:showIntPreviewer", true, true)
		setElementData(client, "official-interiors:showIntPreviewer:ForSale", true, true)
	end
	]]
end
addEvent("interior:requestHUD", true)
addEventHandler("interior:requestHUD", getRootElement(), client_requestHUDinfo)

addEvent("int:updatemarker", true)
addEventHandler("int:updatemarker", getRootElement(), 
	function( newState )
		exports.mrp_anticheat:changeProtectedElementDataEx(client, "interiormarker", newState, false, true) -- No sync at all: function is only called from client thusfar has the actual state itself
	end
)

viewingTimer = nil
function timedInteriorView( thePlayer, houseID )
	local dbid, entrance, exit, type, interiorElement = findProperty( thePlayer, houseID )
	if entrance then

		if isTimer ( viewingTimer ) then
			killTimer( viewingTimer )
		end
		triggerClientEvent(thePlayer, "setPlayerInsideInterior2", interiorElement, exit, interiorElement, getElementData(interiorElement, "furniture_enabled"))			
		outputChatBox( "Şimdi bu mülkü görüntülüyorsunuz. Herhangi bir öğeyi bırakamazsınız. İçeriden çıkarak izlemenizden çıkabilir veya 60 saniyelik zamanlayıcıyı bekleyebilirsiniz..", thePlayer, 0, 255, 0 )
		setElementData( thePlayer, "viewingInterior", 1, true )
		viewingTimer = setTimer( function()
					endTimedInteriorView( thePlayer, houseID )
		end, 60000, 1 )
	else
		outputChatBox( "Invalid House.", thePlayer, 255, 0, 0 )
	end
end
addEvent("viewPropertyInterior", true)
addEventHandler("viewPropertyInterior", getRootElement(), timedInteriorView)

addEventHandler("accounts:characters:change", root,
	function()
		if (viewingTimer and viewingTimer[client]) and isTimer(viewingTimer[client]) then
			killTimer(viewingTimer[client])
		end
	end
)

function endTimedInteriorView( thePlayer, houseID )
	local dbid, entrance, exit, type, interiorElement = findProperty( thePlayer, houseID )
	if entrance then
		triggerClientEvent(thePlayer, "setPlayerInsideInterior2", interiorElement, entrance, interiorElement, getElementData(interiorElement, "furniture_enabled"))			
		outputChatBox( "Zamanlı izlemeniz sona erdi.", thePlayer, 0, 255, 0 )
		setElementData( thePlayer, "viewingInterior", 0, true )

		if isTimer ( viewingTimer ) then
			killTimer( viewingTimer )
		end
		viewingTimer = nil
	else
		outputChatBox( "Geçersiz Ev.", thePlayer, 255, 0, 0 )
	end
end
addEvent("endViewPropertyInterior", true)
addEventHandler("endViewPropertyInterior", getRootElement(), endTimedInteriorView)