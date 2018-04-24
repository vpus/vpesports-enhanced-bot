local build = require(GetScriptDirectory().."/item_build_abaddon")
require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()
local lane_claim = true
local UnderDarkRift = false

function AbilityLevelUpThink()
    local skillsToLevel = build["skills"]
--    if npcBot:GetAbilityPoints() < 1 or (GetGameState() ~= GAME_STATE_PRE_GAME 
--    	and GetGameState() ~= GAME_STATE_GAME_IN_PROGRESS) then
--        return
--    end
    -- for i, item in pairs(skillsToLevel) do
    --     print(i, item)
    -- end
    if npcBot:GetAbilityPoints() > 0 and skillsToLevel[1] ~= "-1" 
    	and skillsToLevel[1] ~= nil then
        -- print(npcBot:GetAbilityPoints(), skillsToLevel[1])
      	npcBot:ActionImmediate_LevelAbility(skillsToLevel[1])
      	table.remove(skillsToLevel, 1)
    end
end

function AbilityUsageThink()
    local botMana = npcBot:GetMana()
    local botHealth = npcBot:GetHealth()
    local botMaxHealth = npcBot:GetMaxHealth()
    local botMaxMana = npcBot:GetMaxMana()
    local bot_location_x = npcBot:GetLocation()[1]
    local bot_location_y = npcBot:GetLocation()[2]
    local action = npcBot:GetCurrentActionType()
    local action_mode = npcBot:GetActiveMode()

    local death_coil  = npcBot:GetAbilityByName("abaddon_death_coil")
    local aphotic_shield = npcBot:GetAbilityByName("abaddon_aphotic_shield")

    local nearbyCreeps  = npcBot:GetNearbyLaneCreeps(1000, true)
    local nearbyEnemies = npcBot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)

    -- death coil think --
    ---- suicide death coil ----
    if death_coil:IsFullyCastable() then
        local coil_cast = false
        local coil_target = nil
        healthCost = death_coil:GetLevel()*25 + 50
        if botHealth < healthCost and #nearbyEnemies > 0 then
            local nearbyEnemies_800 = npcBot:GetNearbyHeroes(800, true, BOT_MODE_NONE)
            for j, enemy in pairs(nearbyEnemies_800) do
                if coil_target == nil then
                    coil_target = enemy
                else
                    if enemy:GetHealth() < coil_target:GetHealth() then
                        coil_target = enemy
                    end
                end
            end
            if coil_target == nil then
                local nearbyAllies_800 = npcBot:GetNearbyHeroes(800, false, BOT_MODE_NONE)
                for j, ally in pairs(nearbyAllies_800) do
                    if coil_target == nil then
                        coil_target = ally
                    else
                        if ally:GetHealth() < coil_target:GetHealth() then
                            coil_target = ally
                        end
                    end
                end
            end
            if coil_target == nil then
                local nearbyCreeps_800 = npcBot:GetNearbyLaneCreeps(800, true)
                for j, creep in pairs(nearbyCreeps_800) do
                    if coil_target == nil then
                        coil_target = creep
                    else
                        if creep:GetHealth() < coil_target:GetHealth() then
                            coil_target = creep
                        end
                    end
                end
            end
            if coil_target == nil then
                local nearbyCreeps_800 = npcBot:GetNearbyLaneCreeps(800, false)
                for j, creep in pairs(nearbyCreeps_800) do
                    if coil_target == nil then
                        coil_target = creep
                    else
                        if creep:GetHealth() < coil_target:GetHealth() then
                            coil_target = creep
                        end
                    end
                end
            end
            if coil_target ~= nil then
                coil_cast = true
            end
        end
        ---- common death coil think ----
        if not coil_cast then
            if not npcBot:IsChanneling() then
                coil_damage = death_coil:GetAbilityDamage()
                for j, enemy in pairs(nearbyEnemies) do
                    if coil_target == nil then
                        coil_target = enemy
                    else
                        local enemyResist = enemy:GetMagicResist()
                        local enemy_coil_damage = coil_damage*(1-enemyResist)
                        if enemy:GetHealth() < enemy_coil_damage then
                            coil_target = enemy
                            coil_cast = true
                            break
                        elseif enemy:GetHealth() < coil_target:GetHealth() then
                            coil_target = enemy
                        end
                    end
                end
                if not coil_cast then
                    local nearbyAllies = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
                    for j, ally in pairs(nearbyAllies) do
                        if ally:GetHealth() < coil_target:GetHealth() and ally:GetHealth() < 500 then
                            coil_target = ally
                        end
                    end
                end
                if (action_mode == BOT_MODE_LANING or action_mode == BOT_MODE_FARM or action_mode == BOT_MODE_PUSH_TOWER_TOP
                or action_mode == BOT_MODE_PUSH_TOWER_TOP or action_mode == BOT_MODE_PUSH_TOWER_MID or action_mode == BOT_MODE_PUSH_TOWER_BOT) then
                    if coil_target == nil then
                        local nearbyCreeps = npcBot:GetNearbyLaneCreeps(1000, true)
                        for j, creep in pairs(nearbyCreeps) do
                            local enemyResist = enemy:GetMagicResist()
                            local enemy_coil_damage = coil_damage*(1-enemyResist)
                            if creep:GetHealth() < enemy_coil_damage then
                                coil_target = creep
                                break
                            end
                        end
                    end
                end
                if not coil_cast and coil_target ~= nil and coil_target ~= npcBot then
                    if botHealth > 500 and #nearbyEnemies > 0 then
                        coil_cast = true
                    end
                end
            end
        end

        ---- death coil cast ----
        if coil_cast then
            print("Use Coil on ", coil_target:GetUnitName())
            npcBot:Action_UseAbilityOnEntity(death_coil, coil_target)
        end
    end

    -- aphotic shield --
    if aphotic_shield:IsFullyCastable() then
        local shield_cast = false
        local shield_target = npcBot
        local shield_target_health = npcBot:GetHealth()
        local nearbyAllies = npcBot:GetNearbyHeroes(1000, false, BOT_MODE_NONE)
        local nearbyEnemies_675 = npcBot:GetNearbyHeroes(675, true, BOT_MODE_NONE)
        for j, ally in pairs(nearbyAllies) do
            if ally:GetHealth() < shield_target:GetHealth() and (ally:GetHealth()*1.5 < botHealth or ally:GetHealth() < 500 ) then
                shield_target = ally
            end
        end

        if aphotic_shield:GetLevel() == 1 then
            if shield_target_health < 200 and #nearbyEnemies_675 > 0 then
                shield_cast = true
            end
        else
            if action_mode == BOT_MODE_RETREAT or action_mode == BOT_MODE_ATTACK and #nearbyEnemies > 0 then
                shield_cast = true
            else
                for j,enemy in pairs(nearbyEnemies) do
                    if enemy:GetAttackTarget() == npcBot and botHealth < botMaxHealth - 150 then
                        shield_cast = true
                        break
                    end
                end
            end
        end

        ---- aphotic shield cast ----
        if shield_cast and not npcBot:HasModifier("modifier_fountain_aura_buff") then
            print("Use Shiled on ", shield_target:GetUnitName())
            npcBot:Action_UseAbilityOnEntity(aphotic_shield, shield_target)
        end
    end

    -- Hood of Defiance --
    if (action_mode == BOT_MODE_ATTACK 
    or action_mode == BOT_MODE_RETREAT 
    or action_mode == BOT_MODE_DEFEND_ALLY
    or action_mode == BOT_MODE_EVASIVE_MANEUVERS) then
        local hoodSlot = npcBot:FindItemSlot("item_hood_of_defiance")
        local hood = nil
        if npcBot:GetItemSlotType(hoodSlot) == ITEM_SLOT_TYPE_MAIN then
            hood = npcBot:GetItemInSlot(hoodSlot)
        end
        if hood ~= nil then
            if hood:IsFullyCastable() then
                npcBot:Action_UseAbility(hood)
            end
        end
    end

    -- Pipe of Insight --
    if (action_mode == BOT_MODE_ATTACK 
    or action_mode == BOT_MODE_RETREAT 
    or action_mode == BOT_MODE_DEFEND_ALLY
    or action_mode == BOT_MODE_EVASIVE_MANEUVERS) then
        local pipeSlot = npcBot:FindItemSlot("item_pipe")
        local pipe = nil
        if npcBot:GetItemSlotType(pipeSlot) == ITEM_SLOT_TYPE_MAIN then
            pipe = npcBot:GetItemInSlot(pipeSlot)
        end
        if pipe ~= nil then
            if pipe:IsFullyCastable() then
                npcBot:Action_UseAbility(pipe)
            end
        end
    end

    -- Shiva's Guard --
    if (action_mode == BOT_MODE_ATTACK 
    or action_mode == BOT_MODE_RETREAT 
    or action_mode == BOT_MODE_DEFEND_ALLY
    or action_mode == BOT_MODE_EVASIVE_MANEUVERS) then
        local shivaSlot = npcBot:FindItemSlot("item_shivas_guard")
        local shiva = nil
        if npcBot:GetItemSlotType(shivaSlot) == ITEM_SLOT_TYPE_MAIN then
            shiva = npcBot:GetItemInSlot(shivaSlot)
        end
        if shiva ~= nil then
            if shiva:IsFullyCastable() then
                npcBot:Action_UseAbility(shiva)
            end
        end
    end

    -- magic wand --
    if (action_mode == BOT_MODE_ATTACK 
    or action_mode == BOT_MODE_RETREAT 
    or action_mode == BOT_MODE_EVASIVE_MANEUVERS) then
        local wandSlot = npcBot:FindItemSlot("item_magic_wand")
        local wand = nil
        if npcBot:GetItemSlotType(wandSlot) == ITEM_SLOT_TYPE_MAIN then
            wand = npcBot:GetItemInSlot(wandSlot)
        end
        if wand ~= nil and (wand:GetCurrentCharges() > 10 or botHealth < 100 or botMana < 100) then
            if wand:IsFullyCastable() then
                npcBot:Action_UseAbility(wand)
            end
        end
    end

    -- Medallion of Courage --
    if npcBot:GetAttackTarget() ~= nil then
        local medallionSlot = npcBot:FindItemSlot("item_medallion_of_courage")
        local medallion = nil
        if npcBot:GetItemSlotType(medallionSlot) == ITEM_SLOT_TYPE_MAIN then
            medallion = npcBot:GetItemInSlot(medallionSlot)
        end
        if medallion ~= nil then
            if medallion:IsFullyCastable() then
                npcBot:Action_UseAbilityOnEntity(medallion, npcBot:GetAttackTarget())
            end
        end
    end

    -- Solar Crest --
    if npcBot:GetAttackTarget() ~= nil then
        local solarCrestSlot = npcBot:FindItemSlot("item_solar_crest")
        local solarCrest = nil
        if npcBot:GetItemSlotType(solarCrestSlot) == ITEM_SLOT_TYPE_MAIN then
            solarCrest = npcBot:GetItemInSlot(solarCrestSlot)
        end
        if solarCrest ~= nil then
            if solarCrest:IsFullyCastable() then
                npcBot:Action_UseAbilityOnEntity(solarCrest, npcBot:GetAttackTarget())
            end
        end
    end

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