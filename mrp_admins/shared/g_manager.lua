function canPlayerAccessStaffManager(player)
	return exports.mrp_integration:isPlayerTrialAdmin(player) or exports.mrp_integration:isPlayerSupporter(player) or exports.mrp_integration:isPlayerVCTMember(player) or exports.mrp_integration:isPlayerLeadScripter(player) or exports.mrp_integration:isPlayerMappingTeamLeader(player)
end	