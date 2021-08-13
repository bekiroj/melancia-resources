function canAccessManager(thePlayer)
	if not thePlayer then
		thePlayer = localPlayer
	end
	
	if not localPlayer then
		return false
	end
	
	if exports.mrp_integration:isPlayerLeadAdmin(thePlayer) then
		return true
	end
	return false
end