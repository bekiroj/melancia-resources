cache = {}
white = "#9c9c9c"
options = {}
screen = Vector2(guiGetScreenSize())
center = Vector2(screen.x/2, screen.y/2)
size = Vector2(200, 500)
sizes = {
    ["top"] = Vector2(452, 62),
    ["center"] = Vector2(456, 33),
    ["bottom"] = Vector2(452, 40),
    ["search"] = Vector2(230, 20),
}
a = "files/"

minLines = 1
maxLines = math.floor((screen.y - 150 - (sizes["top"].y + sizes["bottom"].y + 110)) / 35)
if maxLines >= 15 then maxLines = 15 end
_maxLines = maxLines

--
import("*"):from("mrp_core")

addEventHandler("onClientResourceStart", root,
    function(startedRes)
        if getResourceName(startedRes) == "mrp_core" then
            import("*"):from("mrp_core")
            --startCustomChat()
        end
    end
)

bindKey("tab", "down",
    function()
        if localPlayer:getData("loggedin") ~= 1 then return end
        if not freezeInteract then
            sTimer = setTimer(
                function()
                    if getKeyState("tab") then
                        freezeInteract = true
                    end
                end, 2200, 1
            )
            startScore()
        else
            freezeInteract = false
            stopScore()
        end
    end
)

bindKey("tab", "up",
    function()
        if localPlayer:getData("loggedin") ~= 1 then return end
        if not freezeInteract then
            stopScore()
        end
    end
)

bindKey("mouse_wheel_up", "down",
    function()
        if state then
            if minLines - 1 >= 1 then
                playSound("files/wheel.wav")
                minLines = minLines - 1
                maxLines = maxLines - 1
            end
        end
    end
)

bindKey("mouse_wheel_down", "down",
    function()
        if state then
            local text = "" 
            if textbars["search"] then
                text = textbars["search"][2][2]
            end
            local count = #cache

            if #text > 0 then
                count = #searchCache
            end
            
            if maxLines + 1 <= count then
                playSound("files/wheel.wav")
                minLines = minLines + 1
                maxLines = maxLines + 1
            end
        end
    end
)

addEventHandler("onClientClick", root,
    function(b, s)
        if state then
            if b == "left" and s == "down" then
                if isInSlot(_sX, _sY, _sW, _sH) then
                    scrolling = true
                end
            elseif b == "left" and s == "up" then
                if scrolling then
                    scrolling = false
                end
            end
        end
    end
)

startAnimation = "InOutQuad"
startAnimationTime = 140 -- / 1000 = 0.2 másodperc
function startScore()
    if localPlayer:getData("loggedin") ~= 1 then return end   
    _state = state
    scrolling = false
    state = true
    slots = localPlayer:getData("serverslot") or 300
    multipler = 20
    alpha = 0
    cacheCreate()
    if not _state then
        addEventHandler("onClientRender", root, drawnScoreboard, true, "low-5")
    end
    playerDetails["realplayers"] = 0
    playerDetails["players"] = 0
    if not start then
        start = true
        startTick = getTickCount()
    end
    bar = false
    
    exports['mrp_dx']:createLogoAnimation("score", 1, {0,0,492 * 0.15,566 * 0.15}, {10000, 1000})
end

function stopScore()
    if localPlayer:getData("loggedin") ~= 1 then return end
    if isTimer(sTimer) then
        killTimer(sTimer)
    end
    if start then
    --  Clear()
        --removeEventHandler("onClientRender", root, drawnScoreboard)
        --state = false
        start = false
        exports['mrp_dx']:stopLogoAnimation("score")
        startTick = getTickCount()
    --    cacheDestroy()
    end
end

function dxDrawOuterBorder(x, y, w, h, borderSize, borderColor, postGUI)
	borderSize = borderSize or 2
	borderColor = borderColor or tocolor(0, 0, 0, 255)
	
    --local dxDrawRectangle = _dxDrawRectangle
	dxDrawRectangle(x - borderSize, y - borderSize, w + (borderSize * 2), borderSize, borderColor, postGUI)
	dxDrawRectangle(x, y + h, w, borderSize, borderColor, postGUI)
	dxDrawRectangle(x - borderSize, y, borderSize, h + borderSize, borderColor, postGUI)
	dxDrawRectangle(x + w, y, borderSize, h + borderSize, borderColor, postGUI)
end

playerDetails = {
    ["players"] = 0,
    ["realplayers"] = 0,
}

function updatePlayerDetails()
    if localPlayer:getData("loggedin") ~= 1 then return end
    
    if animState then
        if playerDetails["players"] ~= #cache then
            playerDetails["players"] = #cache
            playerDetails["playersAnimation"] = true
            playerDetails["playersAnimationTick"] = getTickCount()
        end
    end
end
setTimer(updatePlayerDetails, 50, 0)

function drawnScoreboard()
    local now = getTickCount()
    local nowTick = now
    if start then
        local elapsedTime = nowTick - startTick
        local duration = (startTick + startAnimationTime) - startTick
        local progress = elapsedTime / duration
        local alph = interpolateBetween(
            0, 0, 0,
            255, 0, 0,
            progress, startAnimation
        )
        
        alpha = alph
        
        if progress >= 1 then
            animState = true
        end
    else
        local elapsedTime = nowTick - startTick
        local duration = (startTick + startAnimationTime) - startTick
        local progress = elapsedTime / duration
        local alph = interpolateBetween(
            255, 0, 0,
            0, 0, 0,
            progress, startAnimation
        )
        
        alpha = alph
        
        if progress >= 1 then
            animState = false
            alpha = 0
            Clear()
            cacheDestroy()
            state = false
            removeEventHandler("onClientRender", root, drawnScoreboard)
        end
    end

    font = exports['mrp_fonts']:getFont("Roboto", 11)
    font2 = exports['mrp_fonts']:getFont("Roboto", 10)
    --fontBig = exports['mrp_fonts']:getFont("Roboto", 12)
    --local count = #cache
    local text = "" 
    if textbars["search"] then
        text = textbars["search"][2][2]
    end
    local count = count
    local _count = count
    
    if #text > 0 then
        count = #searchCache
        _count = count
    end
    --outputChatBox("countStart: " .. count)
    if count >= _maxLines then
        count = _maxLines
    end
    
    --outputChatBox("count: " .. count)
    --outputChatBox("maxLines: " .. maxLines)
    local y = center.y - ((((count) * sizes["center"].y + 2) + (sizes["top"].y + sizes["bottom"].y)) / 2)
    --a Cikklus helyett kell 1 matematikai egyenlet
    local fullY = sizes["top"].y
    --local count = 0
    
    for i = minLines, maxLines do
        if #text > 0 and searchCache[i] or #text <= 0 and cache[i] then
            local v = searchCache[i]
            if not v then
                v = cache[i]
            end
            
            fullY = fullY + sizes["center"].y + 2
        end
    end
    fullY = fullY - 2 + sizes["bottom"].y
    
    exports['mrp_dx']:updateLogoPos("score", {center.x,y - 50,492 * 0.15,566 * 0.15})
    --dxDrawImage(center.x - sizes["top"].x/2, y, sizes["top"].x, sizes["top"].y, sources["top"], 0,0,0, tocolor(255,255,255,alpha))
    dxDrawRectangle(center.x - sizes["top"].x/2 - 2, y - 2, 452 + 4, fullY + 2, tocolor(31,31,31,math.min(255 * 0.95, alpha)))
    dxDrawRectangle(center.x - sizes["top"].x/2, y, 452, 32, tocolor(255,255,255,math.min(255 * 0.05, alpha)))
    dxDrawText("Melancia#4a4a4a Roleplay", center.x - sizes["top"].x/2 + 10, y, center.x - sizes["top"].x/2 + 452 - 10, y + 32, tocolor(200,200,200,alpha), 1, font, "left", "center",false,false,false,true)
    
    local gW, gH = 110, 18
    local gX, gY = center.x + sizes["top"].x/2 - 10 - gW, y + 32/2 - gH/2
    dxDrawRectangle(gX,gY,gW,gH, tocolor(0,0,0,math.min(255 * 0.15, alpha)))
    
    local gX = gX + 1
    local gY = gY + 1
    local gW = gW - 2
    local gH = gH - 2
    local nowTick = getTickCount()
    local k = "players"
    if playerDetails[k.."Animation"] then
        local startTick = playerDetails[k.."AnimationTick"]

        local elapsedTime = nowTick - startTick
        local duration = (startTick + 500) - startTick
        local progress = elapsedTime / duration
        local alph = interpolateBetween(
            playerDetails["real"..k] * 100, 0, 0,
            playerDetails[k] * 100, 0, 0,
            progress, "InOutQuad"
        )
        playerDetails["real"..k] = alph/100

        if progress >= 1 then
            playerDetails[k.."Animation"] = false
        end
        --multipler = alph / 100
    end
    local gMultipler = playerDetails["real"..k] / slots
    --local gMultipler = #cache / slots
    if gMultipler >= 1 then
        gMultipler = 1
    end
    dxDrawRectangle(gX,gY,gW * gMultipler,gH, tocolor(61,122,188,math.min(255 * 1, alpha)))
    
    dxDrawText(#cache.."/"..slots, gX, gY , gX + gW, gY + gH, tocolor(200,200,200,math.min(255 * 0.5, alpha)), 1, font2, "center", "center")
    local gColor = "#4a4a4a"
    
    local tx = center.x - sizes["top"].x/2 + 16
    dxDrawText(gColor.."#", tx, y + 32, tx, y + 32 + (sizes["top"].y - 32), tocolor(255,255,255,math.min(255 * 1, alpha)), 1, font, "center", "center", false, false, false, true)
    
    local tx = center.x - sizes["top"].x/2 + 65
    dxDrawText(gColor.."ID", tx, y + 32, tx, y + 32 + (sizes["top"].y - 32), tocolor(255,255,255,math.min(255 * 1, alpha)), 1, font, "center", "center", false, false, false, true)
    
    local tx = center.x - sizes["top"].x/2 + 200
    dxDrawText(gColor.."Karakter Adı", tx, y + 32, tx, y + 32 + (sizes["top"].y - 32), tocolor(255,255,255,math.min(255 * 1, alpha)), 1, font, "center", "center", false, false, false, true)
    
    local tx = center.x - sizes["top"].x/2 + 350
    dxDrawText(gColor.."Level", tx, y + 32, tx, y + 32 + (sizes["top"].y - 32), tocolor(255,255,255,math.min(255 * 1, alpha)), 1, font, "center", "center", false, false, false, true)
    
    local tx = center.x - sizes["top"].x/2 + 430 -- ping
    dxDrawText(gColor.."Ping", tx, y + 32, tx, y + 32 + (sizes["top"].y - 32), tocolor(255,255,255,math.min(255 * 1, alpha)), 1, font, "center", "center", false, false, false, true)
    
    y = y + sizes["top"].y
    --local count = 0
    local __StartY = y
    
    for i = minLines, maxLines do
        if #text > 0 and searchCache[i] or #text <= 0 and cache[i] then
            local tooltip, tooltipLines = false, 0
            local v = searchCache[i]
            if not v then
                v = cache[i]
            end
            local loggedin = v["loggedin"]
            local timedout = v["timedout"]
            local id = v["id"]
            local aduty = v["duty_admin"]
            local aColor = "#ff0000"
            local aTitle = "Yetkili"
            local name = v["name"]
            local lvl = v["lvl"]
            local avatar = v["avatar"]
            local ping = v["ping"]
            local pingColor = v["pingColor"]
            dxDrawRectangle(center.x - sizes["center"].x/2, y, sizes["center"].x - 7, sizes["center"].y, tocolor(255,255,255,math.min(255 * 0.05, alpha)))
            
            local rx = center.x - sizes["top"].x/2 + 16 -- avatar
            
            dxDrawOuterBorder(rx - 25/2, y + sizes["center"].y/2 - 25/2, 25, 25, 1, tocolor(44, 77, 115, alpha))
            dxDrawImage(rx - 23/2, y + sizes["center"].y/2 - 23/2, 23, 23, ":mrp_auth/img/"..getElementModel(localPlayer)..".png", 0,0,0, tocolor(255,255,255,alpha))

            local rx = center.x - sizes["top"].x/2 + 65 -- id
            dxDrawText(id or 0, rx, y, rx, y + sizes["center"].y, tocolor(156, 156, 156,(loggedin and alpha) or math.min(255 * 0.25, alpha)), 1, font, "center", "center",false,false,false,true)

            if loggedin then
                local rx = center.x - sizes["top"].x/2 + 350 -- szint
                dxDrawText(lvl, rx, y, rx, y + sizes["center"].y, tocolor(156, 156, 156,alpha), 1, font, "center", "center",false,false,false,true)
            end

            local rx = center.x - sizes["top"].x/2 + 430 -- ping
            --dxDrawText(pingColor .. ping, rx, y, rx, y + sizes["center"].y, tocolor(156, 156, 156,(loggedin and alpha) or math.min(255 * 0.25, alpha)), 1, font, "center", "center",false,false,false,true)
            
            local n = 20
            if loggedin then
                dxDrawImage(rx - n/2, y + sizes["center"].y/2 - n/2, n, n, "files/ping-normal.png", 0,0,0, tocolor(117, 209, 111,math.min(255 * 0.25, alpha)))
                if ping <= 60 then -- normal
                    dxDrawImage(rx - n/2, y + sizes["center"].y/2 - n/2, n, n, "files/ping-normal.png", 0,0,0, tocolor(117, 209, 111,alpha))
                elseif ping <= 130 then -- medium
                    dxDrawImage(rx - n/2, y + sizes["center"].y/2 - n/2, n, n, "files/ping-medium.png", 0,0,0, tocolor(255, 209, 84,alpha))    
                elseif ping >= 130 then -- bad
                    dxDrawImage(rx - n/2, y + sizes["center"].y/2 - n/2, n, n, "files/ping-low.png", 0,0,0, tocolor(227, 79, 79,alpha))    
                end
            else
                dxDrawImage(rx - n/2, y + sizes["center"].y/2 - n/2, n, n, "files/ping-normal.png", 0,0,0, tocolor(220, 220, 220,math.min(255 * 0.25, alpha)))
                if ping <= 60 then -- normal
                    dxDrawImage(rx - n/2, y + sizes["center"].y/2 - n/2, n, n, "files/ping-normal.png", 0,0,0, tocolor(220, 220, 220,math.min(50, alpha)))
                elseif ping <= 130 then -- medium
                    dxDrawImage(rx - n/2, y + sizes["center"].y/2 - n/2, n, n, "files/ping-medium.png", 0,0,0, tocolor(220, 220, 220,math.min(50, alpha)))
                elseif ping >= 130 then -- bad
                    dxDrawImage(rx - n/2, y + sizes["center"].y/2 - n/2, n, n, "files/ping-low.png", 0,0,0, tocolor(220, 220, 220,math.min(50, alpha)))  
                end
            end
            
            if aduty then
                name = aColor .. "[" .. aTitle .. "] " .. white .. name
            end
            
            local pingTooltip
            if isInSlot(rx - n/2, y + sizes["center"].y/2 - n/2, n, n) then
                pingTooltip = true
                exports['mrp_dx']:drawTooltip(1, pingColor .. ping)
            end

            local alpha = alpha
            if not loggedin then
                --name = "#9c9c9c" .. name .
                local w = dxGetTextWidth(name,1,font, true)
                local h = dxGetFontHeight(1, font)
                local x,y = center.x - sizes["top"].x/2 + 200 - w/2, y + sizes["center"].y/2 - h/2
                if not pingTooltip and isInSlot(x, y, w, h) then
                    tooltip = "#9c9c9cŞu an işaretli şahıs MB yükleme ekranında"
                    tooltipLines = tooltipLines + 1
                end
            end

            if timedout then
                local _, newAlpha = interpolateBetween(-5, 0, 0, 5, alpha, 0, now / 2500, "CosineCurve")
                alpha = newAlpha
                
                local w = dxGetTextWidth(name,1,font, true)
                local h = dxGetFontHeight(1, font)
                local x,y = center.x - sizes["top"].x/2 + 200 - w/2, y + sizes["center"].y/2 - h/2
                --dxDrawRectangle(x,y,w,h)
                if not pingTooltip and isInSlot(x, y, w, h) then
                    --exports['mrp_dx']:drawTooltip("#d23131Internethiba", 1)
                    if tooltipLines >= 1 then
                        tooltip = tooltip.."\n#d23131Şu an işaretli şahısta bağlantı sorunu var."
                    end
                    tooltipLines = tooltipLines + 1
                end
                
                --name = "#d23131" .. name .. " (Internethiba)"
            end
            
            if tooltip then
                exports['mrp_dx']:drawTooltip(1, tooltip)
            end

            local rx = center.x - sizes["top"].x/2 + 200 -- név
            dxDrawText(name or "Anan", rx, y, rx, y + sizes["center"].y, tocolor(156, 156, 156,(loggedin and alpha) or math.min(255 * 0.25, alpha)), 1, font, "center", "center",false,false,false,true)

            y = y + sizes["center"].y + 2
        end
    end
    
    y = y - 2
    
    --scrollboard
    
    local percent = #cache
    if #text > 0 then
        percent = #searchCache
    end
    
    if percent >= 1  then
        local gW, gH = 5, y - __StartY
        local gX, gY = center.x + sizes["center"].x/2 - gW, __StartY
        _sX, _sY, _sW, _sH = gX, gY, gW, gH
        
        if scrolling then
            if isCursorShowing() then
                if getKeyState("mouse1") then
                    local cx, cy = exports['mrp_core']:getCursorPosition()
                    local cy = math.min(math.max(cy, _sY), _sY + _sH)
                    local y = (cy - _sY) / (_sH)
                    local num = percent * y
                    minLines = math.max(1, math.floor(math.min(math.max(num, 1), (percent - _maxLines) + 1)))
                    maxLines = minLines + (_maxLines - 1)
                end
            else
                scrolling = false
            end
        end
        
        dxDrawRectangle(gX,gY,gW,gH, tocolor(255,255,255,math.min(255 * 0.05, alpha)))
        --[[
        if not percent[key + (maxColumns * (maxLines - 1))] then
            key = 1
            _key = key - 1
        end

        local percent = #percent
        local _percent = percent

        if percent / maxColumns ~= math.floor(percent / maxColumns) then
            --percent = ((percent / maxColumns) + (math.ceil(percent / maxColumns) - (percent / maxColumns))) * maxColumns
            percent = math.ceil(percent / maxColumns) * maxColumns
        end]]

        --outputChatBox("1>"..(maxColumns * (maxLines - 1)))
        --outputChatBox("2>"..percent)
        local multiplier = math.min(math.max((maxLines - (minLines - 1)) / percent, 0), 1)
        --outputChatBox("3>".._key)
        local multiplier2 = math.min(math.max((minLines - 1) / percent, 0), 1)
        local gY = gY + ((gH) * multiplier2)
        local gH = gH * multiplier
        local r,g,b = exports['mrp_coloration']:getServerColor("blue")
        dxDrawRectangle(gX+1, gY+1, gW-2, gH-2, tocolor(r,g,b, alpha))
        --
        --dxDrawImage(center.x - sizes["bottom"].x/2, y, sizes["bottom"].x, sizes["bottom"].y, sources["bottom"], 0,0,0, tocolor(255,255,255,alpha))
        --local rx = center.x - sizes["bottom"].x/2 + 10
        --local ry = y + 5
    end
    
    --dxDrawRectangle(center.x - 500, y, 500, 40)
    local x, y, w, h = center.x - sizes["search"].x/2, y + sizes["bottom"].y/2 - sizes["search"].y/2, sizes["search"].x, sizes["search"].y
    
    if not bar then
        CreateNewBar("search", {x,y,w,h}, {25, "", false, nil, font2, 1, "center", "center"}, 1)
        bar = true
    else
        UpdatePos("search", {x,y,w,h, alpha})
    end
    
    dxDrawRectangle(x,y,w,h, tocolor(255,255,255,math.min(255 * 0.04, alpha)))
    dxDrawImage(x,y,w,h, "files/search.png", 0,0,0, tocolor(255,255,255,alpha))
    --dxDrawRectangle(rx - sizes["search"].x/2, ry - sizes["search"].y/2, sizes["search"].x, sizes["search"].y)
    
    --local rx = center.x + sizes["center"].x/2 - 10
    
    --dxDrawText("Online játékosok: #d97c0e"..#cache.."/"..slots, rx, y, rx, y + sizes["center"].y, tocolor(255,255,255,alpha), 1, font, "right", "center",false,false,false,true)
    --y = y + sizes["bottom"].y
    --dxDrawImage(center.x - sizes["staymta"].x/2, y, sizes["staymta"].x, sizes["staymta"].y, sources["staymta"], 0,0,0, tocolor(255,255,255,alpha))
end

--Cache Function
function cacheCreate()
    if state then
        --outputChatBox("asd")
        cacheDestroy()
		
        local a = 1
        for k,v in pairs(getElementsByType("player")) do
            if v ~= localPlayer then
                local details = cacheGetDetails(v)
                table.insert(cache, details)
                a = a + 1
            end
        end
        
        --[[local names = {
            "Thomas_Stevens",
            "Joey_Briton",
            "Emanuel_Estephan",
            "Elliot_Carney",
            "Bobby_Morse",
            "Maison_Gould",
            "Frederick_John",
            "Corey_Sargent",
            "Deangelo_Bernard",
            "Michael_Taylor",
            "Oliver_Morgan",
            "Griffin_Powell",
            "May_Brighton",
            "Jack_Emanuel",
            "Jack_Stephen",
            "Joe_Boe",
            "Joe_Boe",
            "Joe_Boe",
        }

        for i = 3, 500 do
            local ped = createPed(107, 0, 0,0)
            ped:setData("level", math.random(2, 15))
            local num = math.random(1, 15)
            local num2 = math.random(1, 2)
            if num == 10 then num = 1 end
            if num2 == 1 then
                num2 = true
            else
                num2 = false
            end
            --local name = names[i - 3]
            if num2 then
                ped:setData("avatar", num)
                ped:setData("loggedIn", num2)
            end
            --ped:setData("name", names[math.random(1, 2)])
            --outputChatBox(names[i - 3])
            local details = cacheGetDetails(ped, names[math.random(1, #names)])
            details["id"] = i
            table.insert(cache, details)
            a = a + 1
        end--]]
        
        count = a

        local details = cacheGetDetails(localPlayer)
        table.insert(cache, 1, details)
        
        table.sort(cache, function(a, b)
            if a["element"] and b["element"] and a["element"] ~= localPlayer and b["element"] ~= localPlayer and a["id"] and b["id"] then
                return tonumber(a["id"]) < tonumber(b["id"])
            end
        end);

        if maxLines > #cache then
            minLines = 1
            maxLines = minLines + (_maxLines - 1)
        end

        if isTimer(pingUpdateTimer) then destroyElement(pingUpdateTimer) end
        pingUpdateTimer = setTimer(
            function()
                --cacheCreate()
                for i = minLines, maxLines do
                    if cache[i] then
                        local _i = i
                        local i = cache[i]
                        local v = i["element"]
                        if isElement(v) then
                            cache[_i]["ping"] = v.ping or -1
                            cache[_i]["pingColor"] = getPingColor(v.ping or -1)
                        else
                            cacheCreate()
                        end
                    end
                end
            end, 1000, 0
        )

        --outputDebugString("Score: Cache - created")
    end
end

addEventHandler("onClientPlayerJoin", root, 
    function()
        setTimer(cacheCreate, 150, 1)
    end
)
addEventHandler("onClientPlayerQuit", root, cacheCreate)

function cacheGetDetails(v, a2)
    local a = {}
	if v:getData("loggedin") == 1 then
		v:setData("charactername", getPlayerName(v))
	end
    a["loggedin"] = v:getData("loggedin")
    a["timedout"] = v:getData("timedout")
    a["id"] = v:getData("playerid") or 0
    a["aduty"] = v:getData("duty_admin") or false
    a["aColor"] = "#ffffff"
    a["aTitle"] = "Ismeretlen"
    local name = v:getData("charactername") or "Giriş yapıyor.."
    name = string.gsub(name, "_", " ")
    name = string.gsub(name, "#" .. (6 and string.rep("%x", 6) or "%x+"), "")
    a["name"] = string.gsub(name, "#%x%x%x%x%x%x", "")
    a["lvl"] = v:getData("level") or 1
    a["avatar"] = v:getData("avatar") or 0
    a["ping"] = v.ping - 40 or 1
    a["pingColor"] = getPingColor(v.ping or -1)
    a["element"] = v
    return a
end

function cacheDestroy()
    cache = {}
    
    if isTimer(pingUpdateTimer) then
        killTimer(pingUpdateTimer)
    end
end

function search(e)
    for a, b in pairs(cache) do
        local x = b["element"]
        if x == e then
            return a
        end
    end
    
    --outputChatBox(i)
    return false
end

function getPingColor(ping)
    local color = "#ffffff"
    
    if ping <= 60 then -- zöld
        color = "#7cc576"
    elseif ping <= 130 then -- sárga
        color = "#d09924"
    elseif ping >= 130 then -- piros
        color = "#d02424"
    end
    
    return color
end

addEventHandler("onClientElementDataChange", root,
    function(dName, oValue)
        if state then
            if dName == "loggedin" then
                local k = search(source)
                if k then
                    local value = source:getData(dName)
                    cache[k]["loggedin"] = value
                end
            elseif dName == "playerid" then
                local k = search(source)
                if k then
                    local value = source:getData(dName)
                    cache[k]["id"] = value
                end
            elseif dName == "timedout" then
                local k = search(source)
                if k then
                    local value = source:getData(dName)
                    cache[k]["timedout"] = value
                end
            elseif dName == "duty_admin" or dName == "account:username" or dName == "account:username" or dName == "admin_level" then
                local k = search(source)
                if source == localPlayer then
                    --outputChatBox("asd2")
                    --cacheCreate()
                end
                
                if k then
                    local value = source:getData(dName)
                    if dName == "duty_admin" then
                        cache[k]["aduty"] = value
                    end
                    
                    local name = "Yetkili"
                    name = string.gsub(name, "_", " ")
                    cache[k]["name"] = string.gsub(name, "#%x%x%x%x%x%x", "")
                    cache[k]["aColor"] = "#f9f9f9"
                    cache[k]["aTitle"] = "Test"
                    searchCache = {}
                    if textbars["search"] and textbars["search"][2] and textbars["search"][2] then
                        local text = string.lower(textbars["search"][2][2])
                        if #text > 0 then
                            for k,v in pairs(cache) do
                                local text2 = string.lower(v["name"])
                                local e = v["element"]
                                if utf8.find(text2, text) then
                                    if e == localPlayer then
                                        table.insert(searchCache, 1, v)
                                    else
                                        table.insert(searchCache, v)
                                    end
                                end
                            end
                            if maxLines > #searchCache then
                                minLines = 1
                                maxLines = minLines + (_maxLines - 1)
                            end
                        end
                    end
                end
            elseif dName == "name" then
                local k = search(source)
                if k then
                    local name = "Test"
                    name = string.gsub(name, "_", " ")
                    cache[k]["name"] = string.gsub(name, "#%x%x%x%x%x%x", "")
                    searchCache = {}
                    local text = string.lower(textbars["search"][2][2])
                    if #text > 0 then
                        for k,v in pairs(cache) do
                            local text2 = string.lower(v["name"])
                            local e = v["element"]
                            if utf8.find(text2, text) then
                                if e == localPlayer then
                                    table.insert(searchCache, 1, v)
                                else
                                    table.insert(searchCache, v)
                                end
                            end
                        end
                        if maxLines > #searchCache then
                            minLines = 1
                            maxLines = minLines + (_maxLines - 1)
                        end
                    end
                end
            elseif dName == "hoursplayed" then
                local k = search(source)
                if k then
                    local value = source:getData(dName)
                    cache[k]["lvl"] = value
                end
            elseif dName == "avatar" then
                local k = search(source)
                if k then
                    local value = source:getData(dName)
                    cache[k]["avatar"] = value
                end    
            end
        end
    end
)