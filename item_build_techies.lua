X = {}
require(GetScriptDirectory() .. "/UtilityFunctions");
local npcBot  = GetBot();
local talents = fillTalentTable(npcBot);

X["items"] = {
	"item_enchanted_mango",
	"item_sobi_mask",
	"item_clarity",
	"item_ring_of_regen",
	"item_boots",
	"item_energy_booster",
	"item_point_booster",
	"item_staff_of_wizardry",
	"item_recipe_force_staff",
	"item_wind_lace",
	"item_void_stone",
	"item_staff_of_wizardry",
	"item_recipe_cyclone",
	"item_energy_booster",
	"item_vitality_booster",
	"item_recipe_bloodstone",
	"item_point_booster",
	"item_ogre_axe",
	"item_staff_of_wizardry",
	"item_blade_of_alacrity",
	"item_void_stone",
	"item_ultimate_orb",
	"item_mystic_staff"
};

-- Set up Skill build
local prox_mines = "techies_land_mines";
local stasis_trap = "techies_stasis_trap";
local blast_off = "techies_suicide";
local remote_mines = "techies_remote_mines";   

local ABILITY1 = "special_bonus_mp_regen_2"
local ABILITY2 = "special_bonus_movement_speed_20"
local ABILITY3 = "special_bonus_cast_range_200"
local ABILITY4 = "special_bonus_exp_boost_30"
local ABILITY5 = "special_bonus_respawn_reduction_60"
local ABILITY6 = "special_bonus_gold_income_20"
local ABILITY7 = "special_bonus_unique_techies"
local ABILITY8 = "special_bonus_cooldown_reduction_20"

X["skills"] = {
    prox_mines,    
    blast_off,    
    prox_mines,    
    blast_off,    
    prox_mines,
    remote_mines,    
    stasis_trap,    
    blast_off,    
    prox_mines,    
    talents[2],
    stasis_trap,    
    remote_mines,    
    stasis_trap,    
    stasis_trap,    
    talents[3],
    blast_off,    
    "-1",       
    remote_mines,    
    "-1",   	
    talents[6],
    "-1",   	
    "-1",   	
    "-1",       
    "-1",       
    talents[7]
};

return X