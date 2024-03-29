name = "Increase Storage"
description = "Increase the slot-number of containers such as backpacks, chests, bundles, and even Chester. All values are configurable."
author = "Luis95R" --Thank you for everything Koma. I'll always remember you. -Luis
forumthread = ""
version = "1.2"
api_version = 10
priority = 9000
dont_starve_compatible = false
reign_of_giants_compatible = false
dst_compatible = true
all_clients_require_mod = true
server_only_mod = true
server_filter_tags = {"increase storage"}
icon_atlas = "preview.xml"
icon = "preview.tex"
configuration_options =
{
   	{
		name = "INCREASEBACKPACKSIZES_BACKPACK",
		label = "Backpack",
		options =	{
						{description = "8(default)", data = 8},
						{description = "10", data = 10},
						{description = "12", data = 12},
						{description = "14", data = 14},
						{description = "16", data = 16},
						{description = "18", data = 18},
					},
		default = 8,
	  },
     {
		name = "INCREASEBACKPACKSIZES_PIGGYBACK",
		label = "Piggyback",
		options =	{
						{description = "12(default)", data = 12},
						{description = "14", data = 14},	
						{description = "16", data = 16},
						{description = "18", data = 18},
					},
		default = 12,
	  },
     {
		name = "INCREASEBACKPACKSIZES_KRAMPUSSACK",
		label = "Krampus Sack",
		options =	{
						{description = "14(default)", data = 14},
						{description = "16", data = 16},
						{description = "18", data = 18},						
					},
		default = 14,
	  },
   	 {
		name = "INCREASEBACKPACKSIZES_ICEPACK",
		label = "Insulation Pack",
		options =	{
						{description = "8(default)", data = 8},
						{description = "10", data = 10},
						{description = "12", data = 12},
						{description = "14", data = 14},
						{description = "16", data = 16},
						{description = "18", data = 18},
					},
		default = 8,
	  },	  
     {
		name = "largericebox",
		label = "Ice Box",
		options =	{
						{description = "9(default)", data = 9},
						{description = "12", data = 12},
						{description = "16", data = 16},
						{description = "20", data = 20},
						{description = "24", data = 24},
					},
		default = 9,
	  },	  
     {
		name = "largertreasurechest",
		label = "Chest",
		options =	{
						{description = "9(default)", data = 9},
						{description = "12", data = 12},
						{description = "16", data = 16},
						{description = "20", data = 20},
						{description = "24", data = 24},
					},
		default = 9,
	  },
     {
		name = "largerdragonflychest",
		label = "Scaled Chest",
		hover = "Includes Shadow Chester.",
		options =	{
						{description = "12(default)", data = 12},
						{description = "16", data = 16},
						{description = "20", data = 20},
						{description = "24", data = 24},
					},
		default = 12,
	  },
     {
		name = "largerbundlecontainer",
		label = "Bundle",
		options =	{
						{description = "4(default)", data = 4},		
						{description = "9", data = 9},
						{description = "12", data = 12},
						{description = "16", data = 16},
						{description = "20", data = 20},
						{description = "24", data = 24},
					},
		default = 4,
	  },	  
	 {
		name = "largerchester",
		label = "Chester",
		hover = "Includes Snow Chester & Hutch.",
		options =	{
						{description = "9(default)", data = 9},
						{description = "12", data = 12},
					},
		default = 9,
	  },	  
}