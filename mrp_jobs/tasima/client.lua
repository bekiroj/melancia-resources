local kamyonMarker = 0
local tasimaCreatedMarkers = {}
local kamyonRota = {
	{ 2422.943359375, -2088.8701171875, 13.497517585754 , false },--1
	{ 2416.4619140625, -2024.3251953125, 13.837896347046 , false },--2
	{ 2415.59765625, -1944.505859375, 13.822632789612 , false },--3
	{ 2515.1787109375, -1935.1455078125, 13.812747001648 , false },--4
	{ 2679.314453125, -1935.1748046875, 13.740351676941 , false},--5
	{ 2712.03125, -2067.4306640625, 13.166911125183 , false},--6
	{ 2729.8759765625, -2166.9794921875, 11.365535736084 , false},--7
	{ 2821.2939453125, -2109.48046875, 11.365948677063 , false},--8
	{ 2835.787109375, -1967.4560546875, 11.374073028564 , false},--9
	{ 2841.92578125, -1814.3310546875, 11.311525344849 , false},--10
	{ 2874.1240234375, -1663.3359375, 11.311150550842 , false},--11
	{ 2886.0390625, -1123.6357421875, 11.310717582703 , false},--12
	{ 2892.0546875, -887.5693359375, 11.311595916748 , false},--13
	{ 2881.857421875, -531.54296875, 14.129968643188 , false},--14
	{ 2721.8291015625, -331.666015625, 27.286252975464 , false},--15
	{ 2775.1630859375, 0.2353515625, 35.436317443848 , false},--16
	{ 2754.2900390625, 255.85546875, 20.701026916504 , false},--17
	{ 2424.578125, 331.2861328125, 33.104610443115 , false},--18
	{ 2221.701171875, 327.359375, 33.148723602295 , false},--19
	{ 1937.4853515625, 310.228515625, 32.787494659424 , false},--20
	{ 1704.26953125, 375.986328125, 30.40549659729 , false},--21
	{ 1776.126953125, 598.2216796875, 22.831697463989 , false},--22
	{ 1802.43359375, 802.1318359375, 11.527328491211 , false},--23
	{ 1780.0126953125, 925, 9.1574249267578 , false},--24
	{  1739.7470703125, 969.677734375, 10.798028945923 , true},--25
}
local tasimay , tasimaz = -2119.6318359375, 13.546875 -- y ve z
local tasima1x = 2482.8603515625 -- x1
local tasima2x = 2459.0859375 -- x2
local tasima3x = 2508 -- x3 3 tane alma noktası koydum rinadaki gibi y ve z ayrı
function tasimaBasla(cmd)
	if getElementData(getLocalPlayer(), "tasima:yukaldi") == false or getElementData(getLocalPlayer(), "tasima:yukaldi") == nil then
		local x , y , z = getElementPosition( localPlayer )
	if getDistanceBetweenPoints3D( tasima1x , tasimay , tasimaz , x , y , z ) > 10 and getDistanceBetweenPoints3D( tasima2x , tasimay , tasimaz , x , y , z ) > 10 and getDistanceBetweenPoints3D( tasima3x , tasimay , tasimaz , x , y , z ) > 10 then
		outputChatBox("[!]#ffffff Bir yükleme noktasına yakın değilsin!",255,0,0,true)
		return
	end
	local carlicense = getElementData(localPlayer, "license.car")
	if carlicense == 0 then
		outputChatBox("[!]#ffffff Bu mesleği yapabilmek için ehliyetinizin olması gerekmektedir!",255,0,0,true)
	return end
		local oyuncuArac = getPedOccupiedVehicle(getLocalPlayer())
		local oyuncuAracModel = getElementModel(oyuncuArac)	
			if oyuncuAracModel == 414 then
			if getPedOccupiedVehicleSeat(getLocalPlayer()) ~= 0 then return end
				setElementData(getLocalPlayer(), "tasima:yukaldi", true)
				updateTasimaRota()
				addEventHandler("onClientMarkerHit", resourceRoot, tasimaRotaMarkerHit)
				outputChatBox("[!]#ffffff Yükünü aldın, belirtilen rotayı takip edebilirsin!",0,153,255,true)
			else
				outputChatBox( "[!]#ffffff Gerekli araç modeline sahip değilsiniz!" ,255,0,0,true )
			end
	else
		outputChatBox("[!] #FFFFFFZaten mesleğe başladınız!", 255, 0, 0, true)
	end
end
addCommandHandler("yukal", tasimaBasla)

function updateTasimaRota()
	kamyonMarker = kamyonMarker + 1
	for i,v in ipairs(kamyonRota) do
		if i == kamyonMarker then
			if not v[4] == true then
				local rotaMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 0, 0, 255, getLocalPlayer())
				table.insert(tasimaCreatedMarkers, { rotaMarker, false })
			elseif v[4] == true and v[5] == true then 
				local bitMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(tasimaCreatedMarkers, { bitMarker, true, true })	
			elseif v[4] == true then
				local malMarker = createMarker(v[1], v[2], v[3], "checkpoint", 4, 255, 255, 0, 255, getLocalPlayer())
				table.insert(tasimaCreatedMarkers, { malMarker, true, false })			
			end
		end
	end
end

function tasimaRotaMarkerHit(hitPlayer, matchingDimension)
	if hitPlayer == getLocalPlayer() then
		local hitVehicle = getPedOccupiedVehicle(hitPlayer)
		if hitVehicle then
			local hitVehicleModel = getElementModel(hitVehicle)
			if hitVehicleModel == 455 or hitVehicleModel == 414 then
				for _, marker in ipairs(tasimaCreatedMarkers) do
					if source == marker[1] and matchingDimension then
						if marker[2] == false then
							destroyElement(source)
							updateTasimaRota()
						elseif marker[2] == true and marker[3] == false then
							local hitVehicle = getPedOccupiedVehicle(hitPlayer)
							setElementFrozen(hitPlayer, true) -- markerdan sonra ilk yazdığında bişey çıkmadı
							setElementFrozen(hitVehicle, true)
							toggleAllControls(false, true, false)
							outputChatBox("[!] #FFFFFFAracınızdaki mallar indiriliyor, lütfen bekleyiniz.", 0, 0, 255, true)
							setElementData(getLocalPlayer(), "tasima:yukaldi", false)
							setTimer(
								function(thePlayer, hitVehicle, hitMarker)
									destroyElement(hitMarker)
									setElementFrozen(hitVehicle, false)
									setElementFrozen(thePlayer, false)									
									toggleAllControls(true)
									triggerServerEvent( "tasima:paraver" , localPlayer )
									for i,v in ipairs(tasimaCreatedMarkers) do
										destroyElement(v[1])
									end
									tasimaCreatedMarkers = {}
									kamyonMarker = 0 -- oldu
									
								end, 10, 1, hitPlayer, hitVehicle, source
							)						
						end
					end
				end
			end
		end
	end
end

function kamyonBitir()
	local pedVeh = getPedOccupiedVehicle(getLocalPlayer())
	local pedVehModel = getElementModel(pedVeh)
	local kamyonSoforlugu = getElementData(getLocalPlayer(), "tasima:yukaldi")
	if pedVeh then
		if pedVehModel == 455 then
			if kamyonSoforlugu then
				setElementData(getLocalPlayer(), "tasima:yukaldi", false)
				for i,v in ipairs(tasimaCreatedMarkers) do
					destroyElement(v[1])
				end
				tasimaCreatedMarkers = {}
				kamyonMarker = 0
				removeEventHandler("onClientMarkerHit", resourceRoot, kamyonRotaMarkerHit)
			end
		end
	end
end
addCommandHandler("tasimacilikbitir", kamyonBitir)

function tasimaAntiYabanci(thePlayer, seat, door) 
	local vehicleModel = getElementModel(source)	
	if vehicleModel == 414 then
		if thePlayer == getLocalPlayer() and seat ~= 0 then
			setElementFrozen(thePlayer, true)
			setElementFrozen(thePlayer, false)
			outputChatBox("[!] #FFFFFFMeslek aracına binemezsiniz.", 255, 0, 0, true)
			cancelEvent()
		end
	end
end
addEventHandler("onClientVehicleStartEnter", getRootElement(), tasimaAntiYabanci)

addEventHandler("onClientResourceStart" , root , function()
setElementData(getLocalPlayer(), "tasima:yukaldi", false)
end)