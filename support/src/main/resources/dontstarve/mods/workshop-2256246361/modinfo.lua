name = "Fuel-Sharing Ice Flingomatic"
description = [[
Shares fuel, turn-on and turn-off with connected Ice Flingomatics

]]
author = "Gleenus and Catherine"
version = "1.03"
forumthread = ""
api_version = 10
dst_compatible = true

all_clients_require_mod = false
client_only_mod = false

icon_atlas = "images/modicon.xml"
icon = "modicon.tex"

----------------------------
-- Configuration settings --
----------------------------


configuration_options = 
{
    {
        name = "CONNECTION_RANGE",
        label = "Connection Range",
		hover = "The maximum range for the Ice Flingomatics be connected.",
        options =
        {
            {description = "Entire Map", data = -1},
            {description = "1 radius", data = 15},
			{description = "2 radius", data = 30},
			{description = "3 radius", data = 45},
			{description = "4 radius", data = 60},
			{description = "5 radius", data = 75},
			{description = "6 radius", data = 90},
			{description = "7 radius", data = 105},
			{description = "8 radius", data = 120},
			{description = "9 radius", data = 135},
			{description = "10 radius", data = 150},
        },
        default = -1,
    },
    {
        name = "CONNECTION_FUEL",
        label = "Share Fuel",
		hover = "The connected Ice Flingomatics should share fuel?",
        options =
        {
			{description = "No", data = false},
			{description = "Yes", data = true},
        },
        default = true,
    },
    {
        name = "CONNECTION_TURNON",
        label = "Share Turn-On",
		hover = "The connected Ice Flingomatics turn on together?",
        options =
        {
			{description = "No", data = false},
			{description = "Yes", data = true},
        },
        default = true,
    },
    {
        name = "CONNECTION_TURNOFF",
        label = "Share Turn-Off",
		hover = "The connected Ice Flingomatics turn off together?",
        options =
        {
			{description = "No", data = false},
			{description = "Yes", data = true},
        },
        default = true,
    },

    {
        name = "CONNECTION_NEEDON",
        label = "Need to be on to share fuel",
		hover = "Require to be on to share fuel.",
        options =
        {
			{description = "No", data = false},
			{description = "Yes", data = true},
        },
        default = false,
    },
}
