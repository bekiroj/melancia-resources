
Info = {
    debug = false,
    screen = Vector2(guiGetScreenSize()),
    state = false,
    isowl = true,
    cache = {},

    _method = function(self,value)
        if self.debug then 
            outputDebugString('[F1-INFO] _method adlı fonksiyon verileri (value = '..tostring(value)..')',0,240,240,240)
        end
        if (value == 'create') then
            WebUIManager:new()
            self.cache.html = WebWindow:new(Vector2(0,0), Vector2(self.screen.x, self.screen.y), "http://mta/mrp_infoscreen/html/interface.html", true);         
            if self.debug then 
                outputDebugString('[F1-INFO] Geliştirici modu aktif hale getirildi.',0,240,240,240)
                setDevelopmentMode(true, true);
            end
        elseif (value == 'destroy') then 
            if not self.cache.html then return false end
            self.cache.html:executeJavascript2("close()");
            showCursor(false)                
            setTimer(function()
                self.cache.html:destroy();
                showChat(true)
                showCursor(false)
                localPlayer:setData('mrp_infoscreen:state',false,false)
                localPlayer:setData('minimap:close',false,false)
                localPlayer:setData('isactive',false,false)
            end,400,1)
        end
    end,

    down = function(self)
        if self.state then
            self:_method('destroy');
            removeEventHandler("onClientBrowserCreated",Info.cache.html:getUnderlyingBrowser(),self._load)
        end
        localPlayer:setData('mrp_infoscreen:state',false,false)
        localPlayer:setData('minimap:close',false,false)
        localPlayer:setData('isactive',false,false)
    return true
    end,

    latent = function(self)
        if self.isowl then 
            self.key = 'account:username';
        else 
            self.key = 'oplayer';
        end
    end,

    returntohtml = function(self,value)
        if not value and self.cache.html then 
            self.cache.html:executeJavascript2('first()');
        end
    end,

    index = function(self)
        if self.state then 
            self:_method('destroy');
            if self.debug then 
                outputDebugString('[F1-INFO] "mrp_infoscreen:state" adlı kullanıcı (client) bazlı değişken değeri '..tostring(not self.state)..' olarak ayarlandı.',0,240,240,240)
            end 
        else 
            if localPlayer:getData('isactive') then return false end
            if localPlayer:getData('playerlist') then return false end
            self:_method('create');
            showChat(false)
            showCursor(true)
            localPlayer:setData('mrp_infoscreen:state',true,false)
            localPlayer:setData('minimap:close',true,false)
            localPlayer:setData('isactive',true,false)
            if self.debug then 
                outputDebugString('[F1-INFO] "mrp_infoscreen:state" adlı kullanıcı (client) bazlı değişken değeri '..tostring(not self.state)..' olarak ayarlandı.',0,240,240,240)
            end
        end
        self.state = not self.state
    end,
}

Info:latent()

bindKey('F1','down',function() 
    if localPlayer:getData(Info.key) then 
        Info:index()
    end
end)

addEventHandler('onClientResourceStop',getResourceRootElement(getThisResource()),function()
    Info:down()
end)

addEvent('info.create.username.javascript.html5.document.callback',true)
addEventHandler('info.create.username.javascript.html5.document.callback',root,function()
end)