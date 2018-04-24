X = {}
require(GetScriptDirectory() .. "/UtilityFunctions")
local npcBot  = GetBot()
local talents = fillTalentTable(npcBot)

X["items"] = {
	"item_tango",
    "item_stout_shield-bear",
    "item_quelling_blade-bear",
    "item_orb_of_venom-bear",
    "item_boots-bear",
    "item_recipe_hand_of_midas",
    "item_gloves",
    "item_boots",
    "item_magic_stick",
    "item_branches",
    "item_branches",
    "item_enchanted_mango",
    "item_relic-bear",
    "item_recipe_radiance-bear",
    "item_blades_of_attack",
    "item_blades_of_attack",
    "item_platemail-bear",
    "item_hyperstone-bear",
    "item_chainmail-bear",
    "item_recipe_assault-bear",
    "item_point_booster",
    "item_staff_of_wizardry",
    "item_ogre_axe",
    "item_blade_of_alacrity",
    "item_belt_of_strength-bear",
    "item_javelin-bear",
    "item_recipe_basher-bear",
    "item_ring_of_health-bear",
    "item_vitality_booster-bear",
    "item_stout_shield-bear",
    "item_recipe_abyssal_blade-bear",
    "item_hyperstone-bear",
    "item_javelin-bear",
    "item_javelin-bear",
    "item_mithril_hammer-bear",
    "item_gloves-bear",
    "item_recipe_maelstrom-bear",
    "item_hyperstone-bear",
    "item_recipe_mjollnir-bear",
}

local spirit = "lone_druid_spirit_bear"
local rabid  = "lone_druid_rabid"
local roar   = "lone_druid_savage_roar"
local form   = "lone_druid_true_form"

local t1 = "special_bonus_hp_250"
local t2 = "special_bonus_unique_lone_druid_2"
local t3 = "special_bonus_unique_lone_druid_6"
local t4 = "special_bonus_unique_lone_druid_7"

-- Abilities:
--    lone_druid_spirit_bear
--    lone_druid_rabid
--    lone_druid_savage_roar
--    lone_druid_true_form_battle_cry
--    generic_hidden
--    lone_druid_true_form
--    lone_druid_true_form_druid
-- Talents:
--    special_bonus_hp_250
--    special_bonus_attack_range_175
--    special_bonus_unique_lone_druid_4
--    special_bonus_unique_lone_druid_2
--    special_bonus_unique_lone_druid_8
--    special_bonus_unique_lone_druid_6
--    special_bonus_unique_lone_druid_9
--    special_bonus_unique_lone_druid_7

X["skills"] = {
    spirit,    
    roar,    
    spirit,    
    rabid,    
    spirit,
    rabid,    
    spirit,    
    rabid,    
    rabid,    
    t1,
    form,    
    form,
    roar,
    roar,
    t2,
    roar,    
    "-1",       
    form,
    "-1",   	
    t3,
    "-1",   	
    "-1",   	
    "-1",       
    "-1",       
    t4
}

return X