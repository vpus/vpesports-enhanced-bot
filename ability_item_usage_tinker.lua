local build = require(GetScriptDirectory().."/item_build_tinker")
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
	local botLoc       = npcBot:GetLocation()
	local action       = npcBot:GetCurrentActionType()
	local botMana      = npcBot:GetMana()
	local botHealth    = npcBot:GetHealth()
	local botHPRegen   = npcBot:GetHealthRegen()
	local botManaRegen = npcBot:GetManaRegen()
	local level        = npcBot:GetLevel()
	local blinkDagger  = npcBot:FindItemSlot("item_blink")
	local travelBoots  = npcBot:FindItemSlot("item_travel_boots")
	local currentGold  = npcBot:GetGold()
	local activeMode   = npcBot:GetActiveMode()
	
	local towerStatusTopRad = _G.GetTowerStatus("top", TEAM_RADIANT)
	local towerStatusMidRad = _G.GetTowerStatus("mid", TEAM_RADIANT)
	local towerStatusBotRad = _G.GetTowerStatus("bot", TEAM_RADIANT)
	local towerStatusTopDir = _G.GetTowerStatus("top", TEAM_DIRE)
	local towerStatusMidDir = _G.GetTowerStatus("mid", TEAM_DIRE)
	local towerStatusBotDir = _G.GetTowerStatus("bot", TEAM_DIRE)
	
	local creepLaneTopRad = _G.GetLaneCreepStatus(LANE_TOP, TEAM_RADIANT)
	local creepLaneMidRad = _G.GetLaneCreepStatus(LANE_MID, TEAM_RADIANT)
	local creepLaneBotRad = _G.GetLaneCreepStatus(LANE_BOT, TEAM_RADIANT)
	local creepLaneTopDir = _G.GetLaneCreepStatus(LANE_TOP, TEAM_DIRE)
	local creepLaneMidDir = _G.GetLaneCreepStatus(LANE_MID, TEAM_DIRE)
	local creepLaneBotDir = _G.GetLaneCreepStatus(LANE_BOT, TEAM_DIRE)
	
	local laser   = npcBot:GetAbilityByName("tinker_laser");
	local missile = npcBot:GetAbilityByName("tinker_heat_seeking_missile");
	local march   = npcBot:GetAbilityByName("tinker_march_of_the_machines");
	local rearm   = npcBot:GetAbilityByName("tinker_rearm");
	
	local nearbyEnemies  = npcBot:GetNearbyHeroes(650, true, BOT_MODE_NONE)

    if action ~= BOT_ACTION_TYPE_USE_ABILITY and action ~= BOT_ACTION_TYPE_MOVE_TO and action ~= BOT_ACTION_TYPE_ATTACK then
    	local nearbyCreeps  = npcBot:GetNearbyLaneCreeps(1000, true)
    	local lowestHPCreep = nil
    	
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
    	
    	if not npcBot:IsChanneling() then
    		if botMana >= (march:GetManaCost() + laser:GetManaCost()) and laser:IsFullyCastable() and nearestEnemy ~= nil then
    			npcBot:Action_UseAbilityOnEntity(laser, nearestEnemy)
    		end
    		if march:IsFullyCastable() and #nearbyCreeps >= 3 and activeMode ~= BOT_MODE_FARM then
    			local marchLoc = _G.getVectorBetweenTargetPercentage(npcBot, nearbyCreeps[1], 0.8)
    			npcBot:Action_UseAbilityOnLocation(march, _G.getAnglePoint(botLoc, marchLoc, 25))
    		end
    	end
    	
		-- Use Missile if enemy nearby
    	if not npcBot:IsChanneling() and missile ~= nil and missile:IsFullyCastable() and #nearbyEnemies > 0 then
    		npcBot:Action_UseAbility(missile)
    	end
    end
end

function ItemUsageThink()
	local bottleLoc  = npcBot:FindItemSlot("item_bottle")
	local bottle     = nil
	local bottleSlot = nil
	local botMana    = npcBot:GetMana()
	local botMaxMana = npcBot:GetMaxMana()
	local botHP      = npcBot:GetHealth()
	local botMaxHP   = npcBot:GetMaxHealth()
	
	local nearbyTrees = npcBot:GetNearbyTrees(1600)
	
	local bountyTopRadLoc = GetRuneSpawnLocation(RUNE_BOUNTY_1)
	local bountyBotRadLoc = GetRuneSpawnLocation(RUNE_BOUNTY_2)
	local bountyTopDirLoc = GetRuneSpawnLocation(RUNE_BOUNTY_3)
	local bountyBotDirLoc = GetRuneSpawnLocation(RUNE_BOUNTY_4)
	
	local bountyTopRadDist = GetUnitToLocationDistance(npcBot, bountyTopRadLoc)
	local bountyBotRadDist = GetUnitToLocationDistance(npcBot, bountyBotRadLoc)
	local bountyTopDirDist = GetUnitToLocationDistance(npcBot, bountyTopDirLoc)
	local bountyBotDirDist = GetUnitToLocationDistance(npcBot, bountyBotDirLoc)
	
	local missile = npcBot:GetAbilityByName("tinker_heat_seeking_missile")
	local enemies = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	local clarity = nil
	local bottle  = nil
	local salve   = nil
	local tango   = nil
	local soul    = nil
	local boots   = nil
	local portal  = nil
	
	local courierLoc = npcBot:FindItemSlot("item_courier")
	local clarityLoc = npcBot:FindItemSlot("item_clarity")
	local bottleLoc  = npcBot:FindItemSlot("item_bottle")
	local salveLoc   = npcBot:FindItemSlot("item_flask")
	local tangoLoc   = npcBot:FindItemSlot("item_tango")
	local soulLoc    = npcBot:FindItemSlot("item_soul_ring")
	local bootsLoc   = npcBot:FindItemSlot("item_travel_boots")
	local portalLoc  = npcBot:FindItemSlot("item_tpscroll")
	
	if npcBot:GetItemSlotType(clarityLoc) == ITEM_SLOT_TYPE_MAIN then
		clarity = npcBot:GetItemInSlot(clarityLoc)
	end
	if npcBot:GetItemSlotType(bottleLoc) == ITEM_SLOT_TYPE_MAIN then
		bottle = npcBot:GetItemInSlot(bottleLoc)
	end
	if npcBot:GetItemSlotType(salveLoc) == ITEM_SLOT_TYPE_MAIN then
		salve = npcBot:GetItemInSlot(salveLoc)
	end
	if npcBot:GetItemSlotType(tangoLoc) == ITEM_SLOT_TYPE_MAIN then
		tango = npcBot:GetItemInSlot(tangoLoc)
	end
	if npcBot:GetItemSlotType(soulLoc) == ITEM_SLOT_TYPE_MAIN then
		soul = npcBot:GetItemInSlot(soulLoc)
	end
	if npcBot:GetItemSlotType(bootsLoc) == ITEM_SLOT_TYPE_MAIN then
		boots = npcBot:GetItemInSlot(bootsLoc)
	end
	if npcBot:GetItemSlotType(portalLoc) == ITEM_SLOT_TYPE_MAIN then
		portal = npcBot:GetItemInSlot(portalLoc)
	end
	
	if bountyTopRadDist < 200 and bountyTopRadDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_1)
	elseif bountyBotRadDist < 200 and bountyBotRadDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_2)
	elseif bountyTopDirDist < 200 and bountyTopDirDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_3)
	elseif bountyBotDirDist < 200 and bountyBotDirDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_4)
	end
	
	-- Drop Clarities and Salves if boots acquired
	if boots ~= nil then
		if clarity ~= nil then
			npcBot:Action_DropItem(clarity, npcBot:GetLocation() + RandomVector(100))
		end
		if salve ~= nil then
			npcBot:Action_DropItem(salve, npcBot:GetLocation() + RandomVector(100))
		end
		if tango ~= nil then
			npcBot:Action_DropItem(tango, npcBot:GetLocation() + RandomVector(100))
		end
		if portal ~= nil then
			npcBot:Action_DropItem(portal, npcBot:GetLocation() + RandomVector(100))
		end
	end

	if botMana/botMaxMana < 0.4 and not npcBot:HasModifier("modifier_clarity_potion") and not npcBot:IsChanneling() then
		if (bottle == nil and clarity ~= nil) or (bottle ~= nil and bottle:GetCurrentCharges() == 0 and clarity ~= nil) or boots == nil then
    		npcBot:Action_UseAbilityOnEntity(clarity, npcBot)
    	elseif soul ~= nil and botHP/botMaxHP >= 0.4 and not npcBot:HasModifier("modifier_item_soul_ring") and not npcBot:HasModifier("modifier_item_soul_ring_buff") then
    		npcBot:Action_UseAbility(soul)
    	end
    end
    
	if botHP/botMaxHP < 0.5 and not npcBot:IsChanneling() then
		if salve ~= nil and not npcBot:HasModifier("modifier_flask_healing") then
			npcBot:Action_UseAbilityOnEntity(salve, npcBot)
		elseif bottle ~= nil and bottle:GetCurrentCharges() > 0 then
			npcBot:Action_UseAbility(bottle)
		elseif tango ~= nil and #nearbyTrees > 0 and not npcBot:HasModifier("modifier_tango_heal") then
			npcBot:Action_UseAbilityOnTree(tango, nearbyTrees[1])
		end
	end

    -- Use courier if in inventory
	if courierLoc ~= nil then
		local courier = npcBot:GetItemInSlot(courierLoc)
		if courier ~= nil then
			npcBot:Action_UseAbility(courier)
		end
	end
	
	-- Use bottle if mana is low
	if bottleLoc ~= nil then
		bottle     = npcBot:GetItemInSlot(bottleLoc)
		bottleSlot = npcBot:GetItemSlotType(bottleLoc)
		
		if bottle ~= nil and botMana/botMaxMana < 0.3 then
			if bottle:GetCurrentCharges() > 0 then
				npcBot:Action_UseAbility(bottle)
			end
		end
	end
	
	-- Move usable items to inventory
	
end