local assets = {
	Asset("ANIM", "anim/tibbersword.zip"),
	Asset("ANIM", "anim/swap_tibbersword.zip"),

	Asset("ATLAS", "images/inventoryimages/tibbersword.xml"),
	Asset("IMAGE", "images/inventoryimages/tibbersword.tex")
}

local function OnEquip(inst, owner)
	owner.AnimState:OverrideSymbol("swap_object", "swap_tibbersword", "swap_tibbersword")
	owner.AnimState:Show("ARM_carry")
	owner.AnimState:Hide("ARM_normal")
end

local function OnUnequip(inst, owner)
	owner.AnimState:Hide("ARM_carry")
	owner.AnimState:Show("ARM_normal")
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddNetwork()
	
	MakeInventoryPhysics(inst)
	
	inst.AnimState:SetBank("tibbersword")
	inst.AnimState:SetBuild("tibbersword")
	inst.AnimState:PlayAnimation("idle")

	inst:AddTag("sharp")
	
	inst.entity:SetPristine()
	
	if not TheWorld.ismastersim then
		return inst
	end
	
	inst:AddComponent("equippable")
	inst.components.equippable:SetOnEquip(OnEquip)
	inst.components.equippable:SetOnUnequip(OnUnequip)
		
	inst:AddComponent("inspectable")
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(1.5*30*16*1)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "twigs"
	
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.imagename = "tibbersword"
	inst.components.inventoryitem.atlasname = "images/inventoryimages/tibbersword.xml"

	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(100)

	return inst
end

return Prefab("common/inventory/tibbersword", fn, assets)
