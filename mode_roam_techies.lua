require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot      = GetBot()
local botTeam     = GetTeam()
local mineCounter = 1
local targetSet   = false

function OnStart()
	npcBot.other_mode = BOT_MODE_ROAM
	npcBot:Action_ClearActions(true)
end

function OnEnd()
	mineCounter = 1
end

function GetDesire()
	local botLevel = npcBot:GetLevel()
	local time     = DotaTime()
	
	if time < 0 or botLevel >= 6 then
		return _G.desires[6]
	else
		return _G.desires[0]
	end
end

function Think()
	-- Abilities
	local ProximityMine = npcBot:GetAbilityByName("techies_land_mines")
	local StasisTrap    = npcBot:GetAbilityByName("techies_stasis_trap")
	local BlastOff      = npcBot:GetAbilityByName("techies_suicide")
	local RemoteMine    = npcBot:GetAbilityByName("techies_remote_mines")

	local queue     = npcBot:NumQueuedActions()
	local action    = npcBot:GetCurrentActionType()
	local enemyTeam = (botTeam == TEAM_RADIANT) and TEAM_DIRE or TEAM_RADIANT
	local time      = DotaTime()
	
	local enemyTowersTop = getAllTowersInLane(LANE_TOP, enemyTeam)
	local enemyTowersMid = getAllTowersInLane(LANE_MID, enemyTeam)
	local enemyTowersBot = getAllTowersInLane(LANE_BOT, enemyTeam)

	local allyTowersTop = getAllTowersInLane(LANE_TOP, botTeam)
	local allyTowersMid = getAllTowersInLane(LANE_MID, botTeam)
	local allyTowersBot = getAllTowersInLane(LANE_BOT, botTeam)

	local remoteLocSet = {}
	
	if time < 0 then
		local tower = GetTower(TEAM_RADIANT, TOWER_TOP_1)
		
		if action ~= BOT_ACTION_TYPE_MOVE_TO and action ~= BOT_ACTION_TYPE_USE_ABILITY  then
			npcBot:Action_MoveToLocation(tower:GetLocation())
		end
	end
	
	if action ~= BOT_ACTION_TYPE_USE_ABILITY and action ~= BOT_ACTION_TYPE_MOVE_TO then
		-- If all allied towers are destroyed, only plant around base
		if #allyTowersTop == 0 and #allyTowersMid == 0 and #allyTowersBot == 0 then
			remoteLocSet = _G.rad_base_remote_locs
		
		-- If all enemy towers are destroyed, only plant around enemy base
		elseif #enemyTowersTop == 0 and #enemyTowersMid == 0 and #enemyTowersBot == 0 then
			remoteLocSet = _G.dir_base_remote_locs_attack
		-- If all allied towers in a lane are destroyed, alternate between roaming
		-- and planting around allied base
		else
			if #allyTowersTop == 0 then
    			local tempSet = TableConcat(_G.rad_base_remote_locs, _G.rad_late_remote_locs)
    			remoteLocSet = TableConcat(remoteLocSet, tempSet)
    		end
    		
    		if #allyTowersMid == 0 then
    			local tempSet = TableConcat(_G.rad_base_remote_locs, _G.rad_late_remote_locs)
    			remoteLocSet = TableConcat(remoteLocSet, tempSet)
    		end
    		
    		if #allyTowersBot == 0 then
    			local tempSet = TableConcat(_G.rad_base_remote_locs, _G.rad_late_remote_locs)
    			remoteLocSet = TableConcat(remoteLocSet, tempSet)
    		end
    		
    		-- If all enemy towers in a lane are destroyed, alternate between roaming
    		-- and planting around enemy base
    		if #enemyTowersTop == 0 then
    			local tempSet = TableConcat(_G.rad_base_remote_locs, _G.rad_late_remote_locs)
    			remoteLocSet = TableConcat(remoteLocSet, tempSet)
    		end
    		
    		if #enemyTowersMid == 0 then
    			local tempSet = TableConcat(_G.rad_base_remote_locs, _G.rad_late_remote_locs)
    			remoteLocSet = TableConcat(remoteLocSet, tempSet)
    		end
    		
    		if #enemyTowersBot == 0 then
    			local tempSet = TableConcat(_G.rad_base_remote_locs, _G.rad_late_remote_locs)
    			remoteLocSet = TableConcat(remoteLocSet, tempSet)
    		end
    			
    		if #enemyTowersBot > 0 and #enemyTowersMid > 0 and #enemyTowersMid > 0 and #allyTowersTop > 0 and #allyTowersMid > 0 and #allyTowersBot > 0 then
    			remoteLocSet = TableConcat(_G.rad_early_remote_locs, _G.dir_early_remote_locs) 
    		end
    	end

		-- Set the appropriate remote mine
		if #remoteLocSet > 0 then
			if mineCounter >= table.getn(remoteLocSet) then
				mineCounter = 1
			end
			if RemoteMine:IsFullyCastable() and action ~= _G.actions["use_ability"] then
				if mineCounter >= table.getn(remoteLocSet) then
					mineCounter = 1
				end
				print("    MINE COUNTER: " .. tostring(mineCounter))
				local remoteLoc = remoteLocSet[mineCounter]
				npcBot:Action_UseAbilityOnLocation(RemoteMine, remoteLoc)
				mineCounter = mineCounter + 1
			elseif GetUnitToLocationDistance(npcBot, remoteLocSet[mineCounter]) > 1000 and action ~= BOT_ACTION_TYPE_MOVE_TO then
				npcBot:Action_MoveToLocation(remoteLocSet[mineCounter] + RandomVector(100))
			end
		end
	end
end


function TableConcat(t1,t2)
    for i=1,#t2 do
        t1[#t1+1] = t2[i]
    end
    return t1
end