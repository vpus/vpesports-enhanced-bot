require( GetScriptDirectory().."/UtilityData")
require( GetScriptDirectory().."/UtilityFunctions")

local npcBot = GetBot()
local hpThreshold = 0.2

function OnStart()
	npcBot:Action_ClearActions(true)
end

-- When faced with multiple enemies, fall back to a safe location
function Think()
	local fountain = GetShopLocation(GetTeam(), SHOP_HOME)
	local enemies  = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local botHealth = npcBot:GetHealth()
	local botMaxHealth = npcBot:GetMaxHealth()
	local botAction = npcBot:GetCurrentActionType()
	local damagedByCreep = npcBot:WasRecentlyDamagedByCreep(1)
	local damagedByHero  = npcBot:WasRecentlyDamagedByCreep(1)
	
	local bottleLoc  = npcBot:FindItemSlot("item_bottle")
	local salveLoc   = npcBot:FindItemSlot("item_flask")
	local tangoLoc   = npcBot:FindItemSlot("item_tango")
	local portalLoc  = npcBot:FindItemSlot("item_tpscroll")
	
	if botHealth/botMaxHealth <= hpThreshold and GetUnitToLocationDistance(npcBot, fountain) > 100 and not npcBot:IsChanneling() then
		if bottleLoc ~= ITEM_SLOT_TYPE_MAIN 
		and salveLoc ~= ITEM_SLOT_TYPE_MAIN 
		and tangoLoc ~= ITEM_SLOT_TYPE_MAIN 
		and portalLoc == ITEM_SLOT_TYPE_MAIN then
			npcBot:Action_UseAbilityOnLocation(npcBot:GetItemInSlot(portalLoc), fountain)
		else
			npcBot:Action_MoveToLocation(fountain)
		end
	else
		npcBot:Action_MoveToLocation(fountain)
	end
end

function GetDesire()
	local nearbyEnemies  = npcBot:GetNearbyHeroes(650, true, BOT_MODE_NONE)
	local nearbyAllies   = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
	local nearbyTowers   = npcBot:GetNearbyTowers(1000, true)
	local nearbyCreeps   = npcBot:GetNearbyLaneCreeps(150, true)
	local currentAction  = npcBot:GetCurrentActionType()
	local damagedByCreep = npcBot:WasRecentlyDamagedByCreep(1)
	local damagedByHero  = npcBot:WasRecentlyDamagedByCreep(1)
	local botCurrentHP   = npcBot:GetHealth()
	local botMaxHP       = npcBot:GetMaxHealth()
	local botLoc         = npcBot:GetLocation()
	local mode           = npcBot:GetActiveMode()
	
	local closerEnemies  = npcBot:GetNearbyHeroes(400, true, BOT_MODE_NONE)
	local fartherEnemies = npcBot:GetNearbyHeroes(800, true, BOT_MODE_NONE)

	if npcBot.duel then
		return _G.desires[1]
	end
	
	if  (currentAction ~= BOT_ACTION_TYPE_USE_ABILITY and not npcBot:IsChanneling()) 
		and (#fartherEnemies > 1) 
    	or (#closerEnemies > 0) 
    	or (#nearbyTowers > 0)
    	or (botCurrentHP/botMaxHP < hpThreshold)
    	or ((damagedByCreep and #nearbyCreeps > 2) or damagedByHero) then
    	
    	if mode == BOT_MODE_ATTACK then
    		return _G.desires[3]
    	end
    	
		return _G.desires[6] 
	end
	
	return _G.desires[1]
end
