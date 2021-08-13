local mysql = exports.mrp_mysql

addEvent("kaydet:dakikavesaat", true)
function veriKaydetDakikaveSaat(client)
	local minutesplayed = getElementData(client, "minutesPlayed")
	local hoursplayed = getElementData(client, "hoursplayed")
	local id = getElementData(client, "dbid") -- account:character:id
	if id then
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `minutesPlayed`='"..minutesplayed.."' WHERE `id`='"..id.."' ")
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `hoursplayed`='"..hoursplayed.."' WHERE `id`='"..id.."' ")
	end
end
addEventHandler("kaydet:dakikavesaat",getRootElement(), veriKaydetDakikaveSaat)

addEvent("kaydet:seviyevesaat", true)
function veriKaydetSeviyeveAmac(client)
	local level = getElementData(client, "level")
	local hoursaim = getElementData(client, "hoursaim")
	local id = getElementData(client, "dbid") -- account:character:id
	if id then
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `level`='"..level.."' WHERE `id`='"..id.."' ")
		dbExec(mysql:getConnection(),"UPDATE `characters` SET `hoursaim`='"..hoursaim.."' WHERE `id`='"..id.."' ")
	end
end
addEventHandler("kaydet:seviyevesaat",getRootElement(), veriKaydetSeviyeveAmac)
