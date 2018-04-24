local build = require(GetScriptDirectory().."/item_build_abyssal_underlord")
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

    local firestorm  = npcBot:GetAbilityByName("abyssal_underlord_firestorm")
    local pit_of_malice = npcBot:GetAbilityByName("abyssal_underlord_pit_of_malice")
    local atrophy_aura  = npcBot:GetAbilityByName("abyssal_underlord_atrophy_aura")
    local dark_rift  = npcBot:GetAbilityByName("abyssal_underlord_dark_rift")
    local cancel_dark_rift  = npcBot:GetAbilityByName("abyssal_underlord_cancel_dark_rift")

    local nearbyCreeps  = npcBot:GetNearbyLaneCreeps(1000, true)
    local nearbyEnemies = npcBot:GetNearbyHeroes(900, true, BOT_MODE_NONE)

    if dark_rift:GetCooldownTimeRemaining() ~= 0 then
        UnderDarkRift = false
    end

    -- Fire storm think --
    if action ~= BOT_ACTION_TYPE_USE_ABILITY and action ~= action ~= BOT_ACTION_TYPE_MOVE_TO then
        if not npcBot:IsChanneling() then
            fire_power_count = 0
            if #nearbyEnemies > 0 then
                for j, enemy in pairs(nearbyEnemies) do
                    fire_power_count = fire_power_count + 2
                end
            end
            if #nearbyCreeps > 0 then
                for j, creep in pairs(nearbyCreeps) do
                    fire_power_count = fire_power_count + 1
                end
            end
            if fire_power_count >= 4 then
                if firestorm:GetCooldownTimeRemaining() == 0 then
                    local soulRingSlot = npcBot:FindItemSlot("item_soul_ring")
                    local soulRing = nil
                    if npcBot:GetItemSlotType(soulRingSlot) == ITEM_SLOT_TYPE_MAIN then
                        soulRing = npcBot:GetItemInSlot(soulRingSlot)
                    end
                    if soulRing ~= nil then
                        if soulRing:IsFullyCastable() and botMana < 300 and botHealth > 400 then
                            npcBot:Action_UseAbility(soulRing)
                        end
                    end
                    -- calculate the location --
                    local x_avg = 0
                    local y_avg = 0
                    if #nearbyCreeps > 0 then
                        for i, creep in ipairs(nearbyCreeps) do
                            x_avg = x_avg + creep:GetLocation()[1]
                            y_avg = y_avg + creep:GetLocation()[2]
                        end
                    end
                    if #nearbyEnemies > 0 then
                        for i, hero in ipairs(nearbyEnemies) do
                            x_avg = x_avg + hero:GetLocation()[1]
                            y_avg = y_avg + hero:GetLocation()[2]
                        end
                    end
                    size = #nearbyCreeps + #nearbyEnemies
                    fire_location = Vector(x_avg/size, y_avg/size, 0)

                    -- print("Ability : Using Fire Storm at ", fire_location)
                    if firestorm:IsFullyCastable() then
                        npcBot:Action_UseAbilityOnLocation(firestorm, fire_location)
                    end
                end
            end
        end
    end

    -- pit of malice think --
    if action ~= BOT_ACTION_TYPE_USE_ABILITY and action ~= action ~= BOT_ACTION_TYPE_MOVE_TO then
        if action_mode == BOT_MODE_ATTACK or action_mode == BOT_MODE_RETREAT or action_mode == BOT_MODE_DEFEND_ALLY or action_mode == BOT_MODE_EVASIVE_MANEUVERS then
            if not npcBot:IsChanneling() then
                pit_power_count = 0
                if #nearbyEnemies > 0 then
                    for i, hero in ipairs(nearbyEnemies) do
                        pit_power_count = pit_power_count + 2
                    end
                end
                if pit_power_count >= 2 then
                    if pit_of_malice:IsFullyCastable() then
                        local soulRingSlot = npcBot:FindItemSlot("item_soul_ring")
                        local soulRing = nil
                        if npcBot:GetItemSlotType(soulRingSlot) == ITEM_SLOT_TYPE_MAIN then
                            soulRing = npcBot:GetItemInSlot(soulRingSlot)
                        end
                        if soulRing ~= nil then
                            if soulRing:IsFullyCastable() and botMana < 300 and botHealth > 400 then
                                npcBot:Action_UseAbility(soulRing)
                            end
                        end
                        aoeLocations = npcBot:FindAoELocation(true, true, npcBot:GetLocation(), 900, 375, 1.0, 0)
                        -- print(aoeLocations.count)
                        pit_of_maliceLoc = aoeLocations.targetloc
                        npcBot:Action_UseAbilityOnLocation(pit_of_malice, pit_of_maliceLoc)
                    end
                end
            end
        end
    end

    -- dark rift think --
    if action_mode == BOT_MODE_RETREAT or action_mode == BOT_MODE_EVASIVE_MANEUVERS then
        if #nearbyEnemies >= 1 then
            if dark_rift:IsFullyCastable() and not UnderDarkRift then
                print("Using Dark Rift")
                npcBot:ActionImmediate_Chat("I'm Casting Dark Rift back to Base! Come to me!!", false)
                npcBot:Action_UseAbilityOnLocation(dark_rift, GetAncient(botTeam):GetLocation())
                UnderDarkRift = true
            end
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

    -- Crimson Guard --
    if (action_mode == BOT_MODE_ATTACK 
    or action_mode == BOT_MODE_RETREAT 
    or action_mode == BOT_MODE_DEFEND_ALLY
    or action_mode == BOT_MODE_EVASIVE_MANEUVERS) then
        local crimsonSlot = npcBot:FindItemSlot("item_crimson_guard")
        local crimson = nil
        if npcBot:GetItemSlotType(crimsonSlot) == ITEM_SLOT_TYPE_MAIN then
            crimson = npcBot:GetItemInSlot(crimsonSlot)
        end
        if crimson ~= nil then
            if crimson:IsFullyCastable() then
                npcBot:Action_UseAbility(crimson)
            end
        end
    end

    -- Guardian Greaves --
    local guardianGreavesSlot = npcBot:FindItemSlot("item_guardian_greaves")
    local guardianGreaves = nil
    if npcBot:GetItemSlotType(guardianGreavesSlot) == ITEM_SLOT_TYPE_MAIN then
        guardianGreaves = npcBot:GetItemInSlot(guardianGreavesSlot)
    end
    local use_guardian = false
    if npcBot:HasModifier("modifier_silence") or npcBot:HasModifier("modifier_silencer_global_silence") then
        use_guardian = true
    else
        if botMana/botMaxMana < 0.5 or botHealth/botMaxHealth < 0.75 then
            use_guardian = true
        else
            nearbyAllies = npcBot:GetNearbyHeroes(900, false, BOT_MODE_NONE)
            for j, ally in pairs(nearbyAllies) do
                allyHealth = ally:GetHealth()
                allyMaxHealth = ally:GetMaxHealth()
                allyMana = ally:GetMana()
                allyMaxMana = ally:GetMaxMana()
                if allyHealth/allyMaxHealth < 0.5 or allyMana/allyMaxMana<0.5 then
                    use_guardian = true
                    break
                end
            end
        end
    end
    if guardianGreaves ~= nil and use_guardian then
        if guardianGreaves:IsFullyCastable() then
            npcBot:Action_UseAbility(guardianGreaves)
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