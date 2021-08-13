function routeHotlineCall(callingElement, callingPhoneNumber, outboundPhoneNumber, startingCall, message)
local callprogress = getElementData(callingElement, "callprogress")	
	if callingPhoneNumber == 155 then
		if startingCall then
			outputChatBox("[!] #90a3b6EGM Operator [Telefon]: EGM Hattı, konumunuzu belirtin.", callingElement, 0, 125, 250, true)
			exports.mrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports.mrp_anticheat:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports.mrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("[!] #90a3b6EGM Operatorü [Telefon]: Evet, size nasıl yardımcı olabilirim?", callingElement, 0, 125, 250, true)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("[!] #90a3b6EGM Operatorü [Telefon]: Aradığınız için teşekkürler, bir birimi yönlendiriyoruz.", callingElement, 0, 125, 250, true)
				local location = getElementData(callingElement, "call.location")
				local affectedElements = { }
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "İstanbul Emniyet Müdürlüğü" ) ) ) do
					for _, itemRow in ipairs(exports['mrp_items']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for _, player in ipairs(getPlayersInTeam(getTeamFromName("İstanbul Emniyet Müdürlüğü"))) do
					outputChatBox("[TELSIZ] Arayan kişinin numarası " .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'.", player, 0, 125, 255)
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 112 then
		if startingCall then
			outputChatBox("[!] #90a3b6İMS Operator [Telefon]: İMS Hattı, konumunuzu belirtin.", callingElement, 0, 125, 250, true)
			exports.mrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports.mrp_anticheat:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports.mrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("[!] #90a3b6İMS Operatorü [Telefon]: Evet, size nasıl yardımcı olabilirim?", callingElement, 0, 125, 250, true)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("[!] #90a3b6İMS Operatorü [Telefon]: Aradığınız için teşekkürler, bir birimi yönlendiriyoruz.", callingElement, 0, 125, 250, true)
				local location = getElementData(callingElement, "call.location")
				local affectedElements = { }
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "İstanbul Devlet Hastanesi" ) ) ) do
					for _, itemRow in ipairs(exports['mrp_items']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for _, player in ipairs(getPlayersInTeam(getTeamFromName("İstanbul Devlet Hastanesi"))) do
					outputChatBox("[TELSIZ] Arayan kişinin numarası " .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'.", player, 0, 125, 255)
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	elseif callingPhoneNumber == 156 then
		if startingCall then
			outputChatBox("[!] #90a3b6Jandarma Operator [Telefon]: Jandarma Hattı, konumunuzu belirtin.", callingElement, 0, 125, 250, true)
			exports.mrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 1, false)
		else
			if (callprogress==1) then -- Requesting the location
				exports.mrp_anticheat:changeProtectedElementDataEx(callingElement, "call.location", message, false)
				exports.mrp_anticheat:changeProtectedElementDataEx(callingElement, "callprogress", 2, false)
				outputChatBox("[!] #90a3b6Jandarma Operatorü [Telefon]: Evet, size nasıl yardımcı olabilirim?", callingElement, 0, 125, 250, true)
			elseif (callprogress==2) then -- Requesting the situation
				outputChatBox("[!] #90a3b6Jandarma Operatorü [Telefon]: Aradığınız için teşekkürler, bir birimi yönlendiriyoruz.", callingElement, 0, 125, 250, true)
				local location = getElementData(callingElement, "call.location")
				local affectedElements = { }
				for key, value in ipairs( getPlayersInTeam( getTeamFromName( "İstanbul Devlet Hastanesi" ) ) ) do
					for _, itemRow in ipairs(exports['mrp_items']:getItems(value)) do
						local setIn = false
						if (not setIn) and (itemRow[1] == 6 and itemRow[2] > 0) then
							
							table.insert(affectedElements, value)
							setIn = true
							break
						end
					end
				end

				for _, player in ipairs(getPlayersInTeam(getTeamFromName("İstanbul İl Jandarma Komutanlığı"))) do
					outputChatBox("[TELSIZ] Arayan kişinin numarası " .. outboundPhoneNumber .. " departmana iletilmiştir.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Açıklama: '" .. message .. "'.", player, 0, 125, 255)
					outputChatBox("[TELSIZ] Lokasyon: '" .. tostring(location) .. "'.", player, 0, 125, 255)
				end
				triggerEvent("phone:cancelPhoneCall", callingElement)
			end
		end
	end
end

function log911( message )
	local logMeBuffer = getElementData(getRootElement(), "911log") or { }
	local r = getRealTime()
	table.insert(logMeBuffer,"["..("%02d:%02d"):format(r.hour,r.minute).. "] " ..  message)
	
	if #logMeBuffer > 30 then
		table.remove(logMeBuffer, 1)
	end
	setElementData(getRootElement(), "911log", logMeBuffer)
end

function read911Log(thePlayer)
	local theTeam = getPlayerTeam(thePlayer)
	local factiontype = getElementData(theTeam, "type")
	if exports.mrp_integration:isPlayerTrialAdmin(thePlayer) or exports.mrp_integration:isPlayerSupporter(thePlayer) then
		local logMeBuffer = getElementData(getRootElement(), "911log") or { }
		outputChatBox("Recent 911 calls:", thePlayer)
		for a, b in ipairs(logMeBuffer) do
			outputChatBox("- "..b, thePlayer)
		end
		outputChatBox("  END", thePlayer)
	end
end
addCommandHandler("show911", read911Log)

function checkService(callingElement)
	t = { "both",
		  "pd",
		  "police",
		  "lspd",
		  "sahp",
		  "sasd", -- PD ends here
		  "es",
		  "medic",
		  "ems",
		  "lsfd",
	}
	local found = false
	for row, names in ipairs(t) do
		if names == string.lower(getElementData(callingElement, "call.service")) then
			if row == 1 then
				local found = true
				return 1 -- Both!
			elseif row >= 2 and row <= 6 then
				local found = true
				return 2 -- Just the PD please
			elseif row >= 7 and row <= 10 then
				local found = true
				return 3 -- ES
			end
		end
	end
	if not found then
		return 4 -- Not found!
	end
end
