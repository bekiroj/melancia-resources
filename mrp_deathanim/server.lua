local clientHazir = {}


function emeklet()
	for i,v in pairs(getElementsByType("player")) do
		if getElementData(v, "Emekleme") then
			triggerClientEvent("Emekleme:Emeklet",v,"Ekle")
		end	
	end
end
--setTimer(emeklet,500,1)



addEventHandler("onPlayerJoin", root, function()
	emekleyenleriYukle(source)
end)

function emekleyenleriYukle(oyuncu)
	if not clientHazir[oyuncu] then
		setTimer(emekleyenleriYukle,5000,1,oyuncu)
	else
		for i,v in pairs(getElementsByType("player")) do
			if getElementData(oyuncu, "Emekleme") then
				triggerClientEvent(source, "Emekleme:Emeklet",v,"Ekle")
			end	
		end
	end	
end

addEventHandler("onResourceStart", resourceRoot, function()
	 setTimer(emeklet,500,1)
end)


addEvent("Emekleme:OyuncuGirdi", true)
addEventHandler("Emekleme:OyuncuGirdi", root, function()
	clientHazir[source] = true
end)