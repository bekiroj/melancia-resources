mysql = exports.mrp_mysql

local alan = createColSphere(-2033.28125, -117.365234375, 1035.171875, 1)
local pickup = createPickup(-2033.28125, -117.365234375, 1035.171875, 3, 1239)
setElementData(pickup, "informationicon:information", "#CC3333/anahtarkopyala#ffffff\nAnahtarcı")
setElementInterior(pickup, 3)
setElementDimension(pickup, 51)

addCommandHandler("anahtarkopyala",function(plr,cmd,durum,id)
	if isElementWithinColShape(plr, alan) then
		if not durum  or not tonumber(id) then 
			outputChatBox("|| Melancia Roleplay || /"..cmd.." <ev/arac> <id> yazarak çıkarabilirsiniz.",plr,255,194,14,true) 
		return end
			if durum == "ev" then -- // Ev başlangıç
				
				for key, v in ipairs(getElementsByType("interior")) do
					local owner = tonumber(getElementData(v, "status")[4])
					if tonumber(id)  == tonumber(v:getData("dbid")) then
						if (owner) and owner == tonumber(plr:getData("dbid")) then
							local isim = getElementData(v,"name")
							if not exports.mrp_global:hasSpaceForItem(plr, 4, 1) then
								outputChatBox("[!]#ffffff Envanterinizde anahtar için yeterli alan bulunmamaktadır!", plr, 255, 0, 0, true)
							return end	
							if not exports.mrp_global:takeMoney(plr, 150) then
								outputChatBox("[!]#ffffff Yeterli miktarda paranız yok.",plr,255,0,0,true)
							return end
							exports.mrp_global:giveItem(plr, 4, id)
							outputChatBox("[!]#ffffff ["..isim.."] adlı mülkünüzün anahtarını kopyaladınız.",plr,100,100,255,true)
						else
							outputChatBox("[!]#ffffff Bu mülkün sahibi değilsiniz.",plr,255,0,0,true)
						end
						
					end
				end
			end -- // Ev bitiş
			if durum == "arac" then -- // Araç başlangıç
				for key, v in ipairs(getElementsByType("vehicle")) do
					if tonumber(id) == tonumber(v:getData("dbid")) then
						if plr:getData("dbid") == v:getData("owner") then
							if not exports.mrp_global:hasSpaceForItem(plr, 3, 1) then
								outputChatBox("[!]#ffffff Envanterinizde anahtar için yeterli alan bulunmamaktadır!", plr, 255, 0, 0, true)
							return end	
								if not exports.mrp_global:takeMoney(plr, 150) then
								outputChatBox("[!]#ffffff Yeterli miktarda paranız yok.",plr,255,0,0,true)
							return end
							exports.mrp_global:giveItem(plr, 3, id)
						outputChatBox("[!]#ffffff ["..tonumber(id).."] id li aracın anahtarını kopyaladınız.",plr,100,100,255,true)
						else
						outputChatBox("[!]#ffffff Bu aracın sahibi değilsiniz.",plr,255,0,0,true)
						end
					end
				end
			end -- // Araç bitiş
	end
end)