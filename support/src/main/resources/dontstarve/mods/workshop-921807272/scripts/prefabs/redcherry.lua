local assets=
{
	Asset("ANIM", "anim/redcherry.zip"),
	Asset("ANIM", "anim/swap_redcherry.zip"),
	Asset("ATLAS", "images/inventoryimages/redcherry.xml"),
	Asset("SOUNDPACKAGE", "sound/redcherry.fev"),
	Asset("SOUND", "sound/redcherry.fsb"),
}

local prefabs = {
}

local function toolpower(inst)
	inst:DoTaskInTime(0.2, function() 
		if TUNING.redcherrychop == 1 then
		    inst.components.tool:SetAction(ACTIONS.CHOP, math.ceil(inst.components.redcherrystatus.level/2000*16))
		end
	    if TUNING.redcherrymine == 1 then
		    inst.components.tool:SetAction(ACTIONS.MINE, 2)
		end
		if TUNING.redcherryhammer == 1 then
	    	inst.components.tool:SetAction(ACTIONS.HAMMER,1)
		end
		if TUNING.redcherrydig == 1 then
	    	inst.components.tool:SetAction(ACTIONS.DIG,1)
		end
		inst.components.equippable.walkspeedmult = math.ceil(100 + .3*inst.components.redcherrystatus.level/20)/100
	end)
end

local function animground(inst)
    inst:DoTaskInTime(0.2, function()
    	local anim = inst.entity:AddAnimState()
    	anim:SetBuild("redcherry")
	    local bank = "redcherry"
	    local level = inst.components.redcherrystatus.level
	    if level <200 then
			bank = "redcherry"
		end
		if level >=200 and level < 400 then
			bank = "redcherry_10"
		end
		if level >=400 and level < 600 then
			bank = "redcherry_20"
		end
		if level >=600 and level < 800 then
			bank = "redcherry_30"
		end
		if level >=800 and level < 1000 then
			bank = "redcherry_40"
		end
		if level >=1000 and level < 1200 then
			bank = "redcherry_50"
		end
		if level >=1200 and level < 1400 then
			bank = "redcherry_60"
		end
		if level >=1400 and level < 1600 then
			bank = "redcherry_70"
		end
		if level >=1600 and level < 1800 then
			bank = "redcherry_80"
		end
		if level >=1800 and level < 2000 then
			bank = "redcherry_90"
		end
		if level >=2000 then
			bank = "redcherry_100"
		end
	    anim:SetBank(bank)
	    anim:PlayAnimation("anim")
    end)
end

local function overridesymbol(inst, owner)
	inst:DoTaskInTime(0.2, function()
		local level = inst.components.redcherrystatus.level
		if level <200 then
			owner.AnimState:OverrideSymbol("swap_object", "swap_redcherry", "swap_redcherry")
		end
		if level >=200 and level < 400 then
			owner.AnimState:OverrideSymbol("swap_object", "swap_redcherry", "swap_redcherry_10")
		end
		if level >=400 and level < 600 then
			owner.AnimState:OverrideSymbol("swap_object", "swap_redcherry", "swap_redcherry_20")
		end
		if level >=600 and level < 800 then
			owner.AnimState:OverrideSymbol("swap_object", "swap_redcherry", "swap_redcherry_30")
		end
		if level >=800 and level < 1000 then
			owner.AnimState:OverrideSymbol("swap_object", "swap_redcherry", "swap_redcherry_40")
		end
		if level >=1000 and level < 1200 then
			owner.AnimState:OverrideSymbol("swap_object", "swap_redcherry", "swap_redcherry_50")
		end
		if level >=1200 and level < 1400 then
			owner.AnimState:OverrideSymbol("swap_object", "swap_redcherry", "swap_redcherry_60")
		end
		if level >=1400 and level < 1600 then
			owner.AnimState:OverrideSymbol("swap_object", "swap_redcherry", "swap_redcherry_70")
		end
		if level >=1600 and level < 1800 then
			owner.AnimState:OverrideSymbol("swap_object", "swap_redcherry", "swap_redcherry_80")
		end
		if level >=1800 and level < 2000 then
			owner.AnimState:OverrideSymbol("swap_object", "swap_redcherry", "swap_redcherry_90")
		end
		if level >=2000 then
			owner.AnimState:OverrideSymbol("swap_object", "swap_redcherry", "swap_redcherry_100")
		end
	end)
end

local function onequip(inst, owner) 
    overridesymbol(inst, owner)
    owner.AnimState:Show("ARM_carry") 
    owner.AnimState:Hide("ARM_normal")

    inst.components.finiteuses:SetUses(inst.components.redcherrystatus.level)

    toolpower(inst)

    if TUNING.redcherryarmor == 1 then
	    for k,v in pairs(owner.components.inventory.equipslots) do
	    	if v.components.armor then
	    		owner.components.inventory:Unequip(k)
	    		owner.components.inventory:GiveItem(v, nil)
	    	end
	    end
	    owner.cnoarmor = function(inst, data)
	        if data.item.components.armor then
	        	owner.components.inventory:Unequip(data.eslot)
	        	owner.components.inventory:GiveItem(data.item, nil)
	        end
	    end
	    owner:ListenForEvent("equip", owner.cnoarmor, owner)
	end
end

local function onunequip(inst, owner) 
    owner.AnimState:Hide("ARM_carry") 
    owner.AnimState:Show("ARM_normal")

    if TUNING.redcherryarmor == 1 then
    	owner:RemoveEventCallback("equip", owner.cnoarmor, owner)
    end
end

local function light(inst, owner)
    if inst._light ~= nil then
        inst._light:Remove()
    end
    inst._light = SpawnPrefab("minerhatlight")
    inst._light.Light:SetFalloff(1)
    inst._light.Light:SetIntensity(inst.components.redcherrystatus.level/2000*.25)
    inst._light.Light:SetRadius(inst.components.redcherrystatus.level/2000*1.6)
    inst._light.Light:SetColour(1,0.1,0.1)
    if owner == nil then
        inst._light.entity:SetParent(inst.entity)
    else
    	inst._light:Remove()
    end

    animground(inst)
end

local function targethp(inst, attacker, target, skipsanity, owner)
	if inst.components.inventoryitem.owner ~= nil then
		local ownerdamage = 1
		if inst.components.inventoryitem.owner.components.combat.damagemultiplier then
			ownerdamage = inst.components.inventoryitem.owner.components.combat.damagemultiplier
		end
		local value = math.ceil(inst.components.redcherrystatus.level/100*ownerdamage)
		local time = 3/(inst.components.redcherrystatus.level/20)^.5
		for i = 1, math.ceil(inst.components.redcherrystatus.level/200) do
			inst:DoTaskInTime(time*i, function()
				if target and target:IsValid() and target.components.health and target.components.health.currenthealth > 0 then
					target.components.combat:GetAttacked(attacker, value, inst)
				end
			end)
		end
	end
end

local function ownerhp(inst, attacker, target, skipsanity, owner)
	if inst.components.inventoryitem.owner ~= nil then
		local value = math.ceil(inst.components.redcherrystatus.level/680)
		local time = 3/(inst.components.redcherrystatus.level/20)^.5
		local owner = inst.components.inventoryitem.owner
		for i = 1, math.ceil(inst.components.redcherrystatus.level/200) do
			inst:DoTaskInTime(time*i, function()
				if owner and owner.components.health and owner.components.health.currenthealth < owner.components.health.maxhealth and owner.components.health.currenthealth > 0 then
					owner.components.health:DoDelta(value)
				end
			end)
		end
	end
end

local function attacksound(inst)
	local chance = math.random(0,7)
	local emitter = inst.components.inventoryitem.owner.SoundEmitter
	if chance <=1 then
		emitter:PlaySound("redcherry/attacksound/att01")
	end
	if chance >1 and chance <=2 then
		emitter:PlaySound("redcherry/attacksound/att02")
	end
	if chance >2 and chance <=3 then
		emitter:PlaySound("redcherry/attacksound/att03")
	end
	if chance >3 and chance <=4 then
		emitter:PlaySound("redcherry/attacksound/att04")
	end
	if chance >4 and chance <=5 then
		emitter:PlaySound("redcherry/attacksound/att05")
	end
	if chance >5 and chance <=6 then
		emitter:PlaySound("redcherry/attacksound/att06")
	end
	if chance >6 and chance <=7 then
		emitter:PlaySound("redcherry/attacksound/att07")
	end
end

local function onattack(inst, attacker, target, skipsanity, owner)
	inst.components.finiteuses:Use(-1)
	if target.components.freezable or target:HasTag("monster") and target.components.health then
		inst.components.redcherrystatus.level = inst.components.redcherrystatus.level + 1
		if inst.components.redcherrystatus.level >= 2000 then
			inst.components.redcherrystatus.level = 2000
		end
		targethp(inst, attacker, target, skipsanity, owner)
		ownerhp(inst, attacker, target, skipsanity, owner)
		if inst.components.inventoryitem.owner ~= nil then
			overridesymbol(inst, inst.components.inventoryitem.owner)
			animground(inst)
			--attacksound(inst)
		end
	end
	inst:DoTaskInTime(0.1, function() inst.components.finiteuses:SetUses(math.ceil(inst.components.redcherrystatus.level)) end)
	toolpower(inst)
end

local function fn()
	local inst = CreateEntity()
	local trans = inst.entity:AddTransform()
	local anim = inst.entity:AddAnimState()
	local sound = inst.entity:AddSoundEmitter()
    MakeInventoryPhysics(inst)
	inst.entity:AddNetwork() 
	
    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("redcherrystatus")
    animground(inst)
    
	inst:AddComponent("inventoryitem")
	inst.components.inventoryitem.atlasname = "images/inventoryimages/redcherry.xml"
	inst.components.inventoryitem:SetOnDroppedFn(light)
	inst.components.inventoryitem:SetOnPutInInventoryFn(light)
	
	inst:AddComponent("equippable")
    inst.components.equippable:SetOnEquip( onequip )
    inst.components.equippable:SetOnUnequip( onunequip )

    inst:AddComponent("tool")
	toolpower(inst)
	
	inst:AddComponent("inspectable")

	inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(2000)
    inst:DoTaskInTime(0.2, function() inst.components.finiteuses:SetUses(math.ceil(inst.components.redcherrystatus.level)) end)
	
	inst:AddComponent("weapon")
	inst.components.weapon:SetDamage(TUNING.MINIFAN_DAMAGE)
	inst.components.weapon:SetOnAttack(onattack)

    return inst
end


return Prefab("common/inventory/redcherry", fn, assets, prefabs) 
