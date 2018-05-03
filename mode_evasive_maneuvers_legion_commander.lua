local npcBot      = GetBot()
local botTeam     = GetTeam()

function think()
    if npcBot:HasModifier("modifier_bloodseeker_rupture") then
        -- if can bkb --
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

        -- if can BoT --
        local botSlot = npcBot:FindItemSlot("item_travel_boots")
        local boT = nil
        if npcBot:GetItemSlotType(botSlot) == ITEM_SLOT_TYPE_MAIN then
            boT = npcBot:GetItemInSlot(botSlot)
        end
        if boT ~= nil then
            if boT:IsFullyCastable() then
                npcBot:Action_UseAbility(boT)
            end
        end

        -- if can TP --
        local tpSlot = npcBot:FindItemSlot("item_tpscroll")
        local tp = nil
        if npcBot:GetItemSlotType(tpSlot) == ITEM_SLOT_TYPE_MAIN then
            tp = npcBot:GetItemInSlot(tpSlot)
        end
        if tp ~= nil then
            if tp:IsFullyCastable() then
                npcBot:Action_UseAbility(tp)
            end
        end
    end
end