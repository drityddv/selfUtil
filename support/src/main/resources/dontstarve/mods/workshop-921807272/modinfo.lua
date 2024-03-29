name = " 妖刀红樱RedSakura"
description =
[[Make RedSakura in the botton of recipetabs - Fight
Every hit will absorb some health from the target after a short delay.
This effect can be stacked through hitting the target multiple times over a short period of time.
Initial durability is 5, hitting mobs or objects that have a healthbar will inrease durability.
Higher the durability, higher the damage over time, and faster the attack speed.
At max durability, each hit will deal over 200 actual damage.
It's a long way to go...
]]
author = "柴柴"
version = "1.2.1"

forumthread = ""

api_version = 10

dst_compatible = true
dont_starve_compatible = false
reign_of_giants_compatible = false
all_clients_require_mod = true


icon_atlas = "modicon.xml"
icon = "modicon.tex"

server_filter_tags = {}

configuration_options =
{
	{
        name = "Lan",
        label = "Language",
        options =   {
                        {description = "English", data = true},
                        {description = "Chinese", data = false},
                    },
        default = true,
    },

    {
        name = "Chop",
        label = "Use as a axe",
        options =   {
                        {description = "Yes", data = true},
                        {description = "No", data = false},
                    },
        default = true,
    },
    
    {
        name = "Mine",
        label = "Use as a pickaxe",
        options =   {
                        {description = "Yes", data = true},
                        {description = "No", data = false},
                    },
        default = true,
    },

    {
        name = "Dig",
        label = "Use as a shovel",
        options =   {
                        {description = "Yes", data = true},
                        {description = "No", data = false},
                    },
        default = false,
    },
	
	{
        name = "Hammer",
        label = "Use as a hammer",
        options =   {
                        {description = "Yes", data = true},
                        {description = "No", data = false},
                    },
        default = false,
    },

    {
        name = "Armor",
        label = "Can equip armor",
        options =   {
                        {description = "Yes", data = true},
                        {description = "No", data = false},
                    },
        default = true,
    },

 }

