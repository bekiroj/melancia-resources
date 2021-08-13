copCars = {
[427] = true,
[490] = true,
[528] = true,
[523] = true,
[596] = true,
[597] = true,
[598] = true,
[599] = true,
[601] = true }

function onCopCarEnter(thePlayer, seat)
	if (seat < 2) and (thePlayer==getLocalPlayer()) then
		local model = getElementModel(source)
		if (copCars[model]) then
			setRadioChannel(0)
		end
	end
end
addEventHandler("onClientVehicleEnter", getRootElement(), onCopCarEnter)

function realisticWeaponSounds(weapon)
	local x, y, z = getElementPosition(getLocalPlayer())
	local tX, tY, tZ = getElementPosition(source)
	local distance = getDistanceBetweenPoints3D(x, y, z, tX, tY, tZ)
	
	if (distance<25) and (weapon>=22 and weapon<=34) then
		local randSound = math.random(27, 30)
		playSoundFrontEnd(randSound)
	end
end
addEventHandler("onClientPlayerWeaponFire", getRootElement(), realisticWeaponSounds)

function getElementSpeed(element,unit)
	if (unit == nil) then unit = 0 end
	if (isElement(element)) then
		local x,y,z = getElementVelocity(element)
		if (unit=="mph" or unit==1 or unit =='1') then
			return (x^2 + y^2 + z^2) ^ 0.5 * 100
		else
			return (x^2 + y^2 + z^2) ^ 0.5 * 1.61 * 100
		end
	else
		return false
	end
end

function setElementSpeed(element, unit, speed)
	if (unit == nil) then unit = 0 end
	if (speed == nil) then speed = 0 end
	speed = tonumber(speed)
	local acSpeed = getElementSpeed(element, unit)
	if (acSpeed~=false) then
		local diff = speed/acSpeed
		local x,y,z = getElementVelocity(element)
		setElementVelocity(element,x*diff,y*diff,z*diff)
		return true
	else
		return false
	end
end


function angle(vehicle)
	local vx,vy,vz = getElementVelocity(vehicle)
	local modV = math.sqrt(vx*vx + vy*vy)
	
	if not isVehicleOnGround(vehicle) then return 0,modV end
	
	local rx,ry,rz = getElementRotation(vehicle)
	local sn,cs = -math.sin(math.rad(rz)), math.cos(math.rad(rz))
	
	local cosX = (sn*vx + cs*vy)/modV

	return math.deg(math.acos(cosX))*0.5, modV
end

local viewDistance = 50
local lookTimer = { }
local scrWidth, scrHeight = guiGetScreenSize()
local sx = scrWidth/2
local sy = scrHeight/2
local sync_interval = 5000
local sync_last = getTickCount()
local nearby_npcs = { }
local nearby_vehs = { }
local nearby_players = { }

local function filterNearByPlayers()
	local filtered = {}
	for dbid, player in pairs(nearby_players) do
		if player and isElement(player) and isElementStreamedIn(player) and isElementOnScreen(player) and player ~= localPlayer then
			filtered[ getElementData(player, 'dbid') ] = player
		end
	end
	return filtered
end

function onClientLookAtRender()
	if not isPedOnFire(localPlayer) then
		local x, y, z = getWorldFromScreenPosition(sx, sy, viewDistance)
		setPedLookAt(localPlayer, x, y, z, -1, 500)
		-- sync local head to near by players
		if false and getTickCount() - sync_last > sync_interval then
			sync_last = getTickCount()
			local filtered = filterNearByPlayers()
			if exports.mrp_global:countTable(filtered) > 0 then
				triggerLatentServerEvent( 'realism:lookat:sync', localPlayer, filtered, { x, y, z } )
			end
		end
	end
end

function syncHeads(dir)
	if source and isElement(source) and isElementStreamedIn(source) then
		setPedLookAt(source, dir[1], dir[2], dir[3], -1, 0)
		outputDebugString(exports.mrp_global:getPlayerName(source)..": "..dir[1]..", "..dir[2]..", "..dir[3])
	end
end
addEvent( 'realism:lookat:sync', true )
addEventHandler( 'realism:lookat:sync' , root, syncHeads)

function lookAtClosestElement()
	local element = getClosestPlayer()
	if not element then
		element = getClosestPeds()
	end
	if not element then
		element = getClosestVehicle()
	end
	if element then
		setPedLookAt (localPlayer, 0, 0, 0, 3500, 1000, element)
	end
end

function getClosestPlayer()
	for dbid, player in pairs( nearby_players ) do
		local x,y,z = getElementPosition(player)			
		local cx,cy,cz = getCameraMatrix()
		local distance = getDistanceBetweenPoints3D(cx,cy,cz,x,y,z)
		if distance <= viewDistance and (player~=localPlayer) and getElementAlpha(player) == 255 then --Within radius viewDistance
			local px,py,pz = getScreenFromWorldPosition(x,y,z,0.05)
			if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then	
				return player
			end
		end
	end
end

function getClosestPeds()
	for dbid, player in pairs( nearby_npcs ) do
		if isElement(player) then
			local x,y,z = getElementPosition(player)
			local cx,cy,cz = getCameraMatrix()
			local distance = getDistanceBetweenPoints3D(cx,cy,cz,x,y,z)
			if distance <= viewDistance and (player~=localPlayer) then --Within radius viewDistance
				local px,py,pz = getScreenFromWorldPosition(x,y,z,0.05)
				if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then
					return player
				end
			end
		else
			nearby_npcs[dbid] = nil
		end
	end
end

function getClosestVehicle()
	for dbid, player in pairs( nearby_vehs ) do
		local x,y,z = getElementPosition(player)			
		local cx,cy,cz = getCameraMatrix()
		local distance = getDistanceBetweenPoints3D(cx,cy,cz,x,y,z)
		if distance <= viewDistance and (player~=localPlayer) then --Within radius viewDistance
			local px,py,pz = getScreenFromWorldPosition(x,y,z,0.05)
			if px and isLineOfSightClear(cx, cy, cz, x, y, z, true, false, false, true, true, false, false) then	
				return player
			end
		end
	end
end

addEventHandler('onClientElementStreamIn', root, function ()
	if getElementType(source) == 'ped' then
		nearby_npcs[ getElementData(source, 'dbid') ] = source
	elseif getElementType(source) == 'player' and source ~= localPlayer then
		nearby_players[ getElementData(source, 'dbid') ] = source
	elseif getElementType(source) == 'vehicle' then
		nearby_vehs[ getElementData(source, 'dbid') ] = source
	end
end)
addEventHandler('onClientElementStreamOut', root, function ()
	if getElementType(source) == 'ped' then
		nearby_npcs[ getElementData(source, 'dbid') ] = nil
	elseif getElementType(source) == 'player' and source ~= localPlayer then
		nearby_players[ getElementData(source, 'dbid') ] = nil
		-- remove look at target for nearby players.
		setPedLookAt (source, 0, 0, 0, 0 )
	elseif getElementType(source) == 'vehicle' then
		nearby_vehs[ getElementData(source, 'dbid') ] = nil
	end
end)

function npcLookAtYou()
	for dbid, npc in pairs(nearby_npcs) do
		if npc and isElement(npc) and isElementOnScreen(npc) then
			setPedLookAt ( npc, 0, 0, 0, 5000, 1000, localPlayer )
		end
	end
end

function updateLookAt()
	-- reset stuff
	setPedLookAt (localPlayer, 0, 0, 0, 0 )
	if lookTimer[1] and isTimer(lookTimer[1]) then
		killTimer(lookTimer[1])
		lookTimer[1] = nil
	end
	if lookTimer[2] and isTimer(lookTimer[2]) then
		killTimer(lookTimer[2])
		lookTimer[2] = nil
	end
	-- set stuff
	local state = tonumber(getElementData(localPlayer, "head_turning") or 0) or 0
	if state == 1 then
		lookAtClosestElement()
		lookTimer[1] = setTimer(lookAtClosestElement, 3000, 0)
	elseif state == 2 then
		onClientLookAtRender()
		lookTimer[2] = setTimer(onClientLookAtRender, 500, 0)
	end
end
addEvent("realism:updateLookAt", false)
addEventHandler( "realism:updateLookAt", root, updateLookAt )

addEventHandler( "onClientResourceStart", getResourceRootElement(getThisResource()),
    function ( startedRes )
		updateLookAt()
		setTimer(npcLookAtYou, 3000, 0)
    end
)

