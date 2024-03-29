PrefabFiles = {
	"globalicon_network",
	"globalicon",
}
GLOBAL.AllGlobalIcons = {}
GLOBAL.GlobalIconAtlasTranslation = {}

local function RecheckAllOwners()
	for _,v in pairs(GLOBAL.AllGlobalIcons) do
		v:OnOwnerDirty()
	end
end

local function AddGlobalPlayerIcon(inst)
	inst.MiniMapEntity:SetDrawOverFogOfWar(true)
	
	if GLOBAL.TheWorld.ismastersim then
		local neticon = GLOBAL.SpawnPrefab("globalicon_network")
		inst:ListenForEvent("onremove", function () neticon:Remove() end)
		neticon:DoTaskInTime(0, function() neticon:SetOwner(inst) end)
	else
		GLOBAL.TheWorld:DoTaskInTime(0, RecheckAllOwners)
	end
end

-- Hack to determine MiniMap icon names
local function ReadAllMiniMapAtlases()
	for i,atlases in ipairs(GLOBAL.ModManager:GetPostInitData("MinimapAtlases")) do
		for i,path in ipairs(atlases) do
			local file = GLOBAL.io.open(GLOBAL.resolvefilepath(path), "r")
			if file then
				local xml = file:read("*a")
				if xml then
					for element in string.gmatch(xml, "<Element[^>]*name=\"([^\"]*)\"") do
						if element then
							local elementName = string.match(element, "^(.*)[.]")
							if elementName then
								GLOBAL.GlobalIconAtlasTranslation[elementName] = element
							end
						end
					end
				end
				file:close()
			end
		end
	end
end

for k,prefabname in ipairs(GLOBAL.DST_CHARACTERLIST) do
	AddPrefabPostInit(prefabname, AddGlobalPlayerIcon)
end

if GLOBAL.MODCHARACTERLIST then
	for k,prefabname in ipairs(GLOBAL.MODCHARACTERLIST) do
		AddPrefabPostInit(prefabname, AddGlobalPlayerIcon)
	end
end

AddPrefabPostInit("world_network", function () 
	if GLOBAL.TheWorld.ismastersim then
		ReadAllMiniMapAtlases()
	else
		GLOBAL.TheWorld:ListenForEvent("playerexited", RecheckAllOwners)
	end
end)