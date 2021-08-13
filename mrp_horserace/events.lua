addEvent('horserace.take.money', true)
addEventHandler('horserace.take.money', root, function()
	if source then
		exports.mrp_global:takeMoney(source, 5000)
	end
end)

addEvent('horserace.give.money', true)
addEventHandler('horserace.give.money', root, function()
	if source then
		exports.mrp_global:giveMoney(source, 12500)
	end
end)