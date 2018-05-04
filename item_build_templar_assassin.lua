X = {}
require(GetScriptDirectory() .. "/UtilityFunctions")
local npcBot  = GetBot()
local talents = fillTalentTable(npcBot)

X["items"] = {
    -- wraith band --
    "item_slippers",
    "item_circlet",
    "item_recipe_wraith_band",
    "item_branches",
    "item_faerie_fire",
    "item_boots",
    "item_sobi_mask",
    "item_ring_of_protection",
    "item_gloves",
    "item_belt_of_strength",
    "item_bottle",
    "item_blink",
    -- Desolator
    "item_mithril_hammer",
    "item_mithril_hammer",
    "item_blight_stone",
    -- Black King Bar
    "item_ogre_axe",
    "item_mithril_hammer",
    "item_recipe_black_king_bar",
    -- Wraith Band --
    "item_slippers",
    "item_circlet",
    "item_recipe_wraith_band",
    -- Force Staff --
    "item_staff_of_wizardry",
    "item_ring_of_health",
    "item_recipe_force_staff",
    -- Dragon Lance --
    "item_ogre_axe",
    "item_boots_of_elves",
    "item_boots_of_elves"
}

local refraction = "templar_assassin_refraction"
local meld       = "templar_assassin_meld"
local psi        = "templar_assassin_psi_blades"
local psitrap    = "templar_assassin_psionic_trap"

--special_bonus_attack_speed_25
--special_bonus_unique_templar_assassin_6
--special_bonus_armor_7
--special_bonus_unique_templar_assassin_3
--special_bonus_unique_templar_assassin_4
--special_bonus_unique_templar_assassin_2
--special_bonus_unique_templar_assassin_5
--special_bonus_unique_templar_assassin

local t1 = "special_bonus_attack_speed_25"
local t2 = "special_bonus_unique_templar_assassin_3"
local t3 = "special_bonus_unique_templar_assassin_4"
local t4 = "special_bonus_unique_templar_assassin_5"

X["skills"] = {
    psi,    -- 1
    refraction, -- 2    
    refraction,    -- 3
    psi,   -- 4
    refraction,    -- 5
    psitrap,    -- 6
    refraction,    -- 7
    meld,   -- 8
    meld,   -- 9
    t1,      -- 10
    meld,   -- 11   
    psitrap,    -- 12
    meld, -- 13
    psi, -- 14
    t2,      -- 15
    psi, -- 16    
    "-1",    -- 17
    psitrap,    -- 18
    "-1",    -- 19	
    t3,      -- 20
    "-1",    -- 21 	
    "-1",    -- 22
    "-1",    -- 23
    "-1",    -- 24
    t4       -- 25
}

return X