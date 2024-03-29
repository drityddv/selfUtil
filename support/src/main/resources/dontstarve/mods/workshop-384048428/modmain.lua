PrefabFiles = {
	"sakura", "sakura_ghost", "sakura_ghost_flower", "sakura_none",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/sakura.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/sakura.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/sakura.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/sakura.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/sakura_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/sakura_silho.xml" ),

    Asset( "IMAGE", "bigportraits/sakura.tex" ),
    Asset( "ATLAS", "bigportraits/sakura.xml" ),
	
	Asset( "IMAGE", "images/map_icons/sakura.tex" ),
	Asset( "ATLAS", "images/map_icons/sakura.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_sakura.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_sakura.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_sakura.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_sakura.xml" ),

	Asset( "IMAGE", "images/inventoryimages/abigailflower.tex" ),
	Asset( "ATLAS", "images/inventoryimages/abigailflower.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/abigailflower2.tex" ),
	Asset( "ATLAS", "images/inventoryimages/abigailflower2.xml" ),
	
	Asset( "IMAGE", "images/inventoryimages/abigailflowerhaunted.tex" ),
	Asset( "ATLAS", "images/inventoryimages/abigailflowerhaunted.xml" ),
	
	Asset( "IMAGE", "bigportraits/sakura_none.tex" ),
    Asset( "ATLAS", "bigportraits/sakura_none.xml" ),
	
	Asset( "IMAGE", "images/names_sakura.tex" ),
    Asset( "ATLAS", "images/names_sakura.xml" ),

}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

GLOBAL.STRINGS.NAMES.SAKURA_GHOST = "The Shadow"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SAKURA_GHOST = "Oh? But wait..."

GLOBAL.STRINGS.NAMES.SAKURA_GHOST_FLOWER = "Sakura's Flower"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SAKURA_GHOST_FLOWER = "Anytime now..."

local NIGHTVISION_COLOURCUBES =
{
    day = "images/colour_cubes/mole_vision_off_cc.tex",
    dusk = "images/colour_cubes/mole_vision_on_cc.tex",
    night = "images/colour_cubes/mole_vision_on_cc.tex",
    full_moon = "images/colour_cubes/mole_vision_off_cc.tex",
}

AddPrefabPostInit("sakura", function(inst)
    inst.nightvision = GLOBAL.net_bool(inst.GUID, "player.customvision", "flipvision")
    inst.nightvision:set_local(false)
 
	local function FlipFn(inst)
		local val = inst.nightvision:value()
		inst.components.playervision:ForceNightVision(val)
		inst.components.playervision:SetCustomCCTable(val and NIGHTVISION_COLOURCUBES or nil)
	end
    inst:ListenForEvent("flipvision", FlipFn)
 
    if GLOBAL.TheWorld.ismastersim then
        local function OnPhaseChange(inst, phase)
            inst.nightvision:set(phase == "night")
        end
        inst:WatchWorldState("phase", OnPhaseChange)
        OnPhaseChange(inst, GLOBAL.TheWorld.state.phase)
    end
end)

AddBrainPostInit("abigailbrain", function(self)
	local _atfn = self.inst.components.aura.auratestfn
	self.inst.components.aura.auratestfn = function(inst, target)
		if inst.cowardmode then
			return false
		end
		return _atfn(inst, target)
	end
	local _caav = self.bt.root.children[1].Visit
	self.bt.root.children[1].Visit = function(self)
		_caav(self)
		if self.status == GLOBAL.RUNNING then
			local leader = self.inst.components.follower.leader
			if leader and not self.inst:IsNear(leader, 15) then
				self.inst.cowardmode = true
				self.status = GLOBAL.FAILED
				self.inst.components.combat:GiveUp()
				self.inst.components.locomotor:Stop()
				return
			else
				self.inst.cowardmode = nil
			end
		end
	end
	local _offn = self.bt.root.children[2].Visit
	self.bt.root.children[2].Visit = function(self)
		_offn(self)
		if self.status == GLOBAL.SUCCESS then
			self.inst.cowardmode = nil
			return
		end
	end
end)

local function MakeNeutral(inst)
    if GLOBAL.TheWorld.ismastersim then
        local _CanTarget = inst.components.combat.CanTarget
        inst.components.combat.CanTarget = function(self, target)
            local ret = _CanTarget(self, target)
            if ret and target:HasTag("sakura") then
                local playertarget = target.components.combat.target
                local shadowtarget = playertarget and playertarget:HasTag("shadowcreature")
                if not shadowtarget then
                    return false
                end
            end
            return ret
        end
    end
end

local comb_rep = GLOBAL.require "components/combat_replica"
local old_IsAlly = comb_rep.IsAlly
function comb_rep:IsAlly(guy,...)
	if guy:HasTag("sakuraghost") then
		return true
	end
	return old_IsAlly(self,guy,...)
end
 
AddPrefabPostInit("crawlinghorror", MakeNeutral)
AddPrefabPostInit("terrorbeak", MakeNeutral)
AddPrefabPostInit("nightmarebeak", MakeNeutral)
AddPrefabPostInit("crawlingnightmare", MakeNeutral)

	
-- The character select screen lines
STRINGS.CHARACTER_TITLES.sakura = "(Dark)Sakura Matou"
STRINGS.CHARACTER_NAMES.sakura = "Sakura"
STRINGS.CHARACTER_DESCRIPTIONS.sakura = "*Sanity Loss during the Day\n*Can See In the Dark\n*Summons 'The shadow'"
STRINGS.CHARACTER_QUOTES.sakura = "\"Sennnnnnnnnnnnnnnnnnnnpai\""

-- Custom speech strings
STRINGS.CHARACTERS.SAKURA = require "speech_sakura"

-- The character's name as appears in-game 
STRINGS.NAMES.SAKURA = "Sakura"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SAKURA = 
{
	GENERIC = "It's Sakura!",
	ATTACKER = "That Sakura looks shifty...",
	MURDERER = "Murderer!",
	REVIVER = "Sakura, friend of ghosts.",
	GHOST = "Sakura could use a heart.",
}

-- Let the game know character is male, female, or robot
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "sakura")


AddMinimapAtlas("images/map_icons/sakura.xml")
AddModCharacter("sakura")

