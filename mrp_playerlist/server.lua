
-- #author:okarosa

local mysql = exports['mrp_mysql']

_changeAvatar = function(player, cmd, number)
	if player:getData("loggedin") == 1 then
		
		
		if (tonumber(number) == 30 or tonumber(number) == 31) then	
				exports['mrp_infobox']:addBox(player, "error", "Bu avatar numaraları oKarosa ve Lucifer tarafından kullanılmaktadır.")		
			return
		end
		
		if not tonumber(number) then
				exports['mrp_infobox']:addBox(player, "error", "Kullanım: /avatar [1-18]")
			return 
		end
		
		if (tonumber(number) < 0 or tonumber(number) > 18) then	
				exports['mrp_infobox']:addBox(player, "error", "Lütfen 1 - 18 aralığında bir avatar sayısı değeri giriniz.")
			return 
		end
		
		local q = dbExec(mysql:getConnection(), "UPDATE characters SET avatar='"..tonumber(number).."' WHERE id='"..player:getData('dbid').."'")
		if q then
			player:setData("avatar", tonumber(number))
			exports['mrp_infobox']:addBox(player, "success", "Başarıyla avatar numaranızı '"..tonumber(number).."' olarak ayarladınız.")
		else
			exports['mrp_infobox']:addBox(player, "error", "Veritabanı kaynaklı bir hata oluştu. Lütfen yöneticiye başvurunuz.")
		end
	end
end