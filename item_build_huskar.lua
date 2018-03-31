X = {}
require(GetScriptDirectory() .. "/UtilityFunctions")
local npcBot  = GetBot()
local talents = fillTalentTable(npcBot)

X["items"] = {
	"item_gauntlets",
    "item_circlet",
    "item_recipe_bracer",
    "item_tango",
    "item_boots",
    "item_blades_of_attack",
    "item_helm_of_iron_will",
    "item_gloves",
    "item_recipe_armlet",
    "item_belt_of_strength",
    "item_gloves",
    "item_ogre_axe",
    "item_mithril_hammer",
    "item_recipe_black_king_bar",
    "item_ogre_axe",
    "item_belt_of_strength",
    "item_recipe_sange",
    "item_talisman_of_evasion",
    "item_ogre_axe",
    "item_boots_of_elves",
    "item_boots_of_elves",
    "item_platemail",
    "item_chainmail",
    "item_hyperstone",
    "item_recipe_assault"
}

local inner_vitality  = "huskar_inner_vitality"
local burning_spear = "huskar_burning_spear"
local berserkers_blood  = "huskar_berserkers_blood"
local life_break  = "huskar_life_break"

X["skills"] = {
    burning_spear,         --1
    berserkers_blood,     --2 
    burning_spear,         --3
    inner_vitality,     --4
    burning_spear,     --5
    life_break,         --6
    burning_spear,     --7
    berserkers_blood,         --8
    berserkers_blood,     --9
    talents[2],     --10
    berserkers_blood,       --11
    life_break,       --12
    inner_vitality,       --13
    inner_vitality,       --14
    talents[4],     --15
    inner_vitality,     --16
    -- "-1",           --17
    life_break,     --18
    -- "-1",           --19
    talents[6],     --20
    -- "-1",   	    --21
    -- "-1",   	    --22
    -- "-1",           --23
    -- "-1",           --24
    talents[9]      --25
}

return X