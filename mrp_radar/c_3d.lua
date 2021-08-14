local maxDist = 2500
local gObjid = 851

thblipstate = false

local renderCache = {}
local objects = {}
setTimer(
    function()
        renderCache = {}
        local px,py,pz = getElementPosition(localPlayer)
        
        for k,v in pairs(radarBlips) do
            local name,blip,type,image,_,_,r,g,b,no3d = unpack(v)
            if not no3d then
                if blip and isElement(blip) then
                   
                    local x,y,z = getElementPosition(blip)
                    local dist = getDistanceBetweenPoints3D(px,py,pz,x,y,z)
                    if dist <= maxDist then
                        local x,y,z = getElementPosition(blip)
                        local sx, sy = getScreenFromWorldPosition(x,y,z)
                        if sx and sy then
                            renderCache[k] = v
                            renderCache[k]["dist"] = {dist, math.floor(dist)}
                            renderCache[k]["screen"] = {x,y,z}
                        end
                    end
                end
            end    
        end
    end, 50, 0
)

function render3DBlips()
    if bigmapIsVisible then return end
    if localPlayer.dimension ~= 0 or localPlayer.interior ~= 0 then return end
    if not localPlayer:getData("loggedin") == 1 then return end
    local font = exports['mrp_fonts']:getFont("Roboto", 11)
    local px,py,pz = getElementPosition(localPlayer)
    for name, data in pairs(renderCache) do
        local name,blip,type,image,_,_,r,g,b,no3d = unpack(data)
        local dist, dist2 = data["dist"][1], data["dist"][2]
        local x,y,z = data["screen"][1], data["screen"][2], data["screen"][3]
        --outputChatBox(r.."-"..g.."-"..b)
        --local x,y,z = getElementPosition(blip)
        local sx, sy = getScreenFromWorldPosition(x,y,z)
        if sx and sy then
            local multipler = 1 - dist / maxDist
            --local a = 50 * multipler
            local c = 32 * multipler
            local alpha = 255 * multipler
            --outputChatBox(r.."-"..g.."-"..b)
            dxDrawImage(sx - c/2, sy - (10 * multipler) - c, c, c, "assets/images/blips/"..image..".png", 0,0,0, tocolor(r,g,b,alpha))
            dxDrawText(name, sx, sy, sx, sy, tocolor(255, 255, 255, alpha), multipler, font, "center", "center", false, false, false, true)
            dxDrawText("#7cc576".. dist2 .. "#ffffff mt", sx, sy + (15 * multipler), sx, sy + (15 * multipler), tocolor(255, 255, 255, alpha), multipler, font, "center", "center", false, false, false, true)
        end
    end
end

--renderTimers = {}

function toggle3DBlip(state)
    thblipstate = state --not thblipstate
    if not thblipstate then
        --removeEventHandler("onClientRender", root, render3DBlips)
        destroyRender("render3DBlips")
    else
        --addEventHandler("onClientRender", root, render3DBlips, true, "low-5")
        createRender("render3DBlips", render3DBlips)
    end
end