X = {}
require(GetScriptDirectory() .. "/UtilityFunctions")
local npcBot  = GetBot()
local talents = fillTalentTable(npcBot)

X["items"] = {
    -- start --
	"item_slippers",
    "item_circlet",
    "item_recipe_wraith_band",
    "item_tango",
    -- ring of basilius --
    "item_sobi_mask",
    "item_ring_of_protection",
    -- phase boots --
    "item_boots",
    "item_blades_of_attack",
    "item_blades_of_attack",
    -- mask of madness --
    "item_lifesteal",
    "item_quarterstaff",
    -- hurricane pike --
    "item_ogre_axe",
    "item_boots_of_elves",
    "item_boots_of_elves",
    "item_staff_of_wizardry",
    "item_ring_of_health",
    "item_recipe_force_staff",
    "item_slippers",
    "item_circlet",
    "item_recipe_wraith_band",
    -- eye of skadi --
    "item_ultimate_orb",
    "item_point_booster",
    "item_ultimate_orb",
    -- divine rapier --
    "item_relic",
    "item_demon_edge",
}

local split_shot  = "medusa_split_shot"
local mystic_snake = "medusa_mystic_snake"
local mana_shield  = "medusa_mana_shield"
local stone_gaze  = "medusa_stone_gaze"

local talent_20_right = "special_bonus_mp_700"
local talent_25_left = "special_bonus_unique_medusa_4"

X["skills"] = {
    mystic_snake,         --1
    mana_shield,     --2 
    mystic_snake,         --3
    mana_shield,     --4
    mystic_snake,     --5
    split_shot,         --6
    mystic_snake,     --7
    split_shot,         --8
    split_shot,     --9
    talents[1],     --10
    stone_gaze,       --11
    split_shot,       --12
    mana_shield,       --13
    mana_shield,       --14
    talents[3],     --15
    stone_gaze,     --16
    -- "-1",           --17
    stone_gaze,     --18
    -- "-1",           --19
    talent_20_right,     --20
    -- "-1",   	    --21
    -- "-1",   	    --22
    -- "-1",           --23
    -- "-1",           --24
    talent_25_left,      --25
}


-- 7[VScript] 9	special_bonus_unique_medusa_2
-- 1[VScript] 10	special_bonus_attack_damage_20
-- 2[VScript] 11	special_bonus_evasion_15
-- 3[VScript] 12	special_bonus_attack_speed_30
-- 4[VScript] 13	special_bonus_unique_medusa_3
-- 5[VScript] 14	special_bonus_mp_700
-- 6[VScript] 15	special_bonus_unique_medusa
-- 7[VScript] 16	special_bonus_unique_medusa_2
-- 8[VScript] 17	special_bonus_unique_medusa_4
return X