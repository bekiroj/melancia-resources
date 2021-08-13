-- Bu senaryo bekiroj tarafından yazılmıştır
local pickup1 = createPickup(1911.296875, -1775.27734375, 13.411722183228, 3, 1239)
setElementData(pickup1, "informationicon:information", "#ffffff/tamiret#90C92F\n200₺")
local tamiryeri1 = createColSphere ( 1911.296875, -1775.27734375, 13.411722183228, 3)

local pickup2 = createPickup(2063.6435546875, -1831.23046875, 13.546875, 3, 1239)
setElementData(pickup2, "informationicon:information", "#ffffff/tamiret#90C92F\n200₺")
local tamiryeri2= createColSphere ( 2063.6435546875, -1831.23046875, 13.546875, 3)

local pickup3 = createPickup(1017.6982421875, -917.615234375, 42.1796875, 3, 1239)
setElementData(pickup3, "informationicon:information", "#ffffff/tamiret#90C92F\n200₺")
local tamiryeri3 = createColSphere ( 1017.6982421875, -917.615234375, 42.1796875, 3)

function vehicle_fix(thePlayer)
	if isPedInVehicle(thePlayer) then
		if isElementWithinColShape(thePlayer, tamiryeri1) or isElementWithinColShape(thePlayer, tamiryeri2) or isElementWithinColShape(thePlayer, tamiryeri3) then
			local car = getPedOccupiedVehicle(thePlayer)

			if not exports.mrp_global:takeMoney(thePlayer, 200) then -- tamir fiyatı
				outputChatBox("Sunucu: #ffffffAracınızı tamir etmek için 200₺ ödemeniz gerekli.", thePlayer, 255,0,0,true)
			return end

			outputChatBox("Sunucu: #ffffffAracınız tamir ediliyor, bekleyin.", thePlayer, 255,0,0,true)
			toggleAllControls ( thePlayer, false )
			setElementData(car, "enginebroke", 0, false)
			setElementFrozen(car, true)
			setTimer(function()
				triggerEvent("fixVehicle", thePlayer)
				outputChatBox("Sunucu: #ffffffAracınız tamir edildi.", thePlayer, 255,0,0,true)
				 toggleAllControls ( thePlayer, true )
				 setElementFrozen(car, false)
			end, 5000, 1)
		end
	end
end
addCommandHandler("tamiret", vehicle_fix)

addEvent("fixVehicle", true)
addEventHandler("fixVehicle", getRootElement(),
	function()
		fixVehicle(getPedOccupiedVehicle(source))
		setElementData(source, "enginebroke", 0, false)
	end
)