mysql = exports.mrp_mysql

function giveBoatLicense(usingGC)
	dbExec(mysql:getConnection(), "UPDATE characters SET boat_license='1' WHERE charactername='" .. (getPlayerName(source)) .. "' LIMIT 1")
	setElementData(source, "license.boat", 1)
	exports.mrp_hud:sendBottomNotification(source, "Department of Motor Vehicles", "Congratulations! You are now fully licensed captain a boat on the water." )
	exports.mrp_global:giveItem(source, 155, getPlayerName(source):gsub("_"," "))
	executeCommandHandler("stats", source, getPlayerName(source))
end
addEvent("acceptBoatLicense", true)
addEventHandler("acceptBoatLicense", getRootElement(), giveBoatLicense)