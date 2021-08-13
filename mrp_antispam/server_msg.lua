local spam = {}
local zaman = {}
local spamkapatsure = 700

function komutkullandi( commandName )
if getElementData(source, "komutkullanimikapat") == false or getElementData(source, "komutkullanimikapat") == 0 then
spam[source] = tonumber(spam[source] or 0) + 1
		if spam[source] >= 9 then
			local playerName = getPlayerName( source ):gsub('_', ' ')
			outputChatBox('[Melancia]#D0D0D0 Bu kadar sık komut kullanımı yapmayınız.',source, 195,184,116,true)
			exports.mrp_anticheat:changeProtectedElementDataEx(source, "komutkullanimikapat", true)
			setElementData(source, "komutkullanimikapat", true)
		   cancelEvent()
		end
	
		if isTimer(zaman[source]) then
			killTimer(zaman[source])
		end
	
		zaman[source] = setTimer(	function (source)
			spam[source] = 0
			
			if isElement(source) and getElementData(source, "komutkullanimikapat") == true or getElementData(source, "komutkullanimikapat") then
				exports.mrp_anticheat:changeProtectedElementDataEx(source, "komutkullanimikapat", false)
				setElementData(source, "komutkullanimikapat", false)
			end
		end, spamkapatsure, 1, source)
	else
		cancelEvent()
	end
end
addEventHandler('onPlayerCommand', root, komutkullandi)