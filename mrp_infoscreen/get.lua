
Get = {
    debug = false,
    cache = {
        ['location'] = ':mrp_infoscreen/storage/cache.xml',
        ['players'] = {},
    },

    _load = function(self)
        self.cache.file = XML.load(self.cache.location)
    end,

    _find = function(self,username)
        if self:index() then
            if not username then return false end 
            return self.cache['players'][tostring(username)] or false
        end
    end,

    _add = function(self,username)
        local datanode = false
        if not self.cache.file then 
            self:_load()
        return self:_find(username)
        end

        if not self:_find(username) then  
            child = self.cache.file:findChild("data",0);
            if child then  
                childata = child:getAttributes();
                for i,v in pairs(childata) do 
                    if i == 'username' then 
                        if v ~= tostring(username) then 
                            datanode = self.cache.file:createChild('data')
                            datanode:setAttribute('username',username)    
                            self.cache.file:saveFile() 
                            self.cache.file:unload() 
                            self:index()
                        end
                    end
                end

            else 
                datanode = self.cache.file:createChild('data')
                datanode:setAttribute('username',username)    
                self.cache.file:saveFile() 
                self.cache.file:unload() 
                self:index()
            end
        end
    end,

    index = function(self)
        self:_load();
        if self.cache.file then 
            self.cache.child = self.cache.file:findChild("data",0);
            if self.cache.child then 
                self.cache.data = self.cache.child:getAttributes();
                if self.cache.data then 
                    for i,v in pairs(self.cache.data) do 
                        if i == 'username' then 
                            self.cache['players'][v] = v
                        end
                    end
                end
            else 
                self.cache.players = {}
            end
            return true
        else 
            self.cache.file = XML(self.cache.location,'root')
            self.cache.file:saveFile()
            self.cache.file:unload()
        return self:index()
        end
    end,
}

Get:index()

addEvent(sha256('mrp_infoscreen'..md5('parsrp')..'checkifexist'),true)
addEventHandler(sha256('mrp_infoscreen'..md5('parsrp')..'checkifexist'),root,function(username)
    if not username then return false end 
    if Get:_find(username) then 
        triggerClientEvent(root,sha256('mrp_infoscreen'..md5('parsrp')..'callback'),root,true)
    else 
        triggerClientEvent(root,sha256('mrp_infoscreen'..md5('parsrp')..'callback'),root,false)
    end
 end)

 addEvent(sha256('mrp_infoscreen'..md5('parsrp')..'add'),true)
 addEventHandler(sha256('mrp_infoscreen'..md5('parsrp')..'add'),root,function(username)
    if not username then return false end
    Get:_add(username)
 end)