PrefabFiles = {
	"ace", "acehat", "acefire", "ace_none", "willowfire",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/ace.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/ace.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/ace.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/ace.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/ace_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/ace_silho.xml" ),

    Asset( "IMAGE", "bigportraits/ace.tex" ),
    Asset( "ATLAS", "bigportraits/ace.xml" ),
	
	Asset( "IMAGE", "images/map_icons/ace.tex" ),
	Asset( "ATLAS", "images/map_icons/ace.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ace.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ace.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_ace.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_ace.xml" ),

	Asset( "IMAGE", "bigportraits/ace_none.tex" ),
    Asset( "ATLAS", "bigportraits/ace_none.xml" ),
	
	Asset( "IMAGE", "images/names_ace.tex" ),
    Asset( "ATLAS", "images/names_ace.xml" ),
}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
GLOBAL.STRINGS.NAMES.ACEHAT = "Ace's Hat"
GLOBAL.STRINGS.NAMES.ACEFIRE = "Ace's Fireball"

-- The character select screen lines
STRINGS.CHARACTER_TITLES.ace = "2nd division commander"
STRINGS.CHARACTER_NAMES.ace = "Ace"
STRINGS.CHARACTER_DESCRIPTIONS.ace = "*Firey Glow\n*Fire Immune\n*Fire everything"
STRINGS.CHARACTER_QUOTES.ace = "\"We have to live a life of no regrets.\""

-- Custom speech strings
STRINGS.CHARACTERS.ACE = require "speech_ace"

-- The character's name as appears in-game 
STRINGS.NAMES.ACE = "Ace"

-- The default responses of examining the character
STRINGS.CHARACTERS.GENERIC.DESCRIBE.ACE = 
{
	GENERIC = "It's Ace!",
	ATTACKER = "That Ace looks shifty...",
	MURDERER = "Murderer!",
	REVIVER = "Ace, friend of ghosts.",
	GHOST = "Ace could use a heart.",
}

-- Let the game know character is male, female, or robot
table.insert(GLOBAL.CHARACTER_GENDERS.MALE, "ace")


AddMinimapAtlas("images/map_icons/ace.xml")
AddModCharacter("ace")

