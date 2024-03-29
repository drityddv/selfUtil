
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {
    Asset("SCRIPT", "scripts/prefabs/player_common.lua"),		
}
local prefabs = {
	"sakura_ghost_flower"
}
local start_inv = {
	-- Custom starting items
	"sakura_ghost_flower"
}

local function Darkness(inst)
    SpawnPrefab("attune_in_fx").entity:AddFollower():FollowSymbol(inst.GUID, "swap_body", 0, 0, 0)
    inst:DoTaskInTime(math.random(20, 25), Darkness)
end

local tempCaveVar = false 

local function updatestats(inst)

	if TheWorld.state.phase == "day" then
	

		inst.components.locomotor.walkspeed = (3.5)
		inst.components.locomotor.runspeed = (5)

		inst.components.sanity.dapperness = (TUNING.DAPPERNESS_SMALL * -3)
		
		inst.components.combat.damagemultiplier = 0.5
		
	   -- DAPPERNESS_TINY = 100/(day_time*15),
       -- DAPPERNESS_SMALL = 100/(day_time*10),
       -- DAPPERNESS_MED = 100/(day_time*6),
       -- DAPPERNESS_LARGE = 100/(day_time*3),
       -- DAPPERNESS_HUGE = 100/(day_time),
	   -- daytime is 300
	   
	elseif TheWorld.state.phase == "dusk" then

		inst.components.locomotor.walkspeed = (5)
		inst.components.locomotor.runspeed = (6.5)
		
		inst.components.sanity.dapperness = (TUNING.DAPPERNESS_SMALL * 3)
		
		inst.components.combat.damagemultiplier = 1
		


	elseif TheWorld.state.phase == "night" then

		inst.components.locomotor.walkspeed = (7.5)
		inst.components.locomotor.runspeed = (8)
		
		inst.components.sanity.dapperness = (TUNING.DAPPERNESS_SMALL * 8)

		inst.components.combat.damagemultiplier = 2
		
    elseif tempCaveVar == true then
		
		inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.75)
		inst.components.locomotor.runspeed = (TUNING.WILSON_WALK_SPEED * 2.5)
		
		inst.components.sanity.dapperness = (TUNING.DAPPERNESS_SMALL * 6)
		
		inst.components.combat.damagemultiplier = 1
		

			
	end


end

-- This initializes for both clients and the host
local common_postinit = function(inst) 
	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "sakura.tex" )
	inst:AddTag("sakuraspecific")
end

local function fn()
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
		
end

local function OnDespawn(inst)
    if inst.sakura_ghost ~= nil then
        inst.sakura_ghost.components.lootdropper:SetLoot(nil)
        inst.sakura_ghost.components.health:SetInvincible(true)
        inst.sakura_ghost:PushEvent("death")
        --in case the state graph got interrupted somehow, just force
        --removal after the dissipate animation should've finished
        inst.sakura_ghost:DoTaskInTime(25 * FRAMES, inst.sakura_ghost.Remove)
    end
end
 
local function OnSave(inst, data)
    if inst.sakura_ghost ~= nil then
        data.sakura_ghost = inst.sakura_ghost:GetSaveRecord()
    end
end
 
local function OnLoad(inst, data)
    if data.sakura_ghost ~= nil and inst.sakura_ghost == nil then
        local sakura_ghost = SpawnSaveRecord(data.sakura_ghost)
        if sakura_ghost ~= nil then
            sakura_ghost.SoundEmitter:PlaySound("dontstarve/common/ghost_spawn")
            sakura_ghost:LinkToPlayer(inst)
        end
    end
end

-- This initializes for the host only
local master_postinit = function(inst)
	inst:AddComponent("sanityaura")
	inst.components.sanityaura.aura = -TUNING.SANITYAURA_LARGE
	-- choose which sounds this character will play
	inst.soundsname = "wendy"
	-- Stats	
	inst.components.health:SetMaxHealth(125)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(200)
	
	inst.ghostbuild = "ghost_sakura_build"
	inst:DoTaskInTime(math.random(20, 25), Darkness)
		
	inst:AddComponent("reader")	
    inst.sakura_ghost = nil
    inst.sakura_ghost_flowers = {}
 
    inst.OnDespawn = OnDespawn
    inst.OnSave = OnSave
    inst.OnLoad = OnLoad
	
	inst.components.builder.magic_bonus = 3
	
	local eater = inst.components.eater
	eater.ignoresspoilage = true
	
		inst.components.eater.Eat_orig = inst.components.eater.Eat
function inst.components.eater:Eat( food )
	if self:CanEat(food) then
		if food.components.edible.sanityvalue < 0 then
		food.components.edible.sanityvalue = 1
	end
		if food.components.edible.healthvalue < 0 then
		food.components.edible.healthvalue = 3
	end
end
return inst.components.eater:Eat_orig(food)
end
	
	inst:WatchWorldState( "startday", function(inst) updatestats(inst) end )
	inst:WatchWorldState( "startdusk", function(inst) updatestats(inst) end )
	inst:WatchWorldState( "startnight", function(inst) updatestats(inst) end )	
	updatestats(inst)
	return inst
	
end

return MakePlayerCharacter("sakura", prefabs, assets, common_postinit, master_postinit, start_inv, fn)