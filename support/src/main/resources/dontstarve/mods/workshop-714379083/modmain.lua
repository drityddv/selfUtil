PrefabFiles = {"rin", "rin_none"}

Assets = {

    Asset( "IMAGE", "images/saveslot_portraits/rin.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/rin.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/rin.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/rin.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/rin_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/rin_silho.xml" ),

    Asset( "IMAGE", "bigportraits/rin.tex" ),
    Asset( "ATLAS", "bigportraits/rin.xml" ),
	
	Asset( "IMAGE", "images/map_icons/rin.tex" ),
	Asset( "ATLAS", "images/map_icons/rin.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_rin.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_rin.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_rin.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_rin.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_rin.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_rin.xml" ),
	
	Asset( "IMAGE", "images/names_rin.tex" ),
    Asset( "ATLAS", "images/names_rin.xml" ),
	
    Asset( "IMAGE", "bigportraits/rin_none.tex" ),
    Asset( "ATLAS", "bigportraits/rin_none.xml" ),

}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

STRINGS.CHARACTER_TITLES.rin = "The Hell Cat"
STRINGS.CHARACTER_NAMES.rin = "Rin"
STRINGS.CHARACTER_DESCRIPTIONS.rin = "*Servant of The Underworld\n*Quick Reflexes\n*Fishy Love"
STRINGS.CHARACTER_QUOTES.rin = "\"Orin-nyan :3\""

STRINGS.CHARACTERS.RIN = require "speech_rin"

STRINGS.NAMES.RIN = "Rin"

AddMinimapAtlas("images/map_icons/rin.xml")

AddModCharacter("rin", "FEMALE")

--Current Mod Version: [1.3.8]
--DST Character Mod created by: Senshimi [https://steamcommunity.com/id/Senshimi/]
--Touhou Project Collection: [http://steamcommunity.com/sharedfiles/filedetails/?id=701414094]
