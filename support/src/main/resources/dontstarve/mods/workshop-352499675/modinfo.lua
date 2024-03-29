name = "DST Resurrection Shelter"
description = "Another island masterpiece!"
author = "Afro1967"
version = "1.4"

forumthread = "19505-Modders-Your-new-friend-at-Klei!"

--dont_starve_compatible = true
--reign_of_giants_compatible = true
all_clients_require_mod = true
dst_compatible = true
client_only_mod = false

api_version = 10
icon_atlas = "r_shelter.xml"
icon = "r_shelter.tex"

configuration_options =
{
	{
		name = "Mode", 
		label = "Difficulty",
		hover = "Here you can choose the recipe for your Resurrection Shelter",
		options = 
	{
		{description = "Easy", data = "easy", hover = "5 Logs 4 Pig Skins and 4 Rope"},
		{description = "Normal", data = "normal", hover = "4 Beard Hair 2 Nightmaire Fuel and 10 logs"},
		{description = "Hard", data = "hard", hover = "1 Life Giving Amulet 5 Nightmare Fuel and 10 Boards"},
	},
		default = "normal",
	},	

	{
		name = "", 
		label = "",
		options = 
	{
		{description = "", data = 0},
	},
		default = 0,
	},	

	{
		name = "ShelterUses", 
		label = "How Many Uses ?",
		hover = "Here you can choose how many uses you will get from your Resurrection Shelter ",
		options = 
	{
		{description = "5", data = 5, hover = "5 uses and the Resurrection Shelter will be destroyed"},
		{description = "10", data = 10, hover = "10 uses and the Resurrection Shelter will be destroyed"},
		{description = "20", data = 20, hover = "20 uses and the Resurrection Shelter will be destroyed"},
		{description = "Endless Uses", data = 1000000, hover = "Unlimited uses of the Resurrection Shelter"},
	},
		default = 5,
	},

	{
		name = "", 
		label = "",
		options = 
	{
		{description = "", data = 0},
	},
		default = 0,
	},	

	{
		name = "ShelterLight", 
		label = "Enable Night Light ?",
		hover = "Here you can choose to enable or disable the night light",
		options = 
	{
		{description = "No", data = "no", hover = "You will have no light if resurrected in the dark"},
		{description = "Yes !", data = "yes", hover = "You will have light if resurrected in the dark"},
	},
		default = "yes",
	},
}

