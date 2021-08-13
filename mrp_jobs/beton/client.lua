local betonMarker = 0
local betonCreatedMarkers = {}
local betonRota = {
	{ 2288.396484375, -2071.4833984375, 13.385972976685 , false },--1
	{ 2205.9013671875, -2154.52734375, 13.3828125 , false },--1
	{ 2092.5908203125, -2107.5712890625, 13.32084941864 , false },--1
	{ 1971.5078125, -2107.2705078125, 13.3828125 , false },--1
	{ 1931.333984375, -2164.271484375, 13.3828125 , false },--1
	{ 1690.599609375, -2164.2314453125, 16.697750091553 , false },--1
	{ 1532.4345703125, -1978.1787109375, 22.722690582275 , false },--1
	{ 1511.212890625, -1869.720703125, 13.3828125 , false },--1
	{ 1362.921875, -1865.8037109375, 13.3828125 , false },--1
	{ 1139.9951171875, -1849.484375, 13.3828125 , false },--1
	{ 1019.521484375, -1793.720703125, 13.785205841064 , false },--1
	{ 825.544921875, -1766.87890625, 13.399476051331 , false },--1
	{ 624.078125, -1726.6025390625, 13.952794075012 , false },--1{ 0, 0, 0 , false },--1
	{ 370.0927734375, -1699.34765625, 7.0395479202271 , false },--1
	{ 165.4970703125, -1570.3642578125, 12.297170639038 , false },--1
	{ 37.0888671875, -1521.47265625, 5.2314605712891 , false },--1
	{ -124.7646484375, -1459.384765625, 2.6953125 , false },--1
	{ -145.578125, -1308.6767578125, 2.6953125 , false },--1
	{ -102.466796875, -1148.580078125, 1.5627844333649 , false },--1
	{  -69.046875, -1121.4638671875, 1.078125 , true},--25
}

local betony , betonz = -2055.0732421875, 13.546875 -- y ve z
local beton1x = 2330.8447265625 -- x1
local beton2x = 2330.8447265625 -- x2
local beton3x = 2330.8447265625 -- x3 3 tane alma noktası koydum rinadaki gibi y ve z ayrı
function betonBasla(cmd)
	if getElementData(getLocalPlayer(), "beton:yukaldi") == false or getElementData(getLocalPlayer(), "beton:yukaldi") == nil then
		local x , y , z = getElementPosition( localPlayer )
	if getDistanceBetweenPoints3D( beton1x , betony , betonz , x , y , z ) > 10 and getDistanceBetweenPoints3D( beton2x , betony , betonz , x , y , z ) > 10 and getDistanceBetweenPoints3D( beton3x , betony , betonz , x , y , z ) > 10 then
		outputChatBox("[!]#ffffff Bir yükleme noktasına yakın değilsin!",255,0,0,true)
		return
	end
	local carlicense = getElementData(localPlayer, "license.car")
	if carlicense == 0 then
		outputChatBox("[!]#ffffff Bu mesleği yapabilmek için ehliyetinizin olması gerekmektedir!",255,0,0,true)
	return end

		local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)	
			if oyuncuAracModel == 524 then
			if getPedOccupiedVehicleSeat(getLocalPlayer()) ~= 0 then return end
				setElementData(getLocalPlayer(), "beton:yukaldi", true)
				updatebetonRota()
				addEventHandler("onClientMarkerHit", resourceRoot, betonRotaMarkerHit)
				outputChatBox("[!]#ffffff Yükünü aldın, belirtilen rotayı takip edebilirsin!",0,153,255,true)
			else
				outputChatBox( "[!]#ffffff Gerekli araç modeline sahip değilsiniz!" ,255,0,0,true )
			end
	else
		outputChatBox("[!] #FFFFFFZaten mesleğe başladınız!", 255, 0, 0, true)
	end
end
addCommandHandler("cimentoyukle", betonBasla)

function updatebetonRota()
	betonMarker = betonMarker + 1
	for i,v in ipairs(betonRota) do
		if i == betonMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				table.insert(betonCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(betonCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(betonCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function betonRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 524 then
				for _, marker in ipairs(betonCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updatebetonRota()
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true) -- markerdan sonra ilk yazdığında bişey çıkmadı
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setElementData(getLocalPlayer(), "beton:yukaldi", false)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)									
									toggleAllControls(true)
									triggerServerEvent( "beton:paraver" , localPlayer )
									for i,v in ipairs(betonCreatedMarkers) do
										destroyElement(v[1])
									end
									betonCreatedMarkers = {}
									betonMarker = 0 -- oldu
									
								end, 10, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function betonBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local betonSoforlugu = getElementData(getLocalPlayer(), "beton:yukaldi")
	if pedVeh then
		if pedVehModel == 524 then
			if betonSoforlugu then
				setElementData(getLocalPlayer(), "beton:yukaldi", false)
				for i,v in ipairs(betonCreatedMarkers) do
					destroyElement(v[1])
				end
				betonCreatedMarkers = {}
				betonMarker = 0
				removeEventHandler("onClientMarkerHit", resourceRoot, betonRotaMarkerHit)
			end
		end
	end
end
addCommandHandler("cimentobitir", betonBitir)

function betonAntiYabanci(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)	
	if vehicleModel == 524 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("[!] #FFFFFFMeslek aracına binemezsiniz.", 255, 0, 0, true)
			cancelEvent()
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), betonAntiYabanci)

addEventHandler("onClientResourceStart" , root , function()
setElementData(getLocalPlayer(), "beton:yukaldi", false)
end)