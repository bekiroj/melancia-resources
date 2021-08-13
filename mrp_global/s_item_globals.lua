function hasSpaceForItem( ... )
	return call( getResourceFromName( "mrp_items" ), "hasSpaceForItem", ... )
end

function hasItem( element, itemID, itemValue )
	return call( getResourceFromName( "mrp_items" ), "hasItem", element, itemID, itemValue )
end

function giveItem( element, itemID, itemValue )
	return call( getResourceFromName( "mrp_items" ), "giveItem", element, itemID, itemValue, false, true )
end

function takeItem( element, itemID, itemValue )
	return call( getResourceFromName( "mrp_items" ), "takeItem", element, itemID, itemValue )
end
