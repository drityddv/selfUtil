PrefabFiles = {
	"saber",
	"saber_none",
	"sword_blue",
	"sword_red",
	"sword_white",
	"sword_black",
	"manastone",
	"saber_skins"
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/saber.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/saber.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/saber.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/saber.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/saber_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/saber_silho.xml" ),

	Asset( "IMAGE", "images/inventoryimages/sword_blue.tex" ),
    Asset( "ATLAS", "images/inventoryimages/sword_blue.xml" ),
	Asset( "IMAGE", "images/inventoryimages/sword_red.tex" ),
    Asset( "ATLAS", "images/inventoryimages/sword_red.xml" ),
	Asset( "IMAGE", "images/inventoryimages/sword_white.tex" ),
    Asset( "ATLAS", "images/inventoryimages/sword_white.xml" ),
	Asset( "IMAGE", "images/inventoryimages/sword_black.tex" ),
    Asset( "ATLAS", "images/inventoryimages/sword_black.xml" ),
	Asset( "IMAGE", "images/inventoryimages/manastone.tex" ),
    Asset( "ATLAS", "images/inventoryimages/manastone.xml" ),

    Asset( "IMAGE", "bigportraits/saber.tex" ),
    Asset( "ATLAS", "bigportraits/saber.xml" ),
	Asset( "IMAGE", "bigportraits/saber_blue.tex" ),
    Asset( "ATLAS", "bigportraits/saber_blue.xml" ),
	Asset( "IMAGE", "bigportraits/saber_blue_armor.tex" ),
    Asset( "ATLAS", "bigportraits/saber_blue_armor.xml" ),
	Asset( "IMAGE", "bigportraits/saber_white.tex" ),
    Asset( "ATLAS", "bigportraits/saber_white.xml" ),
	Asset( "IMAGE", "bigportraits/saber_red.tex" ),
    Asset( "ATLAS", "bigportraits/saber_red.xml" ),
	Asset( "IMAGE", "bigportraits/saber_black.tex" ),
    Asset( "ATLAS", "bigportraits/saber_black.xml" ),
	
	Asset( "IMAGE", "images/map_icons/saber.tex" ),
	Asset( "ATLAS", "images/map_icons/saber.xml" ),
	Asset( "IMAGE", "images/map_icons/sword_blue.tex" ),
    Asset( "ATLAS", "images/map_icons/sword_blue.xml" ),
	Asset( "IMAGE", "images/map_icons/sword_red.tex" ),
    Asset( "ATLAS", "images/map_icons/sword_red.xml" ),
	Asset( "IMAGE", "images/map_icons/sword_white.tex" ),
    Asset( "ATLAS", "images/map_icons/sword_white.xml" ),
	Asset( "IMAGE", "images/map_icons/sword_black.tex" ),
    Asset( "ATLAS", "images/map_icons/sword_black.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_saber.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_saber.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_saber.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_saber.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_saber.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_saber.xml" ),
	
	Asset( "IMAGE", "images/names_saber.tex" ),
    Asset( "ATLAS", "images/names_saber.xml" ),
	
    Asset( "IMAGE", "bigportraits/saber_none.tex" ),
    Asset( "ATLAS", "bigportraits/saber_none.xml" ),

}

local G = GLOBAL
local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.saber = "Saber (Homely)"
STRINGS.CHARACTER_NAMES.saber = "Saber"
STRINGS.CHARACTER_DESCRIPTIONS.saber = "*Increased HP and Speed\n*Does more damage\n*Starves a bit faster"
STRINGS.CHARACTER_QUOTES.saber = "Anything edible is acceptable. Extravagance is our enemy."

--skin quotes
GLOBAL.STRINGS.SKIN_QUOTES.saber_blue = "Hunger is the enemy."
GLOBAL.STRINGS.SKIN_NAMES.saber_blue = "Saber (Blue Dress)"
GLOBAL.STRINGS.SKIN_QUOTES.saber_blue_armor = "A man without fear cannot be wise."
GLOBAL.STRINGS.SKIN_NAMES.saber_blue_armor = "Saber (Blue Armor)"
GLOBAL.STRINGS.SKIN_QUOTES.saber_red = "Yeah, you can leave everything to me!"
GLOBAL.STRINGS.SKIN_NAMES.saber_red = "Saber (Nero)"
GLOBAL.STRINGS.SKIN_QUOTES.saber_white = "Please watch me. I will bring you victory!"
GLOBAL.STRINGS.SKIN_NAMES.saber_white = "Saber (Lily)"
GLOBAL.STRINGS.SKIN_QUOTES.saber_black = "When your knees give in, I'll take your head. Until then..."
GLOBAL.STRINGS.SKIN_NAMES.saber_black = "Saber (Alter)"

-- Custom item names
STRINGS.NAMES.SWORD_BLUE = "Excalibur"
STRINGS.NAMES.SWORD_RED = "Aestus Estus"
STRINGS.NAMES.SWORD_WHITE = "Caliburn"
STRINGS.NAMES.SWORD_BLACK = "Excalibur Morgan"
STRINGS.NAMES.MANASTONE = "Mana Crystal"

-- Custom descriptions of items
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD_BLUE = "The strongest and most majestic holy sword."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD_RED = "The Original Flame, a hand-crafted crimson sword."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD_WHITE = "A sword that is the symbol of the king." 
STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD_BLACK = "The form Excalibur takes after being corrupted by evil..."
STRINGS.CHARACTERS.GENERIC.DESCRIBE.MANASTONE = "A crystal that radiates with mana. Maybe it can be used to summon something?"

--How others will describe the items
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD_BLUE = "The one who pulls this sword out of the ground will be the King of Britain."
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD_RED = "What a unique design."
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD_WHITE = "It feels warm and kind, a comforting feel."
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SWORD_BLACK = "It radiates with a dark glow... Spooky!"

--Custom recipes
--local SABERTAB = AddRecipeTab("Weapons", 999, "images/inventoryimages/sword_blue.xml", "sword_blue.tex", "saber")
local manastone_recipe = AddRecipe("manastone", {Ingredient("bluegem", 4)}, GLOBAL.RECIPETABS.MAGIC, GLOBAL.TECH.NONE, nil, nil, nil, nil, "saber", "images/inventoryimages/manastone.xml")
manastone_recipe.sortkey = 9995
local excalibur_recipe = AddRecipe("sword_blue", {Ingredient("manastone", 1, "images/inventoryimages/manastone.xml")}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.NONE, nil, nil, nil, nil, "saber", "images/inventoryimages/sword_blue.xml")
excalibur_recipe.sortkey = 9996
local caliburn_recipe = AddRecipe("sword_white", {Ingredient("manastone", 1, "images/inventoryimages/manastone.xml")}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.NONE, nil, nil, nil, nil, "saber", "images/inventoryimages/sword_white.xml")
caliburn_recipe.sortkey = 9997
local aestus_estus_recipe = AddRecipe("sword_red", {Ingredient("manastone", 1, "images/inventoryimages/manastone.xml")}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.NONE, nil, nil, nil, nil, "saber", "images/inventoryimages/sword_red.xml")
aestus_estus_recipe.sortkey = 9998
local excalibur_morgan_recipe = AddRecipe("sword_black", {Ingredient("manastone", 1, "images/inventoryimages/manastone.xml")}, GLOBAL.RECIPETABS.WAR, GLOBAL.TECH.NONE, nil, nil, nil, nil, "saber", "images/inventoryimages/sword_black.xml")
excalibur_morgan_recipe.sortkey = 9999

GLOBAL.STRINGS.RECIPE_DESC.SWORD_BLUE = "Summons the holy sword, Excalibur."
GLOBAL.STRINGS.RECIPE_DESC.SWORD_RED = "Summons the crimson sword, Aestus Estus."
GLOBAL.STRINGS.RECIPE_DESC.SWORD_WHITE = "Summons the symbol of the king, Caliburn."
GLOBAL.STRINGS.RECIPE_DESC.SWORD_BLACK = "Summons the sword of darkness."
GLOBAL.STRINGS.RECIPE_DESC.MANASTONE = "Crafts a crystal filled with mana."

-- Custom speech strings
GLOBAL.STRINGS.CHARACTERS.SABER = require "speech_saber"

-- The character's name as appears in-game 
GLOBAL.STRINGS.NAMES.SABER = "Saber"

-- The default responses of examining the character
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.SABER = 
{
	GENERIC = "Saber, the king of knights?",
	GHOST = "Maybe she doesn't have enough mana to revive herself?",
}

AddComponentPostInit("inventory", function(self)
local DropItem_base = self.DropItem -- store the default function
function self:DropItem(item, ...)
if item == nil then
return false
end
if item:HasTag("undroppable") then
return false -- if the item has the tag, do nothing
else
return DropItem_base(self, item, ...) -- otherwise, use default execution
end
end
end)

AddMinimapAtlas("images/map_icons/saber.xml")
AddMinimapAtlas("images/map_icons/sword_blue.xml")
AddMinimapAtlas("images/map_icons/sword_red.xml")
AddMinimapAtlas("images/map_icons/sword_white.xml")
AddMinimapAtlas("images/map_icons/sword_black.xml")

-- Add mod character to mod character list. Also specify a gender. Possible genders are MALE, FEMALE, ROBOT, NEUTRAL, and PLURAL.
AddModCharacter("saber", "FEMALE")
modimport("scripts/saber_skins.lua")