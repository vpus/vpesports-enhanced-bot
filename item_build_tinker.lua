X = {}
require(GetScriptDirectory() .. "/UtilityFunctions")
local npcBot  = GetBot()
local talents = fillTalentTable(npcBot)

X["items"] = {
	"item_courier",
    "item_circlet",
    "item_mantle",
    "item_recipe_null_talisman",
    "item_tango",
    "item_bottle",
    "item_boots",
    "item_recipe_travel_boots",
    "item_gauntlets",
    "item_gauntlets",
    "item_ring_of_regen",
    "item_recipe_soul_ring",
    "item_blink",
    "item_energy_booster",
    "item_void_stone",
    "item_recipe_aether_lens",
    "item_point_booster",
    "item_ogre_axe",
    "item_blade_of_alacrity",
    "item_staff_of_wizardry",
    "item_mystic_staff",
    "item_platemail",
    "item_recipe_shivas_guard"
}

local laser  = "tinker_laser"
local missle = "tinker_heat_seeking_missile"
local march  = "tinker_march_of_the_machines"
local rearm  = "tinker_rearm"

X["skills"] = {
    laser,    
    march,    
    march,    
    laser,    
    march,
    rearm,    
    missle,    
    march,    
    rearm,    
    talents[2],
    missle,    
    missle,
    laser,
    laser,
    talents[4],
    laser,    
    "-1",       
    rearm,
    "-1",   	
    talents[5],
    "-1",   	
    "-1",   	
    "-1",       
    "-1",       
    talents[7]
}

return X