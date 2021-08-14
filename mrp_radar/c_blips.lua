
radarBlips = {}

radarOwnBlips = {}
limitlessDistanceBlips = {}
setTimer(
	function()
		local blipIndex = 1
		for index, value in ipairs(getElementsByType("blip")) do
			if getBlipIcon(value) ~= 0 then
				local distanceStatus = limitlessDistanceBlips[getBlipIcon(value)] and 1 or 0
				radarBlips["blip_"..blipIndex] = {getElementData(value, "name") or "",value,distanceStatus,getBlipIcon(value),30,30,255,255,255}
				blipIndex = blipIndex + 1
			end
		end
	end,
1500, 0)

local free_ids = {}
local free_id = 1
function createOwnBlip(type,word_x,word_y)
	local name = ""
	if type == "mark_1" or type == "mark_2" or type == "mark_3" or type == "mark_4" then name = "Jelölés"
	elseif type == "garage" then name = "Garázs"
	elseif type == "house" then name = "Ház"
	elseif type == "vehicle" then name = "Jármű" end
    if not free_ids[type] then
        free_ids[type] = 0
    end
    local free_id = free_ids[type] + 1
	if not radarOwnBlips[name.." "..tostring(free_id)] then
		local element = createBlip (word_x,word_y,0,0,2,255,0,0,255,0,0)
		radarOwnBlips[name.." "..tostring(free_id)] = {name.." "..tostring(free_id),word_x,word_y,0,type,12,12,255,255,255}
		createStayBlip(name.." "..tostring(free_id),element,0,type,12,12,255,255,255)
		free_ids[type] = 1 
	else
		free_ids[type] = free_id+1
		createOwnBlip(type,word_x,word_y)
	end
end

function deleteOwnBlip(name)
	if radarOwnBlips[name] then
		destroyStayBlip(name)
		radarOwnBlips[name] = nil
	end
end

function jsonLoad()
	local json = fileOpen(":mrp_radar/allblips.json")
	local json_string = ""
	while not fileIsEOF(json) do
		json_string = json_string..""..fileRead(json,500)
	end
	fileClose(json)
	return fromJSON(json_string)
end

function jsonSave()
	if fileExists(":mrp_radar/allblips.json") then fileDelete(":mrp_radar/allblips.json") end
	local json = fileCreate(":mrp_radar/allblips.json")
		local json_string = toJSON(radarOwnBlips)
		fileWrite(json,json_string)
		fileClose(json)
end

addEventHandler( "onClientResourceStart",resourceRoot,function()
	if fileExists(":mrp_radar/allblips.json") then

		local blip_table = nil
		local json = fileOpen(":mrp_radar/allblips.json")
		local json_string = ""
		while not fileIsEOF(json) do
			json_string = json_string..""..fileRead(json,500)
		end
		fileClose(json)
		blip_table = fromJSON( json_string )
		for k, values in pairs(blip_table) do
			radarOwnBlips[values[1]] = {values[1],values[2],values[3],values[4],values[5],values[6],values[7],values[8],values[9],values[10]}
			createStayBlip(values[1],createBlip (values[2],values[3],0,0,2,255,0,0,255,0,0),values[4],values[5],values[6],values[7],values[8],values[9],values[10])
		end
	end
end)

addEventHandler( "onClientResourceStop",resourceRoot,function()
	 jsonSave()
end)



function createStayBlip(name,element,visible,image,imgw,imgh,imgr,imgg,imgb,no3d)
    radarBlips[name] = {name,element,visible,image,imgw,imgh,imgr,imgg,imgb,no3d}
end


function destroyStayBlip(name)
	radarBlips[name] = nil
end
