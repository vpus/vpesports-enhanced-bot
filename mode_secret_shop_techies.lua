local npcBot  = GetBot()
local botTeam = npcBot:GetTeam()

function OnStart()
	npcBot.other_mode = BOT_MODE_SECRET_SHOP
end

function GetDesire()
	if npcBot.secretShop then
		return 1
	end
	
	return 0
end

function Think()
	local secretShopLoc = GetShopLocation(botTeam, SHOP_SECRET)
--	local courier = GetCourier(0)
--	if courier ~= nil then
--		local courierState = GetCourierState(courier)
--		
--		if courierState == COURIER_STATE_IDLE then
--			-- send courier to secret shop
--		elseif courierState == COURIER_STATE_DELIVERING_ITEMS then
--			-- send bot to secret shop
--		end
--	end
	local rearm      = npcBot:GetAbilityByName("tinker_rearm");
	local bootsSlot  = npcBot:FindItemSlot("item_travel_boots")
	local boots      = nil
	if npcBot:GetItemSlotType(bootsSlot) == ITEM_SLOT_TYPE_MAIN then
		boots = npcBot:GetItemInSlot(bootsSlot)
	end

	local secretDist = npcBot:DistanceFromSecretShop()
	
	if secretDist > 0 then
		if boots ~= nil and not npcBot:IsChanneling() and secretDist > 2000 then
			if boots:IsFullyCastable() then
				npcBot:Action_UseAbilityOnLocation(boots, secretShopLoc)
			elseif not boots:IsCooldownReady() and rearm:IsOwnersManaEnough() then
				npcBot:Action_UseAbility(rearm)
			end
		elseif (not npcBot:IsChanneling() and secretDist < 2000) or boots == nil then
			npcBot:Action_MoveToLocation(secretShopLoc)
		end
	else
		npcBot.secretShop = false
	end
end
