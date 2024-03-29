local assets =
{ 
    Asset("ANIM", "anim/acehat.zip"),
    Asset("ANIM", "anim/acehat_swap.zip"), 

    Asset("ATLAS", "images/inventoryimages/acehat.xml"),
    Asset("IMAGE", "images/inventoryimages/acehat.tex"),
}

local prefabs = 
{
}

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

local function OnEquip(inst, owner) 
    owner.AnimState:OverrideSymbol("swap_hat", "acehat_swap", "swap_hat")

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

    inst.AnimState:SetBank("acehat")
    inst.AnimState:SetBuild("acehat")
    inst.AnimState:PlayAnimation("idle")

    inst:AddTag("hat")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()
	
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

    inst:AddComponent("inspectable")

    inst:AddComponent("tradable")

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "acehat"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/acehat.xml"
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    inst.components.equippable:SetOnEquip(OnEquip)
    inst.components.equippable:SetOnUnequip(OnUnequip)
	inst.components.inventoryitem.keepondeath = true
	
	inst:AddComponent("dapperness")
	inst.components.dapperness.dapperness = TUNING.DAPPERNESS_TINY

    MakeHauntableLaunch(inst)

    return inst
end

return  Prefab("common/inventory/acehat", fn, assets, prefabs)