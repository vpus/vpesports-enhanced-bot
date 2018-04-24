require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()

-- Bear Modes
local retreat = 0
local attack  = 0
local farm    = 0
local laning  = 0
local follow  = 0

-- Bear Stats
local action        = nil
local bearLoc       = nil
local bearAction    = nil
local bearMana      = nil
local bearHealth    = nil
local bearMaxHealth = nil
local bearMaxMana   = nil
local bearHPRegen   = nil
local bearManaRegen = nil

local botMode  = nil
local bearMode = nil
local fountain = GetShopLocation(GetTeam(), SHOP_HOME)

function MinionThink(minion)
	if minion ~= nil then
		local minionName = minion:GetUnitName()
		
		if string.find(minionName, "npc_dota_lone_druid_bear") then
			botMode       = npcBot:GetActiveMode()
			npcBot.bear   = minion
			npcBot.bear.roar = minion:GetAbilityByName("lone_druid_savage_roar_bear")
			npcBot.bear.tele = minion:GetAbilityByName("lone_druid_spirit_bear_return")
			action        = minion:GetCurrentActionType()
			bearLoc       = minion:GetLocation()
        	bearAction    = minion:GetCurrentActionType()
        	bearMana      = minion:GetMana()
        	bearHealth    = minion:GetHealth()
        	bearMaxHealth = minion:GetMaxHealth()
        	bearMaxMana   = minion:GetMaxMana()
        	bearHPRegen   = minion:GetHealthRegen()
        	bearManaRegen = minion:GetManaRegen()
			getAllDesires(minion)
			local prevMode = bearMode
			bearMode = getHighestDesire()
			
			if prevMode ~= nil and prevMode ~= bearMode then
				print("    Bear Mode: " .. _G.getDesireString(bearMode))
			end
			
			bearAbilityUsageThink(minion)
			
			if bearMode == BOT_MODE_RETREAT then
				Retreat(minion)
			elseif bearMode == BOT_MODE_ATTACK then
				Attack(minion)
			elseif bearMode == BOT_MODE_FARM then
				Farm(minion)
			elseif bearMode == BOT_MODE_LANING then
				Laning(minion)
			elseif bearMode == BOT_MODE_NONE then
				Follow(minion)
			elseif bearMode == BOT_MODE_ITEM then
				pickupItem(minion.item)
			end
		end
	end
end

-- OTHER FUNCTIONS ---------------------------------------------------------------------------------
function pickupItem(toTransfer)
	local botDist = GetUnitToUnitDistance(npcBot, npcBot.bear)
	
	if botDist < 200 then
    	npcBot.bear:Action_PickUpItem(toTransfer)
    
    	for i = 0, 8 do 
    		local item = npcBot.bear:GetItemInSlot(i)
    		if item ~= nil and item:GetName() == toTransfer:GetName() then
    			print("    " .. tostring(npcBot.bear.item))
    			print("    " .. tostring(npcBot.bear.pickupitem))
    			npcBot.bear.item = nil
    			npcBot.bear.pickupitem = false
    			print(npcBot.bear.item)
    			print(npcBot.bear.pickupitem)
    		end
    	end
	else
		if action ~= BOT_ACTION_TYPE_MOVE_TO then
			npcBot.bear:Action_MoveToLocation(npcBot:GetLocation())
		end
	end
end

function bearAbilityUsageThink(bear)
	local enemyHeroes = bear:GetNearbyHeroes(350, true, BOT_MODE_NONE)
	
	if table.getn(enemyHeroes) > 0 then
		if action ~= BOT_ACTION_TYPE_USE_ABILITY and bear.roar:IsFullyCastable() then
			bear:Action_UseAbility(bear.roar)
		end
	end
end

-- MODES -------------------------------------------------------------------------------------------
function Retreat(bear)
	local nearbyHeroes = bear:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
	
	if table.getn(nearbyHeroes) > 0 and bear.roar:IsFullyCastable() and action ~= BOT_ACTION_TYPE_USE_ABILITY then
		local enemyTarget = nearbyHeroes[1]:GetAttackTarget()
		local distEnemy = GetUnitToUnitDistance(bear, nearbyHeroes[1])
		if enemyTarget == npcBot or enemyTarget == bear then
    		if distEnemy > 325 and action ~= BOT_ACTION_TYPE_MOVE_TO then
    			bear:Action_MoveTo(nearbyHeroes[1]:GetLocation() + RandomVector(50))
    		elseif distEnemy <= 325 and action ~= BOT_ACTION_TYPE_MOVE_TO then
    			bear:Action_UseAbility(bear.roar)
    		else
    			bear:Action_MoveToLocation(fountain)
    		end
		else
			bear:Action_MoveToLocation(fountain)
		end
	else
		bear:Action_MoveToLocation(fountain)
	end
end

function Attack(bear)
	local laneCreeps   = bear:GetNearbyLaneCreeps(1000, true)
	local enemyHeroes  = bear:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
	local neutrals     = bear:GetNearbyNeutralCreeps(500)
	local botTarget    = npcBot:GetAttackTarget()
	local nearbyTowers = npcBot:GetNearbyTowers(1000, true)
	
	if botTarget == nil or not botTarget:IsHero() then
    	if table.getn(laneCreeps) > 0 then
    		local toAttack = laneCreeps[1]
    		
    		for c = 2, table.getn(laneCreeps) do
    			local creep = laneCreeps[c]
    			
    			if toAttack:GetHealth() > creep:GetHealth() then
    				toAttack = creep
    			end
    		end
    		
    		if action ~= BOT_ACTION_TYPE_ATTACK then
    			bear:Action_AttackUnit(toAttack, true)
    		end
    	elseif table.getn(neutrals) > 0 then
    		local toAttack = neutrals[1]
    		
    		for n = 2, table.getn(neutrals) do
    			local neutral = neutrals[n]
    			
    			if toAttack:GetHealth() < neutral:GetHealth() then
    				toAttack = neutral
    			end
    		end
    		
    		if action ~= BOT_ACTION_TYPE_ATTACK then
    			bear:Action_AttackUnit(toAttack, true)
    		end
    	elseif table.getn(nearbyTowers) > 0 and action ~= BOT_ACTION_TYPE_ATTACK then
    		bear:Action_AttackUnit(nearbyTowers[1], true)
    	end
	elseif botTarget ~= nil and botTarget:IsHero() then
		if action ~= BOT_ACTION_TYPE_ATTACK then
			bear:Action_AttackUnit(botTarget, true)
		end
	end
end

function Farm(bear)
	local nearbyNeutrals = bear:GetNearbyNeutralCreeps(600)
	local numNeutrals = table.getn(nearbyNeutrals)
	
	if numNeutrals > 0 then
		if action ~= BOT_ACTION_TYPE_ATTACK and action ~= BOT_ACTION_TYPE_USE_ABILITY then
			bear:Action_AttackUnit(nearbyNeutrals, true)
		end
	else
		if action ~= BOT_ACTION_TYPE_MOVE_TO and action ~= BOT_ACTION_TYPE_USE_ABILITY then
			bear:Action_MoveToLocation(npcBot:GetLocation() + RandomVector(100))
		end
	end
end

function Laning(bear)
	local laneFront = GetLaneFrontLocation(TEAM_RADIANT, LANE_MID, 200)
	local frontDist = GetUnitToLocationDistance(bear, laneFront)
	
	if frontDist > 500 and bearAction ~= BOT_ACTION_TYPE_ATTACK and bearAction ~= BOT_ACTION_TYPE_USE_ABILITY then
		bear:Action_MoveToLocation(laneFront)
	end
	Attack(bear)
end

function Follow(bear)
	bear:Action_MoveToLocation(npcBot:GetLocation())
end

-- DESIRES -----------------------------------------------------------------------------------------
function getAllDesires(bear)
	retreat = getRetreatDesire(bear)
	attack  = getAttackDesire(bear)
	farm    = getFarmDesire(bear)
	laning  = getLaningDesire(bear)
	follow  = getFollowDesire(bear)
end

function getHighestDesire()
	local highestMode = BOT_MODE_RETREAT
	local highest = retreat
	
	if attack > highest then
		highestMode = BOT_MODE_ATTACK
		highest = attack
	end
	
	if farm > highest then
		highestMode = BOT_MODE_FARM
		highest = farm
	end
	
	if laning > highest then
		highestMode = BOT_MODE_LANING
		highest = laning
	end
	
	if follow > highest then
		highestMode = BOT_MODE_NONE
		highest = follow
	end
	
	if npcBot.bear.pickupitem then
		highestMode = BOT_MODE_ITEM
	end
	
	return highestMode
end

function getRetreatDesire(bear)
	local nearbyEnemies  = bear:GetNearbyHeroes(650, true, BOT_MODE_NONE)
	local nearbyAllies   = bear:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
	local nearbyTowers   = bear:GetNearbyTowers(1000, true)
	local nearbyCreeps   = bear:GetNearbyLaneCreeps(150, true)
	local currentAction  = bear:GetCurrentActionType()
	local damagedByCreep = bear:WasRecentlyDamagedByCreep(1)
	local damagedByHero  = bear:WasRecentlyDamagedByCreep(1)
	local botCurrentHP   = bear:GetHealth()
	local botMaxHP       = bear:GetMaxHealth()
	local botLoc         = bear:GetLocation()
	
	local closerEnemies  = bear:GetNearbyHeroes(400, true, BOT_MODE_NONE)
	local fartherEnemies = bear:GetNearbyHeroes(1000, true, BOT_MODE_NONE)

	if bear:IsChanneling() then
		return _G.desires[0]
	end
	
	if (#fartherEnemies > 1) 
    	or (#closerEnemies > 0)
    	or (#nearbyEnemies > 0 and currentAction ~= BOT_ACTION_TYPE_USE_ABILITY and not bear:IsChanneling())
    	or (botCurrentHP/botMaxHP < 0.2 and currentAction ~= BOT_ACTION_TYPE_USE_ABILITY and not bear:IsChanneling())
    	or ((damagedByCreep and #nearbyCreeps > 3) or damagedByHero) then
    	
		return _G.desires[7] 
	end
	
	if #nearbyTowers > 0 then
		if not isTowerSafe(bear, nearbyTowers[1]) then
			return _G.desires[7]
		end
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
	
	return _G.desires[1]
end

function getAttackDesire(bear)
	if botMode == BOT_MODE_ATTACK then
		return _G.desires[6]
	end
	
	return _G.desires[1]
end

function getFarmDesire(bear)
	if botMode == BOT_MODE_FARM then
		return _G.desires[6]
	end
	
	return _G.desires[1]
end

function getLaningDesire(bear)
	if botMode == BOT_MODE_LANING then
		return _G.desires[6]
	end
	
	return _G.desires[1]
end

function getFollowDesire(bear)
	local druidDist = GetUnitToUnitDistance(npcBot, bear)
	local aghaSlot  = npcBot:FindItemSlot("item_ultimate_scepter")
	
	if druidDist > 1000 and npcBot:GetItemSlotType(aghaSlot) ~= ITEM_SLOT_TYPE_MAIN then
		return _G.desires[7]
	end
	
	return _G.desires[1]
end
