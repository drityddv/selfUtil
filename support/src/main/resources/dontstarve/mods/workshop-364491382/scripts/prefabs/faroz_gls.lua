local assets=
{
	Asset("ANIM", "anim/faroz_gls.zip"),
	Asset("ATLAS", "images/inventoryimages/faroz_gls.xml")
}

local function saniup(inst)
	if inst.isWeared and not inst.isDropped then
		inst:AddComponent("dapperness")
		inst.components.dapperness.dapperness = 1
	end
end

local function onequip(inst, owner) 
        owner.AnimState:OverrideSymbol("swap_hat", "faroz_gls", "swap_hat")
        owner.AnimState:Show("HAT")
        owner.AnimState:Show("HAT_HAIR")
        owner.AnimState:Hide("HAIR_NOHAT")
        owner.AnimState:Hide("HAIR")
		
		inst.isWeared = true
		inst.isDropped = false
		saniup(inst)
end

local function onunequip(inst, owner) 
        owner.AnimState:Hide("HAT")
        owner.AnimState:Hide("HAT_HAIR")
        owner.AnimState:Show("HAIR_NOHAT")
        owner.AnimState:Show("HAIR")
		
		inst.isWeared = false
		inst.isDropped = false
		saniup(inst)
end

local function ondrop(inst)
	inst.isDropped = true
	inst.isWeared = false
	saniup(inst)
end

local function fn(Sim)
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork()
    
    inst:AddTag("hat")
    
	inst.isWeared = false
	inst.isDropped = false
	
    anim:SetBank("beehat")
    anim:SetBuild("faroz_gls")
    anim:PlayAnimation("anim")    
        
    inst:AddComponent("inspectable")
    
    inst:AddTag("irreplaceable")
	
	--local light = inst.entity:AddLight()
    --light:SetFalloff(0.4)
    --light:SetIntensity(.8)
    --light:SetRadius(5)
    --light:SetColour(30/255, 215/255, 30/255)
    --light:Enable(false)
	
	if not TheWorld.ismastersim then
        return inst
    end
    
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/faroz_gls.xml"
    
    
    inst:AddComponent("equippable")
    inst.components.equippable.equipslot = EQUIPSLOTS.HEAD
    
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )
	inst.components.inventoryitem:SetOnDroppedFn( ondrop )
	
	--[[
	inst:ListenForEvent( "dusktime", function() saniup(inst) end , GetWorld())
    inst:ListenForEvent( "daytime", function() saniup(inst) end , GetWorld())
    inst:ListenForEvent( "nighttime", function() saniup(inst) end , GetWorld())
    --]]
	
	inst:ListenForEvent("phasechanged", function() saniup(inst) end, TheWorld)
	
    return inst
end

return Prefab( "common/inventory/faroz_gls", fn, assets) 
