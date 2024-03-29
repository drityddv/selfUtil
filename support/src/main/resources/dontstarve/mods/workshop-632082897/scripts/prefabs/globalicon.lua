
local function fn()
    local inst = CreateEntity()
	
	inst.entity:SetCanSleep(false)
    inst.persists = false

	inst.entity:AddTransform()
	inst.entity:AddMiniMapEntity()
	
	inst.MiniMapEntity:SetIcon("wilson.png")
	inst.MiniMapEntity:SetPriority(10)
	inst.MiniMapEntity:SetCanUseCache(false)
	inst.MiniMapEntity:SetDrawOverFogOfWar(true)
	
	inst:AddTag("NOCLICK")
	inst:AddTag("NOBLOCK")
	
    return inst
end

return Prefab("globalicon", fn)
