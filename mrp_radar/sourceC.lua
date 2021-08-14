local screenX, screenY = guiGetScreenSize()
local screenW,screenH = guiGetScreenSize()
local mapTextureSize = 3072
local mapRatio = 6000 / mapTextureSize

toggleControl("radar", false)

renderTimers = {}

function createRender(id, func)
    if not isTimer(renderTimers[id]) then
        renderTimers[id] = setTimer(func, 0, 0)
    end
end

function destroyRender(id)
    if isTimer(renderTimers[id]) then
        killTimer(renderTimers[id])
        renderTimers[id] = nil
        collectgarbage("collect")
    end
end

local texture = nil

local minimap = 1

local blipanimation = true

renderTimers = {}

local hudVisible_ostate = getElementData( localPlayer, "hudVisible")
local keys_denied_ostate = getElementData( localPlayer, "keysDenied")


local optionMenuState = false
local optionMenuAnimationStart = nil
local isoptionMenuAnimation = false
local optionMenuAlpha = 0


navigatorSound = true
state3DBlip = thblipstate

function getZoneNameEx(x, y, z)
	local zone = getZoneName(x, y, z)
	if zone == 'East Beach' then
		return 'Bayrampasa'
	elseif zone == 'Ganton' then
		return 'Bagcılar'
	elseif zone == 'East Los Santos' then
		return 'Bayrampasa'
	elseif zone == 'Las Colinas' then
		return 'Catalca'
	elseif zone == 'Jefferson' then
		return 'Esenler'
	elseif zone == 'Glen Park' then
		return 'Esenler'
	elseif zone == 'Downtown Los Santos' then
		return 'Kagıthane'
	elseif zone == 'Commerce' then
		return 'Beyoglu'
	elseif zone == 'Market' then
		return 'Mecidiyeköy'
	elseif zone == 'Temple' then
		return '4. Levent'
	elseif zone == 'Vinewood' then
		return 'Kemerburgaz'
	elseif zone == 'Richman' then
		return '4. Levent'
	elseif zone == 'Rodeo' then
		return 'Sarıyer'
	elseif zone == 'Mulholland' then
		return 'Kemerburgaz'
	elseif zone == 'Red County' then
		return 'Kemerburgaz'
	elseif zone == 'Mulholland Intersection' then
		return 'Kemerburgaz'
	elseif zone == 'Los Flores' then
		return 'Sancak Tepe'
	elseif zone == 'Willowfield' then
		return 'Zeytinburnu'
	elseif zone == 'Playa del Seville' then
		return 'Zeytinburnu'
	elseif zone == 'Ocean Docks' then
		return 'İkitelli'
	elseif zone == 'Los Santos' then
		return 'İstanbul'
	elseif zone == 'Los Santos International' then
		return 'Atatürk Havalimanı'
	elseif zone == 'Jefferson' then
		return 'Esenler'
	elseif zone == 'Verdant Bluffs' then
		return 'Rümeli Hisarı'
	elseif zone == 'Verona Beach' then
		return 'Ataköy'
	elseif zone == 'Santa Maria Beach' then
		return 'Florya'
	elseif zone == 'Marina' then
		return 'Bakırköy'
	elseif zone == 'Idlewood' then
		return 'Güngören'
	elseif zone == 'El Corona' then
		return 'Kücükcekmece'
	elseif zone == 'Unity Station' then
		return 'Merter'
	elseif zone == 'Little Mexico' then
		return 'Taksim'
	elseif zone == 'Pershing Square' then
		return 'Taksim'
	elseif zone == 'Las Venturas' then
		return 'Edirne'
	else
		return zone
	end
end

function setNavigatorSound(state)
	navigatorSound = state
end

function getNavigatorSound()
	return navigatorSound
end

local textures = {}
_dxDrawImage = dxDrawImage
local function dxDrawImage(x,y,w,h,img, r, rx, ry, color, postgui)
    if type(img) == "string" then
        if not textures[img] then
            textures[img] = dxCreateTexture(img, "dxt5", true, "wrap")
        end
        img = textures[img]
    end
    return _dxDrawImage(x,y,w,h,img, r, rx, ry, color, postgui)
end

local Map_blips_timer = false
local Map_blips = {}
local Map_blips_radar = {}
local now_time = 0

local gps_anim_start = nil

local custom_blip_choosed_type = 0
local custom_blip_choosed = {"mark_1", "mark_2", "mark_3", "mark_4", "garage", "house", "vehicle"}

local hovered_blip = nil
local gps_icon_x,gps_icon_y = 20,15

local minimapPosX = 0
local minimapPosY = 0
local minimapWidth = 290
local minimapHeight = 195
local minimapCenterX = minimapPosX + minimapWidth / 2
local minimapCenterY = minimapPosY + minimapHeight / 2
local minimapRenderSize = 400
local minimapRenderHalfSize = minimapRenderSize * 0.5
local minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize,true)
local playerMinimapZoom = 0.3
local minimapZoom = playerMinimapZoom

local bigmapPosX = 30
local bigmapPosY = 30
local bigmapWidth = screenW - 60
local bigmapWidthRoot = bigmapWidth
local bigmapHeight = screenH - 100
local bigmapCenterX = bigmapPosX + bigmapWidth / 2
local bigmapCenterY = bigmapPosY + bigmapHeight / 2
local bigmapZoom = 0.5
bigmapIsVisible = false

local lastCursorPos = false
local mapDifferencePos = false
local mapMovedPos = false
local lastDifferencePos = false
local mapIsMoving = false
local lastMapPosX, lastMapPosY = 0, 0
local mapPlayerPosX, mapPlayerPosY = 0, 0

local zoneLineHeight = 25
local screenSource = dxCreateScreenSource(screenW, screenH)

local gpsLineWidth = 60
local gpsLineIconSize = 30
local gpsLineIconHalfSize = gpsLineIconSize / 2

occupiedVehicle = nil

local way_say ={
	["left"] = {"Sola dön "," sonra"},
	["right"] = {"Sağa dön "," sonra"},
	["forward"] = {"Düz devam et ","!"},
	["finish"] = {"Varış noktasına "," "},
	["around"] = {"Geri dön..",""},
}

local renderWidget = {}
renderWidget.__index = renderWidget

.minimap

createdBlips = {}
local mainBlips = {

}

local blipTooltips = {
	
}

local hoveredWaypointBlip = false

local farshowBlips = {}
local farshowBlipsData = {}

carCanGPSVal = 1
local gpsHello = false
local gpsLines = {}
local gpsRouteImage = false
local gpsRouteImageData = {}

local hover3DBlipCb = false

local playerCanSeePlayers = false

addCommandHandler("showplayers",
	function ()
		if getElementData(localPlayer, "admin_level") >= 3 then
			playerCanSeePlayers = not playerCanSeePlayers
		end
	end
)


function textureLoading()
	texture = dxCreateTexture( "assets/images/map.png")
	if not texture then
		setTimer(textureLoading,500,1)
	end
end

local save_data = {
	["3D"] = false,
	["Sounds"] = true,
	["Animation"] = true,
}

function jsonGETT(file)
    local fileHandle
    local jsonDATA = {}
    if not fileExists(file) then
        fileHandle = fileCreate(file)
        --local num = originalMaxLines
        --local x, y = sx/2, sy/2
        local save_data = {
            ["3D"] = false,
            ["Sounds"] = true,
            ["Animation"] = true,
        }
        fileWrite(fileHandle, toJSON(save_data))
        fileClose(fileHandle)
        fileHandle = fileOpen(file)
    else
        fileHandle = fileOpen(file)
    end
    if fileHandle then
        local buffer
        local allBuffer = ""
        while not fileIsEOF(fileHandle) do
            buffer = fileRead(fileHandle, 500)
            allBuffer = allBuffer..buffer
        end
        jsonDATA = fromJSON(allBuffer)
        fileClose(fileHandle)
    end
    return jsonDATA
end
 
function jsonSAVET(file, data)
    if fileExists(file) then
        fileDelete(file)
    end
    local fileHandle = fileCreate(file)
    fileWrite(fileHandle, toJSON(data))
    fileFlush(fileHandle)
    fileClose(fileHandle)
    return true
end

addEventHandler("onClientResourceStop", resourceRoot,
    function()
        local save_data = {
            ["3D"] = thblipstate,
            ["Sounds"] = navigatorSound,
            ["Animation"] = blipanimation,
        }
        jsonSAVET("@option.json", save_data)
    end
)

addEventHandler("onClientResourceStart", getResourceRootElement(),
	function ()
		--jsonCheck()
		setElementData(localPlayer, "hudVisible", true)
		save_data = jsonGETT("@option.json")
		thblipstate = save_data["3D"]
        toggle3DBlip(thblipstate)
		navigatorSound = save_data["Sounds"]
		blipanimation = save_data["Animation"]
		
		textureLoading()
		if getPedOccupiedVehicle( localPlayer ) then
			occupiedVehicle = getPedOccupiedVehicle( localPlayer )
		end
		if texture then
			dxSetTextureEdge(texture, "border", tocolor(110, 158, 204,255))
		end

		if texture then
			dxSetTextureEdge(texture, "border", tocolor(110, 158, 204,255))
		end
		
		for k,v in ipairs(getElementsByType("blip")) do
			blipTooltips[v] = getElementData(v, "tooltipText")
		end		
		
		if getElementData( localPlayer, "loggedin") == 1 then
			minimapIsVisible = true
		else
			minimapIsVisible = false
		end

        if minimapIsVisible then
            createRender("renderWidget.minimap", renderWidget.minimap)
        else
            destroyRender("renderWidget.minimap")    
        end
		
		if occupiedVehicle then
			carCanGPS()
		end		
	end
)

addEventHandler("onClientElementDataChange", getRootElement(),
	function (dataName, oldValue)
		if source == occupiedVehicle then
			if dataName == "vehicle.GPS" then
				local dataValue = getElementData(source, dataName) or false
				
				if dataValue then
					carCanGPSVal = dataValue
				else
					if oldValue then
						carCanGPSVal = false
					end
				end
				
				if not carCanGPSVal then
					if getElementData(source, "gpsDestination") then
						endRoute()
					end
				end
			elseif dataName == "gpsDestination" then
				local dataValue = getElementData(source, dataName) or false
				
				if dataValue then
					
					gpsThread = coroutine.create(makeRoute)
					coroutine.resume(gpsThread, unpack(dataValue))
					waypointInterpolation = false
				else
					endRoute()
				end
			end
	
		elseif source == localPlayer and dataName == "inDeath" then
			if occupiedVehicle and getElementData( localPlayer,"inDeath") then
				occupiedVehicle = nil
			end
		end
        
       
		if getElementType(source) == "blip" and dataName == "tooltipText" then
			blipTooltips[source] = getElementData(source, dataName)
		end
	end
)

function getHudCursorPos()
	if isCursorShowing() then
		return getCursorPosition()
	end
	return false
end


reMap = function(value, low1, high1, low2, high2)
	return low2 + (value - low1) * (high2 - low2) / (high1 - low1)
end

local w_x, w_y, w_w, w_h = 0,0,0,0
local diagonal = 0

function roundedRectangle(x, y, w, h, borderColor, bgColor, postGUI)
	if (x and y and w and h) then
		if (not borderColor) then
			borderColor = tocolor(0, 0, 0, 180)
		end
		if (not bgColor) then
			bgColor = borderColor
        end
        
		dxDrawRectangle(x, y, w, h, bgColor, postGUI)
		dxDrawRectangle(x + 2, y - 1, w - 4, 1, borderColor, postGUI)
		dxDrawRectangle(x + 2, y + h, w - 4, 1, borderColor, postGUI)
		dxDrawRectangle(x - 1, y + 2, 1, h - 4, borderColor, postGUI)
		dxDrawRectangle(x + w, y + 2, 1, h - 4, borderColor, postGUI)
        
        dxDrawRectangle(x + 0.5, y + 0.5, 1, 2, borderColor, postGUI)
        dxDrawRectangle(x + 0.5, y + h - 1.5, 1, 2, borderColor, postGUI)
        dxDrawRectangle(x + w - 0.5, y + 0.5, 1, 2, borderColor, postGUI)
        dxDrawRectangle(x + w - 0.5, y + h - 1.5, 1, 2, borderColor, postGUI)
	end
end



function minimap()
	if bigmapIsVisible then return end
	if  tonumber(getElementData(localPlayer, "loggedin")) == 1 then 
	local font = exports['mrp_fonts']:getFont("RobotoB", 11)
	local font_small = exports["mrp_fonts"]:getFont("Roboto",8)
	sx, sy = guiGetScreenSize()
	enabled, w_x, w_y, w_w, w_h, sizable, turnable = true,5,sy-220,335,215
	 x, y, minimapWidth, minimapHeight = w_x, w_y, w_w, w_h
	 diagonal =  math.sqrt((w_w/2)^2+(w_h/2)^2)

	 local playerDimension = getElementDimension(localPlayer)
 
    
	 if playerDimension == 0 or playerDimension == 65000 or playerDimension == 33333 then
	

	if (minimapWidth > 445 or minimapHeight > 400) and minimapRenderSize < 800 then
		minimapRenderSize = 800
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize,true)
	end
	if minimapWidth <= 445 and minimapHeight <= 400 and minimapRenderSize > 600 then
		minimapRenderSize = 600
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize,true)
	end 
	if (minimapWidth > 325 or minimapHeight > 235) and minimapRenderSize < 600 then
		minimapRenderSize = 600
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize,true)
	end
	if minimapWidth <= 325 and minimapHeight <= 235 and minimapRenderSize > 400 then
		minimapRenderSize = 400
		minimapRenderHalfSize = minimapRenderSize * 0.5
		destroyElement(minimapRender)
		minimapRender = dxCreateRenderTarget(minimapRenderSize, minimapRenderSize,true)
	end
	
	if minimapPosX ~= x or minimapPosY ~= y then
		minimapPosX = x
		minimapPosY = y
	end
	
		minimapCenterX = minimapPosX + minimapWidth / 2
		minimapCenterY = minimapPosY + minimapHeight / 2
		local minimapRenderSizeOffset = minimapRenderSize * 0.75

		dxUpdateScreenSource(screenSource, true)

		if getKeyState("num_add") and playerMinimapZoom < 1.2 then
		if not occupiedVehicle then
			playerMinimapZoom = playerMinimapZoom + 0.01
			---calculateBlip() 
		end
		elseif getKeyState("num_sub") and playerMinimapZoom > 0.31 then
			if not occupiedVehicle then
				playerMinimapZoom = playerMinimapZoom - 0.01
				--calculateBlip() 
			end
		end

		minimapZoom = playerMinimapZoom

		playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)
		
		local cameraX, cameraY, _, faceTowardX, faceTowardY = getCameraMatrix()
		--cameraRotation = math.deg(math.atan2(faceTowardY - cameraY, faceTowardX - cameraX)) + 360 + 90
	
		remapPlayerPosX, remapPlayerPosY = remapTheFirstWay(playerPosX), remapTheFirstWay(playerPosY)
		

		dxDrawImageSection(minimapPosX - minimapRenderSize / 2 + minimapWidth / 2, minimapPosY - minimapRenderSize / 2 + minimapHeight / 2, minimapRenderSize, minimapRenderSize, remapTheSecondWay(playerPosX) - minimapRenderSize / minimapZoom / 2, remapTheFirstWay(playerPosY) - minimapRenderSize / minimapZoom / 2, minimapRenderSize / minimapZoom, minimapRenderSize / minimapZoom, texture)  
		--dxDrawRectangle(minimapPosX - minimapRenderSize / 2 + minimapWidth / 2, minimapPosY - minimapRenderSize / 2 + minimapHeight / 2 +65, 65, 65, tocolor(255,0,0,255))
		if gpsRouteImage then
			--dxSetRenderTarget(minimapRender)
			minimapRender:setAsTarget(true)
			dxSetBlendMode("add")
				dxDrawImage(minimapRenderSize / 2 + (remapTheFirstWay(playerPosX) - (gpsRouteImageData[1] + gpsRouteImageData[3] / 2)) * minimapZoom - gpsRouteImageData[3] * minimapZoom / 2, minimapRenderSize / 2 - (remapTheFirstWay(playerPosY) - (gpsRouteImageData[2] + gpsRouteImageData[4] / 2)) * minimapZoom + gpsRouteImageData[4] * minimapZoom / 2, gpsRouteImageData[3] * minimapZoom, -(gpsRouteImageData[4] * minimapZoom), gpsRouteImage, 180, 0, 0,  tocolor(61, 122, 188))
			dxSetBlendMode("blend")
			dxSetRenderTarget()

			dxSetBlendMode("add")
			dxDrawImage(minimapPosX - minimapRenderSize / 2 + minimapWidth / 2, minimapPosY - minimapRenderSize / 2 + minimapHeight / 2, minimapRenderSize, minimapRenderSize, minimapRender)
			dxSetBlendMode("blend")
		end	
		
		if not blipanimation then  renderBlip() end
		dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY - minimapRenderSizeOffset, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, minimapPosX - minimapRenderSizeOffset, minimapPosY - minimapRenderSizeOffset, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, screenSource)
		dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY + minimapHeight, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, minimapPosX - minimapRenderSizeOffset, minimapPosY + minimapHeight, minimapWidth + minimapRenderSizeOffset * 2, minimapRenderSizeOffset, screenSource)
		dxDrawImageSection(minimapPosX - minimapRenderSizeOffset, minimapPosY, minimapRenderSizeOffset, minimapHeight, minimapPosX - minimapRenderSizeOffset, minimapPosY, minimapRenderSizeOffset, minimapHeight, screenSource)
		dxDrawImageSection(minimapPosX + minimapWidth, minimapPosY, minimapRenderSizeOffset, minimapHeight, minimapPosX + minimapWidth, minimapPosY, minimapRenderSizeOffset, minimapHeight, screenSource)
		
		local playerArrowSize = 145 / (4 - minimapZoom) + 3
		local playerArrowHalfSize = playerArrowSize / 2
		_, _, playerRotation = getElementRotation(localPlayer)

		dxDrawOuterBorder(minimapPosX, minimapPosY, minimapWidth,minimapHeight, 2, tocolor(33, 33, 33, 180))
		dxDrawImage(minimapPosX, minimapPosY, minimapWidth, minimapHeight, 'assets/images/design/glow.png',0,0,0,tocolor(255,255,255,255))
		dxDrawImage(minimapPosX + 1, minimapPosY + minimapHeight - 23, 20,20, 'assets/images/design/location.png')

		--dxDrawRoundedRectangle(w_x-2,w_y-2,w_w+4,w_h+4,tocolor(0,0,0,255),tocolor( 0,0,0,255))
		local zoneName = getZoneNameEx(playerPosX, playerPosY, playerPosZ,false)
		local font_bold = exports['mrp_fonts']:getFont("BoldFont", 16)
		local text_width = dxGetTextWidth( zoneName, 0.7, font_bold )
		if w_w > text_width + 32 then 
			
			--dxDrawText(hexCode.." Location: #ffffff"..zoneName, minimapPosX, minimapPosY + minimapHeight, minimapPosX + minimapWidth - 10, minimapPosY + minimapHeight+zoneLineHeight, tocolor(255, 255, 255, 255), 1, font, "left", "center",false,false,false,true)
			dxDrawText(zoneName, minimapPosX+30, minimapPosY + minimapHeight-zoneLineHeight, minimapPosX + minimapWidth - 10, minimapPosY + minimapHeight, tocolor(200, 200, 200, 255), 0.7, font_bold, "left", "center",false,false,false,true)
		
		end

		if now_time <= getTickCount() then
			now_time = getTickCount()+30
			calculateBlip() 
		end

		if blipanimation then  renderBlip() end
		dxDrawImage(minimapCenterX - playerArrowHalfSize, minimapCenterY - playerArrowHalfSize, playerArrowSize, playerArrowSize, "assets/images/player.png", math.abs(360 - playerRotation))

		if w_w*0.81 > 300 then
			w_w = 300
		else
			w_w = w_w*0.6
		end
		w_y = w_y+5


		if w_x+gps_icon_x+gpsLineIconSize <= w_x+w_w then
			if gpsRoute or (not gpsRoute and waypointEndInterpolation) then
			
				if waypointEndInterpolation then
					local interpolationProgress = (getTickCount() - waypointEndInterpolation) / 1550
					interpolatePosition,interpolateAlpha = interpolateBetween(0, 150, 0, 75, 0, 0, interpolationProgress, "Linear") 
					
					dxDrawRectangle( w_x, w_y-5, w_w,60 ,tocolor(37,37,37,interpolateAlpha))
					dxDrawOuterBorder(w_x, w_y-5, w_w,60, 2, tocolor(61,122,188, interpolateAlpha))
					
					dxDrawImage(w_x+gps_icon_x , w_y+ gps_icon_y, gpsLineIconSize, gpsLineIconSize, "assets/images/gps/finish.png", 0, 0, 0, tocolor(255, 255, 255, interpolateAlpha))
					
					if interpolationProgress > 1 then
						waypointEndInterpolation = false
					end
				elseif nextWp then
					dxDrawRectangle( w_x, w_y-5, w_w,60 ,tocolor(37,37,37,255))
					dxDrawOuterBorder(w_x, w_y-5, w_w,60, 2, tocolor(61,122,188, 255))
					if currentWaypoint ~= nextWp and not tonumber(reRouting) then
						if nextWp > 1 then
							waypointInterpolation = {getTickCount(), currentWaypoint}
						end

						currentWaypoint = nextWp
					end
					
					if tonumber(reRouting) then
						currentWaypoint = nextWp
					

						local reRouteProgress = (getTickCount() - reRouting) / 1250
						local refreshAngle_1, refreshAngle_2 = interpolateBetween(360, 0, 0, 0, 360, 0, reRouteProgress, "Linear")

						dxDrawImage(w_x+gps_icon_x , w_y+ gps_icon_y, gpsLineIconSize, gpsLineIconSize, "assets/images/gps/circleout.png", refreshAngle_1,0,0,tocolor( 200,200,200,firstAlpha))
						dxDrawImage(w_x+gps_icon_x , w_y+ gps_icon_y, gpsLineIconSize, gpsLineIconSize, "assets/images/gps/circlein.png", refreshAngle_2,0,0,tocolor( 200,200,200,firstAlpha))
						dxDrawText(way_say["around"][1]..""..way_say["around"][2],  w_x+70,w_y,  w_x+70+100, w_y+55, tocolor(200,200,200, firstAlpha), 1,1, font, "left", "center")
					

						local msg_length = {dxGetTextWidth(way_say["around"][1]..""..way_say["around"][2], 1,font),dxGetTextWidth(way_say["around"][1].."\n"..way_say["around"][2], 1,font)}
						if  w_x+70+msg_length[1]+2 < w_x+w_w then
							dxDrawText(way_say["around"][1]..""..way_say["around"][2],  w_x+70,w_y,  w_x+70+100, w_y+55, tocolor(200,200,200, firstAlpha), 1,1, font, "left", "center")
						elseif w_x+70+msg_length[2]+2 < w_x+w_w then
							dxDrawText(way_say["around"][1].."\n"..way_say["around"][2],  w_x+70,w_y,  w_x+70+100, w_y+55, tocolor(200,200,200, firstAlpha), 1,1, font, "left", "center")
						end

						if reRouteProgress > 1 then
							reRouting = getTickCount()
						end
					elseif turnAround then
						currentWaypoint = nextWp
							if not gps_anim_start then gps_anim_start = getTickCount() end
						local startPolation, endPolation = (getTickCount() - gps_anim_start) / 600, 0
						local firstAlpha = interpolateBetween(0,0,0, 255,0,0,startPolation, "Linear")

						dxDrawImage(w_x+gps_icon_x , w_y+ gps_icon_y, gpsLineIconSize, gpsLineIconSize, "assets/images/gps/around.png",0,0,0,tocolor( 200,200,200,firstAlpha))
						local msg_length = {dxGetTextWidth(way_say["around"][1]..""..way_say["around"][2], 1,font),dxGetTextWidth(way_say["around"][1].."\n"..way_say["around"][2], 1,font)}
						if  w_x+70+msg_length[1]+2 < w_x+w_w then
							dxDrawText(way_say["around"][1]..""..way_say["around"][2],  w_x+70,w_y,  w_x+70+100, w_y+55, tocolor(200,200,200, firstAlpha), 1,1, font, "left", "center")
						elseif w_x+70+msg_length[2]+2 < w_x+w_w then
							dxDrawText(way_say["around"][1].."\n"..way_say["around"][2],  w_x+70,w_y,  w_x+70+100, w_y+55, tocolor(200,200,200, firstAlpha), 1,1, font, "left", "center")
						end

						

					elseif not waypointInterpolation then
						dxDrawImage(w_x+gps_icon_x , w_y+gps_icon_y, gpsLineIconSize, gpsLineIconSize, "assets/images/gps/" .. gpsWaypoints[nextWp][2] .. ".png",0,0,0,tocolor(200,200,200,255))
						if gps_anim_start then gps_anim_start = nil end
						
							local root_distance = math.floor((gpsWaypoints[nextWp][3] or 0) / 10) * 10
							local msg = {{"",""},{"",""},{"",""}}

							if root_distance >= 1000 then
								root_distance = math.round((root_distance/1000),1,"floor")
								msg[1][1] = root_distance.. " kilometre"
								msg[1][2] = way_say[gpsWaypoints[nextWp][2]][1]..""..root_distance.. " kilometre"..way_say[gpsWaypoints[nextWp][2]][2]
								msg[2] = root_distance.. " kilometre"
								msg[3][1] = root_distance.. " km\n"
							else
								msg[1][1] = root_distance.. " metre"
								msg[1][2] = way_say[gpsWaypoints[nextWp][2]][1]..""..root_distance.. " metre"..way_say[gpsWaypoints[nextWp][2]][2]
								msg[2] = root_distance.. " metre"
								msg[3] = root_distance.. " m\n"
							end
							local msg_length = {dxGetTextWidth(msg[1][2], 1,font_small),dxGetTextWidth(msg[2], 1,font),dxGetTextWidth(msg[3], 1,font)}
							if w_x+70+msg_length[1]+2 < w_x+w_w then
								dxDrawText(msg[1][1],  w_x+70,w_y,  w_x+70+100, w_y+40, tocolor(200,200,200, 255), 1,1, font, "left", "center")
								dxDrawText(msg[1][2],  w_x+70,w_y+40,  w_x+70+100, w_y+45, tocolor(150, 150, 150, 255), 1,1, font_small, "left", "center")
							elseif  w_x+70+msg_length[2]+2 < w_x+w_w then
								dxDrawText(msg[2],  w_x+70,w_y,  w_x+70+100, w_y+40, tocolor(200,200,200, 255), 1,1, font, "left", "center")
							elseif  w_x+70+msg_length[3]+2 < w_x+w_w then
								dxDrawText(msg[3],  w_x+70,w_y,  w_x+70+100, w_y+40, tocolor(200,200,200, 255), 1,1, font, "left", "center")
							end
						

					else
						local startPolation, endPolation = (getTickCount() - waypointInterpolation[1]) / 1000, 0
						local firstAlpha,mover_x,mover_y = interpolateBetween(255,10,0, 0,gps_icon_x,gps_icon_y,startPolation, "Linear")
						
						--dxDrawImage(w_x+gps_icon_x, w_y+ gps_icon_y-mover_y, gpsLineIconSize, gpsLineIconSize, "assets/images/gps/" .. gpsWaypoints[waypointInterpolation[2]][2] .. ".png",0,0,0,tocolor(200,200,200,firstAlpha))
						
						local root_distance = math.floor((gpsWaypoints[nextWp][3] or 0) / 10) * 10
							local msg = {{"",""},{"",""},{"",""}}

							if root_distance >= 1000 then 
								root_distance = math.round((root_distance/1000),1,"floor")
								msg[1][1] = root_distance.. " kilometre"
								msg[1][2] = way_say[gpsWaypoints[waypointInterpolation[2]][2]][1]..""..root_distance.. " kilometre"..way_say[gpsWaypoints[waypointInterpolation[2]][2]][2]
								msg[2] = root_distance.. " kilometre"
								msg[3] = root_distance.. " km\n"	
							else
								msg[1][1] = root_distance.. " metre"
								msg[1][2] = way_say[gpsWaypoints[waypointInterpolation[2]][2]][1]..""..root_distance.. " metre"..way_say[gpsWaypoints[waypointInterpolation[2]][2]][2]
								msg[2] = root_distance.. " metre"
								msg[3] = root_distance.. " m\n"
							end
							local msg_length = {dxGetTextWidth(msg[1][2], 1,font_small),dxGetTextWidth(msg[2], 1,font),dxGetTextWidth(msg[3], 1,font)}
							if w_x+70+msg_length[1]+2 < w_x+w_w then
								dxDrawText(msg[1][1],  w_x+70,w_y-mover_y,  w_x+70+100, w_y+40-mover_y, tocolor(200,200,200, firstAlpha), 1,1, font, "left", "center")
								dxDrawText(msg[1][2],  w_x+70,w_y-mover_y+40,  w_x+70+100, w_y+45-mover_y, tocolor(150, 150, 150, firstAlpha), 1,1, font_small, "left", "center")
							elseif  w_x+70+msg_length[2]+2 < w_x+w_w then
								dxDrawText(msg[2],  w_x+70,w_y-mover_y,  w_x+70+100, w_y+40-mover_y, tocolor(200,200,200, firstAlpha), 1,1, font, "left", "center")
								elseif  w_x+70+msg_length[3]+2 < w_x+w_w then
								dxDrawText(msg[3],  w_x+70,w_y-mover_y,  w_x+70+100, w_y+40-mover_y, tocolor(200,200,200, firstAlpha), 1,1, font, "left", "center")
							end

						if gpsWaypoints[waypointInterpolation[2] + 1] then
												
							dxDrawImage(w_x+gps_icon_x-(gps_icon_x-mover_x), w_y+ gps_icon_y, gpsLineIconSize, gpsLineIconSize, "assets/images/gps/" .. gpsWaypoints[waypointInterpolation[2]+1][2] .. ".png",0,0,0,tocolor(200,200,200,255-firstAlpha))
							
							
							local root_distance = math.floor((gpsWaypoints[nextWp][3] or 0) / 10) * 10
							local msg = {{"",""},{"",""},{"",""}}

							if root_distance >= 1000 then 
								root_distance = math.round((root_distance/1000),1,"floor")
								msg[1][1] = root_distance.. " kilometre"
								msg[1][2] = way_say[gpsWaypoints[waypointInterpolation[2]+1][2]][1]..""..root_distance.. " kilometre"..way_say[gpsWaypoints[waypointInterpolation[2]+1][2]][2]
								msg[2] = root_distance.. " kilometre"
								msg[3] = root_distance.. " km\n"	
							else
								msg[1][1] = root_distance.. " metre"
								msg[1][2] = way_say[gpsWaypoints[waypointInterpolation[2]+1][2]][1]..""..root_distance.. " kilometre"..way_say[gpsWaypoints[waypointInterpolation[2]+1][2]][2]
								msg[2] = root_distance.. " metre"
								msg[3] = root_distance.. " m\n"
							end
							local msg_length = {dxGetTextWidth(msg[1][2], 1,font),dxGetTextWidth(msg[2], 1,font_small),dxGetTextWidth(msg[3], 1,font)}
							if w_x+70+msg_length[1]+2 < w_x+w_w then
								dxDrawText(msg[1][1],  w_x+70,w_y+gps_icon_y-mover_y,  w_x+70+100, w_y+40+gps_icon_y-mover_y, tocolor(200,200,200, 255-firstAlpha), 1,1, font, "left", "center")
								dxDrawText(msg[1][2],  w_x+70,w_y+gps_icon_y+40-mover_y,  w_x+70+100, w_y+45+gps_icon_y-mover_y, tocolor(150, 150, 150, 255-firstAlpha), 1,1, font_small, "left", "center")
							elseif  w_x+70+msg_length[2]+2 < w_x+w_w then
								dxDrawText(msg[2],  w_x+70,w_y+gps_icon_y-mover_y,  w_x+70+100, w_y+40+gps_icon_y-mover_y, tocolor(200,200,200, 255-firstAlpha), 1,1, font, "left", "center")
								elseif  w_x+70+msg_length[3]+2 < w_x+w_w then
								dxDrawText(msg[3],  w_x+70,w_y+gps_icon_y-mover_y,  w_x+70+100, w_y+40+gps_icon_y-mover_y, tocolor(200,200,200, 255-firstAlpha), 1,1, font, "left", "center")
							end
						end
						
						if startPolation > 1 then
							endPolation = (getTickCount() - waypointInterpolation[1] - 750) / 500
						end
						
						if endPolation > 1 then
							waypointInterpolation = false
						end
					end
				end
			end 
		end
    else
        if not enabled then return end 
        
        if minimapPosX ~= x or minimapPosY ~= y then
            minimapPosX = x
            minimapPosY = y
        end
        
        local alpha = interpolateBetween(0, 0, 0, 255, 0, 0, getTickCount() / 5000, "SineCurve")
        minimapCenterX = minimapPosX + minimapWidth / 2
        minimapCenterY = minimapPosY + minimapHeight / 2
        dxDrawOuterBorder(minimapPosX, minimapPosY, minimapWidth,minimapHeight, 2, tocolor(33, 33, 33, 180))
        dxDrawRectangle(minimapPosX, minimapPosY, minimapWidth,minimapHeight, tocolor(20, 20, 20, 255))
        
        local startX, startY = minimapPosX + 15, minimapPosY + 15
        local _startX, _startY = startX, startY
        local between1, between2 = 25, 25
        local columns = math.floor((minimapWidth - 15) / between1)
        local lines = math.floor((minimapHeight - 15) / between2)
        local nowColumn = 1
        local nowLine = 1
        
        for i = 1, columns * lines do 
            dxDrawRectangle(startX, startY, 2, 2, tocolor(6, 6, 6, 255))
            startX = startX + between1
            
            nowColumn = nowColumn + 1
            if nowColumn > columns then
                nowColumn = 1
                nowLine = nowLine + 1
                startX = _startX
                startY = startY + between2
            end
        end
        
        local between1, between2 = 5, 5
        local columns = math.floor((minimapWidth - 15) / between1)
        local lines = math.floor((minimapHeight - 15) / between2)
        
        local columns = math.max(2, math.floor(columns * 0.1))
        if columns % 2 == 1 then
            columns = columns + 1
        end
        for i = 1, columns do
            if i % 2 == 1 then
                --outputChatBox("asd")
                local x = interpolateBetween(0, 0, 0, minimapWidth, 0, 0, getTickCount() / (20000 * (i / columns)), "SineCurve")
                dxDrawRectangle(minimapPosX + x, minimapPosY, 2, minimapHeight, tocolor(6, 6, 6, 255))
            else
                --outputChatBox("asd2")
                local x = interpolateBetween(2, 0, 0, minimapWidth, 0, 0, getTickCount() / (20000 * (i / columns)), "SineCurve")
                dxDrawRectangle((minimapPosX + minimapWidth) - x, minimapPosY, 2, minimapHeight, tocolor(6, 6, 6, 255))
            end
        end
        
        local lines = math.max(2, math.floor(lines * 0.1))
        if lines % 2 == 1 then
            lines = lines + 1
        end
        for i = 1, lines do
            if i % 2 == 1 then
                local y = interpolateBetween(0, 0, 0, minimapHeight, 0, 0, getTickCount() / (20000 * (i / lines)), "SineCurve")
                dxDrawRectangle(minimapPosX, minimapPosY + y, minimapWidth, 2, tocolor(6, 6, 6, 255))
            else
                local y = interpolateBetween(2, 0, 0, minimapHeight, 0, 0, getTickCount() / (20000 * (i / lines)), "SineCurve")
                dxDrawRectangle(minimapPosX, (minimapPosY + minimapHeight) - y, minimapWidth, 2, tocolor(6, 6, 6, 255))
            end
        end
        
        local r,g,b = 255,46,46
        local font = exports['mrp_fonts']:getFont("RobotoB", 13)
        local startY = -(60/2 + dxGetFontHeight(1, font)/2)
        dxDrawImage(minimapCenterX - 60/2, minimapCenterY + startY, 60, 60, "assets/images/lostConnection.png", 0, 0, 0, tocolor(r, g, b, alpha))
        startY = startY + 60 + 5 + dxGetFontHeight(1, font)/2
        dxDrawText("Bağlantı Kayboldu...", minimapCenterX, minimapCenterY + startY, minimapCenterX, minimapCenterY + startY, tocolor(r, g, b, alpha), 1, font, "center", "center")
		end
	end
end
--addEventHandler("onClientRender",root,minimap, true, "low-1")

createRender("minimap",minimap)

setTimer(
    function()
        local x,y,z = getElementPosition(localPlayer)
        lostConnection = not isLineOfSightClear(x,y,z,x,y,z+50, true, false, false, false, false)
    end, 300, 0
)

local lastClick = 1
local locations = {
	[1] = {
		text = "Hediye Bölgesi",
		blipSelectedID = 51,
		blipSize = 1,
		x = 1128.9473876953, 
		y = -1489.0773925781, 
		z = 22.753429412842
	},
	[2] = {
		text = "Kamyoncu Mesleği",
		blipSelectedID = 68,
		blipSize = 1,
		x = 99.4296875, 
		y = -1541.2080078125, 
		z =  6.4078483581543
	},
	[3] = {
		text = "Dondurmacı Mesleği",
		blipSelectedID = 38,
		blipSize = 1,
		x = 99.4296875, 
		y = -1541.2080078125, 
		z =  6.4078483581543	
	},
	[4] = {
		text = "Los Santos Bankası",
		blipSelectedID = 52,
		blipSize = 1,
		x = 1457.1572265625, 
		y = -1009.8046875, 
		z = 27.207847595215
	},
	[5] = {
		text = "Oduncu Mesleği",
		blipSelectedID = 39,
		blipSize = 1,
		x = -350.11328125, 
		y = -1035.8984375, 
		z = 60.707851409912
	},
	[6] = {
		text = "Casino",
		blipSelectedID = 73,
		blipSize = 1,
		x = 1250.38671875, 
		y = -1581.7431640625, 
		z = 13.207857131958
	},
	[7] = {
		text = "Los Santos Dorm",
		blipSelectedID = 58,
		blipSize = 1,
		x = 1296.0458984375,
		y = -1424.865234375, 
		z = 14.953125
	},
	[8] = {
		text = "/birlikkur",
		blipSelectedID = 19,
		blipSize = 1,
		x = 1380.8447265625, 
		y = -1088.904296875, 
		z = 27.384355545044
	}	
}

function renderTheBigmap()
	if not bigmapIsVisible then return end
	local font = exports['mrp_fonts']:getFont("Roboto", 10)
	local zoneName = getZoneNameEx(playerPosX, playerPosY, playerPosZ,true)
	if hoveredWaypointBlip then
		hoveredWaypointBlip = false
	end
	
	 _, _, playerRotation = getElementRotation(localPlayer)
		
	
	if getElementDimension(localPlayer) == 0 then
		playerPosX, playerPosY, playerPosZ = getElementPosition(localPlayer)

		cursorX, cursorY = getHudCursorPos()
		if cursorX and cursorY then
			cursorX, cursorY = cursorX * screenW, cursorY * screenH

			
			if getKeyState("mouse1") and cursorX>= bigmapPosX and cursorX<= bigmapPosX+bigmapWidth and cursorY>= bigmapPosY and cursorY<= bigmapPosY+bigmapHeight then
				if not lastCursorPos then
					lastCursorPos = {cursorX, cursorY}
				end
				
				if not mapDifferencePos then
					mapDifferencePos = {0, 0}
				end
				
				if not lastDifferencePos then
					if not mapMovedPos then
						lastDifferencePos = {0, 0}
					else
						lastDifferencePos = {mapMovedPos[1], mapMovedPos[2]}
					end
				end
				
				mapDifferencePos = {mapDifferencePos[1] + cursorX - lastCursorPos[1], mapDifferencePos[2] + cursorY - lastCursorPos[2]}
				
				if not mapMovedPos then
					if math.abs(mapDifferencePos[1]) >= 3 or math.abs(mapDifferencePos[2]) >= 3 then
						mapMovedPos = {lastDifferencePos[1] - mapDifferencePos[1] / bigmapZoom, lastDifferencePos[2] + mapDifferencePos[2] / bigmapZoom}
						mapIsMoving = true
					end
				elseif mapDifferencePos[1] ~= 0 or mapDifferencePos[2] ~= 0 then
					mapMovedPos = {lastDifferencePos[1] - mapDifferencePos[1] / bigmapZoom, lastDifferencePos[2] + mapDifferencePos[2] / bigmapZoom}
					mapIsMoving = true
				end
	
				lastCursorPos = {cursorX, cursorY}
			else
				if mapMovedPos then
					lastDifferencePos = {mapMovedPos[1], mapMovedPos[2]}
				end
				
				lastCursorPos = false
				mapDifferencePos = false
			end
		end
		
		mapPlayerPosX, mapPlayerPosY = lastMapPosX, lastMapPosY
		
		if mapMovedPos then
			mapPlayerPosX = mapPlayerPosX + mapMovedPos[1]
			mapPlayerPosY = mapPlayerPosY + mapMovedPos[2]
		else
			mapPlayerPosX, mapPlayerPosY = playerPosX, playerPosY
			lastMapPosX, lastMapPosY = mapPlayerPosX, mapPlayerPosY
		end
		
		dxDrawImageSection(bigmapPosX, bigmapPosY, bigmapWidth, bigmapHeight, remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2, remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2, bigmapWidth / bigmapZoom, bigmapHeight / bigmapZoom, texture)
		dxDrawImage(bigmapPosX, bigmapPosY, bigmapWidth, bigmapHeight, 'assets/images/design/vignetta.png',0,0,0, tocolor(255, 255, 255, 255))
		
		if gpsRouteImage then
			dxUpdateScreenSource(screenSource, true)
			dxSetBlendMode("add")
				dxDrawImage(bigmapCenterX + (remapTheFirstWay(mapPlayerPosX) - (gpsRouteImageData[1] + gpsRouteImageData[3] / 2)) * bigmapZoom - gpsRouteImageData[3] * bigmapZoom / 2, bigmapCenterY - (remapTheFirstWay(mapPlayerPosY) - (gpsRouteImageData[2] + gpsRouteImageData[4] / 2)) * bigmapZoom + gpsRouteImageData[4] * bigmapZoom / 2, gpsRouteImageData[3] * bigmapZoom, -(gpsRouteImageData[4] * bigmapZoom), gpsRouteImage, 180, 0, 0, tocolor(61, 122, 188))
			dxSetBlendMode("blend")
			dxDrawImageSection(0, 0, bigmapPosX, screenH, 0, 0, bigmapPosX, screenH, screenSource)
			dxDrawImageSection(screenW - bigmapPosX, 0, bigmapPosX, screenH, screenW - bigmapPosX, 0, bigmapPosX, screenH, screenSource)
			dxDrawImageSection(bigmapPosX, 0, screenW - 2 * bigmapPosX, bigmapPosY, bigmapPosX, 0, screenW - 2 * bigmapPosX, bigmapPosY, screenSource)
			dxDrawImageSection(bigmapPosX, screenH - bigmapPosY, screenW - 2 * bigmapPosX, bigmapPosY, bigmapPosX, screenH - bigmapPosY, screenW - 2 * bigmapPosX, bigmapPosY, screenSource)
		end
					

		dxDrawRectangle(bigmapPosX, bigmapPosY + bigmapHeight, bigmapWidth,zoneLineHeight, tocolor(40, 40, 40, 230))
		dxDrawOuterBorder(bigmapPosX, bigmapPosY, bigmapWidth, bigmapHeight+zoneLineHeight, 2, tocolor(40, 40, 40, 230))



		if not Map_blips_timer then
			Map_blips_timer = setTimer( calculateBlipRadar, 50, 1) 
		end

		renderBlipRadar()

		
		cursorX, cursorY = getHudCursorPos()
		if cursorX and cursorY then cursorX, cursorY = cursorX * screenW, cursorY * screenH end

		if cursorX and cursorY and cursorX> bigmapPosX and cursorX< bigmapPosX+bigmapWidth and cursorY> bigmapPosY and cursorY< bigmapPosY+bigmapHeight then
			--if getCursorAlpha() ~= 0 then setCursorAlpha(0) end
			if custom_blip_choosed_type == 0 then 	
				setCursorAlpha(255)
				--dxDrawImage( cursorX-128/2+4, cursorY-128/2-1, 128, 128, "assets/images/design/cross.png")
			else
				local width,height = (12/ (4 - bigmapZoom) + 3) * 2.25,(12 / (4 - bigmapZoom) + 3) * 2.25
				dxDrawImage(cursorX-width/2, cursorY-height/2, width, height, "assets/images/blips/"..custom_blip_choosed[custom_blip_choosed_type]..".png")
			end
		elseif cursorX and cursorY then  
		--if getCursorAlpha() == 0 then setCursorAlpha(255) end
		end


		local font_big = exports["mrp_fonts"]:getFont("Roboto",11)
		local font_awesome = exports["mrp_fonts"]:getFont("FontAwesome",10)

		local f11blipFont = exports["mrp_fonts"]:getFont("RobotoB",10)


		local textWidth = dxGetTextWidth(locations[1].text, 1, "default")
		local widthBlip, heightBlip = 95, 30
		local x = screenX - 110
		local y = 40
		local renk = tocolor(0, 0, 0, 130)
		
		for i=1, #locations do
			local row = locations[i]
			if row then
				local xx,yy = x, y+((i-1)*36)
					dxDrawRectangle(xx-(25+textWidth),yy, widthBlip+textWidth, heightBlip, renk)
					dxDrawText(locations[i].text, xx+90*2, yy+5, xx+30, 24+yy, tocolor(255, 255, 255), 1, f11blipFont, "right", "center")
					dxDrawImage(xx+96/2-16/2, yy+24/2-16/2, 20, 20, "assets/images/blips/"..locations[i].blipSelectedID..".png")
				if inArea(xx-64, yy, 81, 24) then
					if getKeyState("mouse1") and lastClick+200 <= getTickCount() then						
						alreadyBlip = createBlip(locations[i].x, locations[i].y, locations[i].z, locations[i].blipSelectedID, locations[i].blipSize, 255, 0, 0, 255, 0, 300)
						lastClick = getTickCount()
						exports["mrp_infobox"]:addBox("success", "Başarıyla "..locations[i].text.." isimli bölgeyi haritada işaretlediniz.")
					end
				end
			end
		end

		dxDrawText("Ayarlar", bigmapPosX+bigmapWidth-80, bigmapPosY + bigmapHeight, 0,bigmapPosY + bigmapHeight + zoneLineHeight, tocolor(200,200,200,230), 1, font_big, "left", "center")
		
		local options_color = -3618616
		if inText(bigmapPosX+bigmapWidth-30, bigmapPosY + bigmapHeight+2, bigmapPosX+bigmapWidth-15,bigmapPosY + bigmapHeight + zoneLineHeight-4) then
			options_color = tocolor(124,197,118)
		end


		dxDrawText("⚙️", bigmapPosX+bigmapWidth-30, bigmapPosY + bigmapHeight, bigmapPosX+bigmapWidth-10,bigmapPosY + bigmapHeight + zoneLineHeight, options_color, 1, font_awesome, "center", "center")
		

		if optionMenuState or isoptionMenuAnimation then
			local alpha = math.max(optionMenuAlpha,25)-25
			local alpha_2 = math.max(optionMenuAlpha,135)-135
			local alpha_3 = math.max(optionMenuAlpha,55)-55
			local alpha_4 = math.max(optionMenuAlpha,35)-35
			dxDrawOuterBorder(bigmapPosX+bigmapWidth+25,bigmapPosY+bigmapHeight-120,200,120, 2, tocolor(40, 40, 40, alpha_2))
			dxDrawRectangle(bigmapPosX+bigmapWidth+25,bigmapPosY+bigmapHeight-120,200,120,tocolor(40,40,40,alpha))
			
			dxDrawText("Radar Ayarları",bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-120,bigmapPosX+bigmapWidth+30+200,bigmapPosY+bigmapHeight-90,tocolor(200,200,200,alpha),1,font_big,"center","center")
			


			


			dxDrawRectangle(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-90,190,25,tocolor(50,50,50,alpha_3))
			if inArea(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-90,190,25) then				
				dxDrawOuterBorder(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-90,190,25,1,tocolor(255,255,255,alpha_3))
			end
			dxDrawText("3D Blip",bigmapPosX+bigmapWidth+55,bigmapPosY+bigmapHeight-90,bigmapPosX+bigmapWidth+30+190,bigmapPosY+bigmapHeight-90+25,tocolor(200,200,200,alpha_4),1,font_big,"left","center")
			if thblipstate then
				dxDrawText("✔️", bigmapPosX+bigmapWidth+30+3,bigmapPosY+bigmapHeight-90,bigmapPosX+bigmapWidth+30+190,bigmapPosY+bigmapHeight-90+25, tocolor(124,197,118,alpha), 1, font_awesome, "left", "center")
			else
				dxDrawText("✖", bigmapPosX+bigmapWidth+30+5,bigmapPosY+bigmapHeight-90,bigmapPosX+bigmapWidth+30+190,bigmapPosY+bigmapHeight-90+25, tocolor(210,49,49,alpha), 1, font_awesome, "left", "center")
			end

			
			dxDrawRectangle(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-60,190,25,tocolor(50,50,50,alpha_3))
			if inArea(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-60,190,25) then				
				dxDrawOuterBorder(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-60,190,25,1,tocolor(255,255,255,alpha_3))
			end
			dxDrawText("GPS Sesleri",bigmapPosX+bigmapWidth+55,bigmapPosY+bigmapHeight-60,bigmapPosX+bigmapWidth+30+190,bigmapPosY+bigmapHeight-60+25,tocolor(200,200,200,alpha_4),1,font_big,"left","center")
			
			if navigatorSound then
				dxDrawText("✔️", bigmapPosX+bigmapWidth+30+3,bigmapPosY+bigmapHeight-60,bigmapPosX+bigmapWidth+30+190,bigmapPosY+bigmapHeight-60+25, tocolor(124,197,118,alpha), 1, font_awesome, "left", "center")
			else
				dxDrawText("✖", bigmapPosX+bigmapWidth+30+5,bigmapPosY+bigmapHeight-60,bigmapPosX+bigmapWidth+30+190,bigmapPosY+bigmapHeight-60+25, tocolor(210,49,49,alpha), 1, font_awesome, "left", "center")
			end

			
			dxDrawRectangle(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-30,190,25,tocolor(50,50,50,alpha_3))
			if inArea(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-30,190,25) then				
				dxDrawOuterBorder(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-30,190,25,1,tocolor(255,255,255,alpha_3))
			end
			dxDrawText("Blip Animasyonu",bigmapPosX+bigmapWidth+55,bigmapPosY+bigmapHeight-30,bigmapPosX+bigmapWidth+30+190,bigmapPosY+bigmapHeight-30+25,tocolor(200,200,200,alpha_4),1,font_big,"left","center")
			
			if blipanimation then
				dxDrawText("✔️", bigmapPosX+bigmapWidth+30+3,bigmapPosY+bigmapHeight-30,bigmapPosX+bigmapWidth+30+190,bigmapPosY+bigmapHeight-30+25, tocolor(124,197,118,alpha), 1, font_awesome, "left", "center")
			else
				dxDrawText("✖", bigmapPosX+bigmapWidth+30+5,bigmapPosY+bigmapHeight-30,bigmapPosX+bigmapWidth+30+190,bigmapPosY+bigmapHeight-30+25, tocolor(210,49,49,alpha), 1, font_awesome, "left", "center")
			end
			
		end

		

		if mapMovedPos then
			local zoneX = reMap((bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000)
			local zoneY = reMap((bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)
			local movedpos_zoneName = getZoneNameEx(zoneX, zoneY, 0,false)
			dxDrawText(zoneName, bigmapPosX + 10, bigmapPosY + bigmapHeight, bigmapPosX + bigmapWidth, bigmapPosY + bigmapHeight+zoneLineHeight, tocolor(200,200,200,230), 1, font_big, "left", "center")
			dxDrawText("Haritanızı eski düzene getirmek için #3d7abcSpace #c0c0c0basınız", bigmapPosX, bigmapPosY + bigmapHeight, bigmapPosX + bigmapWidth, bigmapPosY + bigmapHeight + zoneLineHeight, tocolor(200,200,200,230), 1, font_big, "center", "center", false, false, false, true)
			if getKeyState("space") then
				mapMovedPos = false
				lastDifferencePos = false
				setCursorPosition(screenW/2,screenH/2)
			end
		else
			dxDrawText(zoneName, bigmapPosX + 10, bigmapPosY + bigmapHeight, bigmapPosX + bigmapWidth, bigmapPosY + bigmapHeight+zoneLineHeight, tocolor(200,200,200,230), 1, font_big, "left", "center")
		end
	else
		return
	end
end

addEventHandler("onClientKey", getRootElement(),
	function (key, pressDown)
		if key == "radar" then 
			setPlayerHudComponentVisible("radar", false)
            cancelEvent()
		end
		if key == "F11" and pressDown then
            custom_blip_choosed_type = 0
            bigmapIsVisible = not bigmapIsVisible
           
   
            setElementData(localPlayer, "bigmapIsVisible", bigmapIsVisible, false)
            if bigmapIsVisible then
                hudVisible_ostate = getElementData( localPlayer, "hudVisible")
                keys_denied_ostate = getElementData( localPlayer, "keysDenied")
                setElementData( localPlayer,"hudVisible",false)
                setElementData( localPlayer, "keysDenied", true)
				showChat(false)
            else
                setElementData( localPlayer,"hudVisible",hudVisible_ostate)
                setElementData( localPlayer, "keysDenied",keys_denied_ostate)
				showChat(true)
            end

           
            
            if bigmapIsVisible then
				createRender("renderTheBigmap",renderTheBigmap)
            else
				destroyRender("renderTheBigmap")
            end

           

            mapMovedPos = false
            lastDifferencePos = false
            bigmapZoom = 1
			cancelEvent()
		elseif key == "mouse_wheel_up" then
			if pressDown then
				if bigmapIsVisible and bigmapZoom + 0.1 <= 2.1 then
					bigmapZoom = bigmapZoom + 0.1
				end
			end
		elseif key == "mouse_wheel_down" then
			if pressDown then
				if bigmapIsVisible and bigmapZoom - 0.1 >= 0.1 then
					bigmapZoom = bigmapZoom - 0.1
				end
			end		
		end
	end
)



function optionMenuAnimation()
	local progress = 0
	if not optionMenuState then
		progress,difference,_ = animcore(optionMenuAnimationStart,500,0,0,0,1,210,0,"Linear")
		bigmapWidth = bigmapWidthRoot-difference
		bigmapCenterX = bigmapPosX + bigmapWidth / 2
	else
		progress,optionMenuAlpha,_ = animcore(optionMenuAnimationStart,250,0,255,0,1,0,0,"Linear")
	end
	if progress >=1 then
	  -- removeEventHandler("onClientRender",root,optionMenuAnimation) 
		destroyRender("optionMenuAnimation")
	   optionMenuAnimationStart = getTickCount()
	   --addEventHandler( "onClientRender", root, optionMenuAnimationSecond)
	   createRender("optionMenuAnimationSecond",optionMenuAnimationSecond)
	end
end


function optionMenuAnimationSecond()
	local progress = 0
	if not optionMenuState then
		progress,optionMenuAlpha,_ = animcore(optionMenuAnimationStart,250,0,0,0,1,255,0,"Linear")
	else
		progress,difference,_ = animcore(optionMenuAnimationStart,500,0,210,0,1,0,0,"Linear")
		bigmapWidth = bigmapWidthRoot-difference
		bigmapCenterX = bigmapPosX + bigmapWidth / 2
	end
	if progress >=1 then
	-- removeEventHandler("onClientRender",root,optionMenuAnimationSecond)
	 destroyRender("optionMenuAnimationSecond")
	 isoptionMenuAnimation = false
	 optionMenuState = not optionMenuState
	end
end

addEventHandler("onClientClick", getRootElement(),
	function (button, state, cursorX, cursorY)
			
	if getElementDimension( localPlayer ) ~= 0 then return end

		if state == "up" and mapIsMoving then
			mapIsMoving = false
			return
		end
		
		local gpsRouteProcess = false
		
		if button == "left" and state == "up" then
			if bigmapIsVisible and occupiedVehicle and carCanGPS() then
				if not getPedOccupiedVehicleSeat( localPlayer ) == 0 and  not getPedOccupiedVehicleSeat( localPlayer ) == 1 then return end
				if getElementData(occupiedVehicle, "gpsDestination") then
					setElementData(occupiedVehicle, "gpsDestination", false)
				elseif cursorX > bigmapPosX and cursorX<bigmapPosX+bigmapWidth and cursorY>bigmapPosY and cursorY<bigmapPosY+bigmapHeight then
					setElementData(occupiedVehicle, "gpsDestination", {
						reMap((cursorX - bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000),
						reMap((cursorY - bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)
					})
				end
				gpsRouteProcess = true
			end
		end
		
		if bigmapIsVisible then
			if button == "right" and state == "down" and custom_blip_choosed_type ~= 0 then
				if hovered_blip then
					deleteOwnBlip(hovered_blip)
				else
					local blipPosX = reMap((cursorX - bigmapPosX) / bigmapZoom + (remapTheSecondWay(mapPlayerPosX) - bigmapWidth / bigmapZoom / 2), 0, mapTextureSize, -3000, 3000)
					local blipPosY = reMap((cursorY - bigmapPosY) / bigmapZoom + (remapTheFirstWay(mapPlayerPosY) - bigmapHeight / bigmapZoom / 2), 0, mapTextureSize, 3000, -3000)
					createOwnBlip(custom_blip_choosed[custom_blip_choosed_type],blipPosX,blipPosY)
					
				end
			elseif button == "left" and state == "down" and not isoptionMenuAnimation and inText( bigmapPosX+bigmapWidth-30, bigmapPosY + bigmapHeight, bigmapPosX+bigmapWidth-10,bigmapPosY + bigmapHeight + zoneLineHeight) then
				--addEventHandler( "onClientRender",root,optionMenuAnimation)
				createRender("optionMenuAnimation",optionMenuAnimation)
				optionMenuAnimationStart = getTickCount()
				isoptionMenuAnimation = true
			elseif button == "left" and state == "down" and not isoptionMenuAnimation and optionMenuState and inArea(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-90,190,25) then
				thblipstate = not thblipstate
				toggle3DBlip(thblipstate)
			elseif button == "left" and state == "down" and not isoptionMenuAnimation and optionMenuState and inArea(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-60,190,25) then
				navigatorSound = not navigatorSound
			elseif button == "left" and state == "down" and not isoptionMenuAnimation and optionMenuState and inArea(bigmapPosX+bigmapWidth+30,bigmapPosY+bigmapHeight-30,190,25) then
				blipanimation = not blipanimation
			end		
		end
	end
)

function setGPSDestination(world_x,world_y)
	if occupiedVehicle and carCanGPS() then
		setElementData(occupiedVehicle, "gpsDestination", nil)
		setElementData(occupiedVehicle, "gpsDestination", {world_x,world_y})
	end
end


addEventHandler("onClientRestore", getRootElement(),
	function ()
		if gpsRoute then
			processGPSLines()
		end
	end
)

function calculateBlip()
	 Map_blips = {}
	for k,value in pairs(radarBlips) do
	 	local blip_x,blip_y,_ = getElementPosition(value[2])
		if not blip_x then
		radarBlips = nil
		radarBlips = {}
		end
        local blip_dis = getDistanceBetweenPoints2D(playerPosX, playerPosY, blip_x, blip_y)
        blip_dis = blip_dis/mapRatio*minimapZoom
        local dx_distance = diagonal*1.2
       
        if blip_dis < dx_distance or value[3]== 1 then 
            Map_blips[k] = value
            Map_blips[k]["blip_x"] = blip_x
            Map_blips[k]["blip_y"] = blip_y
            Map_blips[k]["blip_dis"] = blip_dis
            Map_blips[k]["blip_alpha"] = (1-((blip_dis-diagonal)/(diagonal*0.2)))*255
        else
        	Map_blips[k] = nil
        end
    end
	Map_blips_timer = nil
end



function renderBlipContinue(value)
 	local blip_x,blip_y, blip_dis = value["blip_x"], value["blip_y"], value["blip_dis"]
        local rotation = findRotation(blip_x, blip_y,playerPosX, playerPosY)
        local blip_alpha = 255
        blip_x, blip_y = getPointFromDistanceRotation(w_x+minimapWidth/2, w_y+minimapHeight/2, blip_dis, rotation)
        if not blipanimation then 
        	if 	blip_x < w_x-10 or blip_x > w_x+minimapWidth+10 or blip_y < w_y-10 or blip_y > w_y+minimapHeight+10 then return end
        else
	        	
	        blip_x,blip_y = math.max(w_x, math.min(w_x+minimapWidth,blip_x)),math.max(w_y, math.min(w_y+minimapHeight-zoneLineHeight, blip_y))	   
	       if blip_dis > diagonal and value[3] ~= 1 then
	       	blip_alpha = math.max(0,math.min(255,value["blip_alpha"]))
	       end
        end       	

       local width,height = (value[5]/ (4 - minimapZoom) + 3) * 2.25,(value[6] / (4 - minimapZoom) + 3) * 2.25
       dxDrawImage(blip_x-(width/2),blip_y-(height/2),width,height,"assets/images/blips/"..value[4]..".png",0,0,0,tocolor(value[7],value[8],value[9],blip_alpha))
end


function renderBlip()
	for k , value in pairs(Map_blips) do
       renderBlipContinue(value)
	end
end

function calculateBlipRadar()
	 Map_blips_radar = {}
	for k,value in pairs(radarBlips) do
	 	local blip_x,blip_y,_ = getElementPosition(value[2])
        Map_blips_radar[k] = value
        Map_blips_radar[k]["blip_x"] = blip_x
        Map_blips_radar[k]["blip_y"] = blip_y
    end
    Map_blips_radar["player"] = {"",localPlayer,0,"arrow",64,64,255,255,255} 
    local blip_x,blip_y,_ = getElementPosition(localPlayer)
    Map_blips_radar["player"]["blip_x"] = blip_x
    Map_blips_radar["player"]["blip_y"] = blip_y
	Map_blips_timer = nil
end



function renderBlipRadar()
	local blip_hoover = nil
	for k , value in pairs(Map_blips_radar) do
		width,height = (value[5]/ (4 - bigmapZoom) + 3) * 2.25,(value[6] / (4 - bigmapZoom) + 3) * 2.25
		local map_x,map_y =  Map_blips_radar[k]["blip_x"], Map_blips_radar[k]["blip_y"]

		map_x =  bigmapCenterX + (remapTheFirstWay(mapPlayerPosX) - remapTheFirstWay(map_x)) * bigmapZoom
		map_y =  bigmapCenterY - (remapTheFirstWay(mapPlayerPosY) - remapTheFirstWay(map_y)) * bigmapZoom
		if evisible == 0 then
			if map_x > bigmapPosX + bigmapWidth or map_y > bigmapCenterY + bigmapHeight then 
				return			
			elseif map_x < bigmapPosX or map_y < bigmapCenterY then
				return
			end 
		end
		local blip_x = math.max(bigmapPosX,math.min(bigmapPosX + bigmapWidth,map_x))
		local blip_y =  math.max(bigmapPosX,math.min(bigmapPosY + bigmapHeight,map_y))
		
		if value[4] == "arrow" then
			dxDrawImage(blip_x - width/2, blip_y - height/2, width, height, "assets/images/blips/arrow.png", math.abs(360 - playerRotation))
		else
			dxDrawImage(blip_x - width/2, blip_y - height/2, width, height, "assets/images/blips/" .. value[4]..".png",0,0,0,tocolor(value[7],value[8],value[9])) 
		end

		local cursorX,cursorY = getCursorPosition()
		if cursorX and cursorY then
			cursorX,cursorY = cursorX*screenW,cursorY*screenH  
		else
			cursorX,cursorY = -10,-10
		end


		if cursorX > blip_x - width/2 and cursorX < blip_x - width/2+width and cursorY >  blip_y - height/2 and cursorY <  blip_y - height/2+height and value[1] ~= "" then
			local font = exports['mrp_fonts']:getFont("Roboto", 10)
			local text_width = dxGetTextWidth(value[1],1,font)
			blip_hoover = value[1]
			dxDrawRectangle(blip_x-text_width/2-3,blip_y + height/2+1,text_width+6,18,tocolor(55,55,55))
			dxDrawRoundedRectangle(blip_x -text_width/2-4,blip_y + height/2,text_width+8,20,tocolor(55,55,55),tocolor(55,55,55))
			dxDrawText( value[1],blip_x-text_width/2-4, blip_y + height/2+5,blip_x -text_width/2-4+text_width+8,blip_y - height/2+height+18, tocolor(200,200,200),1,font,"center","center")
		end	

	end
	if blip_hoover then hovered_blip = blip_hoover
	else hovered_blip = nil end
end



function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle) 
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist 
    return x+dx, y+dy
end

function remapTheFirstWay(coord)
	return (-coord + 3000) / mapRatio
end

function remapTheSecondWay(coord)
	return (coord + 3000) / mapRatio
end

function carCanGPS()
		carCanGPSVal = getElementData(occupiedVehicle, "vehicle.GPS") or 1
	return carCanGPSVal
end

function addGPSLine(x, y)
	table.insert(gpsLines, {remapTheFirstWay(x), remapTheFirstWay(y)})
end

function processGPSLines()
	local routeStartPosX, routeStartPosY = 99999, 99999
	local routeEndPosX, routeEndPosY = -99999, -99999
	
	for i = 1, #gpsLines do
		if gpsLines[i][1] < routeStartPosX then
			routeStartPosX = gpsLines[i][1]
		end
		
		if gpsLines[i][2] < routeStartPosY then
			routeStartPosY = gpsLines[i][2]
		end
		
		if gpsLines[i][1] > routeEndPosX then
			routeEndPosX = gpsLines[i][1]
		end
		
		if gpsLines[i][2] > routeEndPosY then
			routeEndPosY = gpsLines[i][2]
		end
	end
	
	local routeWidth = (routeEndPosX - routeStartPosX) + 16
	local routeHeight = (routeEndPosY - routeStartPosY) + 16
	
	if isElement(gpsRouteImage) then
		destroyElement(gpsRouteImage)
	end
	
	gpsRouteImage = dxCreateRenderTarget(routeWidth, routeHeight, true)
	gpsRouteImageData = {routeStartPosX - 8, routeStartPosY - 8, routeWidth, routeHeight}
	
	dxSetRenderTarget(gpsRouteImage)
	dxSetBlendMode("modulate_add")
	
	--dxDrawImage(gpsLines[1][1] - routeStartPosX + 8 - 4, gpsLines[1][2] - routeStartPosY + 8 - 4, 8, 8, "gps/images/dot.png")
	
	for i = 2, #gpsLines do
		if gpsLines[i - 1] then
			local startX = gpsLines[i][1] - routeStartPosX + 8
			local startY = gpsLines[i][2] - routeStartPosY + 8
			local endX = gpsLines[i - 1][1] - routeStartPosX + 8
			local endY = gpsLines[i - 1][2] - routeStartPosY + 8
			
			--dxDrawImage(startX - 4, startY - 4, 8, 8, "gps/images/dot.png")

			dxDrawLine(startX, startY, endX, endY, tocolor(255, 255, 255), 9)
		end
	end
	
	dxSetBlendMode("blend")
	dxSetRenderTarget()
end

function clearGPSRoute()
	gpsLines = {}
	
	if isElement(gpsRouteImage) then
		destroyElement(gpsRouteImage)
	end
	gpsRouteImage = false
end

addEventHandler( "onClientVehicleEnter", root, function(player) 
	if player == localPlayer then
		occupiedVehicle = source
	end	
end)


function getVehicleSpeed(vehicle)
	if getPedOccupiedVehicle( localPlayer ) then
	local velocityX, velocityY, velocityZ = getElementVelocity(vehicle)
	return ((velocityX * velocityX + velocityY * velocityY + velocityZ * velocityZ) ^ 0.5) * 187.5
	else return 0
	end
end


function dxDrawRoundedRectangle(left, top, width, height, color, color2)
	if not postgui then
		postgui = false;
	end

	left, top = left + 2, top + 2;
	width, height = width - 4, height - 4;
    dxDrawRectangle(left - 2, top, 2, height, color2, postgui);
	dxDrawRectangle(left + width, top, 2, height, color2, postgui);
	dxDrawRectangle(left, top - 2, width, 2, color2, postgui);
	dxDrawRectangle(left, top + height, width, 2, color2, postgui);

	dxDrawRectangle(left - 1, top - 1, 1, 1, color2, postgui);
	dxDrawRectangle(left + width, top - 1, 1, 1, color2, postgui);
	dxDrawRectangle(left - 1, top + height, 1, 1, color2, postgui);
	dxDrawRectangle(left + width, top + height, 1, 1, color2, postgui)
end

function dxDrawOuterBorder(x, y, w, h, borderSize, borderColor, postGUI)
	borderSize = borderSize or 2
	borderColor = borderColor or tocolor(0, 0, 0, 255)
	
	dxDrawRectangle(x - borderSize, y - borderSize, w + (borderSize * 2), borderSize, borderColor, postGUI)
	dxDrawRectangle(x, y + h, w, borderSize, borderColor, postGUI)
	dxDrawRectangle(x - borderSize, y, borderSize, h + borderSize, borderColor, postGUI)
	dxDrawRectangle(x + w, y, borderSize, h + borderSize, borderColor, postGUI)
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function inArea(x,y,w,h)
	if isCursorShowing() then
		local aX,aY = getCursorPosition()
		aX,aY = aX*screenW,aY*screenH
		if aX > x and aX < x+w and aY>y and aY<y+h then return true
		else return false end
	else return false end
end


function inText(x1,y1,x2,y2)
	if isCursorShowing() then
		local aX,aY = getCursorPosition()
		aX,aY = aX*screenW,aY*screenH
		if aX > x1 and aX < x2 and aY>y1 and aY<y2 then return true
		else return false end
	else return false end
end

addEventHandler( "onClientResourceStop",resourceRoot,function()
	--[[save_data = {
		["3D"] = thblipstate,
		["Sounds"] = navigatorSound,
		["Animation"] = blipanimation,
	}
	--jsonSave()]]
    if bigmapIsVisible then
        setElementData( localPlayer, "hudVisible",hudVisible_ostate)
        setElementData( localPlayer, "keysDenied",keys_denied_ostate)
    end
end)


function animcore(mstart,duration,sn1,sn2,sn3,fn1,fn2,fn3,animtype)
	local now = getTickCount()
	local elapsedTime = now - mstart
	local progress = elapsedTime / duration
	local num1, num2, num3 = interpolateBetween ( sn1, sn2, sn3, fn1, fn2, fn3, progress, ""..tostring(animtype).."")
	return num1, num2,num3
end
