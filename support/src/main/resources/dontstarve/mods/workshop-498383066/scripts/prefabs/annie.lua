
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),
}
local prefabs = {}

-- Custom starting items
local start_inv = {
	"anniepack",
	"tibberdoll",
	"anniefire",
}

-- When the character is revived from human
local function onbecamehuman(inst)
	-- Set speed when loading or reviving from ghost (optional)
	inst.components.locomotor.walkspeed = 6
	inst.components.locomotor.runspeed = 8.5
end

-- When loading or spawning the character
local function onload(inst)
    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)

    if not inst:HasTag("playerghost") then
        onbecamehuman(inst)
    end
end


-- This initializes for both the server and client. Tags can be added here.
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "annie.tex" )
	
	inst:AddTag("anniebuilder")
	inst:AddTag("anniespecific")
end

-- This initializes for the server only. Components are added here.
local master_postinit = function(inst)
	-- choose which sounds this character will play
	inst.soundsname = "willow"
	
	-- Uncomment if "wathgrithr"(Wigfrid) or "webber" voice is used
    --inst.talker_path_override = "dontstarve_DLC001/characters/"
	
	-- Stats	
	inst.components.health:SetMaxHealth(100)
	inst.components.hunger:SetMax(100)
	inst.components.sanity:SetMax(200)
	
	inst.components.health.SetPenalty = function(self, penalty)
    self.penalty = math.clamp(penalty, 0, 0)
	end
	
	inst.components.locomotor.walkspeed = 6 * 1,5
	inst.components.locomotor.runspeed = 8.5 * 1.5
	
	inst.Transform:SetScale(0.7, 0.7, 0.7)
	
    inst.components.combat.damagemultiplier = 0.75
		
	-- Hunger rate (optional)
	inst.components.hunger.hungerrate = 1 * TUNING.WILSON_HUNGER_RATE
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
end

return MakePlayerCharacter("annie", prefabs, assets, common_postinit, master_postinit, start_inv)
