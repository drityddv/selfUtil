PrefabFiles = {
	"faroz",
	"faroz_gls",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/faroz.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/faroz.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/faroz.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/faroz.xml" ),

    Asset( "IMAGE", "bigportraits/faroz.tex" ),
    Asset( "ATLAS", "bigportraits/faroz.xml" ),
	
	Asset( "IMAGE", "images/map_icons/faroz.tex" ),
	Asset( "ATLAS", "images/map_icons/faroz.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_faroz.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_faroz.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_faroz.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_faroz.xml" ),
	
	Asset("ATLAS", "images/inventoryimages/faroz_gls.xml"),

}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

-- The character select screen lines
STRINGS.CHARACTER_TITLES.faroz = "The Little Scholar"
STRINGS.CHARACTER_NAMES.faroz = "Faroz"
STRINGS.CHARACTER_DESCRIPTIONS.faroz = "*Eat Carrot Level Up! (max30)\n*Magic Glasses.\n*Run Very Fast!"
STRINGS.CHARACTER_QUOTES.faroz = "\"Older Sister Sollyz.\""

GLOBAL.STRINGS.NAMES.FAROZ_GLS = "Magic Glasses"
GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.FAROZ_GLS = "It make me feel refreshing"

-- Custom speech strings
STRINGS.CHARACTERS.faroz = require "speech_faroz"

-- The character's name as appears in-game 
STRINGS.NAMES.faroz = "faroz"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.faroz = 
{
	GENERIC = "It's Faroz!",
	ATTACKER = "That Faroz looks shifty...",
	MURDERER = "Murderer!",
	REVIVER = "Faroz, friend of ghosts.",
	GHOST = "Faroz could use a heart.",
}

-- Let the game know character is male, female, or robot
table.insert(GLOBAL.CHARACTER_GENDERS.FEMALE, "faroz")


AddMinimapAtlas("images/map_icons/faroz.xml")
AddModCharacter("faroz")

