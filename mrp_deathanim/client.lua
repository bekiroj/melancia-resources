emekleyenler = {}

function isEventHandlerAdded( sEventName, pElementAttachedTo, func )
     if type( sEventName ) == 'string' and isElement( pElementAttachedTo ) and type( func ) == 'function' then
          local aAttachedFunctions = getEventHandlers( sEventName, pElementAttachedTo )
          if type( aAttachedFunctions ) == 'table' and #aAttachedFunctions > 0 then
               for i, v in ipairs( aAttachedFunctions ) do
                    if v == func then
        	         return true
        	    end
	       end
	  end
     end
     return false
end

function change()--animasyonu sıfırlama
	setPedAnimationProgress(localPlayer, "FLOOR_hit_f", 0)
end

function degistir()
if getElementData(localPlayer, "Emekleme") == true then
	local x, y, z, x1, y1, z1 = getCameraMatrix ( localPlayer ) 
                    local rx, ry, rz = findRotation(x, y, x1, y1) 
	                setElementRotation(localPlayer,0,0,rx+90)
end
end
function render()--rotasyon
	setPedAnimationProgress(localPlayer, "FLOOR_hit_f", 0)
end

	
function findRotation( x1, y1, x2, y2 ) 
    local t = -math.deg( math.atan2( x2 - x1, y2 - y1 ) )
    return t < 0 and t + 360 or t
end	
	
function render2()
	local x, y, z, x1, y1, z1 = getCameraMatrix ( localPlayer ) 
    local rx, ry, rz = findRotation(x, y, x1, y1) 
	setElementRotation(localPlayer,0,0,rx+90) 
end

addEventHandler("onClientKey", root,
	function(b, s)
		if s and b == "w" then
			if getElementData(localPlayer, "Emekleme") then
				cancelEvent()
			end
		end
	end
)

keys = {
	[""] = "forwards",
}

addEventHandler("onClientKey", root, function(key,press)
	if keys[key] then
		if emekleyenler[localPlayer] then
			if getKeyState(key) then
				setElementFrozen(localPlayer, false)
				setPedControlState(localPlayer, keys[key], true)
				
				if not isTimer(timer) and not isTimer(timertwo) then 
					setPedAnimation(localPlayer, "ped", "FLOOR_hit_f") 
					timer = setTimer(change,600,0) 
					--timertwo = setTimer(degistir,150,0) 
				end
				if not isTimer(timertwo) then 
				timertwo = setTimer(degistir,150,0) 
				end
				removeEventHandler("onClientRender",root,render,true,"low")
				--removeEventHandler("onClientRender",root,render2,true,"low")
			else
				for i,v in pairs(keys) do if getKeyState(i) then return end end
				setPedControlState(localPlayer, keys[key], false)
				setElementFrozen(localPlayer, true)
				if isTimer(timer) then killTimer(timer) end
				if isTimer(timertwo) then killTimer(timertwo) end
				setPedAnimation(localPlayer, "ped", "FLOOR_hit_f")
				addEventHandler("onClientRender",root,render,true,"low")
			end	
		end	
	end
end)


function changeCheck(oyuncu)
	if isElement(oyuncu) and getPedControlState(oyuncu, "forwards") then
		--outputChatBox(getPlayerName(oyuncu))
		setPedAnimationProgress(oyuncu, "FLOOR_hit_f", 0)
	end	
end

local timer2 = {}
function emekletRender()
	local x,y,z = getElementPosition(localPlayer)
	for i,oyuncu in pairs(emekleyenler) do
		if isElement(oyuncu) then
				local blok, anim = getPedAnimation(oyuncu)
				
				if blok ~= "ped" and anim ~= "FLOOR_hit_f" then
					setPedAnimation(oyuncu, "ped", "FLOOR_hit_f")
				end
				
				if getPedControlState(oyuncu, "forwards") then
					if not isTimer(timer2[oyuncu]) then 
						if oyuncu ~= localPlayer then
							timer2[oyuncu] = setTimer(changeCheck,600,0,oyuncu) 
						end	
					end
				else
					if isTimer(timer2[oyuncu]) then killTimer(timer2[oyuncu]) end
					setPedAnimationProgress(oyuncu, "FLOOR_hit_f", 0)
				end	
			--end	
		end
	end
end
addEventHandler("onClientRender",root,emekletRender)

addEvent("Emekleme:Emeklet", true)
addEventHandler("Emekleme:Emeklet", root, function(deger)
	if deger == "Ekle" then
		emekleyenler[source] = source
		setElementData(source, "Emekleme",true)
		setPedAnimation(source, "ped", "FLOOR_hit_f")
		setElementFrozen(source, true)
	elseif deger == "Kaldır" then	
		if emekleyenler[source] then emekleyenler[source] = nil end
		removeEventHandler("onClientRender",root,render,true,"low")
		removeEventHandler("onClientRender",root,render2,true,"low")
		setElementFrozen(source, false)
		setElementData(source, "Emekleme",nil)
		setPedAnimation(source, "", "")
	end	
end)


addEventHandler( "onClientElementStreamIn", root, function()
	if getElementType(source) == "player" and emekleyenler[source] then
		setPedAnimation(source, "ped", "FLOOR_hit_f")
	end
end)


triggerServerEvent("Emekleme:OyuncuGirdi", localPlayer)
