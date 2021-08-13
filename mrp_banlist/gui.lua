-- // written by sourcelua.

function createWindow(banList)
    window = guiCreateWindow(0, 0, 500, 315, "Sunucudan banlanan kişiler", false)
    exports.mrp_global:centerWindow(window)

    gridlist = guiCreateGridList(9, 29, 480, 228, false, window)
    guiGridListAddColumn(gridlist, "Ban ID", 0.1)
    guiGridListAddColumn(gridlist, "Banlanan Oyuncu İsmi", 0.2)
    guiGridListAddColumn(gridlist, "Serial", 0.4)
    guiGridListAddColumn(gridlist, "İp", 0.4)

    for k, v in ipairs(banList) do 
        local row = guiGridListAddRow(gridlist)
        guiGridListSetItemText(gridlist,row,1,v[1],false,false)
        guiGridListSetItemText(gridlist,row,2,v[2],false,false)
        guiGridListSetItemText(gridlist,row,3,v[3],false,false)
        guiGridListSetItemText(gridlist,row,4,v[4],false,false)
    end

    close = guiCreateButton( 0.05, 0.85, 0.4, 0.10, "Kapat", true, window )
    ok = guiCreateButton( 0.55, 0.85, 0.4, 0.10, "Banını Kaldır", true, window )

    setTimer(function()
        state = not state
        if isElement(window) then
            if (state) then
                guiSetText(window, "Melancia")
            else
                guiSetText(window, "Sunucudan banlanan kişiler")
            end
        end
    end, 2000, 0)
end
addEvent('createBanlistGuiWindow', true)
addEventHandler('createBanlistGuiWindow', root, createWindow)

addEventHandler('onClientGUIClick', getRootElement(), 
    function(btn)
        if source == close then 
            destroyElement(window)
        elseif source == ok then
            local query = guiGridListGetSelectedItem(gridlist)
            local id = guiGridListGetItemText(gridlist, query, 1)
            triggerServerEvent('deleteBans', localPlayer, id)
            outputChatBox('[!]#FFFFFF Başarıyla '..guiGridListGetItemText(gridlist, query, 2)..' adlı kişinin banını kaldırdınız, Paneli aç kapat yaptığınızda düzelecektir.',0,255,0,true)

        end
    end
)