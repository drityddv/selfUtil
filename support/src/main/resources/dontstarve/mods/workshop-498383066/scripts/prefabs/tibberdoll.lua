local assets =
{
	Asset("ANIM", "anim/tibberdoll.zip"),
    Asset("ATLAS", "images/inventoryimages/tibberdoll.xml"),
	Asset("IMAGE", "images/inventoryimages/tibberdoll.tex"),
}

local prefabs = 
{
}

-- Still does nothing. Dunno what it should do...
local function fn(Sim)
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
    MakeInventoryPhysics(inst)

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()
    
	inst:AddTag("tibberdoll")
	
    inst.MiniMapEntity:SetIcon("tibberdoll.tex")
    inst.MiniMapEntity:SetPriority(5)
	
    if not TheWorld.ismastersim then
        return inst
    end
		
	inst.entity:SetPristine() 
    
    inst.AnimState:SetBank("tibberdoll")
    inst.AnimState:SetBuild("tibberdoll")
    inst.AnimState:PlayAnimation("idle", false)
	
    MakeHauntableLaunch(inst)
    inst:AddComponent("inspectable")
				
    inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "tibberdoll"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tibberdoll.xml"
	
    return inst
end

return Prefab( "common/inventory/tibberdoll", fn, assets) 