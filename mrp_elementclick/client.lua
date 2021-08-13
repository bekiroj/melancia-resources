Click = Service:new('element-interface')
author = 'github.com/bekiroj'
activated = false
font = DxFont('Roboto.ttf', 9)
localPlayer = getLocalPlayer()
dxDrawRectangle = dxDrawRectangle
dxDrawText = dxDrawText

Click.character = function()
	if localPlayer:getData('loggedin') == 1 then
	if localPlayer:getData('dead') == 1 then return end
		if activated then
			Click.close()
		else
			activated = true
			counter = 0
			size = 25
			Click.pullCharOptions()
			for index, value in ipairs(pulledCharOptions) do
				counter = counter + 1.28
			end
			Click.Charender = Timer(
				function()
					local elementPos = localPlayer:getPosition()
					local x, y = getScreenFromWorldPosition(elementPos)
					dxDrawRectangle(x, y, 150, size*counter, tocolor(0,0,0,255))
					dxDrawOuterBorder(x, y, 150, size*counter, 2, tocolor(10,10,10,250))
					for key, value in pairs(pulledCharOptions) do
						if isMouseInPosition(x, y, 150, size+7) then
							dxDrawRectangle(x, y, 150, size+7, tocolor(5,5,5,250))
							dxDrawText(value[1], x+15, y+7, 150, size+7, tocolor(200,200,200,250), 1, font)
						else
							dxDrawRectangle(x, y, 150, size+7, tocolor(5,5,5,225))
							dxDrawText(value[1], x+15, y+7, 150, size+7, tocolor(200,200,200,250), 1, font)
						end
						if isMouseInPosition(x, y, 150, size+7) and getKeyState("mouse1") then
							Click.close()
							value[2]()
						end
						y = y + 32
					end
				end,
			0, 0)
		end
	end
end

Click.constructor = function(button, state, _,_,_,_,_, clickedElement)
	if localPlayer:getData('loggedin') == 1 then
	if localPlayer:getData('dead') == 1 then return end
		if button == 'right' and state == 'down' then
			if isElement(clickedElement) then
				if clickedElement ~= localPlayer then
					local type =  clickedElement.type
					if type == 'vehicle' or type == 'player' or type == 'ped' then
						if activated then
							Click.close()
						else
							activated = true
							counter = 0
							size = 25
							Click.pullOptions(clickedElement)
							for index, value in ipairs(pulledOptions) do
								counter = counter + 1.28
							end
							Click.render = Timer(
								function()
									if getDistanceBetweenPoints3D(localPlayer.position.x, localPlayer.position.y, localPlayer.position.z, clickedElement.position.x, clickedElement.position.y, clickedElement.position.z) < 3 then
										local elementPos = clickedElement:getPosition()
										local x, y = getScreenFromWorldPosition(elementPos)
										dxDrawRectangle(x, y, 150, size*counter, tocolor(0,0,0,255))
										dxDrawOuterBorder(x, y, 150, size*counter, 2, tocolor(10,10,10,250))
										for key, value in pairs(pulledOptions) do
											if isMouseInPosition(x, y, 150, size+7) then
												dxDrawRectangle(x, y, 150, size+7, tocolor(5,5,5,250))
												dxDrawText(value[1], x+15, y+7, 150, size+7, tocolor(200,200,200,250), 1, font)
											else
												dxDrawRectangle(x, y, 150, size+7, tocolor(5,5,5,225))
												dxDrawText(value[1], x+15, y+7, 150, size+7, tocolor(200,200,200,250), 1, font)
											end
											if isMouseInPosition(x, y, 150, size+7) and getKeyState("mouse1") then
												Click.close()
												value[2]()
											end
											y = y + 32
										end
									else
										Click.close()
									end
								end,
							0, 0)
						end
					end
				end
			end
		end
	end
end

Click.close = function()
	pulledOptions = {}
	pulledCharOptions = {}
	activated = false
	if isTimer(Click.render) then
		killTimer(Click.render)
	end
	if isTimer(Click.Charender) then
		killTimer(Click.Charender)
	end
end

Click.pullOptions = function(element)
	local type =  element.type
	if type == 'vehicle' then
	  if element:getData('carshop') then

	    pulledOptions = {
  			{"Satın Al ("..exports.mrp_global:formatMoney(getElementData(element,"carshop:cost")).."₺)", function()
  		  		triggerServerEvent("carshop:buyCar", element, "cash")
  			end,},
  			{"Detaylarını İncele", function()
  		  		triggerServerEvent("carshop:infoCar", localPlayer, element)
  			end,},
  			{"Vazgeç", function()
			end,},
  		}
	  else
  		pulledOptions = {
  			{"Kapı Kontrolü", function()
  		  	exports["mrp_vehicle"]:openVehicleDoorGUI(element)
  			end,},
  			{"Araç Bagajı(İnaktif)", function()
  		  	
  			end,},
  			{"Vazgeç", function()
			end,},
  		}
  	end
	elseif type == 'player' then
		pulledOptions = {
			{"Üstünü Ara", function()
				if getElementData(element, "ipbagli") or getElementData(element, "kelepce") then
					local target = getPlayerFromName(getPlayerName(element))
					triggerServerEvent("friskShowItems", localPlayer, target)
				else
					outputChatBox("Üzerini aramak istediğiniz kişi bağlı veya kelepçeli değil..", 255, 0, 0)
				end
			end,},
			{"Ellerini Bağla/Çöz", function()
				local target = getPlayerFromName(getPlayerName(element))
				if not getElementData(element, "ipbagli") then
					triggerServerEvent("ipbagla",localPlayer,localPlayer,target)
				else
					triggerServerEvent("ipcoz",localPlayer,localPlayer,target)
				end
			end,},
			{"Gözlerini Bağla/Çöz", function()
				local target = getPlayerFromName(getPlayerName(element))
				if not getElementData(element, "gözbandajı") then
					triggerServerEvent("gozbagla",localPlayer,localPlayer,target)
				else
					triggerServerEvent("gozcoz",localPlayer,localPlayer,target)
				end
			end,},
			{"Kelepçele/Çıkar", function()
				local target = getPlayerFromName(getPlayerName(element))
				if not getElementData(element, "kelepce") then
					if exports["mrp_items"]:hasItem(localPlayer, 45) then
						triggerServerEvent("kelepcele",localPlayer,target,"ver")
					else
						outputChatBox("Bunu yapabilmek için kelepçeye ihtiyacınız var..", 255, 0, 0)
					end
				else
					triggerServerEvent("kelepcele",localPlayer,target,"al")
				end
			end,},
			{"Vazgeç", function()
			end,},
		}
	elseif type == 'ped' and element:getData('name') then
		pulledOptions = {
			{"Etkileşim", function()
				triggerEvent("npc:konus",localPlayer,element)
			end,},
			{"Vazgeç", function()
			end,},
		}
	end
end

Click.pullCharOptions = function()
	pulledCharOptions = {
		{"Karakter Değiştir", function()
			triggerServerEvent("karakterDegistirme", localPlayer)
			exports["mrp_auth"]:options_logOut(localPlayer)
		end,},
		{"Vazgeç", function()
		end,},
	}
end

addEventHandler('onClientClick', root, Click.constructor)
bindKey( "F10", "down", Click.character)

function toggleCursor()
    if (isCursorShowing()) then
        showCursor(false)
    else
        showCursor(true)
    end
end
addCommandHandler("togglecursor", toggleCursor)
bindKey("m", "down", "togglecursor")