local npcBot = GetBot()

local purchase = require(GetScriptDirectory() .. "/item_build_legion_commander");

local itemsPurchase = purchase["items"]
local boughtClarity = false
local boughtSalve   = false
local clarityCount  = 0

function ItemPurchaseThink()
--	if GetGameState() ~= GAME_STATE_PRE_GAME and GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS then
--		return;
--	end
	local bear       = false
	local botHP      = npcBot:GetHealth()
	local botMaxHP   = npcBot:GetMaxHealth()
	local botMana    = npcBot:GetMana()
	local botMaxMana = npcBot:GetMaxMana()
	local gameTime   = DotaTime()
	
	local clarity = nil
	local bottle  = nil
	local salve   = nil
	local boots   = nil
	local arcane  = nil
	
	local clarityLoc = npcBot:FindItemSlot("item_clarity")
	local bottleLoc  = npcBot:FindItemSlot("item_bottle")
	local salveLoc   = npcBot:FindItemSlot("item_salve")
	local bootsLoc   = npcBot:FindItemSlot("item_travel_boots")
	local arcaneLoc  = npcBot:FindItemSlot("item_arcane_boots")
	
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
	
	if npcBot:HasModifier("modifier_flask_healing") then
		boughtSalve = false
	end
	if npcBot:HasModifier("modifier_clarity_potion") then
		boughtClarity = false
	end
	if npcBot:GetItemSlotType(arcaneLoc) == ITEM_SLOT_TYPE_MAIN then
		arcane = npcBot:GetItemInSlot(arcaneLoc)
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
end	
