-- ENKANET
function isPlayerDeveloper(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 7)
end

function isPlayerHeadAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 6)
end

-- ENKANET
function isPlayerSeniorAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 5)
end

--MAXIME
function isPlayerLeadAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 5)
end

function isPlayerAdminIII(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 4)
end

function isPlayerAdminII(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 3)
end

function isPlayerAdminI(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 2)
end

function isPlayerAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 2)
end

function isPlayerTrialAdmin(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local adminLevel = getElementData(player, "admin_level") or 0
	return (adminLevel >= 1)
end

function isPlayerSupporter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local supporter_level = getElementData(player, "supporter_level") or 0
	return (supporter_level >= 1)
end

function isPlayerTester(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 1)
end

function isPlayerScripter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 2)
end

function isPlayerLeadScripter(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local scripter_level = getElementData(player, "scripter_level") or 0
	return (scripter_level >= 3)
end

--LEADER
function isPlayerVehicleConsultant(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local vct_level = getElementData(player, "vct_level") or 0
	return (vct_level >= 2)
end

--MEMBERS
function isPlayerVCTMember(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local vct_level = getElementData(player, "vct_level") or 0
	return (vct_level >= 1)
end

--LEADER
function isPlayerMappingTeamLeader(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local mapper_level = getElementData(player, "mapper_level") or 0
	return (mapper_level >= 2)
end

--MEMBERS
function isPlayerMappingTeamMember(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	local mapper_level = getElementData(player, "mapper_level") or 0
	return (mapper_level >= 1)
end

function isPlayerStaff(player)
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	return 	isPlayerTrialAdmin(player)
	or		isPlayerSupporter(player)
	or 		isPlayerScripter(player)
	or 		isPlayerVCTMember(player)
	or 		isPlayerMappingTeamMember(player)
end

function getAdminGroups() -- this is used in c_adminstats to correspond levels to forum usergroups
	return { SUPPORTER, TRIALADMIN, ADMIN, SENIORADMIN, LEADADMIN }
end

-- internal affairs
function isPlayerIA( player )
	if not player or not isElement(player) or not getElementType(player) == "player" then
		return false
	end
	return false
	--return tonumber( getElementData( player, "account:id" ) ) == 211
end

adminTitles = {
	[1] = "Deneme Yetkili",
	[2] = "Oyun İçi Yetkili I",
	[3] = "Oyun İçi Yetkili II",
	[4] = "Oyun İçi Yetkili III",
	[5] = "Genel Yetkili",
	[6] = "3rd Party Developer",
	[7] = "Developer",
	[10] = "Scripter",
}

function getAdminTitles()
	return adminTitles
end

function getSupporterNumber()
	return SUPPORTER
end

function getAuxiliaryStaffNumbers()
	return table.concat(AUXILIARY_GROUPS, ",")
end

function getAdminStaffNumbers()
	return table.concat(ADMIN_GROUPS, ",")
end
