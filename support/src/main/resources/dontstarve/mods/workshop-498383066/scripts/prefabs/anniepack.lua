local assets =
{
	Asset("ANIM", "anim/anniepack.zip"),
	Asset("ANIM", "anim/swap_anniepack.zip"),
    Asset("ATLAS", "images/inventoryimages/anniepack.xml"),
    Asset("IMAGE", "images/inventoryimages/anniepack.tex"),
}

local function onequip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_body", "swap_anniepack", "backpack")
    owner.AnimState:OverrideSymbol("swap_body", "swap_anniepack", "swap_body")
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

    inst.AnimState:SetBank("anniepack")
    inst.AnimState:SetBuild("anniepack")
    inst.AnimState:PlayAnimation("idle")

    inst.MiniMapEntity:SetIcon("anniepack.png")
    
    inst.foleysound = "dontstarve/movement/foley/backpack"

    inst.entity:SetPristine()

if not TheWorld.ismastersim then
    inst.OnEntityReplicated = function(inst) inst.replica.container:WidgetSetup("backpack") end
    return inst
end

    inst:AddComponent("inspectable")
    
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.keepondeath = true
	inst.components.inventoryitem.imagename = "anniepack"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/anniepack.xml"
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

return Prefab("common/inventory/anniepack", fn, assets)