require( GetScriptDirectory().."/UtilityData");
require( GetScriptDirectory().."/UtilityFunctions");
----------------------------------------------------------------------------------------------------

local bot = GetBot();

function OnStart()
    bot:Action_ClearActions(true);
end

-- Logic for all Attack Mode behavior
--function Think()
--    -- Abilities
--    local ProximityMine = bot:GetAbilityByName("techies_land_mines");
--    local StasisTrap    = bot:GetAbilityByName("techies_stasis_trap");
--    local BlastOff      = bot:GetAbilityByName("techies_suicide");
--    local RemoteMine    = bot:GetAbilityByName("techies_remote_mines");
--
--    local nearbyEnemies = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE);
--    local nearbyAllies  = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE);
--    local botLoc        = bot:GetLocation();
--
--    local botHP    = bot:GetHealth();
--    local botMaxHP = bot:GetMaxHealth();
--    local botMana  = bot:GetMana();
--
--    -- Make sure allies are around to assist the fight
--    if #nearbyEnemies > 0 and #nearbyAllies > 0 then
--        local enemyLoc    = nearbyEnemies[1]:GetLocation();
--        local distToEnemy = _G.getDistanceBetweenTwoPoints(enemyLoc, botLoc);
--        local aoeLoc      = bot:FindAoELocation(true, true, enemyLoc, 400, 1000, 0, 600);
--
--        if BlastOff:IsFullyCastable() and aoeLoc.count > 0 and (botHP / botMaxHP) > 0.5 then
--            local nearbyTowers   = bot:GetNearbyTowers(1000, true);
--            if #nearbyTowers > 0 then
--                local aoeDistToTower = _G.getDistanceBetweenTwoPoints(botLoc, nearbyTowers[1]);
--                if aoeDistToTower > 700 then
--                    bot:ActionPush_UseAbilityOnLocation(BlastOff, aoeLoc.targetloc);
--                end
--            else
--                bot:ActionPush_UseAbilityOnLocation(BlastOff, aoeLoc.targetloc);
--            end
--        elseif StasisTrap:IsFullyCastable() then
--            bot:ActionPush_UseAbilityOnLocation(StasisTrap, botLoc + RandomVector(50));
--        elseif RemoteMine:IsFullyCastable() then
--            bot:ActionPush_UseAbilityOnLocation(RemoteMine, enemyLoc + RandomVector(50));
--        elseif ProximityMine:IsFullyCastable() then
--            bot:ActionPush_UseAbilityOnLocation(ProximityMine, botLoc + RandomVector(100));
--        elseif bot:GetCurrentActionType() ~= _G.actions["attack"] and bot:GetCurrentActionType() ~= _G.actions["attack_move"] then
--            bot:Action_AttackUnit(nearbyEnemies[1], false);
--        end
--    end
--end

function GetDesire()
    -- Abilities
    local ProximityMine = bot:GetAbilityByName("techies_land_mines");
    local StasisTrap    = bot:GetAbilityByName("techies_stasis_trap");
    local BlastOff      = bot:GetAbilityByName("techies_suicide");
    local RemoteMine    = bot:GetAbilityByName("techies_remote_mines");

    local nearbyEnemies = bot:GetNearbyHeroes(1000, true, BOT_MODE_NONE);
    local nearbyAllies  = bot:GetNearbyHeroes(1000, false, BOT_MODE_NONE);
    local ratio         = #nearbyEnemies / (#nearbyAllies + 1);
    local averageEnemyHP = 0;
    local lowestEnemyHP  = 100000;
    local highestEnemyHP = 0;

    for _, enemy in pairs(nearbyEnemies) do
        local enemyHP = enemy:GetHealth();
        averageEnemyHP = averageEnemyHP + enemyHP;
        if enemyHP < lowestEnemyHP then
            lowestEnemyHP = enemyHP;
        end
        if enemyHP > highestEnemyHP then
            highestEnemyHP = enemyHP;
        end
    end

    if BlastOff:IsFullyCastable() and #nearbyEnemies > 0
      and averageEnemyHP <= BlastOff:GetAbilityDamage() then
        return _G.desires[7];
    end
    
    return _G.desires[0];
end
