local syntaxTable = {
	["s"] = "#00a8ff[Melancia]#ffffff ",
	["e"] = "#e84118[Melancia]#ffffff ",
	["w"] = "#fbc531[Melancia]#ffffff ",
}

addEvent("skinshop-system:buySkin", true)
addEventHandler("skinshop-system:buySkin", root,
	function(player, skinID, price)
		if exports["mrp_global"]:hasMoney(player, tonumber(price)) then
			exports["mrp_global"]:takeMoney(player, tonumber(price))
			outputChatBox(syntaxTable["s"].."Kıyafet başarıyla satın alındı.",player,255,255,255,true)
			exports["mrp_global"]:giveItem(player, 16, tonumber(skinID))
			setElementModel(player, tonumber(skinID))
		end
	end
)