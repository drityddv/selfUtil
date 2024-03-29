local assets =
{
    Asset("ANIM", "anim/armor_sweetheartannie.zip"),
    Asset("ATLAS", "images/inventoryimages/armor_sweetheartannie.xml"),
    Asset("IMAGE", "images/inventoryimages/armor_sweetheartannie.tex"),
}

local function onequip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_body", "armor_sweetheartannie", "swap_body")
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

    inst.AnimState:SetBank("armor_sweetheartannie")
    inst.AnimState:SetBuild("armor_sweetheartannie")
    inst.AnimState:PlayAnimation("anim")
    --inst.AnimState:SetMultColour(1, 1, 1, 0.6)

    inst:AddTag("sanity")
    
    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "armor_sweetheartannie"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/armor_sweetheartannie.xml"

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable.dapperness = TUNING.DAPPERNESS_HUGE
	
    inst:AddComponent("waterproofer")
    inst.components.waterproofer:SetEffectiveness(TUNING.WATERPROOFNESS_HUGE)
		
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("common/inventory/armor_sweetheartannie", fn, assets)