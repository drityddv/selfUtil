
local assets=
{
    Asset("ANIM", "anim/acefire.zip"),
    Asset("ANIM", "anim/swap_acefire.zip"),
 
    Asset("ATLAS", "images/inventoryimages/acefire.xml"),
    Asset("IMAGE", "images/inventoryimages/acefire.tex"),
}

local function onattack_acefire(inst, attacker, target)

    if attacker and attacker.components.hunger then
        attacker.components.hunger:DoDelta(-3)
    end
end

local function storeincontainer(inst, container)
    if container ~= nil and container.components.container ~= nil then
        inst:ListenForEvent("onputininventory", inst._oncontainerownerchanged, container)
        inst:ListenForEvent("ondropped", inst._oncontainerownerchanged, container)
        inst._container = container
    end
end

local function unstore(inst)
    if inst._container ~= nil then
        inst:RemoveEventCallback("onputininventory", inst._oncontainerownerchanged, inst._container)
        inst:RemoveEventCallback("ondropped", inst._oncontainerownerchanged, inst._container)
        inst._container = nil
    end
end

local function topocket(inst, owner)
    if inst._container ~= owner then
        unstore(inst)
        storeincontainer(inst, owner)
    end
end

local function toground(inst)
    unstore(inst)
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
	
	inst.AnimState:SetBank("acefire")
    inst.AnimState:SetBuild("acefire")
    inst.AnimState:PlayAnimation("idle")
	
	if not TheWorld.ismastersim then
        return inst
    end
	
    local function OnEquip(inst, owner)
        owner.AnimState:OverrideSymbol("swap_object", "swap_acefire", "swap_acefire")
        owner.AnimState:Show("ARM_carry")
        owner.AnimState:Hide("ARM_normal")
    end
 
    local function OnUnequip(inst, owner)
        owner.AnimState:Hide("ARM_carry")
        owner.AnimState:Show("ARM_normal")
    end
	
	inst._container = nil
	
    inst._oncontainerownerchanged = function(container)
        topocket(inst, container)
    end

    inst._oncontainerremoved = function()
        unstore(inst)
    end
	
	inst:AddComponent("chosenace")
    inst:ListenForEvent("onputininventory", topocket)
    inst:ListenForEvent("ondropped", toground)
  
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.keepondeath = true
    inst.components.inventoryitem.imagename = "acefire"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/acefire.xml"
     
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	inst.components.inventoryitem.keepondeath = true
			
	inst:AddComponent("inspectable")
			
	inst:AddTag("shadow")
 	inst:AddComponent("weapon")
	inst.components.weapon:SetOnAttack(onattack_acefire)
    inst.components.weapon:SetDamage(30)
    inst.components.weapon:SetRange(8, 10)
	inst.components.weapon:SetProjectile("fire_projectile")

    return inst
	
end
	
return  Prefab("common/inventory/acefire", fn, assets)