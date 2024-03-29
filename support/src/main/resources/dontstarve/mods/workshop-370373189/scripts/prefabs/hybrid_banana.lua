local assets=
{
	Asset("ANIM", "anim/hybrid_banana.zip"),
	Asset("ATLAS", "images/inventoryimages/hybrid_banana.xml"),
	Asset("ATLAS", "images/inventoryimages/hybrid_banana_cooked.xml")
}

local prefabs =
{
	"hybrid_banana",
	"hybrid_banana_cooked",
	"spoiled_food",	
}    

	local function raw()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("hybrid_banana")
	inst.AnimState:SetBuild("hybrid_banana")
	inst.AnimState:PlayAnimation("raw", true)
	inst.Transform:SetScale(3,3,3)    

    if not TheWorld.ismastersim then
    return inst
end

    inst.entity:SetPristine()

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_MED
	inst.components.edible.hungervalue = TUNING.CALORIES_MED
	inst.components.edible.sanityvalue = TUNING.SANITY_MED
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hybrid_banana.xml"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
        
	inst:AddComponent("bait")

	inst:AddComponent("cookable")
	inst.components.cookable.product = "hybrid_banana_cooked"

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

local function cooked()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
    inst.entity:AddNetwork()

	MakeInventoryPhysics(inst)

	inst.AnimState:SetBank("hybrid_banana")
	inst.AnimState:SetBuild("hybrid_banana")
	inst.AnimState:PlayAnimation("cooked")
	inst.Transform:SetScale(3,3,3)

    if not TheWorld.ismastersim then
    return inst
end

    inst.entity:SetPristine()

	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(TUNING.PERISH_MED)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "spoiled_food"

	inst:AddComponent("edible")
	inst.components.edible.healthvalue = TUNING.HEALING_MED
	inst.components.edible.hungervalue = TUNING.CALORIES_MED
	inst.components.edible.sanityvalue = TUNING.SANITY_MED
	inst.components.edible.foodtype = FOODTYPE.VEGGIE

    inst:AddComponent("stackable")
	inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

	inst:AddComponent("inspectable")

	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/hybrid_banana_cooked.xml"

	MakeSmallBurnable(inst)
	MakeSmallPropagator(inst)
        
	inst:AddComponent("bait")

	MakeHauntableLaunchAndPerish(inst)

	return inst
end

return Prefab( "hybrid_banana", raw, assets, prefabs),
	Prefab( "hybrid_banana_cooked", cooked, assets)