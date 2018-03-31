function Think()
	
	gs = GetGameState()
	if ( gs == GAME_STATE_HERO_SELECTION ) then
		gameMode = GetGameMode()
		support_pool = {
			"npc_dota_hero_jakiro",
			"npc_dota_hero_witch_doctor",
			"npc_dota_hero_vengefulspirit",
			"npc_dota_hero_keeper_of_the_light",
		}
		math.randomseed(RealTime())
		math.random();math.random();math.random();
		sup_1 = math.random(#support_pool)
		math.randomseed(RealTime())
		math.random();math.random();math.random();
		sup_2 = math.random(#support_pool)
		if sup_2 == sup_1 and sup_2 ~= #support_pool then
			sup_2 = sup_1+1
		elseif sup_2 == sup_1 and sup_2 == #support_pool then
			sup_2 = 1
		end
		mid_pool = {
			"npc_dota_hero_luna",
			"npc_dota_hero_tinker",
			"npc_dota_hero_medusa",
		}
		math.randomseed(RealTime())
		math.random();math.random();math.random();
		mid = math.random(#mid_pool)
		off_pool = {
			"npc_dota_hero_tidehunter",
			"npc_dota_hero_bristleback",
			"npc_dota_hero_beastmaster",
		}
		math.randomseed(RealTime())
		math.random();math.random();math.random();
		off = math.random(#off_pool)
        carry_pool = {
            "npc_dota_hero_drow_ranger",
			"npc_dota_hero_chaos_knight",
        }
		if mid == 1 then
			table.insert(carry_pool, "npc_dota_hero_luna")
		end
		math.randomseed(RealTime())
		math.random();math.random();math.random();
        carry = math.random(#carry_pool)
		if ( GetTeam() == TEAM_RADIANT )
		then
			SelectHero( 2, support_pool[sup_1] )
			SelectHero( 3, support_pool[sup_2] )
			SelectHero( 4, carry_pool[carry] )
			SelectHero( 5, mid_pool[mid] )
			SelectHero( 6, off_pool[off] )
		elseif ( GetTeam() == TEAM_DIRE )
		then
			SelectHero( 7, support_pool[sup_1] )
			SelectHero( 8, support_pool[sup_2] )
			SelectHero( 9, carry_pool[carry] )
			SelectHero( 10, mid_pool[mid] )
			SelectHero( 11, off_pool[off] )
		end
	end
end
function UpdateLaneAssignments()    
    if ( GetTeam() == TEAM_RADIANT )
    then
        return {
        [1] = LANE_TOP,
        [2] = LANE_TOP,
        [3] = LANE_TOP,
        [4] = LANE_mid,
        [5] = LANE_BOT,
        };
    elseif ( GetTeam() == TEAM_DIRE )
    then
        return {
        [1] = LANE_BOT,
        [2] = LANE_BOT,
        [3] = LANE_BOT,
        [4] = LANE_MID,
        [5] = LANE_TOP,
        };
    end
end