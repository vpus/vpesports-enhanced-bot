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
	local nearbyEnemies  = npcBot:GetNearbyHeroes(650, true, BOT_MODE_NONE)
	local nearbyAllies   = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
	local nearbyTowers   = npcBot:GetNearbyTowers(1000, true)
	local nearbyCreeps   = npcBot:GetNearbyCreeps(150, true)
	local currentAction  = npcBot:GetCurrentActionType()
	local damagedByCreep = npcBot:WasRecentlyDamagedByCreep(1)
	local damagedByHero  = npcBot:WasRecentlyDamagedByCreep(1)
	local botCurrentHP   = npcBot:GetHealth()
	local botMaxHP       = npcBot:GetMaxHealth()
	local botLoc         = npcBot:GetLocation()
	
	local closerEnemies  = npcBot:GetNearbyHeroes(400, true, BOT_MODE_NONE)
	local fartherEnemies = npcBot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)

	if npcBot:IsChanneling() then
		return _G.desires[0]
	end
	
	if (#fartherEnemies > 1) 
    	or (#closerEnemies > 0) 
    	or (#nearbyTowers > 0) 
    	or (#nearbyEnemies > 0 and currentAction ~= BOT_ACTION_TYPE_USE_ABILITY and not npcBot:IsChanneling())
    	or (botCurrentHP/botMaxHP < 0.2 and currentAction ~= BOT_ACTION_TYPE_USE_ABILITY and not npcBot:IsChanneling())
    	or ((damagedByCreep and #nearbyCreeps > 3) or damagedByHero) then
    	
		return _G.desires[7] 
	end
	
	for i,enemy in ipairs(fartherEnemies) do
		local enemyLoc   = enemy:GetLocation()
		local enemyRange = enemy:GetAttackRange()
		
		if enemyRange > 200 then
			local dist = _G.getDistance(enemyLoc, botLoc)
			if dist < (enemyRange + 200) then
				return _G.desires[7]
			end
		end
	end
	
	return _G.desires[0]
end
