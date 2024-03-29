
local function UpdatePositionFromOwner(inst)
	if inst and inst.owner then
		local x, y, z = inst.owner.Transform:GetWorldPosition()
	
		inst.net_x:set(x)
		inst.net_y:set(z)
	end
end

local function OnRemove(inst)
	RemoveByValue(AllGlobalIcons, inst)
end

local function UpdateIconPosition(inst)
	if inst.icon then
		inst.icon.Transform:SetPosition(inst.net_x:value(), 0, inst.net_y:value())
	end
end

local function OnIconNameDirty(inst)	
	if inst.icon then
		inst.icon.MiniMapEntity:SetIcon(inst.net_iconname:value())
	end
end

local function OnOwnerDirty(inst)
	if inst.net_owner == nil then
		return nil
	end
	
	inst.owner = inst.net_owner:value()
	
	if inst.icon then
		inst.icon.MiniMapEntity:SetEnabled(inst.owner == nil)
	end
end

local function GetIconName(inst, entity)
	-- Would be nice if there was a MiniMapEntity:GetIcon()
	if GlobalIconAtlasTranslation and GlobalIconAtlasTranslation[entity.prefab] then
		return GlobalIconAtlasTranslation[entity.prefab]
	end
	
	local textureName = entity.prefab .. ".png"
	return textureName
end

local function SetOwner(inst, entity)
	assert(entity)
	
	inst.owner = entity
	inst.net_owner:set(entity)
	inst.net_iconname:set(inst:GetIconName(entity))
end

local function fn()
    local inst = CreateEntity()
	
	if AllGlobalIcons == nil then
		AllGlobalIcons = {}
	end
 
    inst.entity:SetCanSleep(false)
    inst.persists = false

    inst.entity:AddNetwork()
    inst:AddTag("CLASSIFIED")
    inst.entity:SetPristine()
	
	inst.net_x = net_float(inst.GUID, "x")
	inst.net_y = net_float(inst.GUID, "y")
	inst.net_iconname = net_string(inst.GUID, "name", "iconname_dirty")
	inst.net_owner = net_entity(inst.GUID, "owner", "owner_dirty")
	
	inst.OnRemove = OnRemove
	inst.SetOwner = SetOwner
	inst.OnIconNameDirty = OnIconNameDirty
	inst.UpdatePositionFromOwner = UpdatePositionFromOwner
	inst.OnOwnerDirty = OnOwnerDirty
	inst.UpdateIconPosition = UpdateIconPosition
	inst.GetIconName = GetIconName
	
	inst:ListenForEvent("onremove", inst.OnRemove)
	
	local ICON_UPDATE_RATE = 0.1
	
	table.insert(AllGlobalIcons, inst)
	
    if not TheWorld.ismastersim then
		inst.icon = SpawnPrefab("globalicon")
		inst:AddChild(inst.icon)
		
		inst:DoPeriodicTask(ICON_UPDATE_RATE, function() inst:UpdateIconPosition() end)
		inst:ListenForEvent("iconname_dirty", OnIconNameDirty, inst)
		inst:ListenForEvent("owner_dirty", OnOwnerDirty, inst)
        return inst
    end
	
	inst:DoPeriodicTask(ICON_UPDATE_RATE, function() inst:UpdatePositionFromOwner() end)
    return inst
end

return Prefab("globalicon_network", fn)