--MAXIME
mysql = exports.mrp_mysql
TESTER = 25
SCRIPTER = 32
LEADSCRIPTER = 79
COMMUNITYLEADER = 14
TRIALADMIN = 18
ADMIN = 17
SENIORADMIN = 64
LEADADMIN = 15
SUPPORTER = 30
VEHICLE_CONSULTATION_TEAM_LEADER = 39
VEHICLE_CONSULTATION_TEAM_MEMBER = 43
MAPPING_TEAM_LEADER = 44
MAPPING_TEAM_MEMBER = 28
STAFF_MEMBER = {32, 14, 18, 17, 64, 15, 30, 39, 43, 44, 28}
AUXILIARY_GROUPS = {32, 39, 43, 44, 28}
ADMIN_GROUPS = {14, 18, 17, 64, 15}

staffTitles = {
	[1] = {
		[0] = "Oyuncu",
		[1] = "Deneme Yetkili",
		[2] = "Oyun İçi Yetkili I",
		[3] = "Oyun İçi Yetkili II",
		[4] = "Oyun İçi Yetkili III",
		[5] = "Genel Yetkili",
		[6] = "3rd Party Developer",
		[7] = "Developer",
	}, 
	[2] = {
		[0] = "Oyuncu",
		[1] = "Rehber I",
	}, 
	[3] = {
		[0] = "Oyuncu",
		[1] = "VCT Member",
		[2] = "VCT Leader",
	}, 
	[4] = {
		[0] = "Oyuncu",
		[1] = "Script Tester",
		[2] = "Trial Scripter",
		[3] = "Scripter",
	}, 
	[5] = {
		[0] = "Oyuncu",
		[1] = "Mapper",
		[2] = "Lider Mapper",
	}, 
}

function getStaffTitle(teamID, rankID) 
	return staffTitles[tonumber(teamID)][tonumber(rankID)]
end

function getStaffTitles()
	return staffTitles
end