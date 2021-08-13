addEvent("setDrunkness", true)
addEventHandler("setDrunkness", getRootElement(),
	function( level )
		exports.mrp_anticheat:changeProtectedElementDataEx( source, "alcohollevel", level or 0, false )
	end
)