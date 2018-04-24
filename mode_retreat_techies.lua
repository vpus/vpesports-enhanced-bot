require( GetScriptDirectory().."/UtilityData")
require( GetScriptDirectory().."/UtilityFunctions")

local npcBot = GetBot()

function OnStart()
	npcBot:Action_ClearActions(true)
end

function Think()
	local fountain = GetShopLocation(GetTeam(), SHOP_HOME)
	local missile  = npcBot:GetAbilityByName("tinker_heat_seeking_missile")
	local enemies  = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local action   = npcBot:GetCurrentActionType()
	
	if GetUnitToLocationDistance(npcBot, fountain) > 100 and action ~= BOT_ACTION_TYPE_USE_ABILITY then
		npcBot:Action_MoveToLocation(fountain)
	end
end

function GetDesire()
	local nearbyEnemies  = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local closerEnemies  = npcBot:GetNearbyHeroes(900, true, BOT_MODE_NONE)
	local nearbyAllies   = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
	local nearbyTowers   = npcBot:GetNearbyTowers(1000, true)
	local nearbyCreeps   = npcBot:GetNearbyCreeps(150, true)
	local allyCreeps     = npcBot:GetNearbyCreeps(1600, false)
	local action         = npcBot:GetCurrentActionType()
	local damagedByCreep = npcBot:WasRecentlyDamagedByCreep(1)
	local damagedByHero  = npcBot:WasRecentlyDamagedByCreep(1)
	local botCurrentHP   = npcBot:GetHealth()
	local botMaxHP       = npcBot:GetMaxHealth()
	local botLoc         = npcBot:GetLocation()
	
	if npcBot:IsChanneling() then
		return _G.desires[0]
	end
	
	if npcBot.other_mode == BOT_MODE_ROAM then
		if table.getn(nearbyEnemies) > 0 then
			return _G.desires[7]
		else
			return _G.desires[0]
		end
	elseif table.getn(closerEnemies) > 2 then
		return _G.desires[7]
	else
    	for e = 1, table.getn(nearbyEnemies) do
    		local enemy       = nearbyEnemies[e]
    		local dist        = GetUnitToUnitDistance(npcBot, enemy)
    		local enemyTarget = enemy:GetAttackTarget()
    		local isTargetted = false
    		local enemyRange  = enemy:GetAttackRange()
    		
    		if enemyTarget ~= nil then
    			isTargetted = enemyTarget:GetUnitName() == npcBot:GetUnitName()
    		end
    		
    		if dist < enemyRange or (dist > enemyRange and isTargetted) then
    			return _G.desires[7]
    		end
    	end
    	
    	if (botCurrentHP/botMaxHP < 0.2 and not npcBot:IsChanneling())
        	or (damagedByCreep and #nearbyCreeps > 3) then
        	
    		return _G.desires[7]
    	end
    	
    	if table.getn(nearbyTowers) > 0 then
    		return _G.desires[7]
    	end
	end
	return _G.desires[0]
end
