local assets =
{
	Asset("ANIM", "anim/armor_littleredannie.zip"),
    Asset("ATLAS", "images/inventoryimages/armor_littleredannie.xml"),
    Asset("IMAGE", "images/inventoryimages/armor_littleredannie.tex"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "armor_littleredannie", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "armor_littleredannie", "swap_body")
    inst.components.container:Open(owner)
    
end

local function onunequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
    owner.AnimState:ClearOverrideSymbol("backpack")
    inst.components.container:Close(owner)
end

local function fn()
	local inst = CreateEntity()
    
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("armor_littleredannie")
    inst.AnimState:SetBuild("armor_littleredannie")
    inst.AnimState:PlayAnimation("anim")

    inst.MiniMapEntity:SetIcon("armor_littleredannie.png")
    inst:AddTag("fridge")
    inst:AddTag("nocool")
    
    inst.foleysound = "dontstarve/movement/foley/backpack"

if not TheWorld.ismastersim then
    inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("backpack") end
    return inst
end

    inst.entity:SetPristine()
    
    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.keepondeath = true
	inst.components.inventoryitem.imagename = "armor_littleredannie"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/armor_littleredannie.xml"
	inst.components.inventoryitem.cangoincontainer = true

    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.BODY

    
    inst.components.equippable:SetOnEquip(onequip)
    inst.components.equippable:SetOnUnequip(onunequip)

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("backpack")

    MakeHauntableLaunchAndDropFirstItem(inst)

    return inst
end

return Prefab("common/inventory/armor_littleredannie", fn, assets)