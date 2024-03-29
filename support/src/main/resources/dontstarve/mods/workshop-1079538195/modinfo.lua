name = "Moving Box"
description = "Allows you to move structures around."
author = "Peanut Butter & Jelly"
version = "1.1.1"
forumthread = ""
api_version = 10
dst_compatible = true

all_clients_require_mod = true
client_only_mod = false

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

----------------------------
-- Configuration settings --
----------------------------
local WARNING = "\n(WARNING: Enabling this could cause unexpected behavior)"

local OPTION_LIST =
{
	{
		name = "modsupport",
		label = "Mod Support",
		hover = "Support for third-party structures."..WARNING,
		options =
		{
			{description = "Enabled", data = true, hover = "Third-party structures can be packaged."..WARNING},
			{description = "Disabled", data = false, hover = "Third-party structures can NOT be packaged."..WARNING}
		},
		default = false
	}
}

local PACKABLE_LIST =
{
	{"beebox", "Bee Box"},
	{"birdcage", "Birdcage"},
	{"cartographydesk", "Cartographer's Desk"},
	{"cookpot", "Crock Pot"},
	{"dragonflychest", "Scaled Chest"},
	{"dragonflyfurnace", "Scaled Furnace"},
	{"endtable", "End Table"},
	{"firesuppressor", "Ice Flingomatic"},
	{"icebox", "Ice Box"},
	{"lightning_rod", "Lightning Rod"},
	{"meatrack", "Drying Rack"},
	{"moondial", "Moon Dial"},
	{"mushroom_farm", "Mushroom Planter"},
	{"mushroom_light", "Mushroom Light"},
	{"nightlight", "Night Light"},
	{"perdshrine", "Gobbler Shrine"},
	{"pottedfern", "Potted Fern"},
	{"rainometer", "Rainometer"},
	{"researchlab", "Science Machine"},
	{"researchlab2", "Alchemy Engine"},
	{"researchlab3", "Shadow Manipulator"},
	{"researchlab4", "Prestihatitator"},
	{"resurrectionstatue", "Meat Effigy"},	
	{"saltlick", "Salt Lick"},
	{"scarecrow", "Friendly Scarecrow"},
	{"sculptingtable", "Potter's Wheel"},
	{"succulent_potted", "Potted Succulent"},
	{"townportal", "The Lazy Deserter"},
	{"treasurechest", "Chest"},
	{"wardrobe", "Wardrobe"},
	{"winterometer", "Thermal Measurer"},
}

for i=1, #PACKABLE_LIST do
	local option =
	{
		name = PACKABLE_LIST[i][1],
		label = PACKABLE_LIST[i][2],
		options =
		{
			{description = "Enabled", data = true, hover = "This can be packaged."},
			{description = "Disabled", data = false, hover = "This can NOT be packaged."},
		},
		default = true
	}
	
	OPTION_LIST[#OPTION_LIST+1] = option
end

configuration_options = OPTION_LIST