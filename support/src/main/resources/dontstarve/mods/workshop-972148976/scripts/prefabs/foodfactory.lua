require "prefabutil"

local assets=
{
	Asset("ANIM", "anim/newicebox.zip"),
	Asset("ANIM", "anim/ui_chest_3x5.zip"),
}
local prefabs =
{
    "collapse_big",
}
local function onopen(inst)
	inst.AnimState:PlayAnimation("open")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	--for i = 7 , 12 do
    --    local item = inst.components.container:GetItemInSlot(i)
    --    if item and item.components.perishable then
            --item.components.perishable.localPerishMultiplyer = 1
    --    end
    --end
end 

local function onclose(inst)
	inst.AnimState:PlayAnimation("close")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	for i = 1 , 6 do
        local item = inst.components.container:GetItemInSlot(i)
        if item and item.components.perishable then
            item.components.perishable.perishremainingtime = 0
        end
    end
	for i = 7 , 12 do
        local item = inst.components.container:GetItemInSlot(i)
        if item and item.components.perishable then
            --item.components.perishable.localPerishMultiplyer = 0
            item.components.perishable.perishremainingtime = item.components.perishable.perishtime
        end
    end
    inst.components.container.canbeopened = false
    inst:DoTaskInTime(2, function()
		inst.AnimState:PlayAnimation("close")
	    --inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
		inst.components.container.canbeopened = true
	end)
	print("-----------",TheSim.RAILGetPlatform,TheSim.RAILGetPlatform and TheSim.RAILGetPlatform:RAILGetPlatform())
end 

local function onhammered(inst, worker)
	inst.components.lootdropper:DropLoot()
	if inst.components.container ~= nil then
		inst.components.container:DropEverything()
	end
	local fx = SpawnPrefab("collapse_big")
	fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
	fx:SetMaterial("metal")
	inst:Remove()
end

local function onhit(inst, worker)
	--inst.AnimState:PlayAnimation("hit")
	inst.components.container:DropEverything()
	inst.AnimState:PushAnimation("close", false)
	if inst.components.container ~= nil then
		inst.components.container:Close()
	end
end

local function onbuilt(inst)
	--inst.AnimState:PlayAnimation("place")
	inst.AnimState:PushAnimation("close")
end

local function fn(Sim)
	local inst = CreateEntity()
		inst.entity:AddTransform()
		inst.entity:AddAnimState()
		inst.entity:AddSoundEmitter()
		inst.entity:AddMiniMapEntity()
		inst.entity:AddNetwork()

		inst.MiniMapEntity:SetIcon("newicebox.tex")

		inst:AddTag("structure")
		inst:AddTag("fridge")
		inst:AddTag("newicebox")

		inst.AnimState:SetBank("newicebox")
		inst.AnimState:SetBuild("newicebox")
		inst.AnimState:PlayAnimation("close") -- , true

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inspectable")

		inst:AddComponent("container")
		inst.components.container:WidgetSetup("foodfactory")
		inst.components.container.onopenfn = onopen
		inst.components.container.onclosefn = onclose

		inst:AddComponent("lootdropper")


		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(5)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)


	return inst
end

return Prefab( "foodfactory", fn, assets, prefabs),
			 MakePlacer("foodfactory_placer", "foodfactory", "foodfactory", "close") 
