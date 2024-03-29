local assets =
{
    Asset("ANIM", "anim/abigailflower.zip"),
	
	Asset("ATLAS", "images/inventoryimages/abigailflower.xml"),
    Asset("IMAGE", "images/inventoryimages/abigailflower.tex"),
	Asset("ATLAS", "images/inventoryimages/abigailflower2.xml"),
    Asset("IMAGE", "images/inventoryimages/abigailflower2.tex"),
	Asset("ATLAS", "images/inventoryimages/abigailflowerhaunted.xml"),
    Asset("IMAGE", "images/inventoryimages/abigailflowerhaunted.tex"),
}

local prefabs =
{
    "sakura_ghost",
}

local function getstatus(inst)
    if inst._chargestate == 3 then
        return inst.components.inventoryitem.owner ~= nil and
            "HAUNTED_POCKET" or "HAUNTED_GROUND"
    end

    local time_charge = inst.components.cooldown:GetTimeToCharged()
    if time_charge < TUNING.TOTAL_DAY_TIME * .5 then
        return "SOON"
    elseif time_charge < TUNING.TOTAL_DAY_TIME * 2 then
        return "MEDIUM"
    else
        return "LONG"
    end
end

local function activate(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/haunted_flower_LP", "loop")
    inst:ListenForEvent("entity_death", inst._onentitydeath, TheWorld)
end

local function deactivate(inst)
    inst.SoundEmitter:KillAllSounds()
    inst:RemoveEventCallback("entity_death", inst._onentitydeath, TheWorld)
end

local function IsValidLink(inst, player)
    return player.prefab == "sakura" and player.abigail == nil
end

local function updatestate(inst)
    print("Updating state...")
    print("Charged:",inst.components.cooldown:IsCharged())
    if inst._playerlink ~= nil and inst.components.cooldown:IsCharged() then
        if inst._chargestate ~= 3 then
            inst._chargestate = 3
            inst.components.inventoryitem.atlasname = "images/inventoryimages/abigailflowerhaunted.xml"
            inst.components.inventoryitem:ChangeImageName("abigailflowerhaunted")
            inst.AnimState:PlayAnimation("haunted_pre")
            inst.AnimState:PushAnimation("idle_haunted_loop", true)
            inst.AnimState:SetBloomEffectHandle("shaders/anim.ksh")
            if inst.components.inventoryitem.owner == nil then
                activate(inst)
            end
        end
    else
        if inst._chargestate == 3 then
            inst.AnimState:SetBloomEffectHandle("")
            deactivate(inst)
        end
        if inst._playerlink ~= nil and inst.components.cooldown:GetTimeToCharged() < TUNING.TOTAL_DAY_TIME then
            if inst._chargestate ~= 2 then
                inst._chargestate = 2
                inst.components.inventoryitem.atlasname = "images/inventoryimages/abigailflower2.xml"
                inst.components.inventoryitem:ChangeImageName("abigailflower2")
                inst.AnimState:PlayAnimation("idle_2")
            end
        elseif inst._chargestate ~= 1 then
            inst._chargestate = 1
            inst.components.inventoryitem.atlasname = "images/inventoryimages/abigailflower.xml"
            inst.components.inventoryitem:ChangeImageName("abigailflower")
            inst.AnimState:PlayAnimation("idle_1")
        end
    end
end

local function ondeath(inst, deadthing)
    print("Something died next to me")
    print("chargestate:",inst._chargestate)
    print(inst.components.cooldown:GetDebugString())
    if inst._chargestate == 3 and
        inst._playerlink ~= nil and
        inst._playerlink.abigail == nil and
        inst._playerlink.components.leader ~= nil and
        inst.components.inventoryitem.owner == nil and
        deadthing ~= nil and
        not deadthing:HasTag("wall") and
        inst:GetDistanceSqToInst(deadthing) < 256 --[[16 * 16]] then

        inst._playerlink.components.sanity:DoDelta(-TUNING.SANITY_HUGE)
        local abigail = SpawnPrefab("sakura_ghost")
        if abigail ~= nil then
            abigail.Transform:SetPosition(inst.Transform:GetWorldPosition())
            abigail.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")
            abigail:LinkToPlayer(inst._playerlink)
            inst:Remove()
        end
    end
end

local function linktoplayer(inst, player)
    if player ~= nil and IsValidLink(inst, player) then
        inst:ListenForEvent("onremove", inst._onremoveplayer, player)
        inst:ListenForEvent("killed", inst._onplayerkillthing, player)
        inst._playerlink = player
        player.sakura_ghost_flowers[inst] = true
    end
end

local function unlink(inst)
    if inst._playerlink ~= nil then
        inst:RemoveEventCallback("onremove", inst._onremoveplayer, inst._playerlink)
        inst:RemoveEventCallback("killed", inst._onplayerkillthing, inst._playerlink)
        inst._playerlink.sakura_ghost_flowers[inst] = nil
        inst._playerlink = nil
    end
end

local function storeincontainer(inst, container)
    if container ~= nil and container.components.container ~= nil then
        inst:ListenForEvent("onopen", inst._ontogglecontainer, container)
        inst:ListenForEvent("onclose", inst._ontogglecontainer, container)
        inst._container = container
    end
end

local function unstore(inst)
    if inst._container ~= nil then
        inst:RemoveEventCallback("onopen", inst._ontogglecontainer, inst._container)
        inst:RemoveEventCallback("onclose", inst._ontogglecontainer, inst._container)
        inst._container = nil
    end
end

local function topocket(inst, owner)
    deactivate(inst)
    if inst._container ~= owner then
        unstore(inst)
        storeincontainer(inst, owner)
    end
    if owner.components.container ~= nil then
        owner = owner.components.container.opener
    end
    if inst._playerlink ~= owner then
        unlink(inst)
        linktoplayer(inst, owner)
        updatestate(inst)
    end
end

local function toground(inst)
    unstore(inst)
    if inst._chargestate == 3 then
        activate(inst)
    end
end

local function refresh(inst)
    if inst._playerlink == nil then
        local owner = inst.components.inventoryitem.owner
        if owner ~= nil then
            if owner.components.container ~= nil then
                owner = owner.components.container.opener
            end
            linktoplayer(inst, owner)
            updatestate(inst)
        end
    elseif not IsValidLink(inst, inst._playerlink) then
        unlink(inst)
        updatestate(inst)
    end
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

    inst.AnimState:SetBank("abigail_flower")
    inst.AnimState:SetBuild("abigail_flower")
    inst.AnimState:PlayAnimation("idle_1")

    MakeInventoryPhysics(inst)
    
    inst.MiniMapEntity:SetIcon("abigailflower.png")
    
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
	
	inst:AddComponent("chosensakura")
    inst:ListenForEvent("onputininventory", topocket)
    inst:ListenForEvent("ondropped", toground)

    inst._chargestate = nil
    inst._playerlink = nil
    inst._container = nil

    inst._onremoveplayer = function()
        unlink(inst)
        updatestate(inst)
    end

    inst._onplayerkillthing = function(player, data)
        ondeath(inst, data.victim)
    end

    inst._onentitydeath = function(world, data)
        ondeath(inst, data.inst)
    end

    inst._ontogglecontainer = function(container)
        topocket(inst, container)
    end

    inst._onremovecontainer = function(container)
        unstore(inst)
    end

    inst:AddComponent("inventoryitem")
    inst.components.inventoryitem.atlasname = "images/inventoryimages/abigailflower.xml"
    inst.components.inventoryitem.imagename = "abigailflower"
    -----------------------------------
    
    inst:AddComponent("inspectable")
    inst.components.inspectable.getstatus = getstatus

    inst:AddComponent("cooldown")
    inst.components.cooldown.cooldown_duration = TUNING.TOTAL_DAY_TIME + math.random()*TUNING.TOTAL_DAY_TIME*2
    inst.components.cooldown.onchargedfn = updatestate
    inst.components.cooldown.startchargingfn = updatestate
    inst.components.cooldown:StartCharging()
    
    inst:WatchWorldState("phase", updatestate)
    updatestate(inst)

    inst:ListenForEvent("onputininventory", topocket)
    inst:ListenForEvent("ondropped", toground)

    MakeHauntableLaunch(inst)

    inst.OnRemoveEntity = unlink
    inst.Refresh = refresh

    return inst
end

return Prefab("common/inventoryitem/sakura_ghost_flower", fn, assets, prefabs)