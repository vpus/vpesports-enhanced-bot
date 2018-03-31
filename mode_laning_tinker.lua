require(GetScriptDirectory().."/UtilityData");
require(GetScriptDirectory().."/UtilityFunctions");

local npcBot  = GetBot();
local botTeam = GetTeam();
local botLocArray = {};

function GetDesire()
	local gameTime     = DotaTime()
	local mode       = npcBot:GetActiveMode();
	local modeDesire = npcBot:GetActiveModeDesire();
	local bootsSlot  = npcBot:FindItemSlot("item_travel_boots")
	
	if npcBot:GetItemSlotType(bootsSlot) == ITEM_SLOT_TYPE_MAIN then
		return _G.desires[0]
	end
--	print(gameTime)
	return _G.desires[5];
end
