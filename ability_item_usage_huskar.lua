local build = require(GetScriptDirectory().."/item_build_huskar")
require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()
local lane_claim = true

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
      	npcBot:ActionImmediate_LevelAbility(skillsToLevel[1])
      	table.remove(skillsToLevel, 1)
    end
end

function AbilityUsageThink()
    local botMana = npcBot:GetMana()
    local botHealth = npcBot:GetHealth()
    local botMaxHealth = npcBot:GetMaxHealth()
    local bot_location_x = npcBot:GetLocation()[1]
    local bot_location_y = npcBot:GetLocation()[2]
    local action = npcBot:GetCurrentActionType()
    local action_mode = npcBot:GetActiveMode()

    local inner_vitality  = npcBot:GetAbilityByName("huskar_inner_vitality")
    local burning_spear = npcBot:GetAbilityByName("huskar_burning_spear")
    local berserkers_blood  = npcBot:GetAbilityByName("huskar_berserkers_blood")
    local life_break  = npcBot:GetAbilityByName("huskar_life_break")

    -- Check if Inner Vitality is castable and if is used --
    if npcBot:HasModifier("modifier_huskar_life_break_charge") and not npcBot:HasModifier("modifier_huskar_inner_vitality") and inner_vitality:IsFullyCastable() then
        print("Ability : Using Inner Vitality while Life Break")
        npcBot:Action_UseAbilityOnEntity(inner_vitality, npcBot)
    end

    local armletSlot = npcBot:FindItemSlot("item_armlet")
    local armlet = nil
    if npcBot:GetItemSlotType(armletSlot) == ITEM_SLOT_TYPE_MAIN then
        armlet = npcBot:GetItemInSlot(armletSlot)
    end
    if armlet ~= nil then
        local nearbyEnemies = npcBot:GetNearbyHeroes(900, true, BOT_MODE_NONE)
        if npcBot:HasModifier("modifier_item_armlet_unholy_strength") then
            if armlet:IsFullyCastable() and #nearbyEnemies < 1 and action_mode ~= 2 then
                npcBot:Action_UseAbility(armlet)
            elseif #nearbyEnemies >= 1 and botHealth < 300 then
                npcBot:Action_UseAbility(armlet)
                npcBot:Action_UseAbility(armlet)
            end
        else
            if armlet:IsFullyCastable() and #nearbyEnemies >= 2 then
                npcBot:Action_UseAbility(armlet)
            end
        end
    end

    -- Burning Spear Toggle --
    -- print("mode:",action_mode)
    -- print("spear mode", burning_spear:GetAutoCastState())
    if action_mode ~= BOT_MODE_ATTACK then
        -- print("not attacking", burning_spear:GetAutoCastState())
        if burning_spear:GetAutoCastState() then
            -- print("Toggle it OFF")
            burning_spear:ToggleAutoCast()
        end
    else
        -- print("attacking", burning_spear:GetAutoCastState())
        if not burning_spear:GetAutoCastState() then
            -- print("Toggle it ON")
            burning_spear:ToggleAutoCast()
        end
    end

    if action ~= BOT_ACTION_TYPE_USE_ABILITY and action ~= BOT_ACTION_TYPE_ATTACK then
        -- life_break think --
        if life_break ~= nil and life_break:IsFullyCastable() then
            action_mode = npcBot:GetActiveMode()
            if action_mode == BOT_MODE_ATTACK then
                local nearbyEnemies = npcBot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local weakerEnemy = nil

                for k, enemy in pairs(nearbyEnemies) do
                    if weakerEnemy == nil then
                        weakerEnemy = enemy
                    else
                        if enemy:GetRawOffensivePower() < weakerEnemy:GetRawOffensivePower() then
                            weakerEnemy = enemy
                        end
                    end
                end

                print("Ability : Using Life Break")
                npcBot:Action_UseAbilityOnEntity(life_break, weakerEnemy)
            end
        end

        -- inner vatality think --
        bot_percentage = botHealth / botMaxHealth
        if bot_percentage < 0.35 and not npcBot:HasModifier("modifier_huskar_inner_vitality") and inner_vitality:IsFullyCastable() then
            print("Ability : Using Inner Vitality while Life Break")
            npcBot:Action_UseAbilityOnEntity(inner_vitality, npcBot)
        end
    end

    if action_mode == BOT_MODE_LANING then
        -- check creep aggression --
        local nearbyCreeps  = npcBot:GetNearbyLaneCreeps(1000, true)
        count = 0
        for i, creep in pairs(nearbyCreeps) do
            if creep:GetAttackTarget() == npcBot then
                count = count + 1
            end
        end

        -- check tower aggression --
        local nearbyTowers = npcBot:GetNearbyTowers(700, true)
        for i, tower in pairs(nearbyTowers) do
            if tower:GetAttackTarget() == npcBot then
                count = count + 4
            end
        end

        local nearbyEnemies = npcBot:GetNearbyHeroes(700, true, BOT_MODE_NONE)
        local weakerEnemy = nil

        for k, enemy in pairs(nearbyEnemies) do
            if weakerEnemy == nil then
                weakerEnemy = enemy
            else
                if enemy:GetHealth() < weakerEnemy:GetHealth() then
                    weakerEnemy = enemy
                end
            end
        end

        if weakerEnemy ~= nil and count <= 2 then
            npcBot:Action_UseAbilityOnEntity(burning_spear, weakerEnemy)
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