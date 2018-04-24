local npcBot = GetBot()

local purchase = require(GetScriptDirectory() .. "/item_build_keeper_of_the_light");

local itemsPurchase = purchase["items"]

function ItemPurchaseThink()
--	if GetGameState() ~= GAME_STATE_PRE_GAME and GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS then
--		return;
--	end
	
	local botHP      = npcBot:GetHealth()
	local botMaxHP   = npcBot:GetMaxHealth()
	local botMana    = npcBot:GetMana()
	local botMaxMana = npcBot:GetMaxMana()
	
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
	local itemCost = GetItemCost(itemsPurchase[itemIndex])
	
	if botGold >= itemCost then
		local sideShop           = IsItemPurchasedFromSideShop(itemsPurchase[itemIndex])
		local secretShop         = IsItemPurchasedFromSecretShop(itemsPurchase[itemIndex])
		local sideShopDistance   = npcBot:DistanceFromSideShop()
		local secretShopDistance = npcBot:DistanceFromSecretShop()
		local fountainDistance   = npcBot:DistanceFromFountain()
		
--		print("Side Shop? " .. tostring(sideShop)
--		.. " Secret Shop? " .. tostring(secretShop)
--		.. " Side Shop Distance: " .. tostring(sideShopDistance) 
--		.. " Secret Shop Distance: " .. tostring(secretShopDistance)
--		.. " Fountain Distance: " .. tostring(fountainDistance))
		
		if secretShop then
			if secretShopDistance > 200000 then
				courier = GetCourier(0)
				state = GetCourierState(courier)
				if courier ~= nil then
					if state == COURIER_STATE_IDLE or state == COURIER_STATE_AT_BASE then
						npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_SECRET_SHOP)
					end
				end
				local result = npcBot:ActionImmediate_PurchaseItem(itemsPurchase[itemIndex])
				print("Purchasing " .. itemsPurchase[itemIndex] .. ": " .. tostring(result))
				if result == PURCHASE_ITEM_SUCCESS then
					itemsPurchase[itemIndex] = "none"
					npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_RETURN)
				end
			else
				npcBot.secretShop = true -- lets the secret shop mode know to switch
				if secretShopDistance == 0 then
					local result = npcBot:ActionImmediate_PurchaseItem(itemsPurchase[itemIndex])
					print("Purchasing " .. itemsPurchase[itemIndex] .. ": " .. tostring(result))
					if result == PURCHASE_ITEM_SUCCESS then
						itemsPurchase[itemIndex] = "none"
					else
						print("    Item Not Purchased: " .. tostring(result) .. " : " .. tostring(itemsPurchase[itemIndex]))
					end
				end
			end
		elseif not secretShop then
			local result = npcBot:ActionImmediate_PurchaseItem(itemsPurchase[itemIndex])
			print("Purchasing " .. itemsPurchase[itemIndex] .. ": " .. tostring(result))
			if result == PURCHASE_ITEM_SUCCESS then
				itemsPurchase[itemIndex] = "none"
			else
				print("    Item Not Purchased: " .. tostring(result) .. " : " .. tostring(itemsPurchase[itemIndex]))
			end
		end
	end
	
	if npcBot:GetStashValue() > 0 then
		local courier = GetCourier(0)
		local state   = GetCourierState(courier)
		
		if courier ~= nil then
			if state == COURIER_STATE_IDLE or state == COURIER_STATE_AT_BASE and npcBot:IsAlive() then
				npcBot:ActionImmediate_Courier(courier, COURIER_ACTION_TAKE_AND_TRANSFER_ITEMS)
			end
		end
	end
end	
