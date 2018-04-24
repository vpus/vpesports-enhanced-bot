require( GetScriptDirectory().."/UtilityData")
require( GetScriptDirectory().."/UtilityFunctions")

local npcBot = GetBot()

function OnStart()
	npcBot:Action_ClearActions(true)
end

-- When faced with multiple enemies, fall back to a safe location
function Think()
	local fountain = GetShopLocation(GetTeam(), SHOP_HOME)
	local missile  = npcBot:GetAbilityByName("tinker_heat_seeking_missile")
	local enemies  = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	
	if _G.getDistance(fountain, npcBot:GetLocation()) > 100 then
		npcBot:Action_MoveToLocation(fountain)
	end
	
	-- Use Missile if enemy nearby
	if missile ~= nil and missile:IsFullyCastable() and #enemies > 0 then
		npcBot:Action_UseAbility(missile)
	end
end

function GetDesire()
	local nearbyEnemies  = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local nearbyEnemies  = npcBot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
	local nearbyAllies   = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
	local nearbyTowers   = npcBot:GetNearbyTowers(1000, true)
	local nearbyCreeps   = npcBot:GetNearbyCreeps(300, true)
	local allyCreeps     = npcBot:GetNearbyCreeps(1600, false)
	local action         = npcBot:GetCurrentActionType()
	local damagedByCreep = npcBot:WasRecentlyDamagedByCreep(1)
	local damagedByHero  = npcBot:WasRecentlyDamagedByHero(1)
	local botCurrentHP   = npcBot:GetHealth()
	local botMaxHP       = npcBot:GetMaxHealth()
	local botLoc         = npcBot:GetLocation()
	local botMode        = npcBot:GetActiveMode()
	
	if botMode == BOT_MODE_ROAM and table.getn(closerEnemies) > 0 then
		return _G.desires[7]
	end
	
	if npcBot:IsChanneling() then
		return _G.desires[0]
	end
	
	if table.getn(nearbyEnemies) > 0 then
		return _G.desires[7]
	end
	
	for e = 1, table.getn(nearbyEnemies) do
		local enemy       = nearbyEnemies[e]
		local dist        = GetUnitToUnitDistance(npcBot, enemy)
		local enemyTarget = enemy:GetAttackTarget()
		local isTargetted = false
<<<<<<< HEAD
		
		if enemyTarget ~= nil then
			isTargetted = enemyTarget:GetUnitName() == npcBot:GetUnitName()
		end
		
		if dist < 500 or (dist > 500 and isTargetted) then
			return _G.desires[7]
=======
		
		if enemyTarget ~= nil then
			isTargetted = enemyTarget:GetUnitName() == npcBot:GetUnitName()
>>>>>>> 01aa975e87637c939ea9c5e2d1e3ef573c2632b1
		end
		
		if dist < 500 or (dist > 500 and isTargetted) then
			return _G.desires[7]
		end
	end
	
	if (botCurrentHP/botMaxHP < 0.2 and not npcBot:IsChanneling())
    	or (damagedByCreep and #nearbyCreeps > 3) then
    	
		return _G.desires[7]
	end
	
	if table.getn(nearbyTowers) > 0 then
		-- 
	end
	
	if (botCurrentHP/botMaxHP < 0.2 and not npcBot:IsChanneling())
    	or (damagedByCreep and table.getn(nearbyCreeps) > 3) then
    	
		return _G.desires[7]
	end
	
	if table.getn(nearbyTowers) > 0 then
		-- 
	end
	
	return _G.desires[0]
end
