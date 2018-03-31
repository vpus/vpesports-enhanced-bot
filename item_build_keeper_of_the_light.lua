X = {}
require(GetScriptDirectory() .. "/UtilityFunctions")
local npcBot  = GetBot()
local talents = fillTalentTable(npcBot)

X["items"] = {
	"item_boots",
    "item_ring_of_regen",
    "item_wind_lace",
    "item_staff_of_wizardry",
    "item_ring_of_health",
    "item_recipe_force_staff",
    "item_ogre_axe",
    "item_staff_of_wizardry",
    "item_blade_of_alacrity",
    "item_point_booster",
    "item_platemail",
    "item_energy_booster",
    "item_ring_of_health",
    "item_void_stone",
    "item_gem"
}

local illuminate  = "keeper_of_the_light_illuminate"
local manaleak = "keeper_of_the_light_mana_leak"
local chakra  = "keeper_of_the_light_chakra_magic"
local spiritform  = "keeper_of_the_light_spirit_form"
local recall = "keeper_of_the_light_recall"
local blinding = "keeper_of_the_light_blinding_light"

X["skills"] = {
    illuminate,         --1
    chakra,     --2 
    chakra,         --1
    illuminate,     --4
    illuminate,     --5
    chakra,         --6
    illuminate,     --7
    chakra,         --8
    spiritform,     --9
    talents[2],     --10
    manaleak,       --11
    manaleak,       --12
    manaleak,       --13
    manaleak,       --14
    talents[3],     --15
    spiritform,     --16
    "-1",           --17
    spiritform,     --18
    "-1",           --19
    talents[5],     --20
    "-1",   	    --21
    "-1",   	    --22
    "-1",           --23
    "-1",           --24
    talents[8]      --25
}

return X