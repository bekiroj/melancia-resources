local bankayeri = createColSphere ( 2828.7282714844, 2762.3364257813, 16.395889282227, 3)
setElementInterior(bankayeri, 0)
setElementDimension(bankayeri, 9)
local pickup = createPickup(2828.7282714844, 2762.3364257813, 16.395889282227, 3, 1239)
setElementData(pickup, "informationicon:information", "#669900/banka#FFFFFF\nTürkiye Finans")
setElementInterior(pickup, 0)
setElementDimension(pickup, 9)
-- written from bekiroj
function bankayatir(thePlayer, cmd, komut, miktar, targetPlayerNick)
	if not isElementWithinColShape(thePlayer, bankayeri) then
	return end
	if not komut then
		outputChatBox("#669900[!]#FFFFFF /banka [Yatır] [Cek] [Transfer] [Miktar]",thePlayer, 255, 255, 255 ,true)
	return end

	if not miktar then
		outputChatBox("#669900[!]#FFFFFF /banka [Yatır] [Cek] [Transfer] [Miktar]",thePlayer, 255, 255, 255 ,true)
	return end

	if not getElementData(thePlayer, "loggedin") == 1 then
	return end

	if getElementData(thePlayer, "player.Grabbed") then
		outputChatBox("#669900[!]#FFFFFF Şuanda bu işlemi uygulayamazsınız.",thePlayer, 255, 255, 255, true)
	return end

	if getElementData(thePlayer, "player.Cuffed") then
		outputChatBox("#669900[!]#FFFFFF Şuanda bu işlemi uygulayamazsınız.",thePlayer, 255, 255, 255, true)
	return end

	if getElementData(thePlayer, "ipbagli") then
		outputChatBox("#669900[!]#FFFFFF Şuanda bu işlemi uygulayamazsınız.",thePlayer, 255, 255, 255, true)
	return end

	if ( getElementData(thePlayer, "dead") == 1 ) then
		outputChatBox("#669900[!]#FFFFFF Şuanda bu işlemi uygulaymazsınız.",thePlayer, 255, 255, 255, true)
	return end
	
	if getElementData(thePlayer, "gözbandajı") then
		outputChatBox("#669900[!]#FFFFFF Şuanda bu işlemi uygulayamazsınız.",thePlayer, 255, 255, 255, true)
	return end

	if tonumber(miktar) <= 0 then return end

	local bankmoney = getElementData(thePlayer, "bankmoney")
	local bankaCek2 = getElementData(thePlayer, "bankmoney")

	if komut == "yatır" then
		if not exports.mrp_global:takeMoney(thePlayer, miktar) then
			outputChatBox("#669900[!]#ffffff Yatırmak istediğiniz miktarda paranız yok.",thePlayer,255, 255, 255, true)
		return end
		exports.mrp_global:applyAnimation(thePlayer, "DEALER", "shop_pay", 4000, false, true, true)
		setElementData(thePlayer, "bankmoney", bankaCek2 + tonumber(miktar))
		outputChatBox("#669900[!]#FFFFFF Bankaya "..miktar.."$ para yatırdınız.",thePlayer, 255, 255, 255, true)
	end

	if komut == "cek" then
		if not exports.mrp_bank:takeBankMoney(thePlayer, miktar) then
			outputChatBox("#669900[!]#FFFFFF Banka hesabınız girdiğiniz miktarda para bulunmamaktadır.",thePlayer, 255, 255, 255, true)
		return end
		exports.mrp_global:applyAnimation(thePlayer, "DEALER", "shop_pay", 4000, false, true, true)
		exports.mrp_global:giveMoney(thePlayer, miktar)
		setElementData(thePlayer, "bankmoney", bankaCek2 - tonumber(miktar))
		outputChatBox("#669900[!]#FFFFFF Bankadan "..miktar.."$ para çektiniz.",thePlayer, 255, 255, 255, true)
	end

	if komut == "transfer" then
		local targetPlayer, targetPlayerName = exports.mrp_global:findPlayerByPartialNick(thePlayer, targetPlayerNick)
		local thePlayer, thePlayerName = exports.mrp_global:findPlayerByPartialNick(thePlayer, thePlayer)
		if not targetPlayerName then
			outputChatBox("#669900[!]#FFFFFF Transfer edeceğiniz kişinin ID'sini giriniz.",thePlayer, 255, 255, 255 ,true)
		return end
		if not exports.bank:takeBankMoney(thePlayer, miktar) then
			outputChatBox("#669900[!]#FFFFFF Banka hesabınız girdiğiniz miktarda para bulunmamaktadır.",thePlayer, 255, 255, 255, true)
		return end
		if (targetPlayer==thePlayer) then
			outputChatBox("#669900[!]#FFFFFF Kendi hesabınıza para transfer edemezsiniz.",thePlayer, 255, 255, 255, true)
		return end
		local bankaCek22 = getElementData(targetPlayer, "bankmoney")
		exports.mrp_global:applyAnimation(thePlayer, "DEALER", "shop_pay", 4000, false, true, true)
		setElementData(thePlayer, "bankmoney", bankaCek2 - tonumber(miktar))
		setElementData(targetPlayer, "bankmoney", bankaCek22 + tonumber(miktar))
		outputChatBox("#669900[!]#FFFFFF ".. targetPlayerName .. " isimli kişiye "..miktar.."$ para transfer ettiniz.",thePlayer, 255, 255, 255, true)
		outputChatBox("#669900[!]#FFFFFF "..thePlayerName.." isimli kişi size banka hesabınıza "..miktar.."$ para transfer etti.", targetPlayer, 0, 255, 0,true)
	end
end
addCommandHandler("banka", bankayatir, false, false)