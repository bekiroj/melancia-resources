local localPlayer = getLocalPlayer()
local font = 'default-bold'
local font2 = exports.mrp_fonts:getFont("RobotoB", 12)
local active = true
local alpha = 220
local badges = {}
local masks = {}
local maxIconsPerLine = 6
local playerhp = { }
local lasthp = { }
local playerarmor = { }
local lastarmor = { }

function close()
	if active then
		active = false
	else
		active = true
	end
end
addCommandHandler('nametag', close)

function initStuff(res)
	if (res == getThisResource() and getResourceFromName("mrp_items")) or getResourceName(res) == "mrp_items" then
		for key, value in pairs(exports['mrp_items']:getBadges()) do
			badges[value[1]] = { value[4][1], value[4][2], value[4][3], value[5] }
		end
		
		masks = exports['mrp_items']:getMasks()
	end
end
addEventHandler("onClientResourceStart", getRootElement(), initStuff)

function playerQuit()
	if (getElementType(source)=="player") then
		playerhp[source] = nil
		lasthp[source] = nil
		playerarmor[source] = nil
		lastarmor[source] = nil
	end
end
addEventHandler("onClientElementStreamOut", getRootElement(), playerQuit)
addEventHandler("onClientPlayerQuit", getRootElement(), playerQuit)

addEventHandler("onClientMinimize", getRootElement(),
	function()
		setElementData(localPlayer, "hud:minimized", true)
	end
)

addEventHandler("onClientRestore", getRootElement(),
	function()
		setElementData(localPlayer, "hud:minimized", false)
	end
)

function streamIn()
	if (getElementType(source)=="player") then
		playerhp[source] = getElementHealth(source)
		lasthp[source] = playerhp[source]
		playerarmor[source] = getPedArmor(source)
		lastarmor[source] = playerarmor[source]
	end
end
addEventHandler("onClientElementStreamIn", getRootElement(), streamIn)

function isPlayerMoving(player)
	return (not isPedInVehicle(player) and (getPedControlState(player, "forwards") or getPedControlState(player, "backwards") or getPedControlState(player, "left") or getPedControlState(player, "right") or getPedControlState(player, "accelerate") or getPedControlState(player, "brake_reverse") or getPedControlState(player, "enter_exit") or getPedControlState(player, "enter_passenger")))
end

function aimsAt(player)
	return getPedTarget(localPlayer) == player
end

function getBadgeColor(player)
	for k, v in pairs(badges) do
		if getElementData(player, k) then
			return unpack(badges[k])
		end
	end
end

function getVariableColor(variable)
	if (variable) > 50 then
		return "#047a18"
	elseif (variable) >= 30 and (variable) <= 50 then
		return "#fff471"
	elseif (variable) <= 29 then
		return "#ff7171"
	end
end

function getVariableColorArmor(variable)
	if (variable) > 50 then
		return "#808080"
	elseif (variable) >= 30 and (variable) <= 50 then
		return "#808080"
	elseif (variable) <= 29 then
		return "#808080"
	end
end

rozetler = {
	"LSPD badge",
	"FBI badge",
	"LSCSD badge",
	"LSMD badge",
	"SAHP badge",
	"CEK badge",
	"LSN badge",
	"GOV badge",
	"FAA badge",
}

function oyuncuRozetIsim(oyuncu)
	for i,rozet in pairs(rozetler) do
		if getElementData(oyuncu, rozet) then
			return getElementData(oyuncu, rozet)
		end	
	end
	return false
end	

function getPlayerIcons(name, player, forTopHUD, distance, status)
	distance = distance or 0
	local tinted, masked = false, false
	local icons = {}
	if getElementData(player, "loggedin") then
		for key, value in pairs(masks) do
			if getElementData(player, value[1]) then
				if value[4] then
					masked = true
				end
			end
		end

		if masked then
			name = "Belirsiz Kişi"
		end
	
		for k, v in pairs(badges) do
			local title = getElementData(player, k)
			if title then
				if v[4] == 122 or v[4] == 123 or v[4] == 124 or v[4] == 125 or v[4] == 135 or v[4] == 136 or v[4] == 158 or v[4] == 168 then
					name = "Belirsiz Kişi (Bandana)"
					badge = true
				end
			end
		end
		
		if getElementData(player, "admin_level") == 7 and getElementData(player,"duty_admin") == 1 and getElementData(player,"hiddenadmin") == 0 then
			table.insert(icons, 'developeradm')
		end

		if getElementData(player, "admin_level") == 6 and getElementData(player,"duty_admin") == 1 and getElementData(player,"hiddenadmin") == 0 then
			table.insert(icons, '3rdParty_Developer')
		end

		if getElementData(player, "admin_level") == 5 and getElementData(player,"duty_admin") == 1 and getElementData(player,"hiddenadmin") == 0 then
			table.insert(icons, 'headadm')
		end

		if getElementData(player, "admin_level") == 4 and getElementData(player,"duty_admin") == 1 and getElementData(player,"hiddenadmin") == 0 then
			table.insert(icons, 'a3_on')
		end

		if getElementData(player, "admin_level") == 3 and getElementData(player,"duty_admin") == 1 and getElementData(player,"hiddenadmin") == 0 then
			table.insert(icons, 'a2_on')
		end

		if getElementData(player, "admin_level") == 2 and getElementData(player,"duty_admin") == 1 and getElementData(player,"hiddenadmin") == 0 then
			table.insert(icons, 'a1_on')
		end

		if getElementData(player, "admin_level") == 1 and getElementData(player,"duty_admin") == 1 and getElementData(player,"hiddenadmin") == 0 then
			table.insert(icons, 'trialadm_on')
		end

		if getElementData(player, "supporter_level") == 1 and getElementData(player,"duty_supporter") == 1 and getElementData(player,"hiddenadmin") == 0 then
			table.insert(icons, 'H1')
		end
	
		if getElementData(player,"vip") == 1  then
			table.insert(icons, "vip1")
		end

		if getElementData(player,"vip") == 2  then
			table.insert(icons, "vip2")
		end

		if getElementData(player,"vip") == 3  then
			table.insert(icons, "vip3")
		end

		if getElementData(player,"vip") == 4  then
			table.insert(icons, "vip4")
		end
		
		if getElementData(player,"youtuber") == 1 then
			table.insert(icons, "youtuberEtiketi")
		end

		if getElementData(player,"etiket") == 1 then
			table.insert(icons, "isimetiketleri1")
		end

		if getElementData(player,"etiket") == 2 then
			table.insert(icons, "isimetiketleri2")
		end

		if getElementData(player,"etiket") == 3 then
			table.insert(icons, "isimetiketleri3")
		end

		if getElementData(player,"etiket") == 4 then
			table.insert(icons, "isimetiketleri4")
		end

		if getElementData(player,"etiket") == 5 then
		    table.insert(icons, "isimetiketleri5")
		end

		if getElementData(player,"etiket") == 6 then
		    table.insert(icons, "isimetiketleri6")
		end

		if getElementData(player,"etiket") == 7 then
		    table.insert(icons, "isimetiketleri7")
		end

		for key, value in pairs(masks) do
			if getElementData(player, value[1]) then
				table.insert(icons, value[1])
				if value[4] then
					masked = true
				end
			end
		end

		local vehicle = getPedOccupiedVehicle(player)
		local windowsDown = vehicle and getElementData(vehicle, "vehicle:windowstat") == 1

		if vehicle and not windowsDown and vehicle ~= getPedOccupiedVehicle(localPlayer) and getElementData(vehicle, "tinted") then
			local seat0 = getVehicleOccupant(vehicle, 0) == player
			local seat1 = getVehicleOccupant(vehicle, 1) == player
			local chrid = getElementData(player, 'dbid')
			if seat0 or seat1 then
				if distance > 1.4 then
					name = "Belirsiz Kişi (#"..chrid..")"
					tinted = true
				end
			else
				name = "Belirsiz Kişi (#"..chrid..")"
				tinted = true
			end
		end

		if not tinted then

			if getElementData(player,"seatbelt") and getPedOccupiedVehicle(player) then
				table.insert(icons, 'seatbelt')
			end

			if getElementData(player,"smoking") == true then
				table.insert(icons, 'cigarette')
			end

			if masked then
				name = "Gizli (#"..getElementData(player, "dbid")..")"
			end

			for k, v in pairs(badges) do
				local title = getElementData(player, k)
				if title then
					if v[4] == 122 or v[4] == 123 or v[4] == 124 or v[4] == 125 or v[4] == 135 or v[4] == 136 or v[4] == 158 or v[4] == 168 then
						table.insert(icons, 'bandana')
						name = "Belirsiz Kişi (Bandana) ("..getElementData(player, "playerid")..")"
						badge = true
					elseif v[2] == 112 or v[2] == 64 then
						table.insert(icons, 'police')
						name = title .. "\n" .. name
						badge = true
					else
						table.insert(icons, "badge" .. tostring(v[5] or 1))
						name = title .. "\n" .. name
						badge = true
					end
				end
			end

			if tonumber(getElementData(player, 'cellphoneGUIStateSynced') or 0) > 0 then
				table.insert(icons, 'phone')
			end
		end

		if not tinted then
			if not forTopHUD then
				local health = getElementHealth( player )
				local tick = math.floor(getTickCount () / 1000) % 2
				if health <= 25 then
					table.insert(icons, 'lowhp')
				end
				
				if getElementData(player, "Yaralı") then
					table.insert(icons, 'bleeding')
				end
				
				if getElementData(player, "kelepce") then
					table.insert(icons, "handcuffs")
				end
			end
		end
		
		if not forTopHUD then
			if windowsDown then
				table.insert(icons, 'window2')
			end
		end
	end return name, icons, tinted
end

function renderNametags()
	if not active then return end
	if (getElementData(localPlayer, "graphic_nametags") ~= "0") and not isPlayerMapVisible() and getElementData(localPlayer, "loggedin") then
		local players = { }
		local distances = { }
		local lx, ly, lz = getElementPosition(localPlayer)
		local dim = getElementDimension(localPlayer)
		local isNewtyle = (getElementData(localPlayer, "settings_hud_style") ~= "0") 
		for key, player in ipairs(getElementsByType("player")) do
			if (isElement(player)) and getElementDimension(player) == dim then
				local logged = getElementData(player, "account:loggedin")
				if (logged == true) then
					local rx, ry, rz = getElementPosition(player)
					local distance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
					local rdistance = getDistanceBetweenPoints3D(lx, ly, lz, rx, ry, rz)
					local limitdistance = 20
					local reconx = getElementData(localPlayer, "reconx") and exports.mrp_integration:isPlayerTrialAdmin(localPlayer)
					if isElementOnScreen(player) and (player~=localPlayer or isNewtyle) then
						if (aimsAt(player) or distance<limitdistance or reconx) then
							if not getElementData(player, "reconx") and not getElementData(player, "freecam:state") and not (getElementAlpha(player) < 255) then
								local lx, ly, lz = getCameraMatrix()
								local vehicle = getPedOccupiedVehicle(player) or nil
								local collision, cx, cy, cz, element = processLineOfSight(lx, ly, lz, rx, ry, rz+1, true, true, true, true, false, false, true, false, vehicle)
								if not (collision) or aimsSniper() or (reconx) then
									local x, y, z = getElementPosition(player)
									if not (isPedDucked(player)) then
										z = z + 1
									else
										z = z + 0.5
									end
									local sx, sy = getScreenFromWorldPosition(x, y, z+0.30, 100, false)
									local oldsy = nil
									local badge = false
									local tinted = false
									local id = getElementData(player, "playerid")

									if getElementData(player, "fakename") then
										name = getElementData(player, "fakename")
									else
										name = getPlayerName(player):gsub("_", " ").." ("..id..")"
									end

									if (sx) and (sy) then
										distance = distance / 5
										if (reconx or aimsAt(player)) then distance = 1
										elseif (distance<1) then distance = 1
										elseif (distance>2) then distance = 2 
										end
										oldsy = sy
										local picxsize = 48 / 2 --/distance
										local picysize = 48 / 2 --/distance
										local xpos, ypos = 5, 55
										name, icons, tinted = getPlayerIcons(name, player, false, distance)
										local expectedIcons = math.min(#icons, maxIconsPerLine)
										local iconsThisLine = 0
										local offset = 13 * expectedIcons
										
										for k, v in ipairs(icons) do
											picxsize = 54/2-5
											picysize = 54/2-5
											konum = "components/icons/"
											if getPedArmor(player) > 0 then
												ypos =  65
											end
											ypos = ypos - (distance/36)
											dxDrawImage(sx-offset+xpos,oldsy+ypos,picxsize,picysize,konum .. v .. ".png",0,0,0,tocolor(255,255,255,255))
											iconsThisLine = iconsThisLine + 1
											if iconsThisLine == expectedIcons then
												expectedIcons = math.min(#icons - k, maxIconsPerLine)
												offset = 13 * expectedIcons
												iconsThisLine = 0
												xpos = 0
												ypos = ypos + 23
											else
												xpos = xpos + 23
											end
										end

										sy = sy + 10
										sy = sy - 25
											
										if (sx) and (sy) and oldsy then
											if (distance < 5) then distance = 1 end
											if (distance > 2) then distance = 2 end
											local offset = 75 --/ distance
											local scale = 1 --/ distance
											local eren = 65 --/ distance
											local eren4 = 0
											local r, g, b = getBadgeColor(player)
											local bad = getBadgeColor(player)
											if not r or tinted then
												r, g, b = getPlayerNametagColor(player)
											end
											local id = getElementData(player, "playerid")
											
											if badge then
												sy = sy - dxGetFontHeight(scale, newfont) * scale + 2.5
											end
											
											if not isNewtyle then
												name = name
											end

											local countryImgW, countryImgH = 28-5, 28-5

											if getElementData(player,"ses_konusma") then
												dxDrawImage(sx+(dxGetTextWidth(name, scale, "default-bold")/1.5), sy+35, countryImgW, countryImgH,"components/icons/microphone.png")										
											end

											if getElementData(player, "dead") == 1 then
												local deger1 = getElementData(player, "bayilma:deger") or 0
												if deger1 > 0 then
													tx, ty, tw, th = sx-offset, sy, (sx-offset)+160 / distance, sy+35
													r2,g2,b2  = 255,35,35
													yazi2 = "[Yaralı (/hasarlar)] \nSaniye : "..deger1	
													dxDrawText(yazi2, tx+1, ty+7, tw+1, th, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, false, false)
													dxDrawText(yazi2, tx-1, ty+7, tw-1, th, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, false, false)
													dxDrawText(yazi2, tx, ty+1+7, tw, th+1, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, false, false)
													dxDrawText(yazi2, tx, ty-1+7, tw, th-1, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, false, false)
													dxDrawText(yazi2, tx, ty+7, tw, th, tocolor(r2,g2,b2, alpha), scale, font, "center", "center", false, false, false, false, false)
												end
											end

											if getElementData(player,"writting") then
                                           		tx, ty, tw, th = sx-offset, sy-13, (sx-offset)+160 / distance, sy+100-44 / distance							
                                                dxDrawText("...", tx+1, ty, tw+1, th, tocolor(0, 0, 0, 255), scale, font2, "center", "center", false, false, false, false, false)
                                                dxDrawText("...", tx-1, ty, tw-1, th, tocolor(0, 0, 0, 255), scale, font2, "center", "center", false, false, false, false, false)
                                                dxDrawText("...", tx, ty+1, tw, th+1, tocolor(0, 0, 0, 255), scale, font2, "center", "center", false, false, false, false, false)
                                                dxDrawText("...", tx, ty-1, tw, th-1, tocolor(0, 0, 0, 255), scale, font2, "center", "center", false, false, false, false, false)												
                                                dxDrawText("...", sx-offset, sy-13, (sx-offset)+160 / distance, sy+100-44 / distance, tocolor(225, 225, 225, 225), scale, font2, "center", "center", false, false, false, false, false)												
	                                        end

	                                        if getElementData(player, "hud:minimized") then
                                           		tx, ty, tw, th = sx-offset, sy-13, (sx-offset)+160 / distance, sy+100-44 / distance							
                                                dxDrawText("[ AFK ]", tx+1, ty, tw+1, th, tocolor(0, 0, 0, 255), scale, "default-bold", "center", "center", false, false, false, false, false)
                                                dxDrawText("[ AFK ]", tx-1, ty, tw-1, th, tocolor(0, 0, 0, 255), scale, "default-bold", "center", "center", false, false, false, false, false)
                                                dxDrawText("[ AFK ]", tx, ty+1, tw, th+1, tocolor(0, 0, 0, 255), scale, "default-bold", "center", "center", false, false, false, false, false)
                                                dxDrawText("[ AFK ]", tx, ty-1, tw, th-1, tocolor(0, 0, 0, 255), scale, "default-bold", "center", "center", false, false, false, false, false)												
                                                dxDrawText("[ AFK ]", sx-offset, sy-13, (sx-offset)+160 / distance, sy+100-44 / distance, tocolor(200, 60, 60, 255), scale, "default-bold", "center", "center", false, false, false, false, false)												
	                                        end
												
											health = getElementHealth( player )
											armor = getPedArmor( player )
											local lineLength = 50 * ( health / 100 )
											local lineLength2 = 50 * ( armor / 100 )
											local rozet = oyuncuRozetIsim(player) or ""
											local rozet = oyuncuRozetIsim(player) or ""
											local eren2 = 40
											local eren3 = 62

											if rozet then
												eren = 10
												eren2 = 45
												eren3 = 104
													
											end
											if rozet == "" then
												eren = 3
												eren2 = 35
												eren3 = 90
											end
																			
						
											tx, ty, tw, th = sx-offset, sy-eren, (sx-offset)+160 / distance, sy+90-eren

											dxDrawText(name, tx+1, ty, tw+1, th, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true, false)
											dxDrawText(name, tx-1, ty, tw-1, th, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true, false)
											dxDrawText(name, tx, ty+1, tw, th+1, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true, false)
											dxDrawText(name, tx, ty-1, tw, th-1, tocolor(0, 0, 0, 255), 1, font, "center", "center", false, false, false, true, false)
											dxDrawText(name, tx, ty, tw, th, tocolor(r, g, b, alpha), 1, font, "center", "center", false, false, false, true, false)

											dxDrawText("HP: "..math.floor(getElementHealth(player)).."%", tx+1, ty, tw+1, th+eren2, tocolor(0, 0, 0, 255), 0.9, font, "center", "center", false, false, false, true, false)
											dxDrawText("HP: "..math.floor(getElementHealth(player)).."%", tx-1, ty, tw-1, th+eren2, tocolor(0, 0, 0, 255), 0.9, font, "center", "center", false, false, false, true, false)
											dxDrawText("HP: "..math.floor(getElementHealth(player)).."%", tx, ty+1, tw, th+1+eren2, tocolor(0, 0, 0, 255), 0.9, font, "center", "center", false, false, false, true, false)
											dxDrawText("HP: "..math.floor(getElementHealth(player)).."%", tx, ty-1, tw, th-1+eren2, tocolor(0, 0, 0, 255), 0.9, font, "center", "center", false, false, false, true, false)
											dxDrawText("HP: "..getVariableColor(math.floor(getElementHealth(player)))..math.floor(getElementHealth(player)).."%", tx, ty, tw, th+eren2, tocolor(248, 248, 248, alpha), 0.9, font, "center", "center", false, false, false, true, false)
											
											if getPedArmor(player) > 0 then
												dxDrawText("Zırh: "..math.floor(getPedArmor(player)).."%", tx+1, ty-32, tw+1, th+eren3, tocolor(0, 0, 0, 255), 0.9, font, "center", "center", false, false, false, true, false)
												dxDrawText("Zırh: "..math.floor(getPedArmor(player)).."%", tx-1, ty-32, tw-1, th+eren3, tocolor(0, 0, 0, 255), 0.9, font, "center", "center", false, false, false, true, false)
												dxDrawText("Zırh: "..math.floor(getPedArmor(player)).."%", tx, ty+1-32, tw, th+1+eren3, tocolor(0, 0, 0, 255), 0.9, font, "center", "center", false, false, false, true, false)
												dxDrawText("Zırh: "..math.floor(getPedArmor(player)).."%", tx, ty-1-32, tw, th-1+eren3, tocolor(0, 0, 0, 255), 0.9, font, "center", "center", false, false, false, true, false)
												dxDrawText("Zırh: "..getVariableColorArmor(math.floor(getPedArmor(player)))..math.floor(getPedArmor(player)).."%", tx, ty-32, tw, th+eren3, tocolor(248, 248, 248, alpha), 0.9, font, "center", "center", false, false, false, true, false)
											
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
end

setTimer(renderNametags, 0, 0)