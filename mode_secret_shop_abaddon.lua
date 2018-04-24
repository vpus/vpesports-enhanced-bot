local npcBot  = GetBot()
local botTeam = npcBot:GetTeam()

function GetDesire()
    local mode       = npcBot:GetActiveMode();
	local modeDesire = npcBot:GetActiveModeDesire();

	if npcBot.secretShop and mode ~= BOT_MODE_ATTACK and mode ~= BOT_MODE_RETREAT and mode ~= BOT_MODE_DEFEND_ALLY and mode ~= BOT_MODE_EVASIVE_MANEUVERS then
		return _G.desires[4]
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
	local secretDist = npcBot:DistanceFromSecretShop()
	
	if secretDist > 0 then
		if not npcBot:IsChanneling() then
			npcBot:Action_MoveToLocation(secretShopLoc)
		end
	else
		npcBot.secretShop = false
	end
end