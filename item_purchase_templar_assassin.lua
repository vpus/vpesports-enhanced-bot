local npcBot = GetBot()

local purchase = require(GetScriptDirectory() .. "/item_build_templar_assassin");

local itemsPurchase = purchase["items"]
local boughtClarity = false
local boughtSalve   = false
local clarityCount  = 0

function ItemPurchaseThink()
	local bear       = false
	local botHP      = npcBot:GetHealth()
	local botMaxHP   = npcBot:GetMaxHealth()
	local botMana    = npcBot:GetMana()
	local botMaxMana = npcBot:GetMaxMana()
	local gameTime   = DotaTime()
	
	local clarity  = nil
	local bottle   = nil
	local salve    = nil
	local boots    = nil
	local arcane   = nil
	local faerie   = nil
	local tp       = nil
	local tango    = nil
	local branches = nil
	
	local clarityLoc  = npcBot:FindItemSlot("item_clarity")
	local bottleLoc   = npcBot:FindItemSlot("item_bottle")
	local salveLoc    = npcBot:FindItemSlot("item_salve")
	local bootsLoc    = npcBot:FindItemSlot("item_travel_boots")
	local arcaneLoc   = npcBot:FindItemSlot("item_arcane_boots")
	local faerieLoc   = npcBot:FindItemSlot("item_faerie_fire")
	local tpLoc       = npcBot:FindItemSlot("item_tpscroll")
	local tangoLoc    = npcBot:FindItemSlot("item_tango")
	local branchesLoc = npcBot:FindItemSlot("item_branches")
	
	local courier = GetCourier(0)
	
	if npcBot:GetItemSlotType(clarityLoc) == ITEM_SLOT_TYPE_MAIN then
		clarity = npcBot:GetItemInSlot(clarityLoc)
	end
	if npcBot:GetItemSlotType(bottleLoc) == ITEM_SLOT_TYPE_MAIN then
		bottle = npcBot:GetItemInSlot(bottleLoc)
	end
	if npcBot:GetItemSlotType(salveLoc) == ITEM_SLOT_TYPE_MAIN then
		salve = npcBot:GetItemInSlot(salveLoc)
	end
	if npcBot:GetItemSlotType(bootsLoc) == ITEM_SLOT_TYPE_MAIN then
		boots = npcBot:GetItemInSlot(bootsLoc)
	end
	if npcBot:GetItemSlotType(arcaneLoc) == ITEM_SLOT_TYPE_MAIN then
		arcane = npcBot:GetItemInSlot(arcaneLoc)
	end
	if npcBot:GetItemSlotType(faerieLoc) == ITEM_SLOT_TYPE_MAIN then
		faerie = npcBot:GetItemInSlot(faerieLoc)
	end
	if npcBot:GetItemSlotType(tpLoc) == ITEM_SLOT_TYPE_MAIN then
		tp = npcBot:GetItemInSlot(tpLoc)
	end
	if npcBot:GetItemSlotType(tangoLoc) == ITEM_SLOT_TYPE_MAIN then
		tango = npcBot:GetItemInSlot(tangoLoc)
	end
	if npcBot:GetItemSlotType(branchesLoc) == ITEM_SLOT_TYPE_MAIN then
		branches = npcBot:GetItemInSlot(branchesLoc)
	end
	
	-- Keep track of how many salves/clarities have been bought	
	if npcBot:HasModifier("modifier_flask_healing") then
		boughtSalve = false
	end
	if npcBot:HasModifier("modifier_clarity_potion") then
		boughtClarity = false
	end

	local itemIndex = nil
	
	for i = 1, #itemsPurchase do
		if itemsPurchase[i] ~= "none" then
			itemIndex = i
			break
		end
	end
	
	if itemIndex == nil then
		return
	end
	
	local botGold  = npcBot:GetGold()
	local itemName = itemsPurchase[itemIndex]
	local itemCost = GetItemCost(itemName)
	
	if botGold >= itemCost and gameTime > -59 then
		local sideShop           = IsItemPurchasedFromSideShop(itemName)
		local secretShop         = IsItemPurchasedFromSecretShop(itemName)
		local sideShopDistance   = npcBot:DistanceFromSideShop()
		local secretShopDistance = npcBot:DistanceFromSecretShop()
		local fountainDistance   = npcBot:DistanceFromFountain()
		
		if secretShop then
			npcBot.secretShop = true -- lets the secret shop mode know to switch
			if secretShopDistance == 0 then
				local result = npcBot:ActionImmediate_PurchaseItem(itemName)
				print("Purchasing " .. itemName .. ": " .. tostring(result))
    			if result == PURCHASE_ITEM_SUCCESS then
    				itemsPurchase[itemIndex] = "none"
    			else
    				print("    Item Not Purchased: " .. tostring(result) .. " : " .. tostring(itemName))
    			end
			end
		elseif not secretShop then
			local result = npcBot:ActionImmediate_PurchaseItem(itemName)
			print("Purchasing " .. itemName .. ": " .. tostring(result))
			if result == PURCHASE_ITEM_SUCCESS then
				itemsPurchase[itemIndex] = "none"
			else
				print("    Item Not Purchased: " .. tostring(result) .. " : " .. tostring(itemName))
			end
		end
	end
	
	if npcBot:GetStashValue() > 0 then
		local state = GetCourierState(courier)
		
		if courier ~= nil then
			if state == COURIER_STATE_IDLE or state == COURIER_STATE_AT_BASE and npcBot:IsAlive() then
				npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
			end
		end
	end
	
	-- Drop unneeded items
	local blinkLoc = npcBot:FindItemSlot("item_blink")
	local desoLoc  = npcBot:FindItemSlot("item_desolator")
	if npcBot:GetItemSlotType(blinkLoc) ~= ITEM_SLOT_TYPE_INVALID then
		if faerie ~= nil then
			npcBot:Action_DropItem(faerie, npcBot:GetLocation() + RandomVector(50))
		end
		if tango ~= nil then
			npcBot:Action_DropItem(tango, npcBot:GetLocation() + RandomVector(50))
		end
		if clarity ~= nil then
			npcBot:Action_DropItem(clarity, npcBot:GetLocation() + RandomVector(50))
		end
		if salve ~= nil then
			npcBot:Action_DropItem(salve, npcBot:GetLocation() + RandomVector(50))
		end
	end
	if npcBot:GetItemSlotType(desoLoc) ~= ITEM_SLOT_TYPE_INVALID then
		if branches ~= nil then
			npcBot:Action_DropItem(branches, npcBot:GetLocation() + RandomVector(50))
		end
	end
end	
