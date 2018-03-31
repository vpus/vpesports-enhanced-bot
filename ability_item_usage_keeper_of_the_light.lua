local build = require(GetScriptDirectory().."/item_build_keeper_of_the_light")
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
    local action_mode = npcBot:GetActiveMode()

    local illuminate = npcBot:GetAbilityByName("keeper_of_the_light_illuminate")
    local manaleak = npcBot:GetAbilityByName("keeper_of_the_light_mana_leak")
    local chakra = npcBot:GetAbilityByName("keeper_of_the_light_chakra_magic")
    local spiritform = npcBot:GetAbilityByName("keeper_of_the_light_spirit_form")
    local recall = npcBot:GetAbilityByName("keeper_of_the_light_recall")
    local blinding = npcBot:GetAbilityByName("keeper_of_the_light_blinding_light")

    if npcBot:IsChanneling() then
        npcBot:ActionQueue_UseAbilityOnLocation(illuminate,npcBot:GetLocation())
    end

    if action ~= BOT_ACTION_TYPE_USE_ABILITY and action ~= BOT_ACTION_TYPE_ATTACK then
        -- chakra think --
        if chakra ~= nil and chakra:IsFullyCastable() then
            if botMana < 200 then
                npcBot:Action_UseAbilityOnEntity(chakra, npcBot)
                print("Ability : Using Chakra on SELF")
            else
                local alliedHeroes = GetUnitList(UNIT_LIST_ALLIED_HEROES)
                potential_target_hero = ""
                potential_hero_mana = 4000
                for i, alliedHero in ipairs(alliedHeroes) do
                    heroName = alliedHero:GetUnitName()
                    if heroName ~= "npc_dota_hero_keeper_of_the_light" then
                        distance = GetUnitToUnitDistance(npcBot, alliedHero)
                        if distance < 1800 then
                            ally_mana = alliedHero:GetMana()
                            ally_max_mana = alliedHero:GetMaxMana()
                            ally_mana_lose = ally_max_mana - ally_mana
                            if ally_mana < potential_hero_mana and ally_mana_lose > 200 then
                                potential_target_hero = alliedHero
                                potential_hero_mana = ally_mana
                            end
                        end
                    end
                end
                if potential_target_hero ~= "" then
                    npcBot:ActionQueue_UseAbilityOnEntity(chakra, potential_target_hero)
                    print("Ability in Queue : Using Chakra on someone")
                end
            end 
        end

        -- illuminate think --
        if action ~= BOT_ACTION_TYPE_MOVE_TO and action ~= BOT_ACTION_TYPE_USE_ABILITY then
            local nearbyCreeps  = npcBot:GetNearbyLaneCreeps(1000, true)
            local nearbyEnemies = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nearestEnemy  = nil

            for k,enemy in pairs(nearbyEnemies) do
                if nearestEnemy == nil then
                    nearestEnemy = enemy
                else
                    if GetUnitToUnitDistance(nearestEnemy, npcBot) > GetUnitToUnitDistance(enemy, npcBot) then
                        nearestEnemy = enemy
                    end
                end
            end

            if illuminate ~= nil and illuminate:IsFullyCastable() and #nearbyCreeps >= 2 then
                if botTeam == TEAM_RADIANT then
                    local illuminateLoc = _G.getVectorBetweenTargetPercentage(npcBot, nearbyCreeps[1], 0.8)
                else
                    local illuminateLoc = _G.getVectorBetweenTargetPercentage(npcBot, nearbyCreeps[1], -0.8)
                end
                print("Ability in Queue : Casting Illuminate")
                for i=1, 10 do
                    npcBot:ActionQueue_UseAbilityOnLocation(illuminate, illuminateLoc)
                end
            end
        end

        -- spiritform think --
        if action ~= BOT_ACTION_TYPE_MOVE_TO and action ~= BOT_ACTION_TYPE_USE_ABILITY then
            if npcBot:HasModifier("modifier_keeper_of_the_light_spirit_form") and spiritform ~= nil and spiritform:IsFullyCastable() then
                npcBot:ActionQueue_UseAbility(spiritform)
                print("Ability in Queue : Entering Spirit Form")
            end
        end

        -- manaleak think --
        if action_mode == BOT_MODE_ATTACK or action_mode == BOT_MODE_RETREAT then
            local nearbyEnemies = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
            local nearestEnemy  = nil
            for k,enemy in pairs(nearbyEnemies) do
                if nearestEnemy == nil then
                    nearestEnemy = enemy
                else
                    if GetUnitToUnitDistance(nearestEnemy, npcBot) > GetUnitToUnitDistance(enemy, npcBot) then
                        nearestEnemy = enemy
                    end
                end
            end

            if action ~= BOT_ACTION_TYPE_USE_ABILITY and action ~= BOT_ACTION_TYPE_ATTACK then
                if manaleak:IsFullyCastable() then
                    npcBot:Action_UseAbilityOnEntity(manaleak, nearestEnemy)
                end
            end
        end

        -- recall think --

        -- blinding think --
    end

    

end
