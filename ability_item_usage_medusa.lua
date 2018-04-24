local build = require(GetScriptDirectory().."/item_build_medusa")
require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()

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
        print(npcBot:GetAbilityPoints(), skillsToLevel[1])
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

    local split_shot  = npcBot:GetAbilityByName("medusa_split_shot")
    local mystic_snake = npcBot:GetAbilityByName("medusa_mystic_snake")
    local mana_shield  = npcBot:GetAbilityByName("medusa_mana_shield")
    local stone_gaze  = npcBot:GetAbilityByName("medusa_stone_gaze")

    local nearbyCreeps  = npcBot:GetNearbyLaneCreeps(1000, true)
    local nearbyEnemies = npcBot:GetNearbyHeroes(900, true, BOT_MODE_NONE)

    -- Mana Shield think --
    cast = false
    if not npcBot:HasModifier("modifier_medusa_mana_shield") then
        if #nearbyEnemies >= 1 then
            cast = true
        elseif botHealth < botMaxHealth*0.1 then
            cast = true
        elseif botHealth < botMaxHealth*0.7 and botMana > botMaxMana*0.7 then
            cast = true
        end
        if action_mode == BOT_MODE_LANING and botMana < mystic_snake:GetManaCost() then
            cast = false
        end
    else
        if #nearbyEnemies == 0 and botMana < botMaxMana*0.3 and botHealth > botMaxHealth*0.8 then
            cast = true
        end
        if action_mode == BOT_MODE_LANING and botMana < mystic_snake:GetManaCost() then
            cast = true
        end
    end
    if not npcBot:IsChanneling() and mana_shield:IsFullyCastable() and cast then
        npcBot:Action_UseAbility(mana_shield)
    end

    -- mystic_snake think --
    if action ~= BOT_ACTION_TYPE_USE_ABILITY and action ~= action ~= BOT_ACTION_TYPE_MOVE_TO then
        if not npcBot:IsChanneling() then
            power_count = 0
            count = 0
            closest_unit = nil
            closest_distance = 10000
            if #nearbyEnemies > 0 then
                for j, enemy in pairs(nearbyEnemies) do
                    power_count = power_count + 2
                    count = count + 1
                    if closest_unit == nil then
                        closest_unit = enemy
                        closest_distance = GetUnitToUnitDistance(npcBot, enemy)
                    else
                        distance = GetUnitToUnitDistance(npcBot, enemy)
                        if distance < closest_distance then
                            closest_distance = distance
                            closest_unit = enemy
                        end
                    end
                end
            end
            if #nearbyCreeps > 0 then
                for j, creep in pairs(nearbyCreeps) do
                    power_count = power_count + 1
                    count = count + 1
                    if closest_unit == nil then
                        closest_unit = creep
                        closest_distance = GetUnitToUnitDistance(npcBot, creep)
                    else
                        distance = GetUnitToUnitDistance(npcBot, creep)
                        if distance < closest_distance then
                            closest_distance = distance
                            closest_unit = creep
                        end
                    end
                end
            end

            current_jump_amount = mystic_snake:GetLevel() + 2
            if power_count >= 4 and count <= current_jump_amount and mystic_snake:IsFullyCastable() then
                npcBot:Action_UseAbilityOnEntity(mystic_snake, closest_unit)
            end

        end
    end

    -- stone gaze think --
    if action_mode == BOT_MODE_ATTACK or action_mode == BOT_MODE_RETREAT or action_mode == BOT_MODE_DEFEND_ALLY or action_mode == BOT_MODE_EVASIVE_MANEUVERS then
        if #nearbyEnemies >= 2 then
            if not npcBot:IsChanneling() and stone_gaze:IsFullyCastable() then
                npcBot:Action_UseAbility(stone_gaze)
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