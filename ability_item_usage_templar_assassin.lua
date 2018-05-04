local build = require(GetScriptDirectory().."/item_build_templar_assassin")
require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()

local refraction = npcBot:GetAbilityByName("templar_assassin_refraction")
local meld       = npcBot:GetAbilityByName("templar_assassin_meld")
local psi        = npcBot:GetAbilityByName("templar_assassin_psi_blades") 
local trap       = npcBot:GetAbilityByName("templar_assassin_trap")
local psitrap    = npcBot:GetAbilityByName("templar_assassin_psionic_trap")

function BuybackUsageThink()end

function AbilityLevelUpThink()
	local skillsToLevel = build["skills"]
	if npcBot:GetAbilityPoints() > 0 and skillsToLevel[1] ~= nil then
		npcBot:ActionImmediate_LevelAbility(skillsToLevel[1])
		table.remove(skillsToLevel, 1)
	end
end

-- Logic for all Ability Usage behavior
function AbilityUsageThink()
	-- Stats
	local botMana    = npcBot:GetMana()
	local botMaxMana = npcBot:GetMaxMana()
	local botHP      = npcBot:GetHealth()
	local botMaxHP   = npcBot:GetMaxHealth()
	local botLevel   = npcBot:GetLevel()
	local mode       = npcBot:GetActiveMode()
	local action     = npcBot:GetCurrentActionType()
	local allyList   = GetUnitList(UNIT_LIST_ALLIES)
	local botMode    = npcBot:GetActiveMode()
	local hpPercent  = botHP/botMaxHP

	-- Nearby Units
	local allies      = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
	local enemies     = npcBot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
	local enemyCreeps = npcBot:GetNearbyLaneCreeps(1000, true)
	local allyCreeps  = npcBot:GetNearbyLaneCreeps(1000, false)
	local neutrals    = npcBot:GetNearbyNeutralCreeps(1000)
	
	local numAllies      = table.getn(allies)
	local numEnemies     = table.getn(enemies)
	local numEnemyCreeps = table.getn(enemyCreeps)
	local numAllyCreeps  = table.getn(allyCreeps)
	local numNeutrals    = table.getn(neutrals)
	
	local damagedByHero  = npcBot:WasRecentlyDamagedByAnyHero(1)
	local damagedByCreep = npcBot:WasRecentlyDamagedByCreep(1)

	-- PSIONIC TRAP Usage
	if mode == BOT_MODE_ATTACK and psitrap:IsFullyCastable() and action ~= BOT_ACTION_TYPE_USE_ABILITY then
		-- Make sure you're not overriding traps if you don't want to
		if table.getn(npcBot.traps) ~= (npcBot.max_traps * psitrap:GetLevel()) then
			
		
		elseif mode == BOT_MODE_ATTACK then -- Override traps if needed
			local target = npcBot:GetAttackTarget()
			
			if target ~= nil then
				local targetDist = GetUnitToUnitDistance(npcBot, target)
				
				if targetDist < 100 and not npcBot:HasModifier("modifier_templar_assassin_meld") and action ~= BOT_ACTION_TYPE_ATTACK then
					local trapLoc = target:GetExtrapolatedLocation(0.5)
					
					npcBot:Action_UseAbilityOnLocation(psitrap, trapLoc)
				end
			end
		end
	end
	
	-- REFRACTION Usage
	if action ~= BOT_ACTION_TYPE_USE_ABILITY and not npcBot:HasModifier("modifier_templar_assassin_refraction_absorb") then
		if damagedByHero or damagedByCreep and hpPercent < 0.5 then
			npcBot:Action_UseAbility(refraction)
		end
	end
	
	-- MELD, REFRACTION, and BLINK attacking
	if mode == BOT_MODE_ATTACK and action ~= BOT_ACTION_TYPE_USE_ABILITY then
		if not npcBot:HasModifier("modifier_templar_assassin_refraction_absorb") then
			if refraction:IsFullyCastable() then
				npcBot:Action_UseAbility(refraction)
			end
		elseif meld:IsFullyCastable() then
			local target = npcBot:GetAttackTarget()
			
			if target ~= nil then
				local targetDist = GetUnitToUnitDistance(target, npcBot)
				
				if targetDist > 100 then
    				local available, blink = _G.getItemAvailable("item_blink", npcBot)
    				
    				if available and blink:IsFullyCastable() then
    					npcBot:Action_UseAbilityOnLocation(blink, target:GetLocation() + RandomVector(50))
    				else
    					npcBot:Action_MoveToLocation(target:GetLocation() + RandomVector(20))
    				end
				else
					if not npcBot:HasModifier("modifier_templar_assassin_meld") and meld:IsFullyCastable() then
						npcBot:Action_UseAbility(meld)
					else
						npcBot:Action_AttackUnit(target, true)
					end
				end
			end
		else
			
		end
	end
end

function useSoulRing()
	local botMana = npcBot:GetMana()
	local botHP  = npcBot:GetHealth()
	-- SOUL RING Usage
    local soulLoc = npcBot:FindItemSlot("item_soul_ring")
    local soul = nil
    if npcBot:GetItemSlotType(soulLoc) == ITEM_SLOT_TYPE_MAIN then
        soul = npcBot:GetItemInSlot(soulLoc)
    end
    if soul ~= nil then
        if soul:IsFullyCastable() and botMana < 200 and botHP > 400 then
            npcBot:Action_UseAbility(soul)
        end
    end
end

function getArmorMultiplier(armor)
	return 1 - (0.05 * armor / (1 + 0.05 * math.abs(armor)))
end

function BuybackUsageThink()
    if DotaTime() < -30 and lane_claim then
        local lane_id = npcBot:GetAssignedLane()
        if lane_id == 1 then
            npcBot:ActionImmediate_Chat("I'm going Top!", false)
        elseif lane_id == 2 then
            npcBot:ActionImmediate_Chat("I'm going Mid!", false)
        elseif lane_id == 3 then
            npcBot:ActionImmediate_Chat("I'm going Bot!", false)
        end
        lane_claim = false
    end
    return
end
