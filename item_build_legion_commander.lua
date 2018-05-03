X = {}
require(GetScriptDirectory() .. "/UtilityFunctions")
local npcBot  = GetBot()
local talents = fillTalentTable(npcBot)

X["items"] = {
    "item_enchanted_mango",
    "item_enchanted_mango",
    "item_enchanted_mango",
    "item_tango",
    "item_tango",
    "item_stout_shield",
    -- Soul Ring --
    "item_ring_of_regen",
    "item_gauntlets",
    "item_gauntlets",
    "item_recipe_soul_ring",
    -- phase boots --
    "item_boots",
    "item_blades_of_attack",
    "item_blades_of_attack",
    -- magic wand
    "item_magic_stick",
    "item_branches",
    "item_branches",
    "item_recipe_magic_wand",
    "item_blink",
    "item_broadsword",
    "item_chainmail",
    "item_robe",
    "item_ogre_axe",
    "item_mithril_hammer",
    "item_recipe_black_king_bar"
}

local odds    = "legion_commander_overwhelming_odds"
local press   = "legion_commander_press_the_attack"
local courage = "legion_commander_moment_of_courage"
local duel    = "legion_commander_duel"


-- special_bonus_strength_8
-- special_bonus_exp_boost_25
-- special_bonus_attack_speed_30
-- special_bonus_unique_legion_commander_4
-- special_bonus_movement_speed_60
-- special_bonus_unique_legion_commander_3
-- special_bonus_unique_legion_commander
-- special_bonus_unique_legion_commander_2
-- legion_commander_overwhelming_odds
-- legion_commander_press_the_attack
-- legion_commander_moment_of_courage
-- legion_commander_duel

local t1 = "special_bonus_exp_boost_25"
local t2 = "special_bonus_attack_speed_30"
local t3 = "special_bonus_movement_speed_60"
local t4 = "special_bonus_unique_legion_commander"

X["skills"] = {
    odds,    -- 1
    courage, -- 2    
    odds,    -- 3
    press,   -- 4
    odds,    -- 5
    duel,    -- 6
    odds,    -- 7
    press,   -- 8
    press,   -- 9
    t1,      -- 10
    press,   -- 11   
    duel,    -- 12
    courage, -- 13
    courage, -- 14
    t2,      -- 15
    courage, -- 16    
    "-1",    -- 17
    duel,    -- 18
    "-1",    -- 19	
    t3,      -- 20
    "-1",    -- 21 	
    "-1",    -- 22
    "-1",    -- 23
    "-1",    -- 24
    t4       -- 25
}

return X