local assets =
{
    Asset("ANIM", "anim/armor_frostannie.zip"),
    Asset("ATLAS", "images/inventoryimages/armor_frostannie.xml"),
    Asset("IMAGE", "images/inventoryimages/armor_frostannie.tex"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_frostannie", "swap_body")
end

local function onunequip(inst, owner) 
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_frostannie")
    inst.AnimState:SetBuild("armor_frostannie")
    inst.AnimState:PlayAnimation("anim")
    --inst.AnimState:SetMultColour(1, 1, 1, 0.6)

    inst:AddTag("sanity")
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "armor_frostannie"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/armor_frostannie.xml"
	
    inst:AddComponent("insulator")
    inst.components.insulator:SetInsulation( TUNING.INSULATION_LARGE * 1.8 )

    inst:AddComponent("armor")
    inst.components.armor:InitCondition(9 * 99999999, TUNING.ARMOR_SANITY_ABSORPTION)

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
    inst.components.equippable.dapperness = TUNING.DAPPERNESS_MED * 1.3

    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/armor_frostannie", fn, assets)