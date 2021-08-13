local miktar = 700

function betonparaver()
	setElementData(source, "beton:yukaldi", false)
		if getElementData(source, "vip") == 1 then
			miktar = 725
		elseif getElementData(source, "vip") == 2 then
			miktar = 750
		elseif getElementData(source, "vip") == 3 then
			miktar = 775
		end
	exports.mrp_global:giveMoney(source, miktar)
	outputChatBox("[!] #FFFFFFTebrikler, bu turdan $"..miktar.." kazandınız!", source, 0, 255, 0, true)
end
addEvent("beton:paraver", true)
addEventHandler("beton:paraver", getRootElement(), betonparaver)

local pickup = createPickup(2330.8447265625, -2055.0732421875, 13.546875, 3, 1239)
setElementData(pickup, "informationicon:information", "#66CC00/cimentoyukle#ffffff\nÇimento")