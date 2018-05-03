local build = require(GetScriptDirectory().."/item_build_ogre_magi")
require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()

local fireblast = npcBot:GetAbilityByName("ogre_magi_fireblast")
local ignite    = npcBot:GetAbilityByName("ogre_magi_ignite")
local bloodlust = npcBot:GetAbilityByName("ogre_magi_bloodlust")
local form      = npcBot:GetAbilityByName("ogre_magi_unrefined_fireblast")

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
	local currMana = npcBot:GetMana()
	local maxMana  = npcBot:GetMaxMana()
	local currHP   = npcBot:GetHealth()
	local maxHP    = npcBot:GetMaxHealth()
	local mode     = npcBot:GetActiveMode()
	local queue    = npcBot:NumQueuedActions()
	local action   = npcBot:GetCurrentActionType()
	local allyList = GetUnitList(UNIT_LIST_ALLIES)

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
	
	-- Use BLOODLUST
	if bloodlust:IsFullyCastable() and numEnemies > 0 and action ~= BOT_ACTION_TYPE_USE_ABILITY then
		if numAllies > 0 then
			for a = 1, numAllies do
				local ally = allies[a]
				
				if not ally:HasModifier("modifier_ogre_magi_bloodlust") then
					local allyTarget = ally:GetAttackTArget()
					
					if allyTarget ~= nil and allyTarget:IsHero() then
						npcBot:Action_UseAbilityOnEntity(bloodlust, ally)
					end
				end
			end
		elseif mode == BOT_MODE_ATTACK then
			npcBot:Action_UseAbilityOnEntity(bloodlust, npcBot)
		end
	end
	
	-- Use FIREBLAST
	if fireblast:IsFullyCastable() and numEnemies > 0 and action ~= BOT_ACTION_TYPE_USE_ABILITY then
		local enemyDist = GetUnitToUnitDistance(npcBot, enemies[1])
		
		if mode == BOT_MODE_ATTACK then
    		npcBot:Action_UseAbilityOnEntity(fireblast, enemies[1])
		elseif enemies[1]:GetAttackTarget() == npcBot then
			npcBot:Action_UseAbilityOnEntity(fireblast, enemies[1])
		end
	elseif fireblast:IsFullyCastable() and numEnemyCreeps > 3 and action ~= BOT_ACTION_TYPE_USE_ABILITY then
		for c = 1, numEnemyCreeps do
			local enemy = enemyCreeps[c]
			
			if enemy:GetHealth() / enemy:GetMaxHealth() == 1 then
				npcBot:Action_UseAbilityOnEntity(fireblast, enemy)
			end 
		end
	end
	
	-- Use IGNITE
	if ignite:IsFullyCastable() and numEnemies > 0 and action ~= BOT_ACTION_TYPE_USE_ABILITY then
		npcBot:Action_UseAbilityOnEntity(ignite, enemies[1])
	elseif ignite:IsFullyCastable() and numEnemyCreeps > 3 and action ~= BOT_ACTION_TYPE_USE_ABILITY then
		for c = 1, numEnemyCreeps do
			local enemy = enemyCreeps[c]
			
			if enemy:GetHealth() / enemy:GetMaxHealth() == 1 then
				npcBot:Action_UseAbilityOnEntity(ignite, enemy)
			end 
		end
	end
end

function ItemUsageThink()
	local bottle      = nil
	local bottleSlot  = nil
	local botMana     = npcBot:GetMana()
	local botMaxMana  = npcBot:GetMaxMana()
	local botHP       = npcBot:GetHealth()
	local botMaxHP    = npcBot:GetMaxHealth()
	local currentMode = npcBot:GetActiveMode()
	local botAction   = npcBot:GetCurrentActionType()
	
	local bountyTopRadLoc = GetRuneSpawnLocation(RUNE_BOUNTY_1)
	local bountyBotRadLoc = GetRuneSpawnLocation(RUNE_BOUNTY_2)
	local bountyTopDirLoc = GetRuneSpawnLocation(RUNE_BOUNTY_3)
	local bountyBotDirLoc = GetRuneSpawnLocation(RUNE_BOUNTY_4)
	
	local bountyTopRadDist = GetUnitToLocationDistance(npcBot, bountyTopRadLoc)
	local bountyBotRadDist = GetUnitToLocationDistance(npcBot, bountyBotRadLoc)
	local bountyTopDirDist = GetUnitToLocationDistance(npcBot, bountyTopDirLoc)
	local bountyBotDirDist = GetUnitToLocationDistance(npcBot, bountyBotDirLoc)
	
	local enemies = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)
	local allies  = npcBot:GetNearbyHeroes(1600, true, BOT_MODE_NONE)

	-- USABLE ITEMS --------------------------------------------------------------------------------
	local clarity = nil
	local bottle  = nil
	local salve   = nil
	local tango   = nil
	local soul    = nil
	local boots   = nil
	local portal  = nil
	local arcane  = nil
	local cyclone = nil
	local midas   = nil
	local wand    = nil
	local glimmer = nil
	
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
	local bottleLoc  = npcBot:FindItemSlot("item_bottle")
	local midasLoc   = npcBot:FindItemSlot("item_hand_of_midas")
	local wandLoc    = npcBot:FindItemSlot("item_magic_wand")
	local glimmerLoc = npcBot:FindItemSlot("item_glimmer_cape")
	
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
	if npcBot:GetItemSlotType(midasLoc) == ITEM_SLOT_TYPE_MAIN then
		midas = npcBot:GetItemInSlot(midasLoc)
	end
	if npcBot:GetItemSlotType(wandLoc) == ITEM_SLOT_TYPE_MAIN then
		wand = npcBot:GetItemInSlot(wandLoc)
	end
	if npcBot:GetItemSlotType(glimmerLoc) == ITEM_SLOT_TYPE_MAIN then
		glimmer = npcBot:GetItemInSlot(glimmerLoc)
	end
	------------------------------------------------------------------------------------------------

	-- BOUNTY RUNE PICKUP --------------------------------------------------------------------------
	if bountyTopRadDist < 200 and bountyTopRadDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_1)
	elseif bountyBotRadDist < 200 and bountyBotRadDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_2)
	elseif bountyTopDirDist < 200 and bountyTopDirDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_3)
	elseif bountyBotDirDist < 200 and bountyBotDirDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_4)
	end
	------------------------------------------------------------------------------------------------
	
	-- HAND OF MIDAS Usage -------------------------------------------------------------------------
	if midas ~= nil then
		local midasTarget = _G.getMidasTarget(npcBot)
		
		if midas:IsCooldownReady() and not npcBot:IsChanneling() and botAction ~= BOT_ACTION_TYPE_USE_ABILITY then
			npcBot:Action_UseAbilityOnEntity(midas, midasTarget)
		end
	end
	------------------------------------------------------------------------------------------------
	
	-- GLIMMER CAPE Usage --------------------------------------------------------------------------
	if glimmer ~= nil then
		if table.getn(enemies) > 0 and table.getn(allies) > 0 then
			local allyToEnemyDist = GetUnitToUnitDistance(enemies[1], allies[1])
			
			if allyToEnemyDist < 1000 and botAction ~= BOT_ACTION_TYPE_USE_ABILITY and glimmer:IsFUllyCastable() then
				npcBot:Action_UseAbilityOnEntity(glimmer, allies[1])
			end
		elseif table.getn(enemies) > 0 and table.getn(allies) == 0 then
			local botToEnemyDist = GetUnitToUnitDistance(npcBot, enemies[1])
			
			if botToEnemyDist < 500 and botAction ~= BOT_ACTION_TYPE_USE_ABILITY and glimmer:IsFUllyCastable() then
				npcBot:Action_UseAbilityOnEntity(glimmer, allies[1])
			end
		end
	end
	------------------------------------------------------------------------------------------------
	
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
	
	if cyclone ~= nil and cyclone:IsCooldownReady() and currentMode == BOT_MODE_RETREAT then
		if table.getn(enemies) > 0 then
			npcBot:Action_UseAbilityOnEntity(cyclone, enemies[1])
		end
	end
	
	-- Mana Regen
	if botMana / botMaxMana < 0.5 and not npcBot:HasModifier("modifier_clarity_potion") and not npcBot:IsChanneling() and botAction ~= BOT_ACTION_TYPE_USE_ABILITY then
		if arcane ~= nil and arcane:IsCooldownReady() then
			print("    Using ARCANE BOOTS")
    		npcBot:Action_UseAbility(arcane)
		elseif (bottle == nil and clarity ~= nil) or (bottle ~= nil and bottle:GetCurrentCharges() == 0 and clarity ~= nil) or boots == nil then
    		npcBot:Action_UseAbilityOnEntity(clarity, npcBot)
    	elseif soul ~= nil and botHP/botMaxHP >= 0.4 and not npcBot:HasModifier("modifier_item_soul_ring") and not npcBot:HasModifier("modifier_item_soul_ring_buff") then
    		npcBot:Action_UseAbility(soul)
    	end
    end
    
    -- HP Regen
	if botHP/botMaxHP < 0.5 and not npcBot:IsChanneling() and botAction ~= BOT_ACTION_TYPE_USE_ABILITY then
		if salve ~= nil and not npcBot:HasModifier("modifier_flask_healing") then
			npcBot:Action_UseAbilityOnEntity(salve, npcBot)
		elseif bottle ~= nil and bottle:GetCurrentCharges() > 0 and npcBot:DistanceFromFountain() ~= 0 then
			npcBot:Action_UseAbility(bottle)
		elseif wand ~= nil and wand:GetCurrentCharges() > 3 then
			npcBot:Action_UseAbility(wand)
		elseif tango ~= nil and #nearbyTrees > 0 and not npcBot:HasModifier("modifier_tango_heal") then
			local nearbyTrees = npcBot:GetNearbyTrees(1600)
			npcBot:Action_UseAbilityOnTree(tango, nearbyTrees[1])
		end
	end

    -- Use Courier
	if courierLoc ~= nil then
		local courier = npcBot:GetItemInSlot(courierLoc)
		if courier ~= nil then
			npcBot:Action_UseAbility(courier)
		end
	end
end
