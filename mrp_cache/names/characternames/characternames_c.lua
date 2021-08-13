-- @okarosa
local characterNameCache = {}
local characterIDCache = {}
local searched = {}
local refreshCacheRate = 10 --Minutes
function getCharacterNameFromID( id )
	if not id or not tonumber(id) then
		return false
	else
		id = tonumber(id)
	end
	
	if characterNameCache[id] then
		return characterNameCache[id]
	end
	
	for i, player in pairs(getElementsByType("player")) do
		if id == getElementData(player, "dbid") then
			characterNameCache[id] = exports.mrp_global:getPlayerName(player)
			return characterNameCache[id]
		end
	end
	
	if not searched[id] or getTickCount() - searched[id] > refreshCacheRate*1000*60 then
		searched[id] = getTickCount()
		triggerServerEvent("requestCharacterNameCacheFromServer", localPlayer, id)
	else 
		return false
	end

	return "Loading.."
end

function retrieveCharacterNameCacheFromServer(characterName, id)
	if characterName and id then
		characterNameCache[id] = characterName
	end
end
addEvent("retrieveCharacterNameCacheFromServer", true)
addEventHandler("retrieveCharacterNameCacheFromServer", root, retrieveCharacterNameCacheFromServer)

function getCharacterIDFromName( name )
	if not name then
		return false
	else
		name = tostring(name):gsub(" ", "_")
	end
	
	if characterIDCache[name] then
		return characterNameCache[id]
	end
	
	for i, player in pairs(getElementsByType("player")) do
		if name == getPlayerName(player) then
			characterIDCache[name] = tonumber(getElementData(player, "dbid"))
			return characterIDCache[name]
		end
	end
	
	if searched[name] then
		return false
	end
	searched[name] = true
	
	triggerServerEvent("requestCharacterIDCacheFromServer", localPlayer, name)
	
	setTimer(function()
		local index = id
		searched[index] = nil
	end, refreshCacheRate*1000*60, 1)

	return "Loading.."
end

function retrieveCharacterIDCacheFromServer(characterName, id)
	if characterName and id then
		characterIDCache[characterName] = id
	end
end
addEvent("retrieveCharacterIDCacheFromServer", true)
addEventHandler("retrieveCharacterIDCacheFromServer", root, retrieveCharacterIDCacheFromServer)