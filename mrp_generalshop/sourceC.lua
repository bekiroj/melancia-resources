-- // bekiroj

local ped = createPed(52, -28.8828125, -186.8203125, 1003.546875)
setElementInterior(ped, 17)
setElementDimension(ped, 11)
setElementRotation(ped, 0, 0, 359.53582763672, "default", true)
setElementData( ped, "talk", 1, false )
setElementData( ped, "name", "Ali Soyyiğit", false )
setElementData( ped, "shop-panel", 1)
setElementFrozen(ped, true)


local sx, sy = guiGetScreenSize()

function market_panel()
	if not getElementData(localPlayer, "shop-panel") then
		setElementData(localPlayer, "shop-panel", true) 
		GUIEditor = {
	    gridlist = {},
	    window = {},
	    button = {}
		}
		market_arkaplan = guiCreateWindow(sx/2-450/2,sy/2-350/2,367,405, "Satın Almak İstediğiniz Öğeye Çift Tıkayınız", false)
		guiWindowSetSizable(market_arkaplan, false)

		market_liste = guiCreateGridList(9, 24, 348, 343, false, market_arkaplan)
		guiGridListAddColumn(market_liste, "Eşya Adı", 0.4)
		guiGridListAddColumn(market_liste, "Fiyat", 0.4)
		for i = 1, 11 do
		    guiGridListAddRow(market_liste)
		end
		guiGridListSetItemText(market_liste, 0, 1, "Kasa", false, false)
		guiGridListSetItemText(market_liste, 0, 2, "₺250", false, false)
		guiGridListSetItemText(market_liste, 1, 1, "Cep Telefonu", false, false)
		guiGridListSetItemText(market_liste, 1, 2, "₺170", false, false)
		guiGridListSetItemText(market_liste, 2, 1, "Sigara Paketi", false, false)
		guiGridListSetItemText(market_liste, 2, 2, "₺15", false, false)
		guiGridListSetItemText(market_liste, 3, 1, "Çakmak", false, false)
		guiGridListSetItemText(market_liste, 3, 2, "₺20", false, false)
		guiGridListSetItemText(market_liste, 4, 1, "İp", false, false)
		guiGridListSetItemText(market_liste, 4, 2, "₺175", false, false)
		guiGridListSetItemText(market_liste, 5, 1, "Göz Bandı", false, false)
		guiGridListSetItemText(market_liste, 5, 2, "₺175", false, false)
		guiGridListSetItemText(market_liste, 6, 1, "Sarma Paketi", false, false)
		guiGridListSetItemText(market_liste, 6, 2, "₺40", false, false)
		guiGridListSetItemText(market_liste, 7, 1, "Seyyar Teyp", false, false)
		guiGridListSetItemText(market_liste, 7, 2, "₺200", false, false)
		guiGridListSetItemText(market_liste, 8, 1, "Kitap", false, false)
		guiGridListSetItemText(market_liste, 8, 2, "₺40", false, false)
		guiGridListSetItemText(market_liste, 9, 1, "Saksı", false, false)
		guiGridListSetItemText(market_liste, 9, 2, "₺150", false, false)
		guiGridListSetItemText(market_liste, 10, 1, "Beyzbol Sopası", false, false)
		guiGridListSetItemText(market_liste, 10, 2, "₺500", false, false)
		Kapat_buton = guiCreateButton(122, 375, 118, 20, "Arayüzü Kapat", false, market_arkaplan)
	end
end
addEvent("shop-panel-ac", true)
addEventHandler("shop-panel-ac", getRootElement(), market_panel)

addEventHandler("onClientDoubleClick",root,function()
	local siraCek = guiGridListGetSelectedItem(market_liste)
	if siraCek == 1 then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil)
		triggerServerEvent("shop_sistem_telefon",localPlayer)
	end
end)

addEventHandler("onClientDoubleClick",root,function()
	local siraCek = guiGridListGetSelectedItem(market_liste)
	if siraCek == 10 then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil)
		triggerServerEvent("shop_sistem_sopa",localPlayer)
	end
end)

addEventHandler("onClientDoubleClick",root,function()
	local siraCek = guiGridListGetSelectedItem(market_liste)
	if siraCek == 9 then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil)
		triggerServerEvent("shop_sistem_saksi",localPlayer)
	end
end)

addEventHandler("onClientDoubleClick",root,function()
	local siraCek = guiGridListGetSelectedItem(market_liste)
	if siraCek == 8 then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil)
		triggerServerEvent("shop_sistem_kitap",localPlayer)
	end
end)

addEventHandler("onClientDoubleClick",root,function()
	local siraCek = guiGridListGetSelectedItem(market_liste)
	if siraCek == 7 then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil)
		triggerServerEvent("shop_sistem_seyyarteyp",localPlayer)
	end
end)

addEventHandler("onClientDoubleClick",root,function()
	local siraCek = guiGridListGetSelectedItem(market_liste)
	if siraCek == 6 then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil)
		triggerServerEvent("shop_sistem_sarma",localPlayer)
	end
end)

addEventHandler("onClientDoubleClick",root,function()
	local siraCek = guiGridListGetSelectedItem(market_liste)
	if siraCek == 5 then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil)
		triggerServerEvent("shop_sistem_gozband",localPlayer)
	end
end)

addEventHandler("onClientDoubleClick",root,function()
	local siraCek = guiGridListGetSelectedItem(market_liste)
	if siraCek == 4 then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil)
		triggerServerEvent("shop_sistem_ip",localPlayer)
	end
end)

addEventHandler("onClientDoubleClick",root,function()
	local siraCek = guiGridListGetSelectedItem(market_liste)
	if siraCek == 0 then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil)
		triggerServerEvent("shop_sistem_kasa",localPlayer)
	end
end)

addEventHandler("onClientDoubleClick",root,function()
	local siraCek = guiGridListGetSelectedItem(market_liste)
	if siraCek == 2 then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil)
		triggerServerEvent("shop_sistem_sigara",localPlayer)
	end
end)

addEventHandler("onClientDoubleClick",root,function()
	local siraCek = guiGridListGetSelectedItem(market_liste)
	if siraCek == 3 then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil)
		triggerServerEvent("shop_sistem_cakmak",localPlayer)
	end
end)

addEventHandler("onClientGUIClick",root,function()
	if source == Kapat_buton then
		destroyElement(market_arkaplan)
		setElementData(localPlayer, "shop-panel", nil) 
	end
end)