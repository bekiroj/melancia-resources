local miktar = 800

function tasimaparaver()
	setElementData(source, "tasima:yukaldi", false)
		if getElementData(source, "vip") == 1 then
			miktar = 875
		elseif getElementData(source, "vip") == 2 then
			miktar = 900
		elseif getElementData(source, "vip") == 3 then
			miktar = 950
		end
	exports.mrp_global:giveMoney(source, miktar)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan $"..miktar.." kazandınız!", source, 0, 255, 0, true)
end
addEvent("tasima:paraver", true)
addEventHandler("tasima:paraver", getRootElement(), tasimaparaver)

local pickup = createPickup(2460.8671875, -2116.0107421875, 13.546875, 3, 1239)
setElementData(pickup, "informationicon:information", "#66CC00/yukal#ffffff\nTaşımacılık")

local pickup2 = createPickup(2484.0263671875, -2116.0107421875, 13.546875, 3, 1239)
setElementData(pickup2, "informationicon:information", "#66CC00/yukal#ffffff\nTaşımacılık")

local pickup3 = createPickup(2508.439453125, -2116.0107421875, 13.546875, 3, 1239)
setElementData(pickup3, "informationicon:information", "#66CC00/yukal#ffffff\nTaşımacılık")