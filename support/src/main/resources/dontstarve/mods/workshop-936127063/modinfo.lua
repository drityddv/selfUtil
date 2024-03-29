-- This information tells other players more about the mod
name = "Saber"
version = "1.05" -- This is the version of the template. Change it to your own number.
description = "I ask of you, are you my master?\n\n(Original version by kanuosi and LongFei,\nfixed\\ported to DST by Aida Enna)\nNow using the Modded Skins API!\nVersion: "..version
author = "Aida Enna"

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = "/files/file/950-extended-sample-character/"


-- This lets other players know if your mod is out of date, update it to match the current version in the game
api_version = 10

-- Compatible with Don't Starve Together
dst_compatible = true

-- Not compatible with Don't Starve
dont_starve_compatible = false
reign_of_giants_compatible = false

-- Character mods need this set to true
all_clients_require_mod = true 

icon_atlas = "modicon.xml"
icon = "modicon.tex"

-- The mod's tags displayed on the server list
server_filter_tags = {
"character",
}

menu_assets = {
	characters = {
		saber = { gender = "FEMALE", skins = { "blue", "blue_armor", "red", "white", "black" } }
	},
	skins = {
		blue = { name = "Saber (Blue Dress)", desc = "Saber blue dress description", atlas = "images/skinicons/saber_blue.xml", image = "saber_blue.tex" },
		blue_armor = { name = "Saber (Blue Armor)", desc = "Saber blue armor description", atlas = "images/skinicons/saber_blue_armor.xml", image = "saber_blue_armor.tex" },
		red = { name = "Saber (Nero)", desc = "Saber red dress description", atlas = "images/skinicons/saber_red.xml", image = "saber_red.tex" },		
		white = { name = "Saber (Lily)", desc = "Saber white armor description", atlas = "images/skinicons/saber_white.xml", image = "saber_white.tex" },
		black = { name = "Saber (Alter)", desc = "Saber black armor description", atlas = "images/skinicons/saber_black.xml", image = "saber_black.tex" },
	}
}

--configuration_options = {}