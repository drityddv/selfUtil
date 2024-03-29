local assets =
{ 
    Asset("ANIM", "anim/anniebearhat.zip"),
    Asset("ANIM", "anim/anniebearhat_swap.zip"), 

    Asset("ATLAS", "images/inventoryimages/anniebearhat.xml"),
    Asset("IMAGE", "images/inventoryimages/anniebearhat.tex"),
}

local prefabs = 
{
}

local function OnEquip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "anniebearhat_swap", "swap_hat")

    owner.AnimState:Show("HAT")
    owner.AnimState:Show("HAT_HAIR")
    owner.AnimState:Hide("HAIR_NOHAT")
    owner.AnimState:Hide("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Hide("HEAD")
        owner.AnimState:Show("HEAD_HAT")
    end
end

local function OnUnequip(inst, owner) 
    owner.AnimState:Hide("HAT")
    owner.AnimState:Hide("HAT_HAIR")
    owner.AnimState:Show("HAIR_NOHAT")
    owner.AnimState:Show("HAIR")

    if owner:HasTag("player") then
        owner.AnimState:Show("HEAD")
        owner.AnimState:Hide("HEAD_HAT")
    end
end

local function fn()

    local inst = CreateEntity()
    
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("anniebearhat")
    inst.AnimState:SetBuild("anniebearhat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "anniebearhat"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/anniebearhat.xml"
	
    inst:AddComponent("armor")
    inst.components.armor:InitCondition(9 * 9999999999, TUNING.ARMORRUINS_ABSORPTION)
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.inventoryitem.keepondeath = true
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED * 3.3
	


    MakeHauntableLaunch(inst)

    return inst
end

return  Prefab("common/inventory/anniebearhat", fn, assets, prefabs)