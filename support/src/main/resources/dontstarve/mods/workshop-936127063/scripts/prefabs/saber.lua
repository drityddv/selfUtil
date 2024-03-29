
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {}

-- Custom starting items
local start_inv = {
	"manastone"
}

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when reviving from ghost (optional)
	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "saber_speed_mod", 1)
end

local function onbecameghost(inst)
	-- Remove speed modifier when becoming a ghost
   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "saber_speed_mod")
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
        onbecameghost(inst)
    else
        onbecamehuman(inst)
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	inst:AddTag("saber")
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "saber.tex" )
		
	local light = inst.entity:AddLight()
	light:SetColour(220/255, 220/255, 220/255)
	light:SetIntensity(0.8)
	light:SetRadius(2)
	light:SetFalloff(.33)
	inst.Light:Enable(true)
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "willow"
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(150)
	inst.components.health:SetMaxHealth(175)
	
	-- Start health regen
	inst.components.health:StartRegen(1,3)
	
	-- Damage multiplier (optional)
    inst.components.combat.damagemultiplier = 1.5
	
	-- Sanity multiplier (optional)
	inst.components.sanity.rate_modifier = 0.8
	
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1.1 * TUNING.WILSON_HUNGER_RATE
	
	-- Movement speed (optional)
	inst.components.locomotor.walkspeed = 5
	inst.components.locomotor.runspeed = 6.5	
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
	--[[local light = inst.entity:AddLight()
	light:SetColour(220/255, 220/255, 220/255)
	light:SetIntensity(0.8)
	light:SetRadius(2)
	light:SetFalloff(.33)
	inst.Light:Enable(true)]]
	
end

return MakePlayerCharacter("saber", prefabs, assets, common_postinit, master_postinit, start_inv)
