X = {}
require(GetScriptDirectory() .. "/UtilityFunctions")
local npcBot  = GetBot()
local talents = fillTalentTable(npcBot)

X["items"] = {
	"item_stout_shield",
    "item_tango",
    "item_flask",
    "item_clarity",
    "item_magic_stick",
    "item_branches",
    "item_branches",
    "item_enchanted_mango",
    "item_quelling_blade",
    "item_boots",
    "item_gauntlets",
    "item_gauntlets",
    "item_ring_of_regen",
    "item_recipe_soul_ring",
    "item_blades_of_attack",
    "item_blades_of_attack",
    "item_sobi_mask",
    "item_belt_of_strength",
    "item_sobi_mask",
    "item_recipe_necronomicon",
    "item_recipe_necronomicon",
    "item_recipe_necronomicon",
    "item_blink",
    "item_platemail",
    "item_hyperstone",
    "item_chainmail",
    "item_recipe_assault",
    "item_ogre_axe",
    "item_staff_of_wizardry",
    "item_blade_of_alacrity",
    "item_point_booster",
    "item_gem"
}

local wild_axes  = "beastmaster_wild_axes"
local call_of_the_wild = "beastmaster_call_of_the_wild"
local inner_beast  = "beastmaster_inner_beast"
local primal_roar  = "beastmaster_primal_roar"

X["skills"] = {
    wild_axes,         --1
    inner_beast,     --2 
    wild_axes,         --1
    inner_beast,     --4
    wild_axes,     --5
    primal_roar,         --6
    wild_axes,     --7
    inner_beast,         --8
    inner_beast,     --9
    talents[2],     --10
    call_of_the_wild,       --11
    primal_roar,       --12
    call_of_the_wild,       --13
    call_of_the_wild,       --14
    talents[3],     --15
    call_of_the_wild,     --16
    "-1",           --17
    primal_roar,     --18
    "-1",           --19
    talents[6],     --20
    "-1",   	    --21
    "-1",   	    --22
    "-1",           --23
    "-1",           --24
    talents[8]      --25
}

return X