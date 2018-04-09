local build = require(GetScriptDirectory().."/item_build_techies")
require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()

local mine   = npcBot:GetAbilityByName("techies_land_mines")
local stasis = npcBot:GetAbilityByName("techies_stasis_trap")
local blast  = npcBot:GetAbilityByName("techies_suicide")
local remote = npcBot:GetAbilityByName("techies_remote_mines")

function BuybackUsageThink()
end

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
	local currMana = npcBot:GetMana()
	local maxMana  = npcBot:GetMaxMana()
	local currHP   = npcBot:GetHealth()
	local maxHP    = npcBot:GetMaxHealth()
	local mode     = npcBot:GetActiveMode()
	local queue    = npcBot:NumQueuedActions()
	local action   = npcBot:GetCurrentActionType()

	-- Surroundings
	local nearbyEnemies = npcBot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
	----------------------------------------------------------------------------

	-- Use Proximity Mines and Remote Mines
--	if remote:IsFullyCastable() and action ~= BOT_ACTION_TYPE_USE_ABILITY then
--		-- Find the closest Remote Mine location and drop one
--		local distFromClosestLoc, closestLoc = getClosestLocation(npcBot)
--
--		if distFromClosestLoc <= 1000 then
--			npcBot:Action_UseAbilityOnLocation(remote,closestLoc)
--		end
--	else
	if mine:IsFullyCastable() and action ~= BOT_ACTION_TYPE_USE_ABILITY then 
		-- drop a proximity mine near a tree near creeps
		local nearestCreep, nearestCreepDist = getNearestCreep()
		local trees = npcBot:GetNearbyTrees(1000)

		if table.getn(trees) > 0 and nearestCreepDist ~= nil and nearestCreepDist < 1500 and action ~= BOT_ACTION_TYPE_USE_ABILITY and action ~= BOT_ACTION_TYPE_ATTACK and action ~= BOT_ACTION_TYPE_MOVE_TO then
			local treeLoc = GetTreeLocation(trees[1]) + RandomVector(200)
			-- print ("DROPPING Proximity Mine at: "..treeLoc)
			-- print(nearestCreepDist, trees[1])
			if treeLoc[1] > -6800 then
				npcBot:Action_UseAbilityOnLocation(mine, treeLoc)
			end
		end
	end
	
	if npcBot:GetActiveMode() == BOT_MODE_RETREAT and npcBot.other_mode == BOT_MODE_ROAM then
		if stasis:IsFullyCastable() and action ~= BOT_ACTION_TYPE_USE_ABILITY then
			npcBot:Action_UseAbilityOnLocation(stasis, npcBot:GetLocation() + RandomVector(50))
		end
	end
end

function ItemUsageThink()
	local bottleLoc   = npcBot:FindItemSlot("item_bottle")
	local bottle      = nil
	local bottleSlot  = nil
	local botMana     = npcBot:GetMana()
	local botMaxMana  = npcBot:GetMaxMana()
	local botHP       = npcBot:GetHealth()
	local botMaxHP    = npcBot:GetMaxHealth()
	local currentMode = npcBot:GetActiveMode()
	
	local nearbyTrees   = npcBot:GetNearbyTrees(1600)
	local nearbyEnemies = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	
	local bountyTopRadLoc = GetRuneSpawnLocation(RUNE_BOUNTY_1)
	local bountyBotRadLoc = GetRuneSpawnLocation(RUNE_BOUNTY_2)
	local bountyTopDirLoc = GetRuneSpawnLocation(RUNE_BOUNTY_3)
	local bountyBotDirLoc = GetRuneSpawnLocation(RUNE_BOUNTY_4)
	
	local bountyTopRadDist = GetUnitToLocationDistance(npcBot, bountyTopRadLoc)
	local bountyBotRadDist = GetUnitToLocationDistance(npcBot, bountyBotRadLoc)
	local bountyTopDirDist = GetUnitToLocationDistance(npcBot, bountyTopDirLoc)
	local bountyBotDirDist = GetUnitToLocationDistance(npcBot, bountyBotDirLoc)
	
	local enemies = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	local clarity = nil
	local bottle  = nil
	local salve   = nil
	local tango   = nil
	local soul    = nil
	local boots   = nil
	local portal  = nil
	local arcane  = nil
	local cyclone = nil
	
	local courierLoc = npcBot:FindItemSlot("item_courier")
	local clarityLoc = npcBot:FindItemSlot("item_clarity")
	local bottleLoc  = npcBot:FindItemSlot("item_bottle")
	local salveLoc   = npcBot:FindItemSlot("item_flask")
	local tangoLoc   = npcBot:FindItemSlot("item_tango")
	local soulLoc    = npcBot:FindItemSlot("item_soul_ring")
	local bootsLoc   = npcBot:FindItemSlot("item_travel_boots")
	local portalLoc  = npcBot:FindItemSlot("item_tpscroll")
	local arcaneLoc  = npcBot:FindItemSlot("item_arcane_boots")
	local cycloneLoc = npcBot:FindItemSlot("item_cyclone")
	
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
	if npcBot:GetItemSlotType(arcaneLoc) == ITEM_SLOT_TYPE_MAIN then
		arcane = npcBot:GetItemInSlot(arcaneLoc)
	end
	if npcBot:GetItemSlotType(cycloneLoc) == ITEM_SLOT_TYPE_MAIN then
		cyclone = npcBot:GetItemInSlot(cycloneLoc)
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
	if arcane ~= nil then
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
	
	local baseMana = mine:GetManaCost()
	if remote:GetManaCost() > 0 then
		baseMana = remote:GetManaCost()
	end 
	
	if botMana < baseMana and not npcBot:HasModifier("modifier_clarity_potion") and not npcBot:IsChanneling() then
		if arcane ~= nil and arcane:IsCooldownReady() then
			print("    Using ARCANE BOOTS")
    		npcBot:Action_UseAbility(arcane)
		elseif (bottle == nil and clarity ~= nil) or (bottle ~= nil and bottle:GetCurrentCharges() == 0 and clarity ~= nil) or boots == nil then
    		npcBot:Action_UseAbilityOnEntity(clarity, npcBot)
    	elseif soul ~= nil and botHP/botMaxHP >= 0.4 and not npcBot:HasModifier("modifier_item_soul_ring") and not npcBot:HasModifier("modifier_item_soul_ring_buff") then
    		npcBot:Action_UseAbility(soul)
    	end
    end
    
	if botHP/botMaxHP < 0.5 and not npcBot:IsChanneling() then
		if salve ~= nil and not npcBot:HasModifier("modifier_flask_healing") then
			npcBot:Action_UseAbilityOnEntity(salve, npcBot)
		elseif bottle ~= nil and bottle:GetCurrentCharges() > 0 and npcBot:DistanceFromFountain() ~= 0 then
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
	if bottleLoc ~= nil and not npcBot:IsChanneling() then
		bottle     = npcBot:GetItemInSlot(bottleLoc)
		bottleSlot = npcBot:GetItemSlotType(bottleLoc)
		
		if bottle ~= nil and botMana/botMaxMana < 0.3 then
			if bottle:GetCurrentCharges() > 0 then
				npcBot:Action_UseAbility(bottle)
			end
		end
	end
	
	if npcBot.other_mode == BOT_MODE_ROAM and npcBot:GetActiveMode() == BOT_MODE_RETREAT and cyclone ~= nil and table.getn(nearbyEnemies) > 0 then
		local enemy = nearbyEnemies[1]
		
		npcBot:Action_UseAbilityOnEntity(cyclone, enemy)
	end
end

function getNearestCreep()
	local nearbyCreeps =  npcBot:GetNearbyCreeps(500, true)
	if #nearbyCreeps > 0 then
		local nearestCreep = nil
		local nearestCreepDist  = -50
		for _, creep in pairs(nearbyCreeps) do
			local dist = GetUnitToUnitDistance(npcBot, creep)
			if nearestCreepDist == -50 then
				nearestCreepDist  = dist
				nearestCreep = creep
			elseif nearestCreepDist > dist then
				nearestCreepDist  = dist
				nearestCreep = creep
			end
		end
		return nearestCreep, nearestCreepDist
	end
	return nil, nil
end

function getClosestLocation(bot)
	local closestDist   = -50
	local closestLoc    = nil
	local locsToUse     = nil
	local radTowerCount = 0
	local dirTowerCount = 0

	for _, towerID in pairs(_G.towers) do
		 local tower = GetTower(_G.teams[1], towerID)
		 if tower ~= nil then
		 	radTowerCount = radTowerCount + 1
		 	-- Maybe consider tower HP
		 end
	end
	for _, towerID in pairs(_G.towers) do
		 local tower = GetTower(_G.teams[2], towerID)
		 if tower ~= nil then
		 	radTowerCount = dirTowerCount + 1
		 	-- Maybe consider tower HP
		 end
	end

	for _, loc in pairs(_G.rad_early_remote_locs) do
		local dist = GetUnitToLocationDistance(bot, loc)
		if closestDist == -50 then
			closestDist = dist
			closestLoc = loc
		else
			if dist < closestDist then
				closestDist = dist
				closestLoc = loc
			end
		end
	end

	return closestDist, closestLoc
end

function getTeamObject(team, rad, dir)
	if team == _G.teams[1] then
		return rad
	else
		return dir
	end
end
