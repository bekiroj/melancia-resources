function hasSpaceForItem( ... )
	return call( getResourceFromName( "mrp_items" ), "hasSpaceForItem", ... )
end

function hasItem( element, itemID, itemValue )
	return call( getResourceFromName( "mrp_items" ), "hasItem", element, itemID, itemValue )
end

function getItemName( itemID )
	return call( getResourceFromName( "mrp_items" ), "getItemName", itemID )
end
