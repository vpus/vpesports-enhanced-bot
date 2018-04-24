local pickTime=GameTime();
local randomTime=0;

carry_heroes = {
	"npc_dota_hero_antimage",
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_morphling",
	"npc_dota_hero_phantom_lancer",
	"npc_dota_hero_sven",
	"npc_dota_hero_skeleton_king",
	"npc_dota_hero_luna",
	"npc_dota_hero_life_stealer",
	"npc_dota_hero_clinkz",
	"npc_dota_hero_weaver",
	"npc_dota_hero_spectre",
	"npc_dota_hero_ursa",
	"npc_dota_hero_gyrocopter",
	"npc_dota_hero_lycan",
	"npc_dota_hero_lone_druid",
	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_naga_siren",
	"npc_dota_hero_slark",
	"npc_dota_hero_troll_warlord",
	"npc_dota_hero_terrorblade",
	"npc_dota_hero_arc_warden",
	"npc_dota_hero_monkey_king",
}
mid_heroes = {
"npc_dota_hero_bloodseeker",
"npc_dota_hero_mirana",
"npc_dota_hero_nevermore",
"npc_dota_hero_razor",
"npc_dota_hero_storm_spirit",
"npc_dota_hero_windrunner",
"npc_dota_hero_zuus",
"npc_dota_hero_kunkka",
"npc_dota_hero_lina",
"npc_dota_hero_tinker",
"npc_dota_hero_sniper",
"npc_dota_hero_necrolyte",
"npc_dota_hero_queenofpain",
"npc_dota_hero_venomancer",
"npc_dota_hero_death_prophet",
"npc_dota_hero_phantom_assassin",
"npc_dota_hero_pugna",
"npc_dota_hero_templar_assassin",
"npc_dota_hero_viper",
"npc_dota_hero_dragon_knight",
"npc_dota_hero_leshrac",
"npc_dota_hero_huskar",
"npc_dota_hero_broodmother",
"npc_dota_hero_alchemist",
"npc_dota_hero_invoker",
"npc_dota_hero_silencer",
"npc_dota_hero_obsidian_destroyer",
"npc_dota_hero_meepo",
"npc_dota_hero_visage",
"npc_dota_hero_medusa",
"npc_dota_hero_ember_spirit",
}
off_heroes = {
	"npc_dota_hero_axe",
	"npc_dota_hero_puck",
	"npc_dota_hero_tiny",
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_enigma",
	"npc_dota_hero_beastmaster",
	"npc_dota_hero_faceless_void",
	"npc_dota_hero_rattletrap",
	"npc_dota_hero_dark_seer",
	"npc_dota_hero_omniknight",
	"npc_dota_hero_enchantress",
	"npc_dota_hero_batrider",
	"npc_dota_hero_doom_bringer",
	"npc_dota_hero_brewmaster",
	"npc_dota_hero_centaur",
	"npc_dota_hero_magnataur",
	"npc_dota_hero_shredder",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_abaddon",
	"npc_dota_hero_legion_commander",
	"npc_dota_hero_abyssal_underlord",
	"npc_dota_hero_pangolier",
}
support_heroes = {
	"npc_dota_hero_bane",
"npc_dota_hero_crystal_maiden",
"npc_dota_hero_earthshaker",
"npc_dota_hero_pudge",
"npc_dota_hero_sand_king",
"npc_dota_hero_vengefulspirit",
"npc_dota_hero_lich",
"npc_dota_hero_lion",
"npc_dota_hero_shadow_shaman",
"npc_dota_hero_slardar",
"npc_dota_hero_witch_doctor",
"npc_dota_hero_riki",
"npc_dota_hero_warlock",
"npc_dota_hero_dazzle",
"npc_dota_hero_furion",
"npc_dota_hero_night_stalker",
"npc_dota_hero_bounty_hunter",
"npc_dota_hero_jakiro",
"npc_dota_hero_chen",
"npc_dota_hero_ancient_apparition",
"npc_dota_hero_spirit_breaker",
"npc_dota_hero_shadow_demon",
"npc_dota_hero_treant",
"npc_dota_hero_ogre_magi",
"npc_dota_hero_undying",
"npc_dota_hero_rubick",
"npc_dota_hero_disruptor",
"npc_dota_hero_nyx_assassin",
"npc_dota_hero_keeper_of_the_light",
"npc_dota_hero_wisp",
"npc_dota_hero_tusk",
"npc_dota_hero_skywrath_mage",
"npc_dota_hero_elder_titan",
"npc_dota_hero_earth_spirit",
"npc_dota_hero_phoenix",
"npc_dota_hero_oracle",
"npc_dota_hero_techies",
"npc_dota_hero_winter_wyvern",
"npc_dota_hero_dark_willow",
}
carry_pool = {
	"npc_dota_hero_drow_ranger",
	"npc_dota_hero_chaos_knight",
	"npc_dota_hero_juggernaut",
	"npc_dota_hero_phantom_assassin",
	"npc_dota_hero_luna",
	"npc_dota_hero_lone_druid",
}
mid_pool = {
	"npc_dota_hero_luna",
	"npc_dota_hero_tinker",
	"npc_dota_hero_medusa",
	"npc_dota_hero_huskar",
	"npc_dota_hero_viper",
	"npc_dota_hero_death_prophet",
	"npc_dota_hero_dragon_knight",
	"npc_dota_hero_sniper",
}
off_pool = {
	"npc_dota_hero_tidehunter",
	"npc_dota_hero_bristleback",
	"npc_dota_hero_beastmaster",
	"npc_dota_hero_omniknight",
	-- "npc_dota_hero_tiny",
	"npc_dota_hero_underlord",
	"npc_dota_hero_abaddon"
}
support_pool = {
	"npc_dota_hero_jakiro",
	"npc_dota_hero_witch_doctor",
	"npc_dota_hero_vengefulspirit",
	"npc_dota_hero_keeper_of_the_light",
	"npc_dota_hero_bane",
	"npc_dota_hero_crystal_maiden",
	"npc_dota_hero_lich",
	"npc_dota_hero_lion",
	"npc_dota_hero_techies",
}
-- This is the pool of heros from which to choose bots for each position
hero_pool_position={
    [1] = carry_pool,
    [2] = mid_pool,
    [3] = off_pool,
    [4] = support_pool,
}
heroes_positions = {
	[1] = carry_heroes,
	[2] = mid_heroes,
	[3] = off_heroes,
	[4] = support_heroes,
}
function Think()
	local team = GetTeam()
	if(GameTime()<45 and AreHumanPlayersReady(team)==false or GameTime()<25)
	then
		return
	end

	local picks = GetPicks()
	local selectedHeroes = {};
    for slot, hero in pairs(picks) do
        selectedHeroes[hero] = true;
    end

	for i,id in pairs(GetTeamPlayers(team)) do
		if(IsPlayerInHeroSelectionControl(id) and IsPlayerBot(id) and (GetSelectedHeroName(id)=="" or GetSelectedHeroName(id)==nil))
		then
			while (GameTime()-pickTime)<2 do
				return
			end
			pickTime=GameTime();
			
			local temphero = GetPositionedHero(team, selectedHeroes);
			SelectHero(id, temphero);
		end
	end
end

function UpdateLaneAssignments()    
	local gamestate = GetGameState()
	if(gamestate==GAME_STATE_HERO_SELECTION or gamestate==GAME_STATE_STRATEGY_TIME or gamestate==GAME_STATE_TEAM_SHOWCASE or gamestate==GAME_STATE_WAIT_FOR_MAP_TO_LOAD or gamestate==GAME_STATE_WAIT_FOR_PLAYERS_TO_LOAD)
	then
		return;
	end

	local lineup = {}
	dual_off = false
	aggro_tri = false
	for id=1,5 do
		local hero = GetTeamMember(id);
		if (hero == nil) then
			break
		end
		local heroName = hero:GetUnitName();
		-- print(heroName)
		table.insert(lineup,heroName)
		-- print(#lineup)
	end

	-- print(#lineup)

	local support_heroes = {}
	for hero in pairs(lineup) do
		if GetHeroPosition(hero) == 1 then
			local carry_hero = hero
		elseif GetHeroPosition(hero) == 2 then
			local mid_hero = hero
		elseif GetHeroPosition(hero) == 3 then
			local off_hero = hero
		else
			table.insert(support_heroes, hero)
		end
	end

	-- dual off check --
	if ListContains(lineup, "npc_dota_hero_keeper_of_the_light") then
		if (
			ListContains(lineup, "npc_dota_hero_beastmaster") or 
			ListContains(lineup, "npc_dota_hero_bristleback") or
			ListContains(lineup, "npc_dota_hero_omniknight") or
			ListContains(lineup, "npc_dota_hero_tiny")
		) then
			dual_off = true
		end
	end

	-- aggro tri check --
	if (
		carry_hero == "npc_dota_hero_chaos_knight" or
		carry_hero == "npc_dota_hero_phantom_assassin" or
		carry_hero == "npc_dota_hero_juggernaut"
	) then
		aggro_tri = true
	end

	local laneTable = GetLanesTable(dual_off, aggro_tri)
	-- print(laneTable)
	local lanes = {1,2,3,1,1}

	for id=1,5 do
		local hero = GetTeamMember(id)
		if (hero == nil) then
			break
		end
		local hero_name = hero:GetUnitName()
		local position = GetHeroPosition(hero_name)
		if position == 4 and dual_off and hero_name ~= "npc_dota_hero_keeper_of_the_light" then
			position = position + 1
		end
		lanes[id] = laneTable[position]
		-- print("id", id, "position", position, laneTable[position])
	end

	if(DotaTime()<-15)
	then
		-- print(DotaTime())
		return lanes
	end

	local safeLane = GetSafeLane()
	local offLane = GetOffLane()

	if dual_off then
		local lanecount = {
			[LANE_NONE] = 5,
			[LANE_MID] = 1,
			[offLane] = 2,
			[safeLane] = 2,
		};
	elseif aggro_tri then
		local lanecount = {
			[LANE_NONE] = 5,
			[LANE_MID] = 1,
			[offLane] = 2,
			[safeLane] = 2,
		};
	else
		local lanecount = {
			[LANE_NONE] = 5,
			[LANE_MID] = 1,
			[offLane] = 1,
			[safeLane] = 3,
		};
	end
		
	--adjust the lane assignement when player occupied the other lane.
	--TODO: Assign lane at Team level not hero level.
    local playercount = 0
	local ids = GetTeamPlayers(GetTeam())
	for i,v in pairs(ids) do
		if not IsPlayerBot(v) then
			playercount = playercount + 1
		end
	end
	if(playercount>0)
	then
		for i=1,playercount do
			local lane = GetLane( GetTeam(),GetTeamMember( i ) )
			lanecount[lane] = lanecount[lane] - 1
			lanes[i] = lane 
		end
		
		for i=(playercount + 1), 5 do
			local hero = GetTeamMember(i);
			local heroName = hero:GetUnitName();
			local position = GetHeroPosition(heroName);
			local laneTable = GetLanesTable();
			local bestLane = laneTable[position];
			local positionAssaignedLanes = GetPositionAssaignedLanes();
			--try to assign the most suitable lane, if can't try other lane.
			if lanecount[bestLane] > 0 then
				lanes[i] = bestLane
				lanecount[bestLane] = lanecount[bestLane] - 1
			elseif lanecount[offLane] > 0 then
				lanes[i] = offLane
				lanecount[offLane] = lanecount[offLane] - 1
			elseif lanecount[safeLane] > 0 then
				lanes[i] = safeLane
				lanecount[safeLane] = lanecount[safeLane] - 1
			elseif lanecount[LANE_MID] > 0 then
				lanes[i] = LANE_MID
				lanecount[LANE_MID] = lanecount[LANE_MID] - 1
			end
		end
	end
    return lanes

end

--index:id,value:lane Get normal lane assaignment.
function GetAssaignedLanes()

	local laneTable = GetLanesTable();
	local lanes = {1,1,2,3,3};

	for id=1,5 do
		local hero = GetTeamMember(id);
		if(hero == nil)
		then
			break;
		end
		local heroName = hero:GetUnitName();
		local position = GetHeroPosition(heroName);
		lanes[id] = laneTable[position];
	end
	return lanes;
end

function GetPicks()
	local selectedHeroes = {}
	for i=0,20 do
		if (IsTeamPlayer(i)==true) then
			local hName = GetSelectedHeroName(i)
			if (hName ~= "") then
				table.insert(selectedHeroes,hName)
			end
		end
    end
    return selectedHeroes;
end

-- Returns a Hero that fills a position that current team does not have filled.
function GetPositionedHero(team, selectedHeroes)
	--Fill positions in random order
    local positionCounts = GetPositionCounts( team );
	local position
	local continue = true
	while continue do
		-- print("start looping")
		position=RandomInt(1,4)
		if positionCounts[position] == 0 or (position == 4 and positionCounts[position] == 1) then
			continue = false
		end
	end
	-- print("End looping", position)

	return GetRandomHero( hero_pool_position[position], selectedHeroes );
end

-- Returns a random hero from the supplied heroPool that is not in the selectedHeroes list.
-- Note: this function will enter an infinite loop if all heros in the pool have been selected.
function GetRandomHero(heroPool, selectedHeroes)
	local hero;
	repeat
		hero = heroPool[RandomInt(1, #heroPool)]
	until( selectedHeroes[hero] ~= true )
    return hero
end

-- For the given team, returns a table that gives the counts of heros in each position.
function GetPositionCounts( team )
    local counts = { [1]=0, [2]=0, [3]=0, [4]=0 };
    local playerIds=GetTeamPlayers(team);

    for i,id in ipairs(playerIds) do
		local heroName = GetSelectedHeroName(id)
		-- print(heroName)
        if (heroName ~="") then
            for position=1,4,1 do
                if ListContains( hero_pool_position[position], heroName ) then
                    counts[position] = counts[position] + 1;
                end
            end
        end
    end

    return counts
end

-- A utilitiy function that returns true if the passed list contains the passed value.
function ListContains( list, value )
    if list == nil then return false end
    for i,v in ipairs(list) do
        if v == value then
            return true
        end
    end
    return false
end

-- Returns true if, for the specified team, all the Human players have picked a hero.
function AreHumanPlayersReady(team)
	local number,playernumber=0,0
	local IDs=GetTeamPlayers(team);
	for i,id in pairs(IDs)
	do
        if(IsPlayerBot(id)==false)
		then
			local hName = GetSelectedHeroName(id)
			playernumber=playernumber+1
			if (hName ~="")
			then
				number=number+1
			end
		end
    end
	
	if(number>=playernumber)
	then
		return true
	else
		return false
	end
	
end

function GetSafeLane()
	if GetTeam() == TEAM_RADIANT
	then
		return LANE_BOT;
	else
		return LANE_TOP;
	end
end

function GetOffLane()
	if GetTeam() == TEAM_RADIANT
	then
		return LANE_TOP;
	else
		return LANE_BOT;
	end
end

-- Return hero's position
function GetHeroPosition( heroName )
	if (heroName ~="") then
		for p=1,4,1 do
			if( ListContains( heroes_positions[p], heroName )) then
				return p;
			end
		end
	end
	return -1;
end

--index:position,value:lane.
function GetLanesTable(dual_off, aggro_tri)
	local safeLane=GetSafeLane();
	local offLane=GetOffLane();

	if dual_off then
		local laneTable ={
			[1] = safeLane,
			[2] = LANE_MID,
			[3] = offLane,
			[4] = offLane,
			[5] = safeLane
		}
		return laneTable;
	elseif aggro_tri then
		local laneTable ={
			[1] = offLane,
			[2] = LANE_MID,
			[3] = safeLane,
			[4] = offLane,
			[5] = offLane
		}
		return laneTable;
	else
		local laneTable ={
			[1] = safeLane,
			[2] = LANE_MID,
			[3] = offLane,
			[4] = safeLane,
			[5] = safeLane
		}
		return laneTable;
	end
end