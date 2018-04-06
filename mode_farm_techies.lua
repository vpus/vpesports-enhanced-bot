require( GetScriptDirectory().."/UtilityData")
require( GetScriptDirectory().."/UtilityFunctions")

local mode_names = {
	[0] = "Early Mining",
	[1] = "Early Stacking",
	[2] = "Consider Camp",
	[3] = "Attack Camp"
}

local npcBot  = GetBot()
local botTeam = GetTeam()
local mode    = CONSIDER_CAMP

local doneProx           = false
local currentAction      = 0
local currentStackAction = 0
local radCamps = _G.radiant_camp_locs
local dirCamps = _G.dire_camp_locs

local closestCamp = nil
local spawnerLocs = {}

function OnStart()
	npcBot:Action_ClearActions(true)
end

function GetDesire()
	local gameTime = DotaTime()
	local botLevel = npcBot:GetLevel()

	if botLevel >= 10 then
		return _G.desires[5]
	else
		return _G.desires[2]
	end
end

-- Logic for all Farm mode behavior
--function Think()
--	-- Abilities
--	local ProximityMine = npcBot:GetAbilityByName("techies_land_mines")
--	local StasisTrap    = npcBot:GetAbilityByName("techies_stasis_trap")
--	local BlastOff      = npcBot:GetAbilityByName("techies_suicide")
--	local RemoteMine    = npcBot:GetAbilityByName("techies_remote_mines")
--
--	local gameTime  = DotaTime()
--	local queue     = npcBot:NumQueuedActions()
--	local action    = npcBot:GetCurrentActionType()
--
--	local botMana   = npcBot:GetMana()
--	local botHP     = npcBot:GetHealth()
--
--	if table.getn(spawnerLocs) < 18 then
--		local neutralSpawners = GetNeutralSpawners()
--		print(table.getn(neutralSpawners))
--    	for spawn = 1, table.getn(neutralSpawners) do
--    		print(neutralSpawners[spawn])
--    		print("    Description: " .. tostring(neutralSpawners[spawn][1]))
--    		print("    Vector: " .. tostring(neutralSpawners[spawn][2]))
--    	end
--	end
--
--	if botMana < 170 and botHP > 300 then
--		_G.useSoulRing(npcBot)
--	end
--
--	if math.floor(gameTime) % 120 == 0 then
--		-- Refresh camp spawns
--		for _, camp in pairs(radCamps) do
--			camp[5] = false
--		end
--		for _, camp in pairs(dirCamps) do
--			camp[5] = false
--		end
--	end
--
--	if mode == CONSIDER_CAMP then
--		-- Do regular farming
--		local level = npcBot:GetLevel()
--		closestCamp = getClosestCamp(level)
--		local dist  = _G.getDistanceBetweenTwoPoints(npcBot:GetLocation(), closestCamp[2]) -- <---------------------
--
--		if dist > 100 and npcBot:GetCurrentActionType() ~= _G.modes["move"] then
--			print("    MOVING to next camp: " .. closestCamp[1][1] .. "," .. closestCamp[1][2] .. " Distance: " .. dist)
--			npcBot:Action_MoveToLocation(closestCamp[2])
--		elseif dist <= 100 and closestCamp ~= nil then
--			mode = ATTACK_CAMP
--		end
--	elseif mode == ATTACK_CAMP then
--		local nearbyNeutrals = npcBot:GetNearbyNeutralCreeps(1000)
--		local dist           = _G.getDistanceBetweenTwoPoints(npcBot:GetLocation(), closestCamp[2])
--
--		if dist < 100 and #nearbyNeutrals == 0 then
--			setKilledCamp(closestCamp, botTeam)
--			print("    Closest Camp Killed? "..((closestCamp[5]) and "dead" or "still alive")..closestCamp[1][1]..","..closestCamp[1][2])
--			mode = CONSIDER_CAMP
--		elseif dist > 1000 then
--			mode = CONSIDER_CAMP
--		else
--			print("    STARTING attack sequence: "..((closestCamp[5]) and "dead" or "alive")..closestCamp[1][1]..","..closestCamp[1][2])
--			attackNeutralSequence(ProximityMine, closestCamp)
--		end
--	end
--end

-- This is the sequence of Techies attacking a neutral camp:
-- 1: if at camp location, plant a mine in front of camp
-- 2: attack a neutral once
-- 3: run away from camp a bit
-- 4: return to camp location
function attackNeutralSequence(ability, closestCamp)
	local botDistanceFromCamp = getDistanceBetweenTwoPoints(npcBot:GetLocation(), closestCamp[2])
	local nearbyNeutrals      = npcBot:GetNearbyNeutralCreeps(1000)
	local action   = npcBot:GetCurrentActionType()
	local botLoc   = npcBot:GetLocation()
	local queue    = npcBot:NumQueuedActions()
	local manaCost = ability:GetManaCost()
	local botMana  = npcBot:GetMana()
	
	if #nearbyNeutrals > 0 then 
		if currentAction == 0 and ability:IsFullyCastable() and queue == 0 then 
			if ability:IsFullyCastable() then 
				if botDistanceFromCamp < 200 then 
					print("    PROXIMITY mine at neutral camp")
					npcBot:Action_UseAbilityOnLocation(ability, closestCamp[2] + RandomVector(20))
				elseif action ~= _G.actions["move"] and action ~= _G.actions["attack_move"] then
					npcBot:ActionPush_MoveToLocation(closestCamp[2])
				end
			end
			currentAction = 1
		elseif currentAction == 1 and queue == 0 then
			print("    ATTACKING neutrals at camp")
			npcBot:ActionQueue_AttackUnit(nearbyNeutrals[1], true)
			currentAction = 2
		elseif currentAction == 2 and queue == 0 then
			print("    MOVING away to kite neutrals")
			npcBot:ActionQueue_MoveToLocation(closestCamp[4])
			currentAction = 3
		elseif currentAction == 3 and queue == 0 then
			print("    MOVING back to neutral camp")
			npcBot:ActionQueue_MoveToLocation(closestCamp[2])
			currentAction = 0
		end
	elseif botDistanceFromCamp > 200 and currentAction ~= 2 and currentAction ~= 3 and action ~= _G.actions["move"] and action ~= _G.actions["attack_move"] then
		npcBot:ActionPush_MoveToLocation(closestCamp[2])
	end
end

-- Set the given camp to killed
function setKilledCamp(resetCamp, team)
	if team == TEAM_RADIANT then
		for i, camp in pairs(radCamps) do
			if resetCamp[1] == camp[1] then
				camp[5] = true
			end
		end
	else
		for i, camp in pairs(dirCamps) do
			if resetCamp[1] == camp[1] then
				camp[5] = true
			end
		end
	end
end

-- Get the next nearest camp that hasn't been killed, appropriate to level
function getClosestCamp(level)
	local botLoc      = npcBot:GetLocation()
	local closestDist = 100000
	local closestCamp = nil

	if level <= 6 then
		-- attack easy and medium camps
		if botTeam == _G.teams[1] then
			if radCamps[1][5] then
				for _, camp in pairs(radCamps) do
					if not camp[5] then
						if camp[3] == 1 or camp[3] == 2 then
							local dist = getDistanceBetweenTwoPoints(botLoc, camp[1])
							if dist < closestDist then
								closestDist = dist
								closestCamp = camp
								print("DISTANCE FROM CAMP = "..dist)
							end
						end
					end
				end
				if closestCamp ~= nil then
					print("CLOSEST CAMP CHOSEN = "..closestCamp[1][1]..","..closestCamp[1][2])
				else
					print("ALL CAMPS ARE DESTROYED!!!!!!!!")
				end
			else
				closestCamp = radCamps[1]
			end
			return closestCamp
		else
			for _, camp in pairs(dirCamps) do
				if not camp[5] then
					if camp[3] == 1 or camp[3] == 2 then
						local dist = getDistanceBetweenTwoPoints(botLoc, camp[1])
						if dist < closestDist then
							closestDist = dist
							closestCamp = camp
						end
					end
				end
			end
			return closestCamp
		end
	elseif level > 6 then
		-- attack medium, hard and ancient
		if botTeam == _G.teams[1] then
			for _, camp in pairs(radCamps) do
				if not camp[5] then
					if camp[3] == 2 or camp[3] == 3 then
						local dist = getDistanceBetweenTwoPoints(botLoc, camp[1])
						if dist < closestDist then
							closestDist = dist
							closestCamp = camp
							print("DISTANCE FROM CAMP = "..dist)
						end
					end
				end
				if closestCamp ~= nil then
					print("CLOSEST CAMP CHOSEN = "..closestCamp[1][1]..","..closestCamp[1][2])
				else
					print("ALL CAMPS ARE DESTROYED!!!!!!!!")
				end
			end
			return closestCamp
		else
			for _, camp in pairs(dirCamps) do
				if not camp[5] then
					if camp[3] == 2 or camp[3] == 3 then
						local dist = getDistanceBetweenTwoPoints(botLoc, camp[1])
						if dist < closestDist then
							closestDist = dist
							closestCamp = camp
						end
					end
				end
			end
			return closestCamp
		end
	end
end

function minePlaced(vecLoc)
	local unitList = GetUnitList(UNIT_LIST_ALLIES)
	for unit = 1, table.getn(unitList) do
		local mine = unitList[unit] 
		if mine:GetUnitName() == "npc_dota_techies_land_mine" then
			if mine:GetLocation()[1] == vecLoc[1] and mine:GetLocation()[2] == vecLoc[2] then
				return true
			end
		end
	end
	return false
end
