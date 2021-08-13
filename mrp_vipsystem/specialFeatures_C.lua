local specialWeapons = {
	--[weapon_id] = {true, gereken_level (default değeri 1) }
	[31] = {true, 3}
}

local allowedFactions = {
	[1] = true,
	[2] = true,
	[78] = true,
}

function antiWeapon(preSlot)
	local currentWeaponID = getPedWeapon(localPlayer)

	if specialWeapons[currentWeaponID] then
		if specialWeapons[currentWeaponID][1] then

			--faction kontrol
			local myFaction = getElementData(source, "faction") or -1
			if allowedFactions[myFaction] then
				return 
			end
			-- vip kotrol
			local myVipLevel = tonumber(getElementData(localPlayer, "vip")) or 0
			local requiredLevel = specialWeapons[currentWeaponID][2] or 1
			if not (myVipLevel >= requiredLevel) then
				setPedWeaponSlot(localPlayer, preSlot)
				outputChatBox("[!] #FFFFFF"..getWeaponNameFromID(currentWeaponID).." adlı silahı kullanabilmen için VIP ["..requiredLevel.."] olmalısın.", 255, 0, 0, true)
			end
		end
	end
end
addEventHandler("onClientPlayerWeaponSwitch", localPlayer, antiWeapon)