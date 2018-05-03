local build = require(GetScriptDirectory().."/item_build_legion_commander")
require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()
local lane_claim = true

npcBot.duel = false
npcBot.target = nil
npcBot.blink = false
npcBot.press = false

local odds    = npcBot:GetAbilityByName("legion_commander_overwhelming_odds")
local press   = npcBot:GetAbilityByName("legion_commander_press_the_attack")
local courage = npcBot:GetAbilityByName("legion_commander_moment_of_courage") 
local duel    = npcBot:GetAbilityByName("legion_commander_duel")

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
	local botMana = npcBot:GetMana()
	local botMaxMana  = npcBot:GetMaxMana()
	local botHP   = npcBot:GetHealth()
	local botMaxHP    = npcBot:GetMaxHealth()
	local botLevel = npcBot:GetLevel()
	local mode     = npcBot:GetActiveMode()
	local action   = npcBot:GetCurrentActionType()
	local allyList = GetUnitList(UNIT_LIST_ALLIES)
	local botMode  = npcBot:GetActiveMode()

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

	-- OVERWHELMING ODDS Usage
	if odds:IsCooldownReady() and action ~= BOT_ACTION_TYPE_USE_ABILITY then
		local totalEnemies = numEnemies * 2 + numEnemyCreeps
		-- MANGO
		if odds:GetLevel() > 1 then
    		local mangoLoc = npcBot:FindItemSlot("item_enchanted_mango")
            local mango = nil
            if npcBot:GetItemSlotType(mangoLoc) == ITEM_SLOT_TYPE_MAIN then
                mango = npcBot:GetItemInSlot(mangoLoc)
            end
            
            if mango ~= nil and botMana < 100 and botLevel > 1 then
            	npcBot:Action_UseAbility(mango)
            end
        end
        
        useSoulRing()
        
		if totalEnemies >= 4 then
			local enemyLocs = {}
			
			for e = 1, numEnemies do
				table.insert(enemyLocs, enemies[e]:GetLocation())
			end
		
			for c = 1, numEnemyCreeps do
				table.insert(enemyLocs, enemyCreeps[c]:GetLocation())
			end
			
			local centroid = _G.getCentroid(enemyLocs)
			npcBot:Action_UseAbilityOnLocation(odds, centroid)
		elseif mnode == BOT_MODE_ATTACK then
			if numEnemies > 0 then
				npcBot:Action_UseAbilityOnLocation(odds, enemies[1]:GetLocation())
			end
		end
	end

	-- PRESS THE ATTACK Usage
    if press:IsFullyCastable() and action ~= BOT_ACTION_TYPE_USE_ABILITY then
        local shield_cast = false
        local shield_target = npcBot
        local shield_target_health = npcBot:GetHealth()
        local nearbyAllies = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        local nearbyEnemies_675 = npcBot:GetNearbyHeroes(675, true, BOT_MODE_NONE)
        for j, ally in pairs(nearbyAllies) do
            if ally:GetHealth() < shield_target:GetHealth() and (ally:GetHealth()*1.5 < botHP or ally:GetHealth() < 500 ) then
                shield_target = ally
            end
        end

        if press:GetLevel() == 1 then
            if shield_target_health < 200 and #nearbyEnemies_675 > 0 then
                shield_cast = true
            end
        else
            if botMode == BOT_MODE_RETREAT or botMode == BOT_MODE_ATTACK and numEnemies > 0 then
                shield_cast = true
            else
                for j,enemy in pairs(enemies) do
                    if enemy:GetAttackTarget() == npcBot and botHP < botMaxHP - 150 then
                        shield_cast = true
                        break
                    end
                end
            end
        end

        -- Press cast --
        if shield_cast and not npcBot:HasModifier("modifier_fountain_aura_buff") then
            print("Use Shield on " .. tostring(shield_target:GetUnitName()))
            npcBot:Action_UseAbilityOnEntity(press, shield_target)
        end
    end
	
	-- DUEL Usage
	if duel:IsFullyCastable() and action ~= BOT_ACTION_TYPE_USE_ABILITY then
		local target = nil
		
		local botHP     = npcBot:GetHealth()
		local botArmor  = npcBot:GetArmor()
		local botAttack = npcBot:GetAttackDamage()
		local botMult   = getArmorMultiplier(botArmor)
		local botDamage = botAttack * botMult
		
		local botKill   = 0
		local enemyKill = 5000
		
		for e = 0, numEnemies do
			local enemy = enemies[e]
			
--			if enemy ~= nil then
--				local hp     = enemy:GetHealth()
--				local armor  = enemy:GetArmor()
--				local attack = enemy:GetEvasion()
--				local multiplier = getArmorMultiplier(armor)
--				local damage = attack * multiplier
--				local toKillBot = botHP / damage
--				local toKillEnemy = hp / botDamage
--				
--				if botKill < toKillBot and enemyKill > toKillEnemy then
					target = enemy
--				end
--			end
		end
		
		if target ~= nil then
            local blinkLoc = npcBot:FindItemSlot("item_blink")
            local blink    = nil
            if npcBot:GetItemSlotType(blinkLoc) == ITEM_SLOT_TYPE_MAIN then
                blink = npcBot:GetItemInSlot(blinkLoc)
            end
            
            npcBot.duel = true
            npcBot.target = target
            print("Dueling: " .. target:GetUnitName())
            if blink ~= nil and not npcBot.blink then
            	npcBot:ActionQueue_UseAbilityOnLocation(blink, target:GetLocation())
            	npcBot.blink = true
            end
            if npcBot.duel then
				npcBot:ActionQueue_UseAbilityOnEntity(duel, target)
			end
		elseif target == nil or npcBot:HasModifier("modifier_legion_commander_duel") then
			npcBot.duel   = false
			npcBot.target = nil
			npcBot.blink  = false
			npcBot.press  = false
		end
	end
	
	-- PRESS THE ATTACK Usage
	if npcBot.duel and press:IsFullyCastable() then
		local targetDist = GetUnitToUnitDistance(npcbot, target)
		local blinkLoc   = npcBot:FindItemSlot("item_blink")
        local blink      = nil
        if npcBot:GetItemSlotType(blinkLoc) == ITEM_SLOT_TYPE_MAIN then
            blink = npcBot:GetItemInSlot(blinkLoc)
        end
		
		if targetDist <= 250 or blink ~= nil and not npcBot.press then
			npcBot:ActionPush_UseAbilityOnEntity(press, npcBot)
			npcBot.press = true
		end
	end
	
    if (mode == BOT_MODE_ATTACK 
    or mode == BOT_MODE_RETREAT 
    or mode == BOT_MODE_EVASIVE_MANEUVERS) then
        local wandSlot = npcBot:FindItemSlot("item_magic_wand")
        local wand = nil
        if npcBot:GetItemSlotType(wandSlot) == ITEM_SLOT_TYPE_MAIN then
            wand = npcBot:GetItemInSlot(wandSlot)
        end
        if wand ~= nil and (wand:GetCurrentCharges() > 10 or botHP < 100 or botMana < 100) then
            if wand:IsFullyCastable() then
                npcBot:Action_UseAbility(wand)
            end
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
