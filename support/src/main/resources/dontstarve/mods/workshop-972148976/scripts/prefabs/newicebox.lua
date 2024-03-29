require "prefabutil"

local assets=
{
	Asset("ANIM", "anim/newicebox.zip"),
	Asset("ANIM", "anim/ui_chest_3x5.zip"),
	Asset("ANIM", "anim/newiceboxs.zip"),
	Asset("ANIM","anim/ui_chest_4x6.zip"),
}
local prefabs =
{
    "collapse_big",
}

local function onopen(inst)
	inst.AnimState:PlayAnimation("open")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	for i = 10 , 12 do
        local item = inst.components.container:GetItemInSlot(i)
        if item and item.components.perishable then
            item.components.perishable.localPerishMultiplyer = 1
        end
    end
end 

local function onclose(inst)
	inst.AnimState:PlayAnimation("close")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	for i = 10 , 12 do
        local item = inst.components.container:GetItemInSlot(i)
        if item and item.components.perishable then
            item.components.perishable.localPerishMultiplyer = 0
        end
    end
end 

local function onopens(inst)
	inst.AnimState:PlayAnimation("open")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_open")
	for i = 13 , 20 do
        local item = inst.components.container:GetItemInSlot(i)
        if item and Platform ~= "TGP" then
        	if item.components.perishable then
		        item.components.perishable.localPerishMultiplyer = 1
	        elseif item.components.fueled then
	        	item.components.fueled:SetPercent(math.min(1,item.components.fueled:GetPercent() + (GetTime() - inst.closetme) / 4800))
        	end
        end
    end
end 

local function oncloses(inst)
	inst.AnimState:PlayAnimation("close")
	inst.SoundEmitter:PlaySound("dontstarve/wilson/chest_close")
	for i = 13 , 20 do
        local item = inst.components.container:GetItemInSlot(i)
        if item and Platform ~= "TGP" then
            if item.components.perishable then
	            item.components.perishable.localPerishMultiplyer = 0
	        elseif item.components.fueled then
	        --    item.components.fueled:SetPercent(1)
	        	--item.currentTempRange = 1
	        end
        end
    end
	inst.closetme = GetTime()
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

local function onsave( inst , date )
	-- body
end

local function onload( inst , date )
	if inst.prefab == "newicebox" then
		for i = 10 , 12 do
	        local item = inst.components.container:GetItemInSlot(i)
	        if item and item.components.perishable then
	            item.components.perishable.localPerishMultiplyer = 0
	        end
	    end
	elseif inst.prefab == "newiceboxs" then
		for i = 13 , 20 do
	        local item = inst.components.container:GetItemInSlot(i)
	        if item and Platform ~= "TGP" then
	        	if item.components.perishable then
			        item.components.perishable.localPerishMultiplyer = 0
		        elseif item.components.fueled then

	        	end
	        end
	    end
	end
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
		inst.components.container:WidgetSetup("newicebox")
		inst.components.container.onopenfn = onopen
		inst.components.container.onclosefn = onclose

		inst:AddComponent("lootdropper")

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(5)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)

		inst.OnLoad = onload

	return inst
end

local function fns(Sim)
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

		inst.AnimState:SetBank("newiceboxs")
		inst.AnimState:SetBuild("newiceboxs")
		inst.AnimState:PlayAnimation("close") -- , true

		inst.entity:SetPristine()

		if not TheWorld.ismastersim then
			return inst
		end

		inst:AddComponent("inspectable")
		inst:AddComponent("container")
		inst.components.container:WidgetSetup("newiceboxs")
		inst.components.container.onopenfn = onopens
		inst.components.container.onclosefn = oncloses

		inst:AddComponent("lootdropper")

		inst:AddComponent("workable")
		inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
		inst.components.workable:SetWorkLeft(5)
		inst.components.workable:SetOnFinishCallback(onhammered)
		inst.components.workable:SetOnWorkCallback(onhit)

		inst.closetme = 0
		inst.OnLoad = onload

	return inst
end

return Prefab( "newicebox", fn, assets, prefabs),
	MakePlacer("newicebox_placer", "newicebox", "newicebox", "close"),
	Prefab( "newiceboxs", fns, assets, prefabs),
	MakePlacer("newiceboxs_placer", "newiceboxs", "newiceboxs", "close") 
