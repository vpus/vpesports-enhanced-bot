require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()
local botLocArray = {}

function GetDesire()
	local gameTime   = DotaTime()
	local mode       = npcBot:GetActiveMode()
	local modeDesire = npcBot:GetActiveModeDesire()
	local aghaSlot   = npcBot:FindItemSlot("item_ultimate_scepter")
	
	if npcBot:GetItemSlotType(aghaSlot) == ITEM_SLOT_TYPE_MAIN then
		return _G.desires[1]
	end
--	print(gameTime)
	return _G.desires[6]
end
