function onStealthKill(targetPlayer)
	--exports.global:sendMessageToAdmins("[ANTIDM] Blocked stealth kill from "..getPlayerName(source) .." against " .. getPlayerName(targetPlayer))
    cancelEvent(true)
end
addEventHandler("onPlayerStealthKill", getRootElement(), onStealthKill)

function checkCarJack(thePlayer, seat, jacked)
	if jacked and seat == 0 then
	   cancelEvent()
	   outputChatBox("[!]#FFFFFF Binmeye çalıştığınız arabanın sürücü koltuğunda birisi var!", thePlayer,25,25,255,true)
	end
 end
 addEventHandler("onVehicleStartEnter", getRootElement(), checkCarJack)
 
addCommandHandler("ssmod",
	function(player, cmd)
		if getElementData(player, "loggedin") == 1 then
			screenshot_mode = setElementData(player, "screenshot:mode", not getElementData(player, "screenshot:mode"))
			if getElementData(player, "screenshot:mode") then
				fadeCamera(player, false, 1)
			else
				fadeCamera(player, true, 1)
			end
		end
	end
)

function changeBlurLevel()
    setPlayerBlurLevel ( source, 0 )
end
addEventHandler ( "onPlayerJoin", getRootElement(), changeBlurLevel )

function scriptStart()
    setPlayerBlurLevel ( getRootElement(), 0)
end
addEventHandler ("onResourceStart",getResourceRootElement(getThisResource()),scriptStart)

function scriptRestart()
	setTimer ( scriptStart, 4000, 1 )
end
addEventHandler("onResourceStart",getRootElement(),scriptRestart)
