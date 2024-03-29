
local MakePlayerCharacter = require "prefabs/player_common"


local assets = {

        Asset( "ANIM", "anim/player_basic.zip" ),
        Asset( "ANIM", "anim/player_idles_shiver.zip" ),
        Asset( "ANIM", "anim/player_actions.zip" ),
        Asset( "ANIM", "anim/player_actions_axe.zip" ),
        Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),
        Asset( "ANIM", "anim/player_actions_shovel.zip" ),
        Asset( "ANIM", "anim/player_actions_blowdart.zip" ),
        Asset( "ANIM", "anim/player_actions_eat.zip" ),
        Asset( "ANIM", "anim/player_actions_item.zip" ),
        Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),
        Asset( "ANIM", "anim/player_actions_bugnet.zip" ),
        Asset( "ANIM", "anim/player_actions_fishing.zip" ),
        Asset( "ANIM", "anim/player_actions_boomerang.zip" ),
        Asset( "ANIM", "anim/player_bush_hat.zip" ),
        Asset( "ANIM", "anim/player_attacks.zip" ),
        Asset( "ANIM", "anim/player_idles.zip" ),
        Asset( "ANIM", "anim/player_rebirth.zip" ),
        Asset( "ANIM", "anim/player_jump.zip" ),
        Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),
        Asset( "ANIM", "anim/player_teleport.zip" ),
        Asset( "ANIM", "anim/wilson_fx.zip" ),
        Asset( "ANIM", "anim/player_one_man_band.zip" ),
        Asset( "ANIM", "anim/shadow_hands.zip" ),
        Asset( "SOUND", "sound/sfx.fsb" ),
        Asset( "SOUND", "sound/wilson.fsb" ),
        Asset( "ANIM", "anim/beard.zip" ),

        Asset( "ANIM", "anim/faroz.zip" ),
        Asset( "ANIM", "anim/ghost_faroz_build.zip" ),
}
local prefabs = {}
local start_inv = {
	-- Custom starting items
	"faroz_gls",
}




local function applyupgrades(inst)

	local max_upgrades = 30
	local upgrades = math.min(inst.level, max_upgrades)

	local hunger_percent = inst.components.hunger:GetPercent()
	local health_percent = inst.components.health:GetPercent()
	local sanity_percent = inst.components.sanity:GetPercent()

	inst.components.hunger.max = math.ceil (70 + upgrades * 1) --100
	inst.components.health.maxhealth = math.ceil (70 + upgrades * 1) --100
	inst.components.sanity.max = math.ceil (70 + upgrades * 3) --160
	
	inst.components.locomotor.walkspeed =  math.ceil (7 + upgrades / 7) --11
	inst.components.locomotor.runspeed = math.ceil (9 + upgrades / 6) --14
	
	
	inst.components.talker:Say("Level : ".. (inst.level))
	
	if inst.level >29 then
		inst.components.talker:Say("Level : Max!")
	end

	inst.components.hunger:SetPercent(hunger_percent)
	inst.components.health:SetPercent(health_percent)
	inst.components.sanity:SetPercent(sanity_percent)

end

local function oneat(inst, food)
	
	--if food and food.components.edible and food.components.edible.foodtype == "HELLO" then
	if food and food.components.edible and food.prefab == "corn" or food.prefab == "carrot" then
		--give an upgrade!
		inst.level = inst.level + 1
		applyupgrades(inst)	
		inst.SoundEmitter:PlaySound("dontstarve/characters/wx78/levelup")

	end
end

local function onpreload(inst, data)
	if data then
		if data.level then
			inst.level = data.level
			applyupgrades(inst)
			--re-set these from the save data, because of load-order clipping issues
			if data.health and data.health.health then inst.components.health.currenthealth = data.health.health end
			if data.hunger and data.hunger.hunger then inst.components.hunger.current = data.hunger.hunger end
			if data.sanity and data.sanity.current then inst.components.sanity.current = data.sanity.current end
			inst.components.health:DoDelta(0)
			inst.components.hunger:DoDelta(0)
			inst.components.sanity:DoDelta(0)
		end
	end

end

local function onsave(inst, data)
	data.level = inst.level
	data.charge_time = inst.charge_time
end

-- This initializes for both clients and the host
local common_postinit = function(inst) 
	-- choose which sounds this character will play
	inst.soundsname = "willow"

	-- Minimap icon
	inst.MiniMapEntity:SetIcon( "faroz.tex" )
end

-- This initializes for the host only
local master_postinit = function(inst)

	inst.level = 0
	inst.components.eater:SetOnEatFn(oneat)
	applyupgrades(inst)
	-- Stats	
	inst.components.health:SetMaxHealth(70)
	inst.components.hunger:SetMax(70)
	inst.components.sanity:SetMax(70)
	inst.components.locomotor.walkspeed = 7
	inst.components.locomotor.runspeed = 9
	inst.components.combat.damagemultiplier = 0.6
	--inst.components.sanity.dapperness = 1
	
	inst.OnSave = onsave
	inst.OnPreLoad = onpreload
end

return MakePlayerCharacter("faroz", prefabs, assets, common_postinit, master_postinit, start_inv)
