resourceRoot = getResourceRootElement(getThisResource())

yasaklilar = {
	"say",
	"LocalOOC",	
	"ban",
	"pban",
	"oban",
	"jail",
	"sjail",
	"warn",
	"baliktut",
	"me",
	"do",
	"sethp",
	"fixveh",
	"kick",
	"pkick",
	"skick",
	"stopres",
	"sojail",
	"ar",
	"cr",
	"ri",
}




addEventHandler("onClientResourceStart",resourceRoot,function()
	addEventHandler("onClientKey", root,function(button, press) 
		local komut = bindleriCek(button)
		if komut then  
			if press then  
				if isChatBoxInputActive() then return end 
				if guiGetInputEnabled( ) == false then  
					cancelEvent()  
					outputChatBox("Bu butonda uygunsuz komut var. Kaldırmak için: #FFFFFF/unbind #CC0000"..button.." #FFFFFF"..komut, 255,0,0, true)  --chate yazı at
				end	
			end	
		end	
	end)
end)

function bindleriCek(buton)
	for i,v in pairs(yasaklilar) do
		local butonlar = getBoundKeys ( v )
		if type(butonlar) ~= "boolean" and butonlar[buton] then
			return v
		end	
	end
	return false	
end	