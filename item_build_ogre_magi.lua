X = {}
require(GetScriptDirectory() .. "/UtilityFunctions")
local npcBot  = GetBot()
local talents = fillTalentTable(npcBot)

X["items"] = {
    "item_orb_of_venom",
    "item_wind_lace",
    "item_boots",
    "item_magic_stick",
    "item_branches",
    "item_branches",
    "item_enchanted_mango",
    "item_energy_booster",
    "item_staff_of_wizardry",
    "item_ring_of_health",
    "item_recipe_force_staff", -- sell orb ActionImmediate_SellItem(item)
    "item_infused_raindrop",
    "item_circlet",
    "item_ring_of_protection",
    "item_recipe_urn_of_shadows",-- drop TP Action_DropItem(item, location)
    "item_shadow_amulet",
    "item_cloak",
    "item_vitality_booster",
    "item_recipe_spirit_vessel",
    "item_point_booster",
    "item_staff_of_wizardry",
    "item_ogre_axe",
    "item_blade_of_alacrity", -- sell wand, disassemble arcane boots, unlock boots of speed ActionImmediate_SellItem(item), ActionImmediate_DisassembleItem(item), ActionImmediate_SetItemCombineLock(item, false)
    "item_recipe_travel_boots", -- unlock energy booster ActionImmediate_SetItemCombineLock(item, false)
    "item_void_stone",
    "item_recipe_aether_lens", -- sell glimmer cape ActionImmediate_SellItem(item)
    "item_vitality_booster",
    "item_energy_booster",
    "item_recipe_aeon_disk"
}

local fireblast = "ogre_magi_fireblast"
local ignite    = "ogre_magi_ignite"
local bloodlust = "ogre_magi_bloodlust"
local unblast   = "ogre_magi_unrefined_fireblast"
local multi     = "ogre_magi_multicast"

local t1 = "special_bonus_gold_income_10"
local t2 = "special_bonus_hp_300"
local t3 = "special_bonus_unique_ogre_magi"
local t4 = "special_bonus_unique_ogre_magi_2"

X["skills"] = {
    ignite,    
    fireblast,    
    ignite,    
    bloodlust,    
    bloodlust,
    multi,    
    bloodlust,    
    ignite,    
    ignite,    
    t1,
    bloodlust,    
    multi,
    fireblast,
    fireblast,
    t2,
    fireblast,    
    "-1",       
    multi,
    "-1",   	
    t3,
    "-1",   	
    "-1",   	
    "-1",       
    "-1",       
    t4
}

return X