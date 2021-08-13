local reason = {
  ['Unknown'] = 'Bilinmiyor',
  ['Quit'] = 'kendi isteğiyle',
  ['Kicked'] = 'Atıldı',
  ['Banned'] = 'Uzaklaştırıldı',
  ['Bad Connection'] = 'Kötü İnternet',
  ['Timed out'] = 'İnternet Kesintisi',

}


function quitPlayer(type)
    for i,v in ipairs(getElementsByType('player')) do
        local x,y,z = getElementPosition(source)
        local time = getRealTime()
        local hours = time.hour
        local minutes = time.minute
        local seconds = time.second
    
        local monthday = time.monthday
        local month = time.month
        local year = time.year
        if getDistance(source, v) <= 25 then
        if exports.mrp_integration:isPlayerTrialAdmin(v) then
   			triggerClientEvent(v,'quitlog:addPlayer',v,getPlayerName(source),getElementData(source,'account:username'),reason[type],math.ceil(getDistance(source, v)),getZoneNameEx(x,y,z),string.format("%04d-%02d-%02d %02d:%02d:%02d", year + 1900, month + 1, monthday, hours, minutes, seconds))
        else
            triggerClientEvent(v,'quitlog:addPlayer',v,getPlayerName(source),'',reason[type],math.ceil(getDistance(source, v)),getZoneNameEx(x,y,z),string.format("%04d-%02d-%02d %02d:%02d:%02d", year + 1900, month + 1, monthday, hours, minutes, seconds))
        end
    end
end
end
addEventHandler ( "onPlayerQuit", root, quitPlayer )

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






function getDistance(element, other)
	local x, y, z = getElementPosition(element)
	if isElement(element) and isElement(other) then
		return getDistanceBetweenPoints3D(x, y, z, getElementPosition(other))
	end
end

