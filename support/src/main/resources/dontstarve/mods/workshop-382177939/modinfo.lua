name = "DST Storm Cellar"
description = "This thing should hold all my junk."
author = "Afro1967"
version = "1.9"

forumthread = "19505-Modders-Your-new-friend-at-Klei!"

api_version = 10

priority = - 1
dst_compatible = true
all_clients_require_mod = true
client_only_mod = false

icon_atlas = "cellar.xml"
icon = "cellar.tex"

configuration_options =
{
	{
		name = "eightxten",
		label = "Slot Positions",
        hover = "Here's where you to change the positions of the slots",
		options =
	{
		{description = "5 x 16", data = "5x16", hover = "5 slots hight and 16 slots wide"},
		{description = "8 x 10", data = "8x10", hover = "8 slots high and 10 slots wide"},
	},
		default = "5x16",
	},

	{
		name = "",
		label = "",
		options =
	{
		{description = "", data = true },
	},
		default = true,
	},

	{
		name = "workit",
		label = "Workable",
        hover = "If Yep, the cellar can be destroyed by Giants, Meteors and a Hammer.",
		options =
	{
		{description = "Yep", data = "yep", hover = "The cellar can be destroyed."},
		{description = "Nope", data = "nope", hover = "The cellar can not be destroyed."},
	},
		default = "yep",
	},

	{
		name = "chillit",
		label = "Fridge",
        hover = "If Yep, the cellar can be used as a fridge.",
		options =
	{
		{description = "Yep", data = "yep", hover = "Yes give me the damn fridge."},
		{description = "Nope", data = "nope", hover = "No I don't need this big of a damn fridge."},
	},
		default = "yep",
	},
}	