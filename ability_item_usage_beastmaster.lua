local build = require(GetScriptDirectory().."/item_build_beastmaster")
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
    if npcBot:GetAbilityPoints() > 0 and skillsToLevel[1] ~= "-1" 
    	and skillsToLevel[1] ~= nil then
      	npcBot:ActionImmediate_LevelAbility(skillsToLevel[1])
      	table.remove(skillsToLevel, 1)
    end
end

function AbilityUsageThink()
    local botMana = npcBot:GetMana()
    local botHealth = npcBot:GetHealth()
    local bot_location_x = npcBot:GetLocation()[1]
    local bot_location_y = npcBot:GetLocation()[2]
    local action = npcBot:GetCurrentActionType()

    local wild_axes = npcBot:GetAbilityByName("beastmaster_wild_axes")
    local call_of_the_wild = npcBot:GetAbilityByName("beastmaster_call_of_the_wild")
    local inner_beast = npcBot:GetAbilityByName("beastmaster_inner_beast")
    local primal_roar = npcBot:GetAbilityByName("beastmaster_primal_roar")

    local wild_axes_level = wild_axes:GetLevel()

    if action ~= BOT_ACTION_TYPE_USE_ABILITY and action ~= BOT_ACTION_TYPE_ATTACK then
        -- primal_roar think --
        if primal_roar ~= nil and primal_roar:IsFullyCastable() then
            action_mode = npcBot:GetActiveMode()
            if action_mode == 2 then
                local nearbyEnemies = npcBot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
                local strongerEnemy = nil

                for k, enemy in pairs(nearbyEnemies) do
                    if strongerEnemy == nil then
                        strongerEnemy = enemy
                    else
                        if enemy:GetRawOffensivePower() > strongerEnemy:GetRawOffensivePower() then
                            strongerEnemy = enemy
                        end
                    end
                end

                print("Ability : Using Primal Roar")
                npcBot:Action_UseAbilityOnEntity(primal_roar, strongerEnemy)
            end
        end
        
        -- wild_axes think --
        if wild_axes ~= nil and wild_axes:IsFullyCastable() and wild_axes_level >= 2 then
            local nearbyEnemies = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local strongerEnemy = nil

            for k, enemy in pairs(nearbyEnemies) do
                if strongerEnemy == nil then
                    strongerEnemy = enemy
                else
                    if enemy:GetRawOffensivePower() > strongerEnemy:GetRawOffensivePower() then
                        strongerEnemy = enemy
                    end
                end
            end

            if strongerEnemy ~= nil then
                if botTeam == 2 then
                    local wildAxeLoc = _G.getVectorBetweenTargetPercentage(npcBot, strongerEnemy, 1.1)
                    print("Ability : Using Wild Axe on ", wildAxeLoc)
                    npcBot:Action_UseAbilityOnLocation(wild_axes, wildAxeLoc)
                else
                    local wildAxeLoc = _G.getVectorBetweenTargetPercentage(strongerEnemy, npcBot, 1.1)
                    print("Ability : Using Wild Axe on ", wildAxeLoc)
                    npcBot:Action_UseAbilityOnLocation(wild_axes, wildAxeLoc)
                end
            else
                action_mode = npcBot:GetActiveMode()
                if action_mode == BOT_MODE_FARM then
                    local nearbyCreeps  = npcBot:GetNearbyLaneCreeps(1000, true)
                    if #nearbyCreeps >= 3 then
                        if botTeam == 2 then
                            local wildAxeLoc = _G.getVectorBetweenTargetPercentage(npcBot, nearbyCreeps[3], 1.1)
                            print("Ability : Using Wild Axe on ", wildAxeLoc)
                            npcBot:ActionQueue_UseAbilityOnLocation(wild_axes, wildAxeLoc)
                        else
                            local wildAxeLoc = _G.getVectorBetweenTargetPercentage(nearbyCreeps[3], npcBot, 1.1)
                            print("Ability : Using Wild Axe on ", wildAxeLoc)
                            npcBot:ActionQueue_UseAbilityOnLocation(wild_axes, wildAxeLoc)
                        end
                    end
                end
            end
            -- wildAxeLoc = {bot_location_x+400, bot_location_y+400}
            -- print(npcBot:GetLocation())
            -- npcBot:Action_UseAbilityOnLocation(wild_axes, npcBot:GetLocation())
        end

        -- call_of_the_wild think --    
        if call_of_the_wild ~= nil and call_of_the_wild:IsFullyCastable() then
            npcBot:Action_UseAbility(call_of_the_wild)
            print("Ability : Using call of wild")
        end
    end
end

-- function ItemUsageThink()
--     local clarity = nil
--     local soul = nil
--     local necro1 = nil
--     local necro2 = nil
--     local necro3 = nil

--     local clarityLoc = npcBot:FindItemSlot("item_clarity")
--     local soulLoc    = npcBot:FindItemSlot("item_soul_ring")
--     local necro1Loc = npcBot:FindItemSlot("item_necronomicon_1")
--     local necro2Loc = npcBot:FindItemSlot("item_necronomicon_2")
--     local necro3Loc = npcBot:FindItemSlot("item_necronomicon_3")

--     if npcBot:GetItemSlotType(clarityLoc) == ITEM_SLOT_TYPE_MAIN then
-- 		clarity = npcBot:GetItemInSlot(clarityLoc)
-- 	end
--     if npcBot:GetItemSlotType(soulLoc) == ITEM_SLOT_TYPE_MAIN then
-- 		soul = npcBot:GetItemInSlot(soulLoc)
-- 	end
--     if npcBot:GetItemSlotType(necro1Loc) == ITEM_SLOT_TYPE_MAIN then
-- 		clarity = npcBot:GetItemInSlot(necro1Loc)
-- 	end
--     if npcBot:GetItemSlotType(necro2Loc) == ITEM_SLOT_TYPE_MAIN then
-- 		clarity = npcBot:GetItemInSlot(necro2Loc)
-- 	end
--     if npcBot:GetItemSlotType(necro3Loc) == ITEM_SLOT_TYPE_MAIN then
-- 		clarity = npcBot:GetItemInSlot(necro3Loc)
-- 	end

--     local action_mode = npcBot:GetActiveMode()

--     local botMana    = npcBot:GetMana()
-- 	local botMaxMana = npcBot:GetMaxMana()
--     if botMana/botMaxMana < 0.4 and not npcBot:HasModifier("modifier_clarity_potion") then
-- 		if (bottle == nil and clarity ~= nil) or (bottle ~= nil and bottle:GetCurrentCharges() == 0 and clarity ~= nil) or boots == nil then
--     		npcBot:Action_UseAbilityOnEntity(clarity, npcBot)
--     	elseif soul ~= nil then
--     		npcBot:Action_UseAbility(soul)
--     	end
--     end

--     -- if action_mode == BOT_MODE_PUSH_TOWER_TOP or action_mode == BOT_MODE_PUSH_TOWER_MID or BOT_MODE_PUSH_TOWER_MID == BOT_MODE_PUSH_TOWER_BOT or action_mode == BOT_MODE_ATTACK then
--         if necro1Loc ~= nil then
--             local necro1 = npcBot:GetItemInSlot(necro1Loc)
--             if necro1 ~= nil then
--                 npcBot:Action_UseAbility(necro1)
--             end
--         end
        
--         if necro2Loc ~= nil then
--             local necro2 = npcBot:GetItemInSlot(necro2Loc)
--             if necro2 ~= nil then
--                 npcBot:Action_UseAbility(necro2)
--             end
--         end

--         if necro3Loc ~= nil then
--             local necro3 = npcBot:GetItemInSlot(necro3Loc)
--             if necro3 ~= nil then
--                 npcBot:Action_UseAbility(necro3)
--             end
--         end
--     -- end
    
-- end

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