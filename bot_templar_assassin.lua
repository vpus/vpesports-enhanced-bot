require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot  = GetBot()
local botTeam = GetTeam()
npcBot.traps = {}
npcBot.max_traps = 5
npcBot.attacking = false

function MinionThink(trap)
	local trigger = trap:GetAbilityByName("templar_assassin_trap")
	local trap    = trap:GetUnitName();
	if trap == "npc_dota_templar_assassin_psionic_trap" then
		addTrap(trap) -- Add trap to list if it isn't already
		
		local nearbyEnemies = trap:GetNearbyHeroes(380, true, BOT_MODE_NONE)
		
		if table.getn(nearbyEnemies) > 0 then
			trap:Action_UseAbility(trigger)
		end
	end
end

function addTrap(trap)
	for i, v in ipairs(npcBot.traps) do
		if v == trap then
			return
		end
	end
	
	table.insert(npcBot.traps, trap)
end