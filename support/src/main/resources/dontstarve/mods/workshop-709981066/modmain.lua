PrefabFiles = {
	"tenshi",
	"tenshi_none",
}

Assets = {
    Asset( "IMAGE", "images/saveslot_portraits/tenshi.tex" ),
    Asset( "ATLAS", "images/saveslot_portraits/tenshi.xml" ),

    Asset( "IMAGE", "images/selectscreen_portraits/tenshi.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/tenshi.xml" ),
	
    Asset( "IMAGE", "images/selectscreen_portraits/tenshi_silho.tex" ),
    Asset( "ATLAS", "images/selectscreen_portraits/tenshi_silho.xml" ),

    Asset( "IMAGE", "bigportraits/tenshi.tex" ),
    Asset( "ATLAS", "bigportraits/tenshi.xml" ),
	
	Asset( "IMAGE", "images/map_icons/tenshi.tex" ),
	Asset( "ATLAS", "images/map_icons/tenshi.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_tenshi.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_tenshi.xml" ),
	
	Asset( "IMAGE", "images/avatars/avatar_ghost_tenshi.tex" ),
    Asset( "ATLAS", "images/avatars/avatar_ghost_tenshi.xml" ),
	
	Asset( "IMAGE", "images/avatars/self_inspect_tenshi.tex" ),
    Asset( "ATLAS", "images/avatars/self_inspect_tenshi.xml" ),
	
	Asset( "IMAGE", "images/names_tenshi.tex" ),
    Asset( "ATLAS", "images/names_tenshi.xml" ),
	
    Asset( "IMAGE", "bigportraits/tenshi_none.tex" ),
    Asset( "ATLAS", "bigportraits/tenshi_none.xml" ),

}

local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS

STRINGS.CHARACTER_TITLES.tenshi = "The Grand Celestial"
STRINGS.CHARACTER_NAMES.tenshi = "Tenshi"
STRINGS.CHARACTER_DESCRIPTIONS.tenshi = "*Divine Justice / Divine Punishment\n*Spirit Awakening / Great Calamity\n*Ascension / Transcendence"
STRINGS.CHARACTER_QUOTES.tenshi = "\"If you don't punish me, The World shall be no more!\""

STRINGS.CHARACTERS.TENSHI = require "speech_tenshi"

STRINGS.NAMES.TENSHI = "Tenshi"

AddMinimapAtlas("images/map_icons/tenshi.xml")

AddModCharacter("tenshi", "FEMALE")

--Current Mod Version: [1.2.8]
--DST Character Mod created by: Senshimi [https://steamcommunity.com/id/Senshimi/]
--Touhou Project Collection: [http://steamcommunity.com/sharedfiles/filedetails/?id=701414094]
