
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {"acehat",
}

local start_inv = {
	-- Custom starting items
	"acehat",
	"acefire",
}

local function Sparkle(inst)
    SpawnPrefab("firesplash_fx").entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
    inst:DoTaskInTime(math.random(8, 10), Sparkle)
end

local function RestoreLight(inst)
    inst.Light:Enable(true)
	inst.Light:SetRadius(1)
    inst.Light:SetFalloff(.6)
    inst.Light:SetIntensity(0.9)
    inst.Light:SetColour(255/255,102/155,0/255)
end

-- This initializes for both clients and the host
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "ace.tex" )
	inst:AddTag("acespecific")
end
 
local function startfirebug(inst)
    inst.components.firebug:Enable()
end

local function stopfirebug(inst)
    inst.components.firebug:Disable()
end

local function sanityfn(inst)
	local x,y,z = inst.Transform:GetWorldPosition()	
	local delta = 0
	local max_rad = 10
	local ents = TheSim:FindEntities(x,y,z, max_rad, {"fire"})
    for k,v in pairs(ents) do 
    	if v.components.burnable and v.components.burnable.burning then
    		local sz = TUNING.SANITYAURA_TINY
    		local rad = v.components.burnable:GetLargestLightRadius() or 1
    		sz = sz * ( math.min(max_rad, rad) / max_rad )
			local distsq = inst:GetDistanceSqToInst(v)
			delta = delta + sz/math.max(1, distsq)
    	end
    end

    return delta
end
  
-- This initializes for the host only
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "wilson"
	-- Stats	
	inst.components.health.fire_damage_scale = 0
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(200)
    inst.components.sanity.custom_rate_fn = sanityfn
	inst.components.sanity.night_drain_mult = 1
	inst.components.sanity.neg_aura_mult = 1
	
    inst.components.combat.damagemultiplier = 1.3
	
	inst.components.temperature.mintemp = 20
	
	inst.entity:AddLight()
    inst.Light:Enable(true)
    inst.Light:SetRadius(1)
    inst.Light:SetFalloff(.6)
    inst.Light:SetIntensity(0.9)
    inst.Light:SetColour(255/255,102/155,0/255)
	
	inst:AddComponent("firebug")
    inst.components.firebug.prefab = "willowfire"
	inst.components.firebug.sanity_threshold = TUNING.WILLOW_LIGHTFIRE_SANITY_THRESH

	inst:DoTaskInTime(math.random(8, 10), Sparkle)
	
	inst:ListenForEvent("ms_respawnedfromghost", RestoreLight)

    inst:ListenForEvent("ms_respawnedfromghost", startfirebug)
    inst:ListenForEvent("ms_becameghost", stopfirebug)
    inst:ListenForEvent("death", stopfirebug)

    startfirebug(inst)	
end

return MakePlayerCharacter("ace", prefabs, assets, common_postinit, master_postinit, start_inv)
