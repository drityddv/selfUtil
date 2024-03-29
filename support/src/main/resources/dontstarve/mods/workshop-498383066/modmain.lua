PrefabFiles = {
	"annie", "summontibber", "anniepack", "armor_littleredannie", "armor_sweetheartannie", "armor_frostannie", "tibberdoll", "anniebearhat", "tibbersword", "anniefire", "annie_none",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/annie.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/annie.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/annie.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/annie.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/annie_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/annie_silho.xml" ),

    Asset( "IMAGE", "bigportraits/annie.tex" ),
    Asset( "ATLAS", "bigportraits/annie.xml" ),
	
	Asset( "IMAGE", "images/map_icons/annie.tex" ),
	Asset( "ATLAS", "images/map_icons/annie.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_annie.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_annie.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_annie.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_annie.xml" ),
	
	Asset( "ATLAS", "images/hud/annietab.xml" ),
	
	Asset( "IMAGE", "bigportraits/annie_none.tex" ),
    Asset( "ATLAS", "bigportraits/annie_none.xml" ),
	
	Asset( "IMAGE", "images/names_annie.tex" ),
    Asset( "ATLAS", "images/names_annie.xml" ),

}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

local SITCOMMAND = GLOBAL.Action(4, true, true, 10,	false, false, nil)
local SITCOMMAND_CANCEL = GLOBAL.Action(4, true, true, 10, false, false, nil)

local resolvefilepath = GLOBAL.resolvefilepath
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local Recipe = GLOBAL.Recipe
local TECH = GLOBAL.TECH

--Annie Tab

anniestab = AddRecipeTab("Annie", 998, "images/hud/annietab.xml", "annietab.tex", "anniebuilder")

--Recipe

--Plutia Recipes

local anniebearhat_recipe = AddRecipe("anniebearhat",
{GLOBAL.Ingredient("beefalowool", 6), GLOBAL.Ingredient("silk", 6), GLOBAL.Ingredient("houndstooth", 2)},
anniestab, TECH.NONE,
nil, nil, nil, nil, nil,
"images/inventoryimages/anniebearhat.xml", "anniebearhat.tex")
anniebearhat_recipe.tagneeded = false
anniebearhat_recipe.builder_tag = "anniebuilder"

local armor_frostannie_recipe = AddRecipe("armor_frostannie",
{GLOBAL.Ingredient("beefalowool", 6), GLOBAL.Ingredient("silk", 6), GLOBAL.Ingredient("winterhat", 1)},
anniestab, TECH.NONE,
nil, nil, nil, nil, nil,
"images/inventoryimages/armor_frostannie.xml", "armor_frostannie.tex")
armor_frostannie_recipe.tagneeded = false
armor_frostannie_recipe.builder_tag = "anniebuilder"

local armor_littleredannie_recipe = AddRecipe("armor_littleredannie",
{GLOBAL.Ingredient("beefalowool", 4), GLOBAL.Ingredient("silk", 6), GLOBAL.Ingredient("feather_robin", 2)},
anniestab, TECH.NONE,
nil, nil, nil, nil, nil,
"images/inventoryimages/armor_littleredannie.xml", "armor_littleredannie.tex")
armor_littleredannie_recipe.tagneeded = false
armor_littleredannie_recipe.builder_tag = "anniebuilder"

local armor_sweetheartannie_recipe = AddRecipe("armor_sweetheartannie",
{GLOBAL.Ingredient("beefalowool", 4), GLOBAL.Ingredient("silk", 6), GLOBAL.Ingredient("goldnugget", 3)},
anniestab, TECH.NONE,
nil, nil, nil, nil, nil,
"images/inventoryimages/armor_sweetheartannie.xml", "armor_sweetheartannie.tex")
armor_sweetheartannie_recipe.tagneeded = false
armor_sweetheartannie_recipe.builder_tag = "anniebuilder"

local summontibber_recipe = AddRecipe("summontibber",
{GLOBAL.Ingredient("tibberdoll", 1, "images/inventoryimages/tibberdoll.xml")},
anniestab, TECH.NONE,
nil, nil, nil, nil, nil,
"images/inventoryimages/summontibber.xml", "summontibber.tex")
summontibber_recipe.tagneeded = false
summontibber_recipe.builder_tag ="anniebuilder"
summontibber_recipe.atlas = resolvefilepath("images/inventoryimages/summontibber.xml")

---Names/Recipe Desc/Character Description

GLOBAL.STRINGS.NAMES.ANNIEPACK = "Annie's Backpack"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIEPACK = "A cute backpack for a very dark child."

GLOBAL.STRINGS.NAMES.ANNIEFIRE = "Annie's Fireball"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIEFIRE = "Concentrated fire only to be used by a specific little girl."

GLOBAL.STRINGS.NAMES.ANNIEBEARHAT = "Reverse Annie"
GLOBAL.STRINGS.RECIPE_DESC.ANNIEBEARHAT = "I'm just like Tibbers!"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIEBEARHAT= "What a very unsettling hat."
GLOBAL.STRINGS.NAMES.ARMOR_FROSTANNIE = "Frost Fire Suit"
GLOBAL.STRINGS.RECIPE_DESC.ARMOR_FROSTANNIE = "For Chilly Days!"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_FROSTANNIE = "That loosk rather comfy!"

GLOBAL.STRINGS.NAMES.ARMOR_LITTLEREDANNIE = "Little red annie suit"
GLOBAL.STRINGS.RECIPE_DESC.ARMOR_LITTLEREDANNIE = "Off to Grandmas!"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_LITTLEREDANNIE = "Someone's bringing grandma cookies today."

GLOBAL.STRINGS.NAMES.ARMOR_SWEETHEARTANNIE = "Sweet Heart Annie Suit"
GLOBAL.STRINGS.RECIPE_DESC.ARMOR_SWEETHEARTANNIE = "Fiery burning love."
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.ARMOR_SWEETHEARTANNIE = "This a cupid outfit or..?"

GLOBAL.STRINGS.NAMES.TIBBERDOLL = "Annie's Tibber Doll"
GLOBAL.STRINGS.RECIPE_DESC.TIBBERDOLL = "I cherish you the most!"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.TIBBERDOLL = "I have a bad feeling picking this up..."

GLOBAL.STRINGS.NAMES.SUMMONTIBBER = "Tibbers"
GLOBAL.STRINGS.RECIPE_DESC.SUMMONTIBBER = "Tibbers! Yay!"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SUMMONTIBBER = "It's a Bearger..no..Wait..WHAT?!"

AddMinimapAtlas("images/inventoryimages/summontibber.xml")
AddMinimapAtlas("images/inventoryimages/anniepack.xml")

AddReplicableComponent("followersitcommand")

SITCOMMAND.id = "SITCOMMAND"
SITCOMMAND.str = "Order to Stay"
SITCOMMAND.fn = function(act)
	local targ = act.target
	if targ and targ.components.followersitcommand then
		act.doer.components.locomotor:Stop()
		act.doer.components.talker:Say("Stay Tibbers!!")
		targ.components.followersitcommand:SetStaying(true)
		targ.components.followersitcommand:RememberSitPos("currentstaylocation", GLOBAL.Point(targ.Transform:GetWorldPosition())) 
		return true
	end
end
AddAction(SITCOMMAND)

SITCOMMAND_CANCEL.id = "SITCOMMAND_CANCEL"
SITCOMMAND_CANCEL.str = "Order to Follow"
SITCOMMAND_CANCEL.fn = function(act)
	local targ = act.target
	if targ and targ.components.followersitcommand then
		act.doer.components.locomotor:Stop()
		act.doer.components.talker:Say("Tibbers come!")
		targ.components.followersitcommand:SetStaying(false)
		return true
	end
end
AddAction(SITCOMMAND_CANCEL)

AddComponentAction("SCENE", "followersitcommand", function(inst, doer, actions, rightclick)
	if rightclick and inst.replica.followersitcommand then
		if not inst.replica.followersitcommand:IsCurrentlyStaying() then
			table.insert(actions, GLOBAL.ACTIONS.SITCOMMAND)
		else
			table.insert(actions, GLOBAL.ACTIONS.SITCOMMAND_CANCEL)
		end
	end
end)

-- add tradable component to various gear
function HF_addtradablecomponenttoprefab(inst)
	if not inst.components.tradable then
		inst:AddComponent("tradable")
	end
end

AddPrefabPostInit("tibbersword", HF_addtradablecomponenttoprefab)
AddPrefabPostInit("armor_sanity", HF_addtradablecomponenttoprefab)
AddPrefabPostInit("umbrella", HF_addtradablecomponenttoprefab)
AddPrefabPostInit("grass_umbrella", HF_addtradablecomponenttoprefab)
AddPrefabPostInit("torch", HF_addtradablecomponenttoprefab)
AddPrefabPostInit("armorwood", HF_addtradablecomponenttoprefab)
AddPrefabPostInit("armormarble", HF_addtradablecomponenttoprefab)
AddPrefabPostInit("armorgrass", HF_addtradablecomponenttoprefab)
AddPrefabPostInit("armorruins", HF_addtradablecomponenttoprefab)
-- DLC
AddPrefabPostInit("armordragonfly", HF_addtradablecomponenttoprefab)

AddComponentPostInit("moisture", function(self)
	local old = self.GetMoistureRate
	self.GetMoistureRate = function(self)
		local oldvalue = old(self)
		local x, y, z = self.inst.Transform:GetWorldPosition()
		local ents = GLOBAL.TheSim:FindEntities(x, y, z, 4, {'sheltercarrier'})
		for k, v in pairs(ents) do 
			if v.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS) and 
			v.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS).prefab == "umbrella" then
				return 0
			end
			if v.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS) and 
			v.components.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS).prefab == "grass_umbrella" then
				return oldvalue * 0.5
			end
		end
		return oldvalue
	end
end)

local comb_rep = GLOBAL.require "components/combat_replica"
local old_IsAlly = comb_rep.IsAlly
function comb_rep:IsAlly(guy,...)
	if guy:HasTag("summontibber") then
		return true
	end
	return old_IsAlly(self,guy,...)
end

-- The character select screen lines
STRINGS.CHARACTER_TITLES.annie = "The Dark Child"
STRINGS.CHARACTER_NAMES.annie = "Annie"
STRINGS.CHARACTER_DESCRIPTIONS.annie = "*Throws Fireballs\n*Tibbers!\n*Burn!"
STRINGS.CHARACTER_QUOTES.annie = "\"Have you seen my bear Tibbers?\""

-- Custom speech strings
STRINGS.CHARACTERS.ANNIE = require "speech_annie"

-- The character's name as appears in-game 
STRINGS.NAMES.ANNIE = "Annie"
GLOBAL.STRINGS.CHARACTERS.ANNIE.DESCRIBE.SUMMONTIBBER = "YAY! TIBBERS!"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ANNIE = 
{
	GENERIC = "It's Annie!",
	ATTACKER = "That Annie looks shifty...",
	MURDERER = "Murderer!",
	REVIVER = "Annie, friend of ghosts.",
	GHOST = "Annie could use a heart.",
}


AddMinimapAtlas("images/map_icons/annie.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("annie", "FEMALE")

