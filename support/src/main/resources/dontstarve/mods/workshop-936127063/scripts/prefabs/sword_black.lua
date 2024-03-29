local assets=
{
    Asset("ANIM", "anim/sword_black.zip"),
    Asset("ANIM", "anim/swap_sword_black.zip"),
  
    Asset("ATLAS", "images/inventoryimages/sword_black.xml"),
    Asset("IMAGE", "images/inventoryimages/sword_black.tex"),
}
local function OnEquip(inst, owner)
    owner.AnimState:OverrideSymbol("swap_object", "swap_sword_black", "swap_sword_black")
    owner.AnimState:Show("ARM_carry")
    owner.AnimState:Hide("ARM_normal")
	
	owner.Light:Enable(true)
end
  
local function OnUnequip(inst, owner)
    owner.AnimState:Hide("ARM_carry")
    owner.AnimState:Show("ARM_normal")
	owner.Light:Enable(false)
end
 
local function ondrop(inst, dropper)
		inst.onuse = false
		inst.Light:Enable(true)
end

local function onpickup(inst, picker)
		inst.onuse = false
		inst.Light:Enable(false)
end

local function fn()
  
    local inst = CreateEntity()
 
    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()
     
    MakeInventoryPhysics(inst)   
      
    inst.AnimState:SetBank("sword_black")
    inst.AnimState:SetBuild("sword_black")
    inst.AnimState:PlayAnimation("idle")
 
    inst:AddTag("sharp")
	
	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "sword_black.tex" )
	
	local light = inst.entity:AddLight()
	light:SetColour(100/255, 1/255, 1/255)
	light:SetIntensity(0.8)
	light:SetRadius(2)
	light:SetFalloff(.33)
	inst.Light:Enable(false)
 
    if not TheWorld.ismastersim then
        return inst
    end
 
    inst.entity:SetPristine()
     
    inst:AddComponent("weapon")
    inst.components.weapon:SetDamage(50)
  
    inst:AddComponent("inspectable")
    inst:AddComponent("talker")  
    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.imagename = "sword_black"
    inst.components.inventoryitem.atlasname = "images/inventoryimages/sword_black.xml"
      
    inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( OnEquip )
    inst.components.equippable:SetOnUnequip( OnUnequip )
	
	inst.components.inventoryitem.keepondeath = true
	
	inst.components.inventoryitem.onputininventoryfn = function(inst, player)
		--If it's in their inventory
		local owner = inst.components.inventoryitem:GetGrandOwner()
		if player.components.inventory and player.prefab ~= "saber" then 
			inst:DoTaskInTime(0.1, function()
			
			player.components.inventory:DropItem(inst)
			inst.components.talker:Say("It's so heavy!")
			end)
		--If it's in a container		
		elseif player.components.container and owner.prefab ~= "saber" then 
			inst:DoTaskInTime(0.1, function()
			
			player.components.container:DropItem(inst)
			inst.components.talker:Say("It's so heavy, I can't put it in the backpack!")
			end)
		end
	end
     
    return inst
end
return  Prefab("common/inventory/sword_black", fn, assets) 