local G = GLOBAL
local STRINGS = G.STRINGS

G.SABERSKINS = {
	saber = {
		["blue"] = {
			builds = {
				normal_skin = "saber_blue",
				ghost_skin = "ghost_saber_blue_build",
			},
		},
		["blue_armor"] = {
			builds = {
				normal_skin = "saber_blue_armor",
				ghost_skin = "ghost_saber_blue_armor_build",
			},
		},
	    ["red"] = {
			builds = {
				normal_skin = "saber_red",
				ghost_skin = "ghost_saber_red_build",
			},
		},
		["white"] = {
			builds = {
				normal_skin = "saber_white",
				ghost_skin = "ghost_saber_white_build",
			},
		},
		["black"] = {
			builds = {
				normal_skin = "saber_black",
				ghost_skin = "ghost_saber_black_build",
			},
		},
		      },
--	ITEMS = {}
}

if G.SKIN_RARITY_COLORS.ModMade ~= nil then G.MakeModCharacterSkinnable("saber") end