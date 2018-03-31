local npcBot      = GetBot()
local botTeam     = GetTeam()

function Think()
    local idle = true

    if npcBot:HasModifier("modifier_huskar_life_break_charge") and not npcBot:HasModifier("modifier_huskar_inner_vitality") and inner_vitality:IsFullyCastable() then
        print("Ability : Using Inner Vitality while Life Break")
        npcBot:Action_UseAbilityOnEntity(inner_vitality, npcBot)
        local armletSlot = npcBot:FindItemSlot("item_armlet")
        local armlet = nil
        if npcBot:GetItemSlotType(armletSlot) == ITEM_SLOT_TYPE_MAIN then
            armlet = npcBot:GetItemInSlot(armletSlot)
        end
        if armlet ~= nil then
            if not npcBot:HasModifier("modifier_item_armlet_unholy_strength") then
                if armlet:IsFullyCastable() then
                    npcBot:Action_UseAbility(armlet)
                end
            end
        end

        local bkbSlot = npcBot:FindItemSlot("item_black_king_bar")
        local bkb = nil
        if npcBot:GetItemSlotType(bkbSlot) == ITEM_SLOT_TYPE_MAIN then
            bkb = npcBot:GetItemInSlot(bkbSlot)
        end
        if bkb ~= nil then
            if bkb:IsFullyCastable() then
                npcBot:Action_UseAbility(bkb)
            end
        end
        idle = false
    end

    if not burning_spear:GetAutoCastState() then
        -- print("Toggle it ON")
        burning_spear:ToggleAutoCast()
    end

    if life_break ~= nil and life_break:IsFullyCastable() then
        local nearbyEnemies = npcBot:GetNearbyHeroes(1200, true, BOT_MODE_NONE)
        local weakerEnemy = nil

        for k, enemy in pairs(nearbyEnemies) do
            if weakerEnemy == nil then
                weakerEnemy = enemy
            else
                if enemy:GetHealth() < weakerEnemy:GetHealth() and not enemy:HasModifier("modifier_item_blade_mail_reflect") then
                    weakerEnemy = enemy
                end
            end
        end

        print("Ability : Using Life Break")
        npcBot:Action_UseAbilityOnEntity(life_break, weakerEnemy)
        idle = false
    end

    -- inner vatality think --
    if not npcBot:HasModifier("modifier_huskar_inner_vitality") and inner_vitality:IsFullyCastable() then
        print("Ability : Using Inner Vitality while Life Break")
        npcBot:Action_UseAbilityOnEntity(inner_vitality, npcBot)
        idle = false
    end

    -- attack think --
    local nearbyEnemies = npcBot:GetNearbyHeroes(900, true, BOT_MODE_NONE)
    local targetEnemy = nil

    for k, enemy in pairs(nearbyEnemies) do
        if targetEnemy == nil then
            targetEnemy = enemy
        else
            if enemy:GetHealth() < targetEnemy:GetHealth() and not enemy:HasModifier("modifier_item_blade_mail_reflect") and not enemy:IsAttackImmune() then
                targetEnemy = enemy
            end
        end
    end

    if targetEnemy ~= nil then
        npcBot:Action_AttackUnit(targetEnemy, true)
        idle = false
    end

    if idle then
        if npcBot:GetHealth() > 500 then
            local nearbyEnemies = npcBot:GetNearbyHeroes(3000, true, BOT_MODE_NONE)
            npcBot:Action_AttackUnit(nearbyEnemies[1], true)
        else
            npcBot:Action_MoveToLocation(GetAncient(GetTeam()):GetLocation())
        end
    end

end