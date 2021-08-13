local localPlayer = getLocalPlayer()

local minutesPlayed = function()
	if getElementData(localPlayer, 'loggedin') == 1 then
		if getElementData(localPlayer, 'minutesPlayed') > 60 then
			setElementData(localPlayer, 'minutesPlayed', toumber(0))
			setElementData(localPlayer, "hoursplayed", tonumber(getElementData(localPlayer, "hoursplayed") + 1))
		else
			setElementData(localPlayer, "minutesPlayed", tonumber(getElementData(localPlayer, "minutesPlayed") + 1))
		end
	end
end

local checkAim = function()
	if getElementData(localPlayer, 'loggedin') == 1 then
		if getElementData(localPlayer, 'hoursplayed') >= getElementData(localPlayer, 'hoursaim') then
            setElementData(localPlayer, "level", tonumber(getElementData(localPlayer, "level") + 1))
            setElementData(localPlayer, "hoursaim", tonumber(getElementData(localPlayer, "hoursaim") * 2))
            outputChatBox('[Melancia]#D0D0D0 Tebrikler, seviye atladınız!',195,184,116,true)
        end
	end
end

local drinkHunger = function()
	if getElementData(localPlayer, 'loggedin') == 1 then
		if getElementData(localPlayer, 'hunger') == 0 then
            setElementHealth(localPlayer, getElementHealth(localPlayer) - 15)
		else
			setElementData(localPlayer, "hunger", tonumber(getElementData(localPlayer, "hunger") - 1))
		end
		if getElementData(localPlayer, 'thirst') == 0 then
            setElementHealth(localPlayer, getElementHealth(localPlayer) - 15)
		else
			setElementData(localPlayer, "thirst", tonumber(getElementData(localPlayer, "thirst") - 1))
		end
	end
end

local limiterDrinkHunger = function()
	if getElementData(localPlayer, 'loggedin') == 1 then
		if exports.mrp_integration:isPlayerDeveloper(localPlayer) then return end
		if getElementData(localPlayer, 'hunger') > 100 then
			setElementData(localPlayer, 'hunger', tonumber(100))
		end
		if getElementData(localPlayer, 'thirst') > 100 then
			setElementData(localPlayer, 'thirst', tonumber(100))
		end
	end
end

addEventHandler('onClientResourceStart', getRootElement(), function()
	setTimer(minutesPlayed,60000,0)
    setTimer(checkAim,60000,0)
	setTimer(drinkHunger,250000,0)
	setTimer(limiterDrinkHunger,60,0)
end)