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
