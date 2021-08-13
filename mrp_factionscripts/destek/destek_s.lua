-- //bekiroj

function getZoneNameEx(x, y, z)
	local zone = getZoneName(x, y, z)
	if zone == 'East Beach' then
		return 'Bayrampaşa'
	elseif zone == 'Ganton' then
		return 'Bağcılar'
	elseif zone == 'East Los Santos' then
		return 'Bayrampaşa'
	elseif zone == 'Las Colinas' then
		return 'Çatalca'
	elseif zone == 'Jefferson' then
		return 'Esenler'
	elseif zone == 'Glen Park' then
		return 'Esenler'
	elseif zone == 'Downtown Los Santos' then
		return 'Kağıthane'
	elseif zone == 'Commerce' then
		return 'Beyoğlu'
	elseif zone == 'Market' then
		return 'Mecidiyeköy'
	elseif zone == 'Temple' then
		return '4. Levent'
	elseif zone == 'Vinewood' then
		return 'Kemerburgaz'
	elseif zone == 'Richman' then
		return '4. Levent'
	elseif zone == 'Rodeo' then
		return 'Sarıyer'
	elseif zone == 'Mulholland' then
		return 'Kemerburgaz'
	elseif zone == 'Red County' then
		return 'Kemerburgaz'
	elseif zone == 'Mulholland Intersection' then
		return 'Kemerburgaz'
	elseif zone == 'Los Flores' then
		return 'Sancak Tepe'
	elseif zone == 'Willowfield' then
		return 'Zeytinburnu'
	elseif zone == 'Playa del Seville' then
		return 'Zeytinburnu'
	elseif zone == 'Ocean Docks' then
		return 'İkitelli'
	elseif zone == 'Los Santos' then
		return 'İstanbul'
	elseif zone == 'Los Santos International' then
		return 'Atatürk Havalimanı'
	elseif zone == 'Jefferson' then
		return 'Esenler'
	elseif zone == 'Verdant Bluffs' then
		return 'Rümeli Hisarı'
	elseif zone == 'Verona Beach' then
		return 'Ataköy'
	elseif zone == 'Santa Maria Beach' then
		return 'Florya'
	elseif zone == 'Marina' then
		return 'Bakırköy'
	elseif zone == 'Idlewood' then
		return 'Güngören'
	elseif zone == 'El Corona' then
		return 'Küçükçekmece'
	elseif zone == 'Unity Station' then
		return 'Merter'
	elseif zone == 'Little Mexico' then
		return 'Taksim'
	elseif zone == 'Pershing Square' then
		return 'Taksim'
	elseif zone == 'Las Venturas' then
		return 'Edirne'
	else
		return zone
	end
end

function destek(thePlayer, cmd, ...)
	if getElementData(thePlayer, "loggedin") == 1 then
		if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 78 then
			
			if not getElementData(thePlayer, "destekacik") then
				if not tonumber((...)) then
					outputChatBox("İşlem: /destek [Tür]", thePlayer, 255, 194, 14)
				return end
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local tur = table.concat({...}, " ")
				local username = getPlayerName(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local playerX, playerY, playerZ = getElementPosition(thePlayer)
				local playerZoneName = getZoneNameEx(playerX, playerY, playerZ)
				
				exports.mrp_global:sendLocalMeAction(thePlayer, "Telsizinin tuşuna basarak destek istediğini belirtir.")
				setElementData(thePlayer, "destekacik", true)
				setElementData(thePlayer, "destek_tur", tonumber(tur))
				
				for k, pdplayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul Emniyet Müdürlüğü"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 155) " .. username:gsub("_", " ") .. " destek istediğini belirtti, yönelmeniz bekleniyor. ("..tur..")", pdplayer, 0,0,0,true)
				end

				for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul İl Jandarma Komutanlığı"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 155) " .. username:gsub("_", " ") .. " destek istediğini belirtti, yönelmeniz bekleniyor. ("..tur..")", lscsdplayer, 0,0,0,true)
				end
			else
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local tur = table.concat({...}, " ")
				local username = getPlayerName(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local playerX, playerY, playerZ = getElementPosition(thePlayer)
				local playerZoneName = getZoneName(playerX, playerY, playerZ)
				
				setElementData(thePlayer, "destekacik", false)
				
				for k, pdplayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul Emniyet Müdürlüğü"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 155) " .. username:gsub("_", " ") .. " destek çağrısını kaldırdı.", pdplayer, 0,0,0,true)
				end

				for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul İl Jandarma Komutanlığı"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 155) " .. username:gsub("_", " ") .. " destek çağrısını kaldırdı.", lscsdplayer, 0,0,0,true)
				end
			end
		end
	end
end
addCommandHandler("destek", destek)

function takip(thePlayer, cmd)
	if getElementData(thePlayer, "loggedin") == 1 then
		if getElementData(thePlayer, "faction") == 1 or getElementData(thePlayer, "faction") == 78 then
			
			if not getElementData(thePlayer, "takipacik") then
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local username = getPlayerName(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local playerX, playerY, playerZ = getElementPosition(thePlayer)
				local playerZoneName = getZoneName(playerX, playerY, playerZ)
				
				exports.mrp_global:sendLocalMeAction(thePlayer, "Telsizinin tuşuna basarak destek istediğini belirtir.")

				setElementData(thePlayer, "takipacik", true)
				
				for k, pdplayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul Emniyet Müdürlüğü"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 155) " .. username:gsub("_", " ") .. " takip ettiğini belirtti.", pdplayer, 0,0,0,true)
				end

				for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul İl Jandarma Komutanlığı"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 155) " .. username:gsub("_", " ") .. " takip ettiğini belirtti.", lscsdplayer, 0,0,0,true)
				end
			else
				local theTeam = getPlayerTeam(thePlayer)
				local factionRank = tonumber(getElementData(thePlayer,"factionrank"))
				local factionRanks = getElementData(theTeam, "ranks")
				local factionRankTitle = factionRanks[factionRank]
				local username = getPlayerName(thePlayer)
				local x, y, z = getElementPosition(thePlayer)
				local playerX, playerY, playerZ = getElementPosition(thePlayer)
				local playerZoneName = getZoneName(playerX, playerY, playerZ)
				
				setElementData(thePlayer, "takipacik", false)
				
				for k, pdplayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul Emniyet Müdürlüğü"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 155) " .. username:gsub("_", " ") .. " takipten ayrıldığını belirtti.", pdplayer, 0,0,0,true)
				end

				for k, lscsdplayer in ipairs(getPlayersInTeam(getTeamFromName ("İstanbul İl Jandarma Komutanlığı"))) do
					outputChatBox("#6464FF[!]#8B8B8E (CH: 155) " .. username:gsub("_", " ") .. " takipten ayrıldığını belirtti.", lscsdplayer, 0,0,0,true)
				end
			end
		end
	end
end
addCommandHandler("takip", takip)