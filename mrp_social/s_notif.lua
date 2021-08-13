-- [[ handler responders ]]
function getImage( playerToReceive, id )
    triggerClientEvent( playerToReceive, "onClientGotImage", resourceRoot, exports.mrp_cache:getImage(id))
end

addEvent("getImage", true)
addEventHandler("getImage", resourceRoot , getImage)