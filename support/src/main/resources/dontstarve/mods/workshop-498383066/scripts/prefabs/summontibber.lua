local brain = require "brains/summontibberbrain"

local assets = {
	Asset("ATLAS", "images/inventoryimages/summontibber.xml"),
	Asset("ANIM", "anim/tibber.zip"),
}

local prefabs = {
	"annie",
	"groundpound_fx",
	"groundpoundring_fx",
	"tibbersword",
}

local function SetGroundPounderSettings(inst, mode)
	if mode == "normal" then 
		inst.components.groundpounder2.damageRings = 2
		inst.components.groundpounder2.destructionRings = 2
		inst.components.groundpounder2.numRings = 3
	--[[elseif mode == "hibernation" then 
		inst.components.groundpounder.damageRings = 3
		inst.components.groundpounder.destructionRings = 3
		inst.components.groundpounder.numRings = 4]]
	end
end

local function OnSave(inst, data)
	data.cangroundpound = inst.cangroundpound
end

local function OnLoad(inst, data)
	if data ~= nil then
		inst.cangroundpound = data.cangroundpound
	end
end

local function ontimerdone(inst, data)
	if data.name == "GroundPound" then
		inst.cangroundpound = true
	end
end

local function ShouldAcceptItem(inst, item)
	local currenthealth = inst.components.health.currenthealth / inst.components.health.maxhealth
	if item.components.edible and currenthealth < 1 and item.components.edible.healthvalue > 0 then
		return true
	end
	if item.components.equippable and 
	(item.components.equippable.equipslot == EQUIPSLOTS.HEAD or 
	item.components.equippable.equipslot == EQUIPSLOTS.HANDS or 
	item.components.equippable.equipslot == EQUIPSLOTS.BODY) and 
	not item.components.projectile then
		if item.prefab == "batbat" then
			print("refusing batbat")
			return false
		end
		return true
	end
end

local function OnGetItemFromPlayer(inst, giver, item)
	if item.components.equippable and 
	(item.components.equippable.equipslot == EQUIPSLOTS.HEAD or 
	item.components.equippable.equipslot == EQUIPSLOTS.HANDS or 
	item.components.equippable.equipslot == EQUIPSLOTS.BODY) then     
		local newslot = item.components.equippable.equipslot
		local current = inst.components.inventory:GetEquippedItem(newslot)
		if current then
			inst.components.inventory:DropItem(current)
		end      
		inst.components.inventory:Equip(item)
	elseif item.components.edible then
		inst.components.health:DoDelta(item.components.edible:GetHunger(inst), nil, item.prefab)
		inst:PushEvent("oneatsomething", {food = item})
		inst.sg:GoToState("eat")
	end
end

local function OnRefuseItem(inst, item)
	inst.sg:GoToState("refuse")
	inst.components.talker:Say("...")
end

local function NormalRetargetFn(inst)
        return FindEntity(inst, TUNING.PIG_TARGET_DIST, function(guy)
                return guy:HasTag("monster") and guy.components.health and not guy.components.health:IsDead()
                and inst.components.combat:CanTarget(guy)
        end, nil, { "character" }, nil)
end

local function linkToBuilder(inst, builder)
	if not builder.components.leader then
		builder:AddComponent("leader")
	end
	builder.components.leader:AddFollower(inst, true)

	builder.components.health:DoDelta(-30, nil, nil, nil, nil, true)
    builder.components.sanity:DoDelta(-40)

	-- sound and anim reactions
    	if builder.components.combat.hurtsound ~= nil and builder.SoundEmitter ~= nil then
        	builder.SoundEmitter:PlaySound(builder.components.combat.hurtsound)
    	end

	builder:PushEvent("damaged", {})
end

local function OnAttacked(inst, data)
	local attacker = data.attacker
    inst.components.combat:SetTarget(attacker)
    inst.components.combat:ShareTarget(attacker, 30, function(dude)
		return dude:HasTag("summonedbyplayer") and dude.components.follower.leader == inst.components.follower.leader
	end, 5)
end

local function OnAttackOther(inst, data)
	local target = data.target
	inst.components.combat:ShareTarget(target, 30, function(dude)
		return dude:HasTag("summonedbyplayer") and dude.components.follower.leader == inst.components.follower.leader
	end, 5)
end

local function fn()
	local inst = CreateEntity()
	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddMiniMapEntity()
	inst.entity:AddSoundEmitter()
	inst.entity:AddDynamicShadow()
	inst.entity:AddNetwork()
	
	MakeCharacterPhysics(inst, 30, .3)
	
	inst.DynamicShadow:SetSize(2, 1.5)
	
	inst.Transform:SetFourFaced()
	inst.Transform:SetScale(4, 4, 4)

	inst.AnimState:SetBank("wilson")
	inst.AnimState:SetBuild("tibber")
	inst.AnimState:PlayAnimation("idle_loop", true)
	inst.AnimState:Hide("ARM_carry")
	inst.AnimState:Show("ARM_normal")
	
    inst.MiniMapEntity:SetIcon("summontibber.tex")
    inst.MiniMapEntity:SetPriority(4)
	
	inst:AddTag("summontibber")
	inst:AddTag("sheltercarrier")
	inst:AddTag("summonedbyplayer")
	inst:AddTag("scarytoprey")
	
	inst.entity:SetPristine()

	if not TheWorld.ismastersim then
		return inst
	end
	
	MakeMediumBurnableCharacter(inst, "pig_torso")
	
	inst:AddComponent("tibbercracker")
	
	inst:AddComponent("combat")
	inst.components.combat:SetDefaultDamage(30)
	inst.components.combat:SetAttackPeriod(2)
	inst.components.combat:SetRetargetFunction(3, NormalRetargetFn)
	
	local self = inst.components.combat
	local old = self.GetAttacked
	function self:GetAttacked(attacker, damage, weapon, stimuli)
		if attacker and (attacker.prefab == "tentacle" or attacker:HasTag("player")) then
			return true
		end
		return old(self, attacker, damage, weapon, stimuli)
	end
		
	inst:AddComponent("follower")
	
	inst:AddComponent("followersitcommand")
	
	inst:AddComponent("health")
	inst.components.health:SetMaxHealth(800)
	inst.components.health:StartRegen(10, 10)
	inst.components.health.fire_damage_scale = 0
	
	inst:AddComponent("inspectable")
	
	inst:AddComponent("groundpounder2")
	inst.components.groundpounder2.destroyer = true
	SetGroundPounderSettings(inst, "normal")
	--inst.components.groundpounder2.damageRings = 2
	--inst.components.groundpounder2.destructionRings = 2
	--inst.components.groundpounder2.numRings = 3
	
	inst:AddComponent("timer")

	inst:ListenForEvent("timerdone", ontimerdone)

	inst:AddComponent("inventory")
	
	inst:AddComponent("locomotor")
	inst.components.locomotor.runspeed = 1.7
	inst.components.locomotor.walkspeed = 1.2
	
	inst:AddComponent("lootdropper")
	
	inst:AddComponent("talker")
	inst.components.talker:StopIgnoringAll()
	
	inst:AddComponent("trader")
	inst.components.trader:SetAcceptTest(ShouldAcceptItem)
	inst.components.trader.deleteitemonaccept = false
	inst.components.trader.onaccept = OnGetItemFromPlayer
	inst.components.trader.onrefuse = OnRefuseItem
	inst.components.trader:Enable()
	
	inst:ListenForEvent("equip", function()
	inst.AnimState:ClearOverrideSymbol("swap_hat")
	inst.AnimState:Show("hair")
	inst.AnimState:ClearOverrideSymbol("swap_body")
	end)
	
	inst.cangroundpound = false
	
	inst.OnSave = OnSave
	inst.OnLoad = OnLoad

	inst:SetBrain(brain)
	inst:SetStateGraph("SGsummontibber")
	
	inst:AddComponent("perishable")
	inst.components.perishable:SetPerishTime(1.5*30*16*1)
	inst.components.perishable:StartPerishing()
	inst.components.perishable.onperishreplacement = "tibberdoll"

	inst:WatchWorldState("startnight", function()  
		inst.components.health:DoDelta(-10)  
	end)

	inst.OnBuilt = linkToBuilder
	
	inst:ListenForEvent("attacked", OnAttacked)  
	inst:ListenForEvent("onattackother", OnAttackOther)

	return inst
end

return Prefab("common/summontibber", fn, assets, prefabs)