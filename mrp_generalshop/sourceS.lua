-- // bekiroj

function kasa_ver()
	if getElementData(source, "loggedin") == 0 then return end
	if not exports.mrp_global:takeMoney(source, 250) then
		outputChatBox("[!]#ffffff Eşyayı satın almak için yeterli miktarda paran yok.",source,100,100,255,true)
	return end
	outputChatBox("[!]#ffffff Kasaya ₺250 ödeyerek 1 adet Kasa satın aldınız.",source,100,100,255,true)
	exports.mrp_global:giveItem(source, 60, 1)
end
addEvent("shop_sistem_kasa", true)
addEventHandler("shop_sistem_kasa", getRootElement(), kasa_ver)

function sigara_ver()
	if getElementData(source, "loggedin") == 0 then return end
	if not exports.mrp_global:takeMoney(source, 15) then
		outputChatBox("[!]#ffffff Eşyayı satın almak için yeterli miktarda paran yok.",source,100,100,255,true)
	return end
	outputChatBox("[!]#ffffff Kasaya ₺15 ödeyerek 1 adet Sigara Paketi satın aldınız.",source,100,100,255,true)
	exports.mrp_global:giveItem(source, 105, 20)
end
addEvent("shop_sistem_sigara", true)
addEventHandler("shop_sistem_sigara", getRootElement(), sigara_ver)

function cakmak_ver()
	if getElementData(source, "loggedin") == 0 then return end
	if not exports.mrp_global:takeMoney(source, 20) then
		outputChatBox("[!]#ffffff Eşyayı satın almak için yeterli miktarda paran yok.",source,100,100,255,true)
	return end
	outputChatBox("[!]#ffffff Kasaya ₺20 ödeyerek 1 adet Çakmak satın aldınız.",source,100,100,255,true)
	exports.mrp_global:giveItem(source, 107, 1)
end
addEvent("shop_sistem_cakmak", true)
addEventHandler("shop_sistem_cakmak", getRootElement(), cakmak_ver)

function ip_ver()
	if getElementData(source, "loggedin") == 0 then return end
	if not exports.mrp_global:takeMoney(source, 175) then
		outputChatBox("[!]#ffffff Eşyayı satın almak için yeterli miktarda paran yok.",source,100,100,255,true)
	return end
	outputChatBox("[!]#ffffff Kasaya ₺175 ödeyerek 1 adet İp satın aldınız.",source,100,100,255,true)
	exports.mrp_global:giveItem(source, 46, 1)
end
addEvent("shop_sistem_ip", true)
addEventHandler("shop_sistem_ip", getRootElement(), ip_ver)

function gozband_ver()
	if getElementData(source, "loggedin") == 0 then return end
	if not exports.mrp_global:takeMoney(source, 175) then
		outputChatBox("[!]#ffffff Eşyayı satın almak için yeterli miktarda paran yok.",source,100,100,255,true)
	return end
	outputChatBox("[!]#ffffff Kasaya ₺175 ödeyerek 1 adet Göz Bandı satın aldınız.",source,100,100,255,true)
	exports.mrp_global:giveItem(source, 66, 1)
end
addEvent("shop_sistem_gozband", true)
addEventHandler("shop_sistem_gozband", getRootElement(), gozband_ver)

function sarma_ver()
	if getElementData(source, "loggedin") == 0 then return end
	if not exports.mrp_global:takeMoney(source, 40) then
		outputChatBox("[!]#ffffff Eşyayı satın almak için yeterli miktarda paran yok.",source,100,100,255,true)
	return end
	outputChatBox("[!]#ffffff Kasaya ₺40 ödeyerek 1 adet Sarma Paketi satın aldınız.",source,100,100,255,true)
	exports.mrp_global:giveItem(source, 181, 1)
end
addEvent("shop_sistem_sarma", true)
addEventHandler("shop_sistem_sarma", getRootElement(), sarma_ver)

function seyyarteyp_ver()
	if getElementData(source, "loggedin") == 0 then return end
	if not exports.mrp_global:takeMoney(source, 200) then
		outputChatBox("[!]#ffffff Eşyayı satın almak için yeterli miktarda paran yok.",source,100,100,255,true)
	return end
	outputChatBox("[!]#ffffff Kasaya ₺200 ödeyerek 1 adet Seyyar Teyp satın aldınız.",source,100,100,255,true)
	exports.mrp_global:giveItem(source, 54, 1)
end
addEvent("shop_sistem_seyyarteyp", true)
addEventHandler("shop_sistem_seyyarteyp", getRootElement(), seyyarteyp_ver)

function kitap_ver()
	if getElementData(source, "loggedin") == 0 then return end
	outputChatBox("[!]#ffffff Bu sistem henüz kullanılmamaktadır.",source,100,100,255,true)
end
addEvent("shop_sistem_kitap", true)
addEventHandler("shop_sistem_kitap", getRootElement(), kitap_ver)

function saksi_ver()
	if getElementData(source, "loggedin") == 0 then return end
	if not exports.mrp_global:takeMoney(source, 150) then
		outputChatBox("[!]#ffffff Eşyayı satın almak için yeterli miktarda paran yok.",source,100,100,255,true)
	return end
	outputChatBox("[!]#ffffff Kasaya ₺150 ödeyerek 1 adet Saksı satın aldınız.",source,100,100,255,true)
	exports.mrp_global:giveItem(source, 333, 1)
end
addEvent("shop_sistem_saksi", true)
addEventHandler("shop_sistem_saksi", getRootElement(), saksi_ver)

function telefon_ver()
	if getElementData(source, "loggedin") == 0 then return end
	if not exports.mrp_global:takeMoney(source, 170) then
		outputChatBox("[!]#ffffff Eşyayı satın almak için yeterli miktarda paran yok.",source,100,100,255,true)
	return end
	outputChatBox("[!]#ffffff Kasaya ₺170 ödeyerek 1 adet Telefon satın aldınız.",source,100,100,255,true)
	local itemValue = math.random(530, 542) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9) .. math.random(0, 9)
	exports.mrp_global:giveItem(source, 2, itemValue)
end
addEvent("shop_sistem_telefon", true)
addEventHandler("shop_sistem_telefon", getRootElement(), telefon_ver)

function sopa_ver()
	if getElementData(source, "loggedin") == 0 then return end
	if not exports.mrp_global:takeMoney(source, 500) then
		outputChatBox("[!]#ffffff Eşyayı satın almak için yeterli miktarda paran yok.",source,100,100,255,true)
	return end
	outputChatBox("[!]#ffffff Kasaya ₺500 ödeyerek 1 adet Beyzbol Sopası satın aldınız.",source,100,100,255,true)
	-------------------------------------------------------
	local cid = tonumber(getElementData(source,"account:character:id"))
	local silahid = 5
	local silahisim = getWeaponNameFromID(5)
	local serial = exports.mrp_global:createWeaponSerial(1,cid)
	exports["mrp_items"]:giveItem(source, 115, silahid..":"..serial..":"..silahisim.."::")
	-------------------------------------------------------

end
addEvent("shop_sistem_sopa", true)
addEventHandler("shop_sistem_sopa", getRootElement(), sopa_ver)