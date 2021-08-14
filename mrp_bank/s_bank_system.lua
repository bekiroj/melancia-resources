mysql = exports.mrp_mysql
function setElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	if syncToClient == nil then
		syncToClient = false
	end
	
	if noSyncAtall == nil then
		noSyncAtall = false
	end
	
	if tonumber(theValue) then
		theValue = tonumber(theValue)
	end
	
	exports.mrp_anticheat:changeProtectedElementDataEx(theElement, theParameter, theValue, syncToClient, noSyncAtall)
	return true
end


addEventHandler( "onResourceStart", getResourceRootElement(),
	function()
		-- delete all old wiretransfers
		dbExec(mysql:getConnection(),"DELETE FROM wiretransfers WHERE time < NOW() - INTERVAL 4 WEEK" )
	end
)

--MAXIME
function hasBankMoney(thePlayer, amount)
	amount = tonumber(amount) 
	amount = math.floor(math.abs(amount))
	if getElementType(thePlayer) == "player" then
		return getElementData(thePlayer, "bankmoney") >= amount
	elseif getElementType(thePlayer) == "team" then
		return getElementData(thePlayer, "money") >= amount
	end
end

function takeBankMoney(thePlayer, amount)
	amount = tonumber(amount)
	amount = math.floor(math.abs(amount))
	if not hasBankMoney(thePlayer, amount) then
		return false, "Lack of money in bank"
	end
	if getElementType(thePlayer) == "player" then
		return setElementDataEx(thePlayer, "bankmoney", getElementData(thePlayer, "bankmoney")-amount, true) and dbExec(mysql:getConnection(),"UPDATE `characters` SET `bankmoney`=bankmoney-"..amount.." WHERE `id`='"..getElementData(thePlayer, "dbid").."' ") 
	elseif getElementType(thePlayer) == "team" then
		return setElementDataEx(thePlayer, "money", getElementData(thePlayer, "money")-amount, true) and dbExec(mysql:getConnection(),"UPDATE `factions` SET `bankbalance`=bankbalance-"..amount.." WHERE `id`='"..getElementData(thePlayer, "id").."' ") 
	end
end

function giveBankMoney(thePlayer, amount)
	amount = tonumber(amount)
	amount = math.floor(math.abs(amount))
	if getElementType(thePlayer) == "player" then
		return setElementDataEx(thePlayer, "bankmoney", getElementData(thePlayer, "bankmoney")+amount, true) and dbExec(mysql:getConnection(),"UPDATE `characters` SET `bankmoney`=bankmoney+"..amount.." WHERE `id`='"..getElementData(thePlayer, "dbid").."' ") 
	elseif getElementType(thePlayer) == "team" then
		return setElementDataEx(thePlayer, "money", getElementData(thePlayer, "money")+amount, true) and dbExec(mysql:getConnection(),"UPDATE `factions` SET `bankbalance`=bankbalance+"..amount.." WHERE `id`='"..getElementData(thePlayer, "id").."' ") 
	end
end

function setBankMoney(thePlayer, amount)
	amount = tonumber(amount)
	amount = math.floor(math.abs(amount))
	if getElementType(thePlayer) == "player" then
		return setElementDataEx(thePlayer, "bankmoney", amount, true) and dbExec(mysql:getConnection(),"UPDATE `characters` SET `bankmoney`="..amount.." WHERE `id`='"..getElementData(thePlayer, "dbid").."' ") 
	elseif getElementType(thePlayer) == "team" then
		return setElementDataEx(thePlayer, "money", amount, true) and dbExec(mysql:getConnection(),"UPDATE `factions` SET `bankbalance`="..amount.." WHERE `id`='"..getElementData(thePlayer, "id").."' ") 
	end
end
