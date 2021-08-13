hotlines = {
	[155] = "Polis İmdat",
	[112] = "112 Acil",
	[156] = "Jandarma",
}

function isNumberAHotline(theNumber)
	local challengeNumber = tonumber(theNumber)
	return hotlines[challengeNumber]
end