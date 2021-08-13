
local scoreboardDummy

addEventHandler ( "onResourceStart", getResourceRootElement(getThisResource()), function ()
	scoreboardDummy = createElement ( "arp_scoreboard" )
	setElementData ( scoreboardDummy, "serverName", "  Melancia Roleplay | www.melanciaroleplay.com" )
	setElementData ( scoreboardDummy, "maxPlayers", getMaxPlayers () )
	setElementData ( scoreboardDummy, "allow", true )

end, false )

addEventHandler ( "onResourceStop", getResourceRootElement(getThisResource()), function ()
	if scoreboardDummy then
		destroyElement ( scoreboardDummy )
	end
end, false )
