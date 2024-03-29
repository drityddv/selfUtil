require "prefabutil"

local assets =
{
	Asset("ANIM", "anim/r_shelter.zip"),
    Asset("SOUND", "sound/common.fsb"),
}

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	SpawnPrefab("collapse_big").Transform:SetPosition(inst.Transform:GetWorldPosition())
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_wood")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle", true)
end

local function onbuilt(inst)
    inst:AddTag("lightningrod")
	inst.AnimState:PlayAnimation("idle")
	inst.AnimState:PushAnimation("idle", true)
    TheWorld:PushEvent("ms_sendlightningstrike", Vector3(inst.Transform:GetWorldPosition()))
end

local function onfinished(inst)
    inst.AnimState:PlayAnimation("trash")
    local smoke = SpawnPrefab("maxwell_smoke")
    local pos = inst:GetPosition()
    smoke.Transform:SetPosition(pos.x, pos.y, pos.z)
    smoke.Transform:SetScale(3,5,3)
    inst.SoundEmitter:PlaySound("dontstarve/common/fireAddFuel")
    inst:ListenForEvent("animover", inst.Remove)
    inst:DoTaskInTime(16 * FRAMES)
    inst.persists = false
end

local function OnHaunt(inst, haunter)
    inst.components.finiteuses:Use()
    return true
end

local function fn()
	local inst = CreateEntity()

	inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
    inst.entity:AddMiniMapEntity()
    inst.entity:AddNetwork()

	MakeObstaclePhysics(inst, 1)
	inst.Physics:SetCollisionGroup(COLLISION.OBSTACLES)
	inst.Physics:ClearCollisionMask()
	inst.Physics:CollidesWith(COLLISION.WORLD)
	inst.Physics:CollidesWith(COLLISION.ITEMS)

    inst.AnimState:SetBank("r_shelter")
    inst.AnimState:SetBuild("r_shelter")
    inst.AnimState:PlayAnimation("idle", true)

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "r_shelter.tex" )

    inst.entity:AddLight()
    inst.Light:Enable(false)
    inst.Light:SetColour(223/255, 208/255, 69/255)
    inst.Light:SetRadius(3)
    inst.Light:SetFalloff(4)
    inst.Light:SetIntensity(.5)

    inst:AddTag("shelter")

    inst:AddTag("resurrector")

    if not TheWorld.ismastersim then
        return inst
    end

    inst.entity:SetPristine()

	inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(4)
	inst.components.workable:SetOnFinishCallback(onhammered)
	inst.components.workable:SetOnWorkCallback(onhit)

	inst:AddComponent("inspectable")
	inst.components.inspectable:RecordViews()

	inst:AddComponent("hauntable")
	inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
    inst.components.hauntable:SetOnHauntFn(OnHaunt)

    inst:AddComponent("finiteuses")
    inst.components.finiteuses:SetMaxUses(ShelterUses)
    inst.components.finiteuses:SetUses(ShelterUses)
    inst.components.finiteuses:SetOnFinished(onfinished)

    inst:ListenForEvent("onbuilt", onbuilt)

    inst:DoPeriodicTask(1, function(inst)
    if ShelterLight and TheWorld.state.isnight 
    then
    inst.Light:Enable(true)    
    else
    inst.Light:Enable(false)
    end
end)

	return inst
end

return Prefab( "common/r_shelter", fn, assets),
	MakePlacer( "common/r_shelter_placer", "r_shelter", "r_shelter", "idle" ) 
