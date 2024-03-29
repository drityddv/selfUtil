require "prefabutil"

local assets=
{
	Asset("ANIM", "anim/cellar.zip"),
}

local function onopen(inst) 
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")		
    inst.AnimState:PlayAnimation("open")
end 

local function onclose(inst) 
	inst.AnimState:PlayAnimation("closed")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")		
end 

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	inst.components.container:DropEverything()
	inst.SoundEmitter:PlaySound("dontstarve/common/destroy_metal")
	inst:Remove()
end

local function onhit(inst, worker)
	inst.AnimState:PlayAnimation("closed")
	inst.components.container:DropEverything()
	inst.components.container:Close()
end

local function onbuilt(inst)
	inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("closed")	
end

local function fn(Sim)
	local inst = CreateEntity()
    inst.entity:AddTransform()
	inst.entity:AddAnimState()
	inst.entity:AddSoundEmitter()
	inst.entity:AddNetwork()

    MakeObstaclePhysics(inst, 1.5)    

	local minimap = inst.entity:AddMiniMapEntity()
	minimap:SetIcon( "cellar.tex" )

    if not TheWorld.ismastersim then
    return inst
    end

    inst.entity:SetPristine()	

    inst.AnimState:SetBank("cellar")
    inst.AnimState:SetBuild("cellar")
    inst.AnimState:PlayAnimation("closed", true)
    
    inst:AddComponent("inspectable")

    inst:AddComponent("container")
    inst.components.container:WidgetSetup("cellar")    
    inst.components.container.onopenfn = onopen
    inst.components.container.onclosefn = onclose
    
    inst:AddComponent("lootdropper")

    if chillit then
    inst:AddTag("fridge")
end

    if yep then
    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(5)
    inst.components.workable:SetOnFinishCallback(onhammered)
    inst.components.workable:SetOnWorkCallback(onhit)
end
    return inst
end

return Prefab( "common/cellar", fn, assets),
	MakePlacer("common/cellar_placer", "cellar", "cellar", "closed") 

