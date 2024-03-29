
local MakePlayerCharacter = require "prefabs/player_common"

local assets = {Asset("SCRIPT", "scripts/prefabs/player_common.lua")}

local prefabs = {}

local start_inv = {"chester_eyebone", "feather_crow", "nightmarefuel"}

local function onbecamehuman(inst)

	inst.components.locomotor:SetExternalSpeedMultiplier(inst, "rin_speed_mod", 1)

end

local function onbecameghost(inst)

   inst.components.locomotor:RemoveExternalSpeedMultiplier(inst, "rin_speed_mod")
  
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

local function onsave(inst, data)

		data.maxhealth = inst.components.health.maxhealth or nil
	
end

local function onpreload(inst, data)

		inst.components.health:SetMaxHealth(data.maxhealth)
		
end


local common_postinit = function(inst)

	inst.MiniMapEntity:SetIcon( "rin.tex" )
	
end

local function nightvision(inst)

	if TheWorld.state.phase == "day" then
		
		inst.Light:Enable(false)
		
	elseif TheWorld.state.phase == "dusk" then
	
		inst.Light:Enable(false)
		
	elseif TheWorld.state.phase == "night" then
	
		inst.entity:AddLight()
		inst.Light:SetRadius(1)
		inst.Light:SetFalloff(.15)
		inst.Light:SetIntensity(.15)
		inst.Light:SetColour(120/255,120/255,0/255)
		inst.Light:Enable(true)
		
	elseif tempCaveVar == true and TheWorld.state.phase == "caveday" then
		
		inst.Light:Enable(false)
		
	elseif tempCaveVar == true and TheWorld.state.phase == "cavedusk" then

		inst.Light:Enable(false)
		
	elseif tempCaveVar == true and TheWorld.state.phase == "cavenight" then
	
		inst.entity:AddLight()
		inst.Light:SetRadius(1)
		inst.Light:SetFalloff(.15)
		inst.Light:SetIntensity(.15)
		inst.Light:SetColour(120/255,120/255,0/255)
		inst.Light:Enable(true)
		
	end
	
end

local function oneat(inst, food)

	if food and food.components.edible and food.prefab == "fish" and inst.components.health.maxhealth <= 450 then
		
		inst.components.health:DoDelta(15)
		inst.components.hunger:DoDelta(15)
		inst.components.sanity:DoDelta(15)
		
		inst.components.health.maxhealth = (inst.components.health.maxhealth + 1)
		
	elseif food and food.components.edible and food.prefab == "fish_cooked" and inst.components.health.maxhealth <= 450 then
	
		inst.components.health:DoDelta(30)
		inst.components.hunger:DoDelta(30)
		inst.components.sanity:DoDelta(30)
		
		inst.components.health.maxhealth = (inst.components.health.maxhealth + 1)
	
	end
	
end

local function hungerpain(inst)

	if inst.components.hunger.current >= (100) and inst.components.hunger.current < (150) then

		    inst.components.combat.damagemultiplier = 1.15
			
			inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.15)
			inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 1.15)
			
	elseif inst.components.hunger.current >= (50) and inst.components.hunger.current < (100) then
	
		    inst.components.combat.damagemultiplier = 1.00
			
			inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.00)
			inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 1.00)
			
	elseif inst.components.hunger.current >= (0) and inst.components.hunger.current < (50) then
	
			inst.components.combat.damagemultiplier = 0.85
			
			inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 0.85)
			inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 0.85)
			
	end
	
end

local master_postinit = function(inst)

	inst.soundsname = "willow"

	inst.components.health:SetMaxHealth(300)
	inst.components.hunger:SetMax(150)
	inst.components.sanity:SetMax(150)
	
    inst.components.combat.damagemultiplier = 1.15
	
	inst.components.hunger.hungerrate = ( TUNING.WILSON_HUNGER_RATE * 1.30 )
	
	inst.components.temperature.inherentinsulation = ( TUNING.INSULATION_PER_BEARD_BIT * 1.50 )
	
	inst.components.locomotor.walkspeed = (TUNING.WILSON_WALK_SPEED * 1.15)
	inst.components.locomotor.runspeed = (TUNING.WILSON_RUN_SPEED * 1.15)
	
	inst.components.sanity.neg_aura_mult = 0.85
	inst.components.sanity.night_drain_mult = 0.85
	
	inst.OnSave = onsave
	inst.OnLoad = onload
    inst.OnNewSpawn = onload
	inst.OnPreLoad = onpreload
	
	inst.components.eater:SetOnEatFn(oneat)
	
	inst:WatchWorldState( "isday", function(inst) nightvision(inst) end )
	inst:WatchWorldState( "isdusk", function(inst) nightvision(inst) end )
	inst:WatchWorldState( "isnight", function(inst) nightvision(inst) end )
	inst:WatchWorldState( "iscaveday", function(inst) nightvision(inst) end )
	inst:WatchWorldState( "iscavedusk", function(inst) nightvision(inst) end )
	inst:WatchWorldState( "iscavenight", function(inst) nightvision(inst) end )
	
	inst:ListenForEvent("hungerdelta", function(inst) hungerpain(inst) end )
	
	oneat(inst)
	nightvision(inst)
	return inst
	
end

return MakePlayerCharacter("rin", prefabs, assets, common_postinit, master_postinit, start_inv)

--Current Mod Version: [1.3.8]
--DST Character Mod created by: Senshimi [https://steamcommunity.com/id/Senshimi/]
--Touhou Project Collection: [http://steamcommunity.com/sharedfiles/filedetails/?id=701414094]
