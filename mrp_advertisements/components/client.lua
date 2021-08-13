local advertPed = createPed(184, 1489.0400390625, 1305.4697265625, 1093.2963867188)
setElementDimension(advertPed, 16)
setElementInterior(advertPed, 3)
setElementRotation(advertPed, 0, 0, 270.44635009766)
setElementFrozen(advertPed, true)
addEventHandler("onClientClick", root, function(b, s, _, _, _, _, _, elem) if (b == "right" and s == "down" and elem and getElementType(elem) == "ped" and elem == advertPed) then triggerEvent("reklam:HTML", localPlayer, localPlayer)  end end)

addCommandHandler("reklam",
	function(cmd)
		if (getElementData(localPlayer, "vip") >= 1) then
			triggerEvent("reklam:HTML", localPlayer, localPlayer)		
		end
	end
)