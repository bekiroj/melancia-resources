local mysql = exports.mrp_mysql
addEventHandler("onResourceStart", resourceRoot,
	function()
		dbQuery(
			function(qh)
				local res, rows, err = dbPoll(qh, 0)
				if rows > 0 then
					local result_table = { }
					for index, row in ipairs(res) do
						table.insert(result_table, row)
					end
					setElementData(resourceRoot, "gunlicense:table", result_table)
				end
			end,
		mysql:getConnection(), "SELECT `charactername`, `gun_license`, `gun2_license` FROM `characters` WHERE `gun_license`=1 OR `gun2_license`=1" )
	end
)

function syncTable(guntable)
	if type(guntable) == "table" then
		setElementData(resourceRoot, "gunlicense:table", guntable)
		for k,v in ipairs(exports.mrp_pool:getPoolElementsByType("player")) do
			if getElementData(v, "gunlicense:activewindow") then
				triggerClientEvent(v, "gunlicense:refreshclient", resourceRoot)
			end
		end
	end
end
addEvent("gunlicense:synctable", true)
addEventHandler("gunlicense:synctable", resourceRoot, syncTable)

function startThis(thePlayer)
	if (exports.mrp_integration:isPlayerSeniorAdmin(thePlayer)) or (exports.mrp_global:hasItem(thePlayer, 209) and (exports.factions:isPlayerInFaction(thePlayer, 1) or exports.factions:isPlayerInFaction(thePlayer, 50))) then
		triggerClientEvent(thePlayer, "weaponlicensesGUI", thePlayer)
	end
end
addCommandHandler("weaponlicenses", startThis)
addEvent("gunlicense:weaponlicenses", true)
addEventHandler("gunlicense:weaponlicenses", root, startThis)


-- Revoking section
function revokeElements(name)
	if name then
		exports.mrp_anticheat:changeProtectedElementDataEx(getPlayerFromName(name), "license.gun", 0, false)
		exports.mrp_anticheat:changeProtectedElementDataEx(getPlayerFromName(name), "license.gun2", 0, false)
	end
end
addEvent("gunlicense:revokeElement", true)
addEventHandler("gunlicense:revokeElement", resourceRoot, revokeElements)

function mysqlRevoke(name)
	if name then
		dbExec(mysql:getConnection(),"UPDATE characters SET gun_license='0' WHERE charactername='"..(name).."' LIMIT 1")
		dbExec(mysql:getConnection(),"UPDATE characters SET gun2_license='0' WHERE charactername= '"..(name).."' LIMIT 1")
	end
end
addEvent("gunlicense:revokemysql", true)
addEventHandler("gunlicense:revokemysql", resourceRoot, mysqlRevoke)

-- Issueing section
function changeElement(name, licensetype)
	if name and licensetype and isElement(getPlayerFromName(name)) then
		if getElementData(getPlayerFromName(name), "loggedin") == 1 then
			exports.mrp_anticheat:changeProtectedElementDataEx(getPlayerFromName(name), "license."..licensetype, 1, false)
		end
	end
end
addEvent("gunlicense:changeelement", true)
addEventHandler("gunlicense:changeelement", resourceRoot, changeElement)

function mysqlIssue(name, licensetype)
	if name and licensetype then
		dbExec(mysql:getConnection(),"UPDATE characters SET "..licensetype.."_license='1' WHERE charactername= '"..(name).."' LIMIT 1")
	end
end
addEvent("gunlicense:issuemysql", true)
addEventHandler("gunlicense:issuemysql", resourceRoot, mysqlIssue)
