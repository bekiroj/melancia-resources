-- // written by sourcelua.

function getAllBans(thePlayer)
	if exports["mrp_integration"]:isPlayerSeniorAdmin(thePlayer) then
        local list = {}
		local query = dbPoll (dbQuery(exports.mrp_mysql:getConnection(), "SELECT * FROM bans "), -1 )

		if (query) then
			for i, bans in ipairs(query) do
            	table.insert(list, {bans["id"], getCharacterName(bans["account"]), bans["serial"], bans["admin"], bans["reason"], bans["ip"]} )
            end
        end

        triggerClientEvent(thePlayer, "createBanlistGuiWindow", thePlayer, list)
	end
end
addCommandHandler("banlist", getAllBans)

local charCache = {} 

function getCharacterName( id )
	if not charCache[ id ] then
		if not (id < 1) then			
			local query = dbQuery(exports.mrp_mysql:getConnection(), "SELECT `username` FROM `accounts` WHERE `id` = ?", id)
		    local result = dbPoll (query, -1)
			if result then
			for _, row in ipairs ( result ) do
				name = (row["username"])
			end
				if name then
					charCache[ id ] = name:gsub("_", " ")
				end
			end
		else
			charCache[ id ] = false
		end
	end
	return charCache[ id ]
end

function deleteBan(id)
	dbExec(exports.mrp_mysql:getConnection(), "DELETE FROM bans WHERE id = ?", id)
end
addEvent('deleteBans',true)
addEventHandler('deleteBans', root, deleteBan)