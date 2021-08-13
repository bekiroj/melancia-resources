function openDutyWindow()
	local availablePackages, allowList = fetchAvailablePackages(localPlayer)
		
	if #availablePackages > 0 then
		local dutyLevel = getElementData(localPlayer, "duty")
		if not dutyLevel or dutyLevel == 0 then
			selectPackageGUI_open(availablePackages, allowList)
		else
			triggerServerEvent("duty:offduty", localPlayer)
		end
	else
		outputChatBox(exports.mrp_pool:getServerSyntax("Duty", "w").."Herhangi bir işbaşı bölgesinde bulunmuyorsun.", 255, 255, 255, true)
	end
end
addCommandHandler("duty", openDutyWindow)

addCommandHandler("armor",
	function()
		local availablePackages, allowList = fetchAvailablePackages(localPlayer)
		if #availablePackages > 0 then
			local dutyLevel = getElementData(localPlayer, "duty")
			if dutyLevel or dutyLevel == 1 then
				if getElementData(localPlayer, "faction") == 1 or getElementData(localPlayer, "faction") == 78 then
					createArmourGUI()
				end
			end
		else
			outputChatBox(exports.mrp_pool:getServerSyntax("Duty", "w").."Herhangi bir işbaşı bölgesinde bulunmuyorsun.", 255, 255, 255, true)
		end
	end
)

function createArmourGUI()
	local time = getRealTime()
	window = guiCreateWindow(0, 0, 520, 200, "LSPD, Commerce HQ - M:RPG", false)
    guiWindowSetSizable(window, false)
    exports.mrp_global:centerWindow(window)

    infoLabel = guiCreateLabel(7, 29, 503, 40, "Bu arayüzden operasyon yeleğinizin türünü belirleyip alabilirsiniz.", false, window)
    guiLabelSetHorizontalAlign(infoLabel, "center", false)
    okButton = guiCreateButton(10, 157, 317, 33, "Seçileni Al", false, window)
    denyButton = guiCreateButton(335, 158, 165, 32, "Pencereyi Kapat", false, window)
    _25 = guiCreateRadioButton(9, 71, 501, 19, "%50 Zırh", false, window)
    _50 = guiCreateRadioButton(9, 97, 501, 19, "%75 Zırh", false, window)
    _75 = guiCreateRadioButton(9, 121, 501, 19, "%100 Zırh", false, window)
   	addEventHandler("onClientGUIClick", root,
   		function(b)
   			if b == "left" then
   				if source == denyButton then
   					destroyElement(window)
   				elseif source == okButton then
   					if guiRadioButtonGetSelected(_25) then
						triggerServerEvent("duty.setArmor", localPlayer, localPlayer, 50)
   						outputChatBox(exports.mrp_pool:getServerSyntax(false, "s").."Zırh başarıyla edinildi.", 255, 255, 255, true)
   						destroyElement(window)
   						return
   					end
   					if guiRadioButtonGetSelected(_50) then
					 	triggerServerEvent("duty.setArmor", localPlayer, localPlayer, 75)
   						outputChatBox(exports.mrp_pool:getServerSyntax(false, "s").."Zırh başarıyla edinildi.", 255, 255, 255, true)
   						destroyElement(window)
   						return
   					end
   					if guiRadioButtonGetSelected(_75) then
						triggerServerEvent("duty.setArmor", localPlayer, localPlayer, 100)
   						outputChatBox(exports.mrp_pool:getServerSyntax(false, "s").."Zırh başarıyla edinildi.", 255, 255, 255, true)
   						destroyElement(window)
   						return
   					end
   				end
   			end
   		end
   	) 
end

function itemIsAllowed(allowList, id)
	for k,v in pairs(allowList) do
		if tonumber(id) == tonumber(v[1]) then
			return true
		end
	end
	return false
end

-- --- --
-- GUI --
-- --- --
local gAvailablePackages = nil
local gChks = { }
local gButtons = { }
local gui = { }

function selectPackageGUI_open(availablePackages, allowList)
	gAvailablePackages = availablePackages
	local screenWidth, screenHeight = guiGetScreenSize()
	local windowWidth, windowHeight = 680, 516
	local left = screenWidth/2 - windowWidth/2
	local top = screenHeight/2 - windowHeight/2
	gui["_root"] = guiCreateWindow(left, top, windowWidth, windowHeight, "Duty Selection", false)
	guiWindowSetSizable(gui["_root"], false)
	
	gui["tabSelection"] = guiCreateTabPanel(10, 25, 651, 471, false, gui["_root"])
	for pIndex, packageDetails in ipairs(availablePackages) do
		local guiTabName = "package"..tostring(packageDetails[1])
		gui[guiTabName] = guiCreateTab(packageDetails[2], gui["tabSelection"])

		local xAxis = 10 -- Start at 10
		local yAxis = 20 -- Start at 10
		
		-- Regular items
		for index, itemDetails in pairs(packageDetails[5]) do
			local guiPrefix = guiTabName.."-package"..tostring(index).."-"
			
			gui[guiPrefix.."chk1"] = guiCreateCheckBox(xAxis + 30, yAxis+50, 16, 17, "chk", false, false, gui[guiTabName])
			setElementData(gui[guiPrefix.."chk1"], "button:action", "Push")
			setElementData(gui[guiPrefix.."chk1"], "button:itemDetails", itemDetails)
			setElementData(gui[guiPrefix.."chk1"], "button:itemID", index)
			setElementData(gui[guiPrefix.."chk1"], "button:grantID", packageDetails[1])
			setElementData(gui[guiPrefix.."chk1"], "button:chk", gui[guiPrefix.."chk1"])
			addEventHandler("onClientGUIClick", gui[guiPrefix.."chk1"], selectPackageGUI_process)
			addEventHandler("onClientGUIDoubleClick", gui[guiPrefix.."chk1"], selectPackageGUI_process)
			table.insert(gChks, gui[guiPrefix.."chk1"])
			
			gui[guiPrefix.."pushButton1"] = guiCreateButton(xAxis, yAxis, 71, 51, exports['mrp_items']:getItemName(itemDetails[2]), false, gui[guiTabName])
			setElementData(gui[guiPrefix.."pushButton1"], "button:action", "Push")
			setElementData(gui[guiPrefix.."pushButton1"], "button:chk", gui[guiPrefix.."chk1"])
			addEventHandler("onClientGUIClick", gui[guiPrefix.."pushButton1"], selectPackageGUI_process)
			gButtons[ gui[guiPrefix.."chk1"] ] = gui[guiPrefix.."pushButton1"]
			
			gui[guiPrefix.."label_3"] = guiCreateLabel(xAxis, yAxis+6, 71, 13, itemDetails[3], false, gui[guiTabName])
			guiLabelSetHorizontalAlign(gui[guiPrefix.."label_3"], "left", false)
			guiLabelSetVerticalAlign(gui[guiPrefix.."label_3"], "center")
			guiSetProperty(gui[guiPrefix.."label_3"], "AlwaysOnTop", "True")

			if not itemIsAllowed(allowList, itemDetails[1]) then
				guiLabelSetColor(gui[guiPrefix.."label_3"], 255, 0, 0)
				guiSetEnabled(gui[guiPrefix.."pushButton1"], false)
				guiSetEnabled(gui[guiPrefix.."chk1"], false)
			end

			xAxis = xAxis + 80 -- prepare next row
			
			if xAxis >= 650 then
				xAxis = 10
				yAxis = yAxis + 70
			end
		end
		
		-- Skins
		local skinTable = { }
		
		-- show current skin?
		--[[if not packageDetails["forceSkinChange"] then
			local currentSkin = getElementModel( localPlayer )
			local clothing = getElementData( localPlayer, 'clothing:id' )
			if clothing then
				table.insert(skinTable, currentSkin .. ':' .. clothing)
			else
				table.insert(skinTable, tostring(currentSkin))
			end
		end]]
		
		-- add package skins
		if packageDetails[3] then
			for i, a in pairs(packageDetails[3]) do
				if a[2] == "N/A" then a[2] = nil end
				local a = table.concat(a, ":")
				table.insert(skinTable, tostring(a))
			end
		end
		
		local xAxis = 0 -- Start at 10
		local yAxis = 200 -- Start at 10
		
		local count = 0
		for skinIndex, skinID in pairs(skinTable) do
			count = count + 1
			--local skinID = table.concat(skinID, ":")
			local skinImg = ("%03d"):format(skinID:gsub(":(.*)$", ""), 10)

			gui[guiTabName.."-radio-"..skinID] = guiCreateRadioButton (xAxis + 30, yAxis+80, 15, 15, "", false, gui[guiTabName] )
			setElementData(gui[guiTabName.."-radio-"..skinID], "button:skinID", skinID)
			setElementData(gui[guiTabName.."-radio-"..skinID], "button:grantID", packageDetails[1])
			table.insert(gChks, gui[guiTabName.."-radio-"..skinID])
			if skinIndex == 1 then
				guiRadioButtonSetSelected(gui[guiTabName.."-radio-"..skinID], true)
			end
			
			gui[guiTabName.."-skin-"..skinID] = guiCreateStaticImage (xAxis, yAxis, 75, 75, ":mrp_auth/img/" .. skinImg..".png", false, gui[guiTabName] )
			setElementData(gui[guiTabName.."-skin-"..skinID], "button:action", "Radio")
			setElementData(gui[guiTabName.."-skin-"..skinID], "button:element", gui[guiTabName.."-radio-"..skinID])
			addEventHandler("onClientGUIClick", gui[guiTabName.."-skin-"..skinID], selectPackageGUI_process)
			xAxis = xAxis + 80 -- prepare next row
			if count == 8 then
				count = 0
				xAxis = 10
				yAxis = yAxis + 100
			end
		end

		gui[guiTabName.."-cancel"] = guiCreateButton(10, 400, 200, 35, "Cancel", false, gui[guiTabName])
		setElementData(gui[guiTabName.."-cancel"], "button:action", "Cancel")
		addEventHandler("onClientGUIClick", gui[guiTabName.."-cancel"], selectPackageGUI_process)
		
		gui[guiTabName.."-spawn"] = guiCreateButton(440, 400, 200, 35, "Spawn", false, gui[guiTabName])
		setElementData(gui[guiTabName.."-spawn"], "button:action", "Go")
		setElementData(gui[guiTabName.."-spawn"], "button:grantID", packageDetails[1])
		addEventHandler("onClientGUIClick", gui[guiTabName.."-spawn"], selectPackageGUI_process)
	end
end

function selectPackageGUI_process(mouseButton, mouseState, absoluteX, absoluteY)
	if source and isElement(source) and mouseButton == "left" and mouseState == "up" then
		local theGUIelement = source
		local btnAction = getElementData(theGUIelement, "button:action")
		if btnAction then
			if btnAction == "Cancel" then
				destroyElement(gui["_root"])
				gui = { }
				gChks = { }
				gAvailablePackages = { }
			elseif btnAction == "Radio" then 
				local victimElement = getElementData(theGUIelement, "button:element")
				if victimElement then
					guiRadioButtonSetSelected(victimElement, true)
				end
			elseif btnAction == "Go" then
				local grantID = getElementData(theGUIelement, "button:grantID")
				if grantID then
					local spawnRequest = { }
					local spawnSkin = -1
					-- Make spawn request for server
					for tableIndex, chkBox in ipairs(gChks) do
						local rowGrantID = getElementData(chkBox, "button:grantID")
						if rowGrantID == grantID then
							local rowItemDetails = getElementData(chkBox, "button:itemDetails")
							if rowItemDetails then
								if guiCheckBoxGetSelected(chkBox) then
									table.insert(spawnRequest, rowItemDetails)
								end
							end
							local rowSkinDetails = getElementData(chkBox, "button:skinID")
							if rowSkinDetails then
								if guiRadioButtonGetSelected(chkBox) then
									spawnSkin = rowSkinDetails
								end
							end
						end
					end
					destroyElement(gui["_root"])
					gui = { }
					gChks = { }
					gAvailablePackages = { }
					
					if spawnSkin == -1 then
						return
					end
					triggerServerEvent("duty:request", localPlayer, grantID, spawnRequest, spawnSkin)
				end
				
			elseif btnAction == "Push" then
				local guiChk = getElementData(theGUIelement, "button:chk")
				if guiChk then
					local newstate =  not guiCheckBoxGetSelected ( guiChk )
					chkItemDetails = getElementData(guiChk, "button:itemDetails")
					if chkItemDetails and chkItemDetails[1] then
						for tableIndex, chkBox in ipairs(gChks) do
							cchkItemDetails = getElementData(chkBox, "button:itemDetails")
							if cchkItemDetails and cchkItemDetails[1] then
								if (cchkItemDetails[1] == chkItemDetails[1]) then
									guiCheckBoxSetSelected ( chkBox, false )
									guiSetEnabled( gButtons[chkBox], not newstate )
								end
							end
						end	
					end
					
					
					guiCheckBoxSetSelected ( guiChk, newstate )
					guiSetEnabled( gButtons[guiChk], true )
				end
			elseif btnAction == "Block" then
				guiCheckBoxSetSelected ( theGUIelement, not guiCheckBoxGetSelected ( theGUIelement ) )
			end
		end
	end
end
