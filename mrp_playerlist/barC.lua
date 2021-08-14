textbars = {}
local guiState = false
local now = 0
local tick = 0
local state = false
searchCache = {}
 

function CreateNewBar(name, details, options, id)
    searchCache = {}
    local x,y,w,h = unpack(details)
    textbars[name] = {details, options, id}
    if not state then
        addEventHandler("onClientRender", root, DrawnBars, true, "low-5")
        state = true
    end
end

function onGuiBlur()
    guiBringToFront(source)
end

function onGuiChange()
    local name = getElementData(source, "name") or ""
    textbars[name][2][2] = guiGetText(source)
    playSound("files/key.mp3")
    searchCache = {}
    local text = string.lower(textbars[name][2][2])
    
    for k,v in ipairs(cache) do
        local text2 = string.lower(v["name"])
        local text3 = string.lower(tostring(v["id"]))
        local e = v["element"]
        
        if string.lower(tostring(text2)):find(text) or string.lower(text3):find(text) then
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

function Clear()
    for k,v in pairs(textbars) do
        if isElement(v[4]) then
            destroyElement(v[4])
        end
        textbars[k] = nil
    end
    if state then
        removeEventHandler("onClientRender", root, DrawnBars)
        state = false
        guiState = false
        tick = 0
        now = 0
    end
end

function UpdatePos(name, details)
    if textbars[name] then
        textbars[name][1] = details
        if not state then
            addEventHandler("onClientRender", root, DrawnBars, true, "low-5")
            state = true
        end
    end
end

function GetText(name)
    return textbars[name][2][2]
end

function DrawnBars()
    for k,v in pairs(textbars) do
        local details = v[1]
        local x,y,w,h = unpack(details)
        local w,h = x + w, y + h
        local options = v[2]
        local text = options[2]
        local color = options[4]
        local font = options[5]
        local fontsize = options[6]
        local alignX = options[7]
        local alignY = options[8]
        local secured = options[9]
        
        if text == "" or #text == 0 then
            text = "Karakter Adı & ID"
        end
        
        if text ~= "Karakter Adı & ID" then
            if isElement(v[4]) then
                tick = tick + 5
                if tick >= 425 then
                    tick = 0
                elseif tick >= 250 then
                    text = text .. "|"
                end 
            end
        end
        
        local color = tocolor(200,200,200,math.min(255 * 0.5, alpha))
        dxDrawText(text, x,y, w,h, color, fontsize, font, alignX, alignY)
    end
end

addEventHandler("onClientClick", root,
    function(b, s)
        if b == "left" and s == "down" then
            if state then
                for k,v in pairs(textbars) do
                    local details = v[1]
                    local x,y,w,h = unpack(details)
                    if isInSlot(x,y,w,h) then
                        if not isElement(v[4]) then
                            local gui = GuiEdit(-1, -1, 1, 1, textbars[k][2][2], true)
                            gui.maxLength = v[2][1]
                            gui:setData("name", k)
                            gui.caretIndex = #textbars[k][2][2]
                            setTimer(guiBringToFront, 50, 1, gui)
                            addEventHandler("onClientGUIBlur", gui, onGuiBlur, true)
                            addEventHandler("onClientGUIChanged", gui, onGuiChange, true)
                            textbars[k][4] = gui
                        else
                            guiBringToFront(v[4])
                        end
                        return
                    end
                end
                
                for k,v in pairs(textbars) do
                    if isElement(v[4]) then
                        destroyElement(v[4])
                    end
                    textbars[k][4] = nil
                end
            end
        end
    end
)