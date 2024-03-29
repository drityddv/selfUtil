name = "More durability [Amulets|Staffs]"
description = "Allow you to modify amulets and staffs durabilities"
author = "Aire Ayquaza"
version = "1.0.0"

forumthread = ""

api_version = 10

icon_atlas = "modicon.xml"
icon = "modicon.tex"

all_clients_require_mod = false
client_only_mod = false
dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = true

server_filter_tags = {"more durability", "durability", "reign of giants", "amulets", "staffs"}

configuration_options =
{
	{
        name = "ICESTAFF_USES",
        label = "Ice Staff uses",
        options = 
        {
            {description = "20 (default)", data = 20},
            {description = "40", data = 40},
			{description = "60", data = 60},
			{description = "80", data = 80},
			{description = "100", data = 100}
        }, 
        default = 20,
    },
	{
        name = "FIRESTAFF_USES",
        label = "Fire Staff uses",
        options = 
        {
            {description = "20 (default)", data = 20},
            {description = "40", data = 40},
			{description = "60", data = 60},
			{description = "80", data = 80},
			{description = "100", data = 100}
        }, 
        default = 20,
    },
	{
        name = "YELLOWSTAFF_USES",
        label = "Star Caller's Staff uses",
        options = 
        {
            {description = "20 (default)", data = 20},
            {description = "40", data = 40},
			{description = "60", data = 60},
			{description = "80", data = 80},
			{description = "100", data = 100}
        }, 
        default = 20,
    },
	{
        name = "ORANGESTAFF_USES",
        label = "The Lazy Explorer uses",
        options = 
        {
            {description = "20 (default)", data = 20},
            {description = "40", data = 40},
			{description = "60", data = 60},
			{description = "80", data = 80},
			{description = "100", data = 100}
        }, 
        default = 20,
    },
	{
        name = "GREENSTAFF_USES",
        label = "Deconstruction Staff uses",
        options = 
        {
            {description = "5 (default)", data = 5},
            {description = "10", data = 10},
			{description = "15", data = 15},
			{description = "20", data = 20},
			{description = "25", data = 25}
        }, 
        default = 5,
    },
	{
        name = "TELESTAFF_USES",
        label = "Telelocator Staff uses",
        options = 
        {
            {description = "5 (default)", data = 5},
            {description = "10", data = 10},
			{description = "15", data = 15},
			{description = "20", data = 20},
			{description = "25", data = 25}
        }, 
        default = 5,
    },
	{
        name = "TORNADOSTAFF_USES",
        label = "Weather Pain uses",
        options = 
        {
            {description = "15 (default)", data = 15},
            {description = "30", data = 30},
			{description = "45", data = 45},
			{description = "60", data = 60},
			{description = "75", data = 75}
        }, 
        default = 15,
    },
	{
        name = "REDAMULET_USES",
        label = "Life Giving Amulet uses",
        options = 
        {
            {description = "20 (default)", data = 20},
            {description = "40", data = 40},
			{description = "60", data = 60},
			{description = "80", data = 80},
			{description = "100", data = 100}
        }, 
        default = 20,
    },
	{
        name = "BLUEAMULET_FUEL",
        label = "Chilled Amulet durability",
        options = 
        {
            {description = "6min (default)", data = 1},
            {description = "12min", data = 2},
			{description = "18min", data = 3},
			{description = "24min", data = 4},
			{description = "30min", data = 5}
        }, 
        default = 1,
    },
	{
        name = "PURPLEAMULET_FUEL",
        label = "Nightmare Amulet durability",
        options = 
        {
            {description = "3min 12sec (default)", data = 1},
            {description = "6min 24sec", data = 2},
			{description = "9min 36sec", data = 3},
			{description = "12min 48sec", data = 4},
			{description = "16min", data = 5}
        }, 
        default = 1,
    },
	{
        name = "YELLOWAMULET_FUEL",
        label = "Magiliminescence durability",
        options = 
        {
            {description = "8min (default)", data = 1},
            {description = "16min", data = 2},
			{description = "24min", data = 3},
			{description = "32min", data = 4},
			{description = "40min", data = 5}
        }, 
        default = 1,
    },
	{
        name = "ORANGEAMULET_USES",
        label = "The Lazy Forager uses",
        options = 
        {
            {description = "225 (default)", data = 225},
            {description = "450", data = 450},
			{description = "675", data = 675},
			{description = "1000", data = 1000},
			{description = "1225", data = 1225}
        }, 
        default = 225,
    },
	{
        name = "GREENAMULET_USES",
        label = "Construction Amulet uses",
        options = 
        {
            {description = "5 (default)", data = 5},
            {description = "10", data = 10},
			{description = "15", data = 15},
			{description = "20", data = 20},
			{description = "25", data = 25}
        }, 
        default = 5,
    }
}