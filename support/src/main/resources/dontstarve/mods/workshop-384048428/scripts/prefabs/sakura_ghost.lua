local assets =
{
	Asset("ANIM", "anim/ghost.zip"),
	Asset("ANIM", "anim/ghost_sakura_build.zip"),
	Asset("SOUND", "sound/ghost.fsb")
}

local brain = require("brains/abigailbrain")

local function Retarget(inst)
    return FindEntity(inst, 20, function(guy)
        return inst._playerlink ~= nil
            and inst.components.combat:CanTarget(guy)
            and (guy.components.combat.target == inst._playerlink or
                inst._playerlink.components.combat.target == guy)
            and guy.prefab ~= "tentacle"
    end)
end

local function OnAttacked(inst, data)
    local attacker = data.attacker
    if attacker ~= nil and attacker == inst._playerlink then
        inst.components.health:SetVal(0)
    else
        inst.components.combat:SetTarget(attacker)
    end
end

local function auratest(inst, target)
    if target and target.prefab == "tentacle" then
        return false
    end
 
    if target == inst._playerlink then
        return false
    end
 
    if inst.components.combat.target == target then
        return true
    end
 
    local leader = inst.components.follower.leader
    if target.components.combat.target ~= nil
        and (target.components.combat.target == inst or
            target.components.combat.target == leader) then
        return true
    end
 
    if leader ~= nil
        and (leader == target
            or (target.components.follower ~= nil and
                target.components.follower.leader == leader)) then
        return false
    end
 
    return not target:HasTag("player") and target:HasTag("monster") or target:HasTag("prey")
end

local function updatedamage(inst, phase)
    if phase == "day" then
        inst.components.combat.defaultdamage = TUNING.ABIGAIL_DAMAGE_PER_SECOND 
    elseif phase == "night" then
        inst.components.combat.defaultdamage = 2 * TUNING.ABIGAIL_DAMAGE_PER_SECOND     
    elseif phase == "dusk" then
        inst.components.combat.defaultdamage = TUNING.ABIGAIL_DAMAGE_PER_SECOND 
    end
end

local LOOT = { "sakura_ghost_flower" }

local function refreshcontainer(container)
    for i = 1, container:GetNumSlots() do
        local item = container:GetItemInSlot(i)
        if item ~= nil and item.prefab == "sakura_ghost_flower" then
            item:Refresh()
        end
    end
end

local function unlink(inst)
    inst._playerlink.sakura_ghost = nil
    local inv = inst._playerlink.components.inventory
    refreshcontainer(inv)

    local activeitem = inv:GetActiveItem()
    if activeitem ~= nil and activeitem.prefab == "sakura_ghost_flower" then
        activeitem:Refresh()
    end

    for k, v in pairs(inv.opencontainers) do
        refreshcontainer(k.components.container)
    end
end

local function linktoplayer(inst, player)
    inst.components.lootdropper:SetLoot(LOOT)
    inst.persists = false
    inst._playerlink = player
    player.sakura_ghost = inst
    player.components.leader:AddFollower(inst, true)
    for k, v in pairs(player.sakura_ghost_flowers) do
        k:Refresh()
    end
    player:ListenForEvent("onremove", unlink, inst)
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddLight()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("ghost")
    inst.AnimState:SetBuild("ghost_sakura_build")
    inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
    inst.AnimState:PlayAnimation("idle", true)
    --inst.AnimState:SetMultColour(1, 1, 1, .6)

    inst:AddTag("character")
    inst:AddTag("scarytoprey")
    inst:AddTag("girl")
    inst:AddTag("ghost")
    inst:AddTag("noauradamage")
    inst:AddTag("notraptrigger")
    inst:AddTag("abigail")
    inst:AddTag("sakuraghost")

    MakeGhostPhysics(inst, 1, .5)

    inst.Light:SetIntensity(.6)
    inst.Light:SetRadius(.5)
    inst.Light:SetFalloff(.6)
    inst.Light:Enable(true)
    inst.Light:SetColour(180 / 255, 195 / 255, 225 / 255)

    --It's a loop that's always on, so we can start this in our pristine state
    inst.SoundEmitter:PlaySound("dontstarve/ghost/ghost_girl_howl_LP", "howl")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

    inst:SetBrain(brain)
    
    inst:AddComponent("locomotor") -- locomotor must be constructed before the stategraph
    inst.components.locomotor.walkspeed = TUNING.ABIGAIL_SPEED * 1.25
    inst.components.locomotor.runspeed = TUNING.ABIGAIL_SPEED * 1.25
    
    inst:SetStateGraph("SGghost")

    inst:AddComponent("inspectable")
    
    inst:AddComponent("health")
    inst.components.health:SetMaxHealth(725)
    inst.components.health:StartRegen(1, 1)

	inst:AddComponent("combat")
    inst.components.combat.defaultdamage = TUNING.ABIGAIL_DAMAGE_PER_SECOND
    inst.components.combat.playerdamagepercent = TUNING.ABIGAIL_DMG_PLAYER_PERCENT
    inst.components.combat:SetRetargetFunction(3, Retarget)
	
	local self = inst.components.combat
	local old = self.GetAttacked
	function self:GetAttacked(attacker, damage, weapon, stimuli)
		if attacker and attacker.prefab == "tentacle" then
			return true
		end
		return old(self, attacker, damage, weapon, stimuli)
	end

    inst:AddComponent("aura")
    inst.components.aura.radius = 3
    inst.components.aura.tickperiod = 1
    inst.components.aura.ignoreallies = true
    inst.components.aura.auratestfn = auratest

    MakeHauntableGoToState(inst, "haunted", nil, 64*FRAMES*1.2)

    inst:AddComponent("lootdropper")
    ------------------    

    inst:AddComponent("follower")
    
    inst:ListenForEvent("attacked", OnAttacked)

    inst:WatchWorldState("phase", updatedamage)
    
    updatedamage(inst, TheWorld.state.phase)

    inst.LinkToPlayer = linktoplayer

    return inst
end

return Prefab("common/monsters/sakura_ghost", fn, assets)