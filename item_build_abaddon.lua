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
    "item_branches",
    "item_branches",
    -- magic wand --
    "item_magic_stick",
    -- Helm of Dominator --
    "item_ring_of_regen",
    "item_branches",
    "item_recipe_headdress",
    "item_ring_of_health",
    "item_gloves",
    -- phase boots --
    "item_boots",
    "item_blades_of_attack",
    "item_blades_of_attack",
    -- radiance --
    "item_relic",
    "item_recipe_radiance",
    -- medallion of courage --
    "item_chainmail",
    "item_sobi_mask",
    "item_blight_stone",
    -- solar crest --
    "item_talisman_of_evasion",
    -- Hood of Defiance --
    "item_ring_of_health",
    "item_cloak",
    "item_ring_of_regen",
    -- Pipe of Insight --
    "item_ring_of_regen",
    "item_branches",
    "item_recipe_headdress",
    "item_recipe_pipe",
    -- Shiva's Guard --
    "item_platemail",
    "item_mystic_staff",
    "item_recipe_shivas_guard",
    -- Octarine Core --
    "item_point_booster",
    "item_vitality_booster",
    "item_energy_booster",
    "item_mystic_staff",
}

local death_coil  = "abaddon_death_coil"
local aphotic_shield = "abaddon_aphotic_shield"
local forstmourne  = "abaddon_frostmourne"
local borrowed_time  = "abaddon_borrowed_time"

X["skills"] = {
    aphotic_shield,         --1
    forstmourne,     --2 
    aphotic_shield,         --3
    forstmourne,     --4
    aphotic_shield,     --5
    borrowed_time,         --6
    aphotic_shield,     --7
    forstmourne,         --8
    forstmourne,     --9
    talents[2],     --10
    death_coil,       --11
    borrowed_time,       --12
    death_coil,       --13
    death_coil,       --14
    talents[4],     --15
    death_coil,     --16
    -- "-1",           --17
    borrowed_time,     --18
    -- "-1",           --19
    talents[5],     --20
    -- "-1",   	    --21
    -- "-1",   	    --22
    -- "-1",           --23
    -- "-1",           --24
    talents[7],      --25
    "separate",
    talents[1],
    talents[2],
    talents[3],
    talents[4],
    talents[5],
    talents[6],
    talents[7],
    talents[8],
    talents[9],
}
return X