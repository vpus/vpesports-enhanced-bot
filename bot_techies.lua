require(GetScriptDirectory().."/UtilityData");
require(GetScriptDirectory().."/UtilityFunctions");

local npcBot  = GetBot();
local botTeam = GetTeam();

-- Keep a reference to each mine
local remoteMines = {};
local proxMines   = {};

npcBot.canAttackTower = true

-- Detonate only enough Remote Mines to kill an enemy player and no more
function MinionThink(hMinionUnit)
	if hMinionUnit ~= nil then
		local unitName = hMinionUnit:GetUnitName();
		if unitName == "npc_dota_techies_remote_mine" then
			local remoteDetonate = hMinionUnit:GetAbilityByName("techies_remote_mines_self_detonate");
			local remoteLevel    = npcBot:GetAbilityByName("techies_remote_mines"):GetLevel();
			local nRadius        = remoteDetonate:GetSpecialValueInt("radius");
			local numHeroes      = 0;
			local nearbyHeroes   = hMinionUnit:GetNearbyHeroes(nRadius, true, BOT_MODE_NONE);
			local nearbyCreeps   = hMinionUnit:GetNearbyCreeps(nRadius, true);
			
			remoteMines = _G.getAllUnitsByName("npc_dota_techies_remote_mine", UNIT_LIST_ALLIES);

			-- Get all nearby enemies
			if table.getn(nearbyHeroes) then
    			for _, hero in pairs(nearbyHeroes) do
    				if hero:IsHero() then
    					hMinionUnit:SetTarget(hero)
    					local minesDetonated = detonateMines(remoteLevel, hero, remoteDetonate, npcBot);
    					numHeroes = numHeroes + 1;
    				end
    			end
			elseif table.getn(nearbyCreeps) > 3 then
				local nearbyMines = {}
				for m = 1, table.getn(remoteMines) do
					local mine = remoteMines[m]
					local creep = nearbyCreeps[1]
					local dist = GetUnitToUnitDistance(mine, creep)
					
					if dist < nRadius then
						table.insert(nearbyMines, mine)
					end
				end
				
				nearbyMines[1]:Action_UseAbility(remoteDetonate)
			end
		elseif unitName == "npc_dota_techies_land_mine" then
			proxMines = _G.getAllUnitsByName("npc_dota_techies_land_mine", UNIT_LIST_ALLIES);
		end
	end
	-- Add to total proximity and remote mines currently active
	_G.total_prox    = #proxMines;
	_G.total_remotes = #remoteMines;
end

function minesToKillEnemy(remoteLevel, enemyBot, bot)
	local health      = enemyBot:GetHealth();
	local mineDmg     = 0;
	local modifier    = 0;
	local enemyResist = enemyBot:GetMagicResist(); -- this is a percentage
	-- print("Enemy Resistance:", enemyResist);
	if bot:HasModifier("modifier_item_ultimate_scepter") or
	   bot:HasModifier("modifier_item_ultimate_scepter_consumed") then
		modifier = 150;
	end
	if remoteLevel == 1 then
		mineDmg = 300 + modifier;
	elseif remoteLevel == 2 then
		mineDmg = 450 + modifier;
	else
		mineDmg = 750 + modifier;
	end
	mineDmg = mineDmg - (mineDmg * enemyResist);
	local numMines  = health/mineDmg;

	-- print("Number of MINES to kill enemy:", health, mineDmg, number, remoteLevel, math.ceil(number))

	return math.ceil(numMines);
end

-- See if mines have been detonated, then remove them
-- Also check if the enemy is someone else and update
function analyzeMines(enemyBot)
	for i, mine in pairs(remoteMines) do
		if mine:IsNull() then
			table.remove(remoteMines, i)
			-- print("mine removed, already dead");
		else
			local target = mine:GetTarget()
			if target ~= enemyBot then
				-- print("Target has moved out of range... removing target from mine")
				enemyBot:SetTarget(nil)
			end	
		end
	end
end

-- Analyze all mines with the same target and detonate enough
-- mines to kill the enemy, and no more
function detonateMines(remoteLevel, enemyBot, ability, bot)
	analyzeMines(enemyBot)
	local numMines       = minesToKillEnemy(remoteLevel, enemyBot, bot)
	local minesDetonated = 0
	local totalMines     = 0
	for _, mine in pairs(remoteMines) do
		if mine:GetTarget() == enemyBot then
			totalMines = totalMines + 1
		end
	end
	if totalMines >= numMines then
		for _, mine in pairs(remoteMines) do
			local target = mine:GetTarget()

			if target == enemyBot then
				mine:Action_UseAbility(ability)
				minesDetonated = minesDetonated + 1

				if minesDetonated == numMines then
					return minesDetonated
				end
			end
		end
	end
end

function printAllCreepAttackers(creepList)
	if creepList ~= nil then
		for _, creep in pairs(creepList) do
			if creep ~= nil then
				for _, creepTable in pairs(creep) do
					if creepTable ~= nil then
						for i, creepData in ipairs(creepTable) do
							if i == 0 then
								print("allied creep:", creepData:GetUnitName())
							else
								print("    attacker", creepData:GetUnitName())
							end
						end
						print(" ")
					end
				end
			end
		end
	else
		print("No Attackers")
	end
end
