
local MakePlayerCharacter = require "prefabs/player_common"

local assets = {Asset("SCRIPT", "scripts/prefabs/player_common.lua")}
local prefabs = {}

local start_inv = {"dragonfruit_seeds", "pomegranate_seeds", "pumpkin_seeds"}

local function onbecamehuman(inst)

	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "tenshi_speed_mod", 1)
	
end

local function onbecameghost(inst)

   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "tenshi_speed_mod")
   
end

local function onload(inst)

    inst:ListenForEvent("ms_respawnedfromghost", onbecamehuman)
    inst:ListenForEvent("ms_becameghost", onbecameghost)

    if inst:HasTag("playerghost") then
	
        onbecameghost(inst)
		
    else
	
        onbecamehuman(inst)
		
    end
	
end

local common_postinit = function(inst) 

	inst.MiniMapEntity:SetIcon( "tenshi.tex" )
	
end

local function divinity(inst)

	if inst.components.health.currenthealth > (75) and inst.components.health.currenthealth <= (150) then
	
		inst.components.combat.damagemultiplier = 2.00
		inst.components.health.absorb = 0.50
	   
	 elseif inst.components.health.currenthealth == (75) then
	   
	   	inst.components.combat.damagemultiplier = 1.00
		inst.components.health.absorb = 0.00
		
	elseif  inst.components.health.currenthealth >= (0) and inst.components.health.currenthealth < (75) then
	
		   	inst.components.combat.damagemultiplier = 0.50
			inst.components.health.absorb = -0.50
			
	end
	
end

local function calamity(inst)

	if inst.components.hunger.current > (75) and inst.components.hunger.current <= (150) then
	
		inst.components.locomotor.walkspeed = ( TUNING.WILSON_WALK_SPEED * 1.00 )
		inst.components.locomotor.runspeed = ( TUNING.WILSON_RUN_SPEED * 1.00 )
		
		inst.components.hunger.hungerrate = ( TUNING.WILSON_HUNGER_RATE * 1.00)
	
		inst.components.sanity.dapperness = ( TUNING.DAPPERNESS_MED * 0.20 )
	   
	 elseif inst.components.hunger.current == (75) then
	   
		inst.components.locomotor.walkspeed = ( TUNING.WILSON_WALK_SPEED * 1.00 )
		inst.components.locomotor.runspeed = ( TUNING.WILSON_RUN_SPEED * 1.00 )
		
		inst.components.hunger.hungerrate = ( TUNING.WILSON_HUNGER_RATE * 1.00)
	
		inst.components.sanity.dapperness = ( TUNING.DAPPERNESS_MED * 0.00 )
		
	elseif  inst.components.hunger.current >= (0) and inst.components.hunger.current < (75) then
	
		inst.components.locomotor.walkspeed = ( TUNING.WILSON_WALK_SPEED * 1.50 )
		inst.components.locomotor.runspeed = ( TUNING.WILSON_RUN_SPEED * 1.50 )
		
		inst.components.hunger.hungerrate = ( TUNING.WILSON_HUNGER_RATE * 2.00)
	
		inst.components.sanity.dapperness = ( TUNING.DAPPERNESS_MED * -2.0 )

		end
		
end
	   
	   local function trance(inst)
	   
	   	if inst.components.sanity.current > (75) and inst.components.sanity.current <= (150) then
		
			inst.components.temperature.inherentinsulation = ( TUNING.INSULATION_PER_BEARD_BIT * -2.00 )
	   
			inst.components.sanity.neg_aura_mult = 2.0
			inst.components.sanity.night_drain_mult = 2.0
			
		 elseif inst.components.hunger.current == (75) then
		 
			inst.components.temperature.inherentinsulation = ( TUNING.INSULATION_PER_BEARD_BIT * 0.00 )
	   
			inst.components.sanity.neg_aura_mult = 1.0
			inst.components.sanity.night_drain_mult = 1.0
			
		elseif  inst.components.sanity.current >= (0) and inst.components.sanity.current < (75) then
				
			inst.components.temperature.inherentinsulation = ( TUNING.INSULATION_PER_BEARD_BIT * 10.00 )
	   
			inst.components.sanity.neg_aura_mult = 0.2
			inst.components.sanity.night_drain_mult = 0.2
	
				
		end
			
	end
			
			
	   
local master_postinit = function(inst)

	inst.soundsname = "willow"
	
	inst.components.health:SetMaxHealth(150)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(150)

	inst.components.combat.damagemultiplier = 2.00
	inst.components.health.absorb = 0.50
	
	inst.components.locomotor.walkspeed = ( TUNING.WILSON_WALK_SPEED * 1.00 )
	inst.components.locomotor.runspeed = ( TUNING.WILSON_RUN_SPEED * 1.00 )
		
	inst.components.hunger.hungerrate = ( TUNING.WILSON_HUNGER_RATE * 1.00)
	
	inst.components.sanity.dapperness = ( TUNING.DAPPERNESS_MED * 0.20 )
		
	inst.components.sanity.neg_aura_mult = 2.0
	inst.components.sanity.night_drain_mult = 2.0
	
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	
	inst:ListenForEvent("healthdelta", function(inst) divinity(inst) end )
	inst:ListenForEvent("hungerdelta", function(inst) calamity(inst) end )
	inst:ListenForEvent("sanitydelta", function(inst) trance(inst) end )
	
	divinity(inst)
	calamity(inst)
	trance(inst)
	
	return inst
	
end

return MakePlayerCharacter("tenshi", prefabs, assets, common_postinit, master_postinit, start_inv)

--Current Mod Version: [1.2.8]
--DST Character Mod created by: Senshimi [https://steamcommunity.com/id/Senshimi/]
--Touhou Project Collection: [http://steamcommunity.com/sharedfiles/filedetails/?id=701414094]
