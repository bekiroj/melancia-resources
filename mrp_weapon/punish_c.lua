function cancelAttack (attacker, weapon, bodypart )
	if getElementData(attacker, 'level') < 2 then
		cancelEvent()
	end
	if getElementData(source, 'level') < 2 then
		cancelEvent()
	end
end
addEventHandler ( "onClientPlayerDamage", getRootElement(), cancelAttack)