local PHYSICS_RADIUS = .15

local assets =
{
	Asset("ANIM", "anim/box.zip"),
	Asset("ANIM", "anim/box_full.zip"),
	Asset("ANIM", "anim/swap_box_full.zip"),
	Asset("ATLAS", "images/inventoryimages/box.xml"),
	Asset("IMAGE", "images/inventoryimages/box.tex"),
	Asset("ATLAS", "images/inventoryimages/box_full.xml"),
	Asset("IMAGE", "images/inventoryimages/box_full.tex"),
}

----------------------------------

local function OnPack(inst, unpackedEntity)
	local pt = inst:GetPosition()
	
	SpawnPrefab("die_fx").Transform:SetPosition(pt:Get())
end

local function OnUnpack(inst, unpacked, unpacker)
	local pt = inst:GetPosition()
	unpacker.components.inventory:GiveItem(SpawnPrefab("moving_box"), nil, pt)
	
	SpawnPrefab("die_fx").Transform:SetPosition(pt:Get())
	
	inst:Remove()
end

local function OnUnequip(inst, owner)
    owner.AnimState:ClearOverrideSymbol("swap_body")
end

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_body", "swap_box_full", "swap_body")
end

local function OnBurnt(inst)
    if inst.components.package ~= nil then
        inst.components.package:Empty()
    end

    SpawnPrefab("ash").Transform:SetPosition(inst.Transform:GetWorldPosition())

    inst:Remove()
end

local function OnDrop(inst)
	inst.Physics:SetVel(0, 0, 0)
end

local function common()
	local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)
	
    inst.AnimState:SetBank("box")
    inst.AnimState:SetBuild("box")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("nonpotatable")
	
    inst.entity:SetPristine()

    if not TheWorld.ismastersim or not TheNet:GetIsServer() then
		return inst
    end
	
	--------
	
    inst:AddComponent("inspectable")
	
	inst:AddComponent("package")
	inst.components.package:SetOnPackFn(OnPack)
	inst.components.package:SetOnUnpackFn(OnUnpack)

    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.cangoincontainer = true
	inst.components.inventoryitem.imagename = "box"	
    inst.components.inventoryitem.atlasname = "images/inventoryimages/box.xml"
	
	MakeMediumBurnable(inst)
    MakeMediumPropagator(inst)
    inst.components.burnable:SetOnBurntFn(OnBurnt)

    return inst
end

local function full()
    local inst = common()
	
	MakeSmallHeavyObstaclePhysics(inst, PHYSICS_RADIUS)
	
	inst.AnimState:SetBank("box_full")
    inst.AnimState:SetBuild("swap_box_full")
    inst.AnimState:PlayAnimation("idle")
	
	inst:AddTag("full")
	inst:AddTag("heavy")
	inst:AddTag("irreplaceable")

    if not TheWorld.ismastersim or not TheNet:GetIsServer() then
		return inst
    end
	
	--------

	inst.components.inventoryitem.cangoincontainer = false
	inst.components.inventoryitem.imagename = "box_full"	
    inst.components.inventoryitem.atlasname = "images/inventoryimages/box_full.xml"
	inst.components.inventoryitem:SetOnDroppedFn(OnDrop)
	
	inst:AddComponent("heavyobstaclephysics")
	inst.components.heavyobstaclephysics:SetRadius(PHYSICS_RADIUS)
	inst.components.heavyobstaclephysics:MakeSmallObstacle()
			
	inst:AddComponent("equippable")
	inst.components.equippable.equipslot = EQUIPSLOTS.BODY
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.equippable.walkspeedmult = 0.25

    return inst
end	
	
return Prefab("moving_box", common, assets),
		Prefab("moving_box_full", full, assets)
