require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()
local botLocArray = {}

function OnStart()
	npcBot:Action_ClearActions(true)
end

function GetDesire()
    local botLevel = npcBot:GetLevel();

	if botLevel < 6 then
		return _G.desires[5]
	else
		return _G.desires[0]
	end
end

-- Logic for all Laning Mode behavior
--function Think()
--	local botLoc        = npcBot:GetLocation()
--	local trees         = npcBot:GetNearbyTrees(1000)
--	local creeps        = npcBot:GetNearbyCreeps(1000, true)
--	local enemies       = npcBot:GetNearbyHeroes(1000, true, BOT_MODE_NONE)
--	local queue         = npcBot:NumQueuedActions()
--	local lane          = _G.getTeamObject(botTeam, LANE_TOP, LANE_BOTTOM)
--	local laneFront     = GetLaneFrontLocation(botTeam, lane, -700)
--	local distFromFront = _G.getDistanceBetweenTwoPoints(botLoc, laneFront)
--	local action        = npcBot:GetCurrentActionType()
--
--	if distFromFront < 200 and action ~= BOT_ACTION_TYPE_USE_ABILITY 
--	and #creeps > 0 and action ~= BOT_ACTION_TYPE_ATTACK then
--		npcBot:Action_AttackUnit(creeps[1], true)
--	else
--		npcBot:Action_MoveToLocation(laneFront + RandomVector(50))
--	end
--end
