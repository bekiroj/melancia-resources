importer={}
importer.__index = importer

function importer:import(functionsToImport)
    if functionsToImport:len()>0 then
        local impr = {}
        setmetatable(impr,importer)
        impr.scripts=functionsToImport
        return impr
    end
end

function importer:from(script)
	local res=getResourceFromName(script)
    if res then
	   local functions=res:getExportedFunctions()
        if #functions>0 then
            local importThis={}
            if(self.scripts=="*")then
                importThis=functions
            else
                local tbsplit=split(self.scripts,",")
                for i,v in ipairs(functions)do
                    for ii,vv in ipairs(tbsplit)do
                        if(string.find(v,vv))then
                            table.insert(importThis,v)
                        end
                    end
                end
            end
            for i,v in ipairs(importThis)do
                _G[v]=function(...)
                    return call(res,v,...)
                end
            end
        end
    end
end

function import(...)
	return importer:import(...)
end