local npcBot  = GetBot()
local botTeam = npcBot:GetTeam()

function GetDesire()
	if npcBot.secretShop then
		return _G.desires[7]
	end
	
	return _G.desires[1]
end

function Think()
	local secretShopLoc = GetShopLocation(botTeam, SHOP_SECRET)
	local bootsSlot  = npcBot:FindItemSlot("item_travel_boots")
	local boots      = nil
	if npcBot:GetItemSlotType(bootsSlot) == ITEM_SLOT_TYPE_MAIN then
		boots = npcBot:GetItemInSlot(bootsSlot)
	end

	local secretDist = npcBot:DistanceFromSecretShop()
	
	if secretDist > 0 then
		if boots ~= nil and not npcBot:IsChanneling() then
			if boots:IsFullyCastable() then
				npcBot:Action_UseAbilityOnLocation(boots, secretShopLoc)
			end
		elseif not npcBot:IsChanneling() then
			npcBot:Action_MoveToLocation(secretShopLoc)
		end
	else
		npcBot.secretShop = false
	end
end