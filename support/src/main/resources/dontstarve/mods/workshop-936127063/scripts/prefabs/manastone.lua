local assets=
{
    Asset("ANIM", "anim/manastone.zip"), -- a standard asset
    Asset("ATLAS", "images/inventoryimages/manastone.xml"),
    Asset("IMAGE", "images/inventoryimages/manastone.tex"),
}
 
local function fn()
  
    local inst = CreateEntity()
 
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
     
    MakeInventoryPhysics(inst)   
 
    inst.AnimState:SetBank("manastone")
    inst.AnimState:SetBuild("manastone")
    inst.AnimState:PlayAnimation("idle", true)
 
    if not TheWorld.ismastersim then
        return inst
    end
 
    inst.entity:SetPristine()
	
    inst:AddComponent("inspectable")	
	inst:AddTag("undroppable")
    inst:AddComponent("inventoryitem")
	
    inst.components.inventoryitem.imagename = "manastone"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/manastone.xml"
     
	
	 
    return inst
end
return  Prefab("common/inventory/manastone", fn, assets) 