X = {}
require(GetScriptDirectory() .. "/UtilityFunctions")
local npcBot  = GetBot()
local talents = fillTalentTable(npcBot)

X["items"] = {
    -- start --
	"item_stout_shield",
    "item_flask",
    "item_tango",
    "item_enchanted_mango",
    -- arcane boots --
    "item_boots",
    "item_energy_booster",
    -- magic wand --
    "item_magic_stick",
    "item_branches",
    "item_branches",
    -- Soul Ring --
    "item_ring_of_regen",
    "item_gauntlets",
    "item_gauntlets",
    "item_recipe_soul_ring",
    -- vanguard --
    "item_ring_of_health",
    "item_vitality_booster",
    -- Hood of Defiance --
    "item_ring_of_health",
    "item_cloak",
    "item_ring_of_regen",
    -- Pipe of Insight --
    "item_ring_of_regen",
    "item_branches",
    "item_recipe_headdress",
    "item_recipe_pipe",
    -- Crimson Guard --
    "item_chainmail",
    "item_branches",
    "item_recipe_buckler",
    "item_recipe_crimson_guard",
    -- Mekansm --
    "item_ring_of_regen",
    "item_branches",
    "item_recipe_headdress",
    "item_chainmail",
    "item_branches",
    "item_recipe_buckler",
    "item_recipe_mekansm",
    -- Guardian Greaves --
    "item_recipe_guardian_greaves",
    -- Blink Dagger --
    "item_blink",
    -- Blade Mail --
    "item_broadsword",
    "item_chainmail",
    "item_robe",
    -- Shiva's Guard --
    "item_platemail",
    "item_mystic_staff",
    "item_recipe_shivas_guard",
}

local firestorm  = "abyssal_underlord_firestorm"
local pit_of_malice = "abyssal_underlord_pit_of_malice"
local atrophy_aura  = "abyssal_underlord_atrophy_aura"
local dark_rift  = "abyssal_underlord_dark_rift"
local cancel_dark_rift  = "abyssal_underlord_cancel_dark_rift"

X["skills"] = {
    atrophy_aura,         --1
    firestorm,     --2 
    firestorm,         --3
    atrophy_aura,     --4
    firestorm,     --5
    dark_rift,         --6
    firestorm,     --7
    pit_of_malice,         --8
    pit_of_malice,     --9
    talents[3],     --10
    pit_of_malice,       --11
    dark_rift,       --12
    pit_of_malice,       --13
    atrophy_aura,       --14
    talents[5],     --15
    atrophy_aura,     --16
    -- "-1",           --17
    dark_rift,     --18
    -- "-1",           --19
    talents[6],     --20
    -- "-1",   	    --21
    -- "-1",   	    --22
    -- "-1",           --23
    -- "-1",           --24
    talents[8],      --25
}
return X