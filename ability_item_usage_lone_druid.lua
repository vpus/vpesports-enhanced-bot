local build = require(GetScriptDirectory().."/item_build_lone_druid")
require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()

local spirit = npcBot:GetAbilityByName("lone_druid_spirit_bear")
local rabid  = npcBot:GetAbilityByName("lone_druid_rabid")
local roar   = npcBot:GetAbilityByName("lone_druid_savage_roar")
local form   = npcBot:GetAbilityByName("lone_druid_true_form")

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
	local allyList = GetUnitList(UNIT_LIST_ALLIES)

	-- Recast bear if he's dead
	if (npcBot.bear == nil or not npcBot.bear:IsAlive()) and spirit:IsFullyCastable() then
		npcBot:Action_UseAbility(spirit)
	elseif npcBot.bear ~= nil and npcBot.bear:IsAlive() then
		local aghaSlot = npcBot:FindItemSlot("item_ultimate_scepter")
		local bearDist = GetUnitToUnitDistance(npcBot, npcBot.bear)
		local bearAction = npcBot.bear:GetCurrentActionType()
		
		if npcBot:GetItemSlotType(aghaSlot) ~= ITEM_SLOT_TYPE_MAIN and bearDist > 1000 and bearAction ~= BOT_ACTION_TYPE_USE_ABILITY then
			npcBot.bear:Action_UseAbility(npcBot.bear.tele)
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
	
	local nearbyTrees = npcBot:GetNearbyTrees(1600)
	
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
	local midas   = nil
	
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
	
	if bountyTopRadDist < 200 and bountyTopRadDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_1)
	elseif bountyBotRadDist < 200 and bountyBotRadDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_2)
	elseif bountyTopDirDist < 200 and bountyTopDirDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_3)
	elseif bountyBotDirDist < 200 and bountyBotDirDist ~= 0 then
		npcBot:Action_PickUpRune(RUNE_BOUNTY_4)
	end
	
	if midas ~= nil then
		local midasTarget = _G.getMidasTarget(npcBot)
		
		if midas:IsCooldownReady() and not npcBot:IsChanneling() and botAction ~= BOT_ACTION_TYPE_USE_ABILITY then
			npcBot:Action_UseAbilityOnEntity(midas, midasTarget)
		end
	end
	
	if roar ~= nil and roar:IsFullyCastable() and botAction ~= BOT_ACTION_TYPE_USE_ABILITY then
		local nearbyEnemies = npcBot:GetNearbyHeroes(350, true, BOT_MODE_NONE)
		
		if table.getn(nearbyEnemies) > 0 then
			npcBot:Action_UseAbility(roar)
		end
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
	
	if cyclone ~= nil and cyclone:IsCooldownReady() and currentMode == BOT_MODE_RETREAT then
		if table.getn(enemies) > 0 then
			npcBot:Action_UseAbilityOnEntity(cyclone, enemies[1])
		end
	end

	if botMana < spirit:GetManaCost() and not npcBot:HasModifier("modifier_clarity_potion") and not npcBot:IsChanneling() then
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
end
