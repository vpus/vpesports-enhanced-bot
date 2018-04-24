require(GetScriptDirectory().."/UtilityData")
require(GetScriptDirectory().."/UtilityFunctions")

local npcBot     = GetBot()
local botTeam    = GetTeam()
local targetCamp = nil
local spawners = GetNeutralSpawners()
local finishedCamps = {}
function GetDesire()
	local gameTime = DotaTime()
	local botLevel = npcBot:GetLevel()
	local aghaSlot = npcBot:FindItemSlot("item_ultimate_scepter")
	
	if gameTime < 0 then
		return _G.desires[7]
	end
	if npcBot:GetItemSlotType(aghaSlot) == ITEM_SLOT_TYPE_MAIN then
		return _G.desires[1]
	end
	
	return _G.desires[1]
end

function Think()
	local gameTime     = DotaTime()
	local botLoc       = npcBot:GetLocation()
	local botAction    = npcBot:GetCurrentActionType()
	local botMana      = npcBot:GetMana()
	local botHealth    = npcBot:GetHealth()
	local botMaxHealth = npcBot:GetMaxHealth()
	local botMaxMana   = npcBot:GetMaxMana()
	local botHPRegen   = npcBot:GetHealthRegen()
	local botManaRegen = npcBot:GetManaRegen()
	local level        = npcBot:GetLevel()
	local currentGold  = npcBot:GetGold()
	local currentLane  = nil
	
    local spirit = npcBot:GetAbilityByName("lone_druid_spirit_bear")
    local rabid  = npcBot:GetAbilityByName("lone_druid_rabid")
    local roar   = npcBot:GetAbilityByName("lone_druid_savage_roar")
    local form   = npcBot:GetAbilityByName("lone_druid_true_form")
	
	if gameTime < 0 then
		local tower = GetTower(botTeam, TOWER_MID_1)
		if botAction ~= BOT_ACTION_TYPE_MOVE_TO then
			npcBot:Action_MoveToLocation(tower:GetLocation() + RandomVector(300))
			if npcBot.bear ~= nil and npcBot.bear:IsAlive() then
				npcBot.bear:Action_MoveToLocation(tower:GetLocation() + RandomVector(300))
			end
		end
		return
	end
	
	if targetCamp == nil then
		local gotCamp = false
		for s = 1, table.getn(spawners) do
			local spawner = spawners[s]
			
			if spawner["team"] == botTeam and ((level <= 3 and (spawner["type"] == "small" or spawner["type"] == "medium"))
			or (level < 6 and (spawner["type"] == "medium" or spawner["type"] == "large"))
			or (level >= 6 and (spawner["type"] == "medium" or spawner["type"] == "large" or spawner["type"] == "ancient"))) then
				local found = false
				for i = 1, table.getn(finishedCamps) do
					local finished = finishedCamps[i]
					
					if finished[1] == spawner["location"][1] and finished[2] == spawner["location"][2] then
						found = true
					end
				end
				
				if not found then
					targetCamp = Vector(spawner["location"][1], spawner["location"][2], 0)
					gotCamp = true
					break
				end
			end
		end
		
		-- Reset camps once they're all destroyed
		if not gotCamp then
			finishedCamps = {}
		end
	else
		local dist = GetUnitToLocationDistance(npcBot, targetCamp)
		
		if dist > 500 then
			if botAction ~= BOT_ACTION_TYPE_MOVE_TO then
    			npcBot:Action_MoveToLocation(targetCamp + RandomVector(100))
			end
			if npcBot.bear ~= nil and npcBot.bear:GetCurrentActionType() ~= BOT_ACTION_TYPE_MOVE_TO then
				npcBot.bear:Action_MoveToLocation(targetCamp + RandomVector(100))
			end
		else
			local neutrals    = npcBot:GetNearbyNeutralCreeps(500)
			local numNeutrals = table.getn(neutrals)
			
			if numNeutrals > 0 then
				local easiest = neutrals[1]
				
				for i = 2, numNeutrals do
					if neutrals[i]:GetHealth() < easiest:GetHealth() then
						easiest = neutrals[i]
					end
				end
				
				if botAction ~= BOT_ACTION_TYPE_ATTACK and botAction ~= BOT_ACTION_TYPE_USE_ABILITY then
					npcBot:Action_AttackUnit(easiest, true)
					
					if npcBot.bear ~= nil then
						if npcBot.bear:GetCurrentActionType() ~= BOT_ACTION_TYPE_ATTACK and npcBot.bear:GetCurrentActionType() ~= BOT_ACTION_TYPE_USE_ABILITY then
							npcBot.bear:Action_AttackUnit(easiest, true)
						end
					end
				end
			else
				table.insert(finishedCamps, targetCamp)
				targetCamp = nil
			end
		end
	end
end
