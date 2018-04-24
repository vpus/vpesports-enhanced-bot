------------------------------------ Variable ----------------------------------
total_prox    = 0;
total_remotes = 0;
total_stasis  = 0;
------------------------------------- Final ------------------------------------
-- Get all player IDs
rad_player_ids = GetTeamPlayers(TEAM_RADIANT);
dir_player_ids = GetTeamPlayers(TEAM_DIRE);

-- Modes for Farming
EARLY_MINING   = 0;
EARLY_STACKING = 1;
CONSIDER_CAMP   = 2;
ATTACK_CAMP    = 3;

teams = {
	TEAM_RADIANT,
	TEAM_DIRE,
	TEAM_NEUTRAL,
	TEAM_NONE
};

modes = {
	["none"]        = BOT_MODE_NONE,
	["lane"]        = BOT_MODE_LANING,
	["attack"]      = BOT_MODE_ATTACK,
	["roam"]        = BOT_MODE_ROAM,
	["retreat"]     = BOT_MODE_RETREAT,
	["secret"]      = BOT_MODE_SECRET_SHOP,
	["side"]        = BOT_MODE_SIDE_SHOP,
	["push_top"]    = BOT_MODE_PUSH_TOWER_TOP,
	["push_mid"]    = BOT_MODE_PUSH_TOWER_MID,
	["push_bot"]    = BOT_MODE_PUSH_TOWER_BOT,
	["defend_top"]  = BOT_MODE_DEFEND_TOWER_TOP,
	["defend_mid"]  = BOT_MODE_DEFEND_TOWER_MID,
	["defend_bot"]  = BOT_MODE_DEFEND_TOWER_BOT,
	["assemble"]    = BOT_MODE_ASSEMBLE,
	["team_roam"]   = BOT_MODE_TEAM_ROAM,
	["farm"]        = BOT_MODE_FARM,
	["defend_ally"] = BOT_MODE_DEFEND_ALLY,
	["evasive"]     = BOT_MODE_EVASIVE_MANEUVERS,
	["roshan"]      = BOT_MODE_ROSHAN,
	["item"]        = BOT_MODE_ITEM,
	["ward"]        = BOT_MODE_WARD
};

desires = {
	BOT_MODE_DESIRE_NONE,
	BOT_MODE_DESIRE_VERYLOW,
	BOT_MODE_DESIRE_LOW,
	BOT_MODE_DESIRE_MODERATE,
	BOT_MODE_DESIRE_HIGH,
	BOT_MODE_DESIRE_VERYHIGH,
	BOT_MODE_DESIRE_ABSOLUTE
};

actions = {
	["none"]        = BOT_ACTION_TYPE_NONE,
	["idle"]        = BOT_ACTION_TYPE_IDLE,
	["move_to"]     = BOT_ACTION_TYPE_MOVE_TO,
	["attack"]      = BOT_ACTION_TYPE_ATTACK,
	["attack_move"] = BOT_ACTION_TYPE_ATTACKMOVE,
	["use_ability"] = BOT_ACTION_TYPE_USE_ABILITY,
	["pick_rune"]   = BOT_ACTION_TYPE_PICK_UP_RUNE,
	["pick_item"]   = BOT_ACTION_TYPE_PICK_UP_ITEM,
	["drop_item"]   = BOT_ACTION_TYPE_DROP_ITEM,
	["shrine"]      = BOT_ACTION_TYPE_SHRINE,
	["delay"]       = BOT_ACTION_TYPE_DELAY
};

actionsTEST = {
	[BOT_ACTION_TYPE_NONE]         = "None",
	[BOT_ACTION_TYPE_IDLE]         = "Idle",
	[BOT_ACTION_TYPE_MOVE_TO]      = "Move To",
	[BOT_ACTION_TYPE_ATTACK]       = "Attack",
	[BOT_ACTION_TYPE_ATTACKMOVE]   = "Attack Move",
	[BOT_ACTION_TYPE_USE_ABILITY]  = "Use Ability",
	[BOT_ACTION_TYPE_PICK_UP_RUNE] = "Pick Rune",
	[BOT_ACTION_TYPE_PICK_UP_ITEM] = "Pick Item",
	[BOT_ACTION_TYPE_DROP_ITEM]    = "Drop Item",
	[BOT_ACTION_TYPE_SHRINE]       = "Shrine",
	[BOT_ACTION_TYPE_DELAY]        = "Delay"	
};

towers = {
	TOWER_TOP_1,
	TOWER_MID_1,
	TOWER_BOT_1,
	TOWER_TOP_2,
	TOWER_MID_2,
	TOWER_BOT_2,
	TOWER_TOP_3,
	TOWER_MID_3,
	TOWER_BOT_3,
	TOWER_BASE_1,
	TOWER_BASE_2
};

rad_early_remote_locs = {
	Vector(-6200, 3400),
	Vector(-3200, 4400),
	Vector(-900, -1200),
	Vector(800, 500),
	Vector(3600, 800),
	Vector(-1700, 1100),
	Vector(2600, -2000)
};

rad_late_remote_locs = {
	Vector(4000, 3500),
	Vector(5000, 4200),
	Vector(3100, 5800),
	Vector(6300, 2600),
	Vector(-1700, 1100),
	Vector(2600, -2000)
};

rad_base_remote_locs = {
	Vector(-6600, -3500),
	Vector(-4700, -4200),
	Vector(-4100, -6100),
	Vector(-5600, -4700),
	Vector(-5200, -5100)
};

dir_early_remote_locs = {
	Vector(6000, 3400),
	Vector(5200, -4000),
	Vector(3500, -5200),
	Vector(-1700, 1100),
	Vector(2600, -2000)
};

dir_late_remote_locs = {
	Vector(4000, 3500),
	Vector(-1700, 1100),
	Vector(2600, -2000)
};

dir_base_remote_locs = {
	Vector(3700, 5700),
	Vector(4400, 3800),
	Vector(6300, 3100),
	Vector(4800, 4800),
	Vector(5300, 4300)
};

rad_base_remote_locs_attack = {
	Vector(2600, 5700),
	Vector(3600, 3000),
	Vector(6300, 2000)
}

dir_base_remote_locs_attack = {
	Vector(-6600, -2500),
	Vector(-4000, -3400),
	Vector(-3000, -6000)
}

rad_fountain = Vector(-6700, -6200);
dir_fountain = Vector(6600, 6000);

radiant_camp_locs = {
	{
		Vector(2800, -4550), -- Where Neutrals spawn
		Vector(3500, -4500), -- Where to plant a mine
		1,
		Vector(4300, -4000), -- Where to run away to
		false     -- Are the neutrals dead? When did they die?
	},
	{
		Vector(-3600, 850),
		Vector(-4400, 600),
		2,
		Vector(-5500, 1500),
		false
	},
	{
		Vector(-1800, -4500),
		Vector(-1800, -3700),
		2,
		Vector(-1700, -3100),
		false
	},
	{
		Vector(300, -4700),
		Vector(1150, -4500),
		2,
		Vector(2000, -4000),
		false
	},
	{
		Vector(-4700, -400), 
		Vector(-4800, 300),
		3,
		Vector(-4700, 800),
		false
	},
	{
		Vector(-350, -3400),
		Vector(-900, -2900),
		3,
		Vector(-1500, -2300),
		false
	},
	{
		Vector(4800, -4500),
		Vector(4600, -3800),
		3,
		Vector(4400, -3400),
		false
	},
	{
		Vector(-3000, -100),
		Vector(-2400, 300),
		4,
		Vector(-1500, 1000),
		false
	},
	{
		Vector(100, -1900),
		Vector(600, -2100),
		4,
		Vector(1600, -2400),
		false
	},
};

dire_camp_locs = {
	{
		Vector(4400, 800),
		Vector(-2900, 5250),
		1
	},
	{
		Vector(4400, 800),
		Vector(3000, -200),
		2
	},
	{
		Vector(4400, 800),
		Vector(1300, 3950),
		2
	},
	{
		Vector(4400, 800),
		Vector(-1400, -4350),
		2
	},
	{
		Vector(4400, 800),
		Vector(3950, 750),
		3
	},
	{
		Vector(4400, 800),
		Vector(-400, 3700),
		3
	},
	{
		Vector(4400, 800),
		Vector(-4850, 3950),
		3
	},
	{
		Vector(4400, 800),
		Vector(3800, -1000),
		4
	},
	{
		Vector(4400, 800),
		Vector(-700, 2800),
		4
	},
}

top_lane = {
	Vector(-6600, -3300),
	Vector(-6000, 5700),
	Vector(3300, 5800)
};

mid_lane = {
	Vector(-4400, -4000),
	Vector(4100, 3500)	
};

bot_lane = {
	Vector(-3800, -6000),
	Vector(5900, -6000),
	Vector(6300, 2800)	
};
