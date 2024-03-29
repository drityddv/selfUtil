name = 'Your skeleton respawn'
description = "Resurrection from your skeleton!                                                                                                                                                                                                                                                                  Allows you to resurrect yourself on your skeleton.                                                                                                                                                                                                                                                              ----------UPDATED----------                                                                                                                                                                                                                                                                                                     + Added the ability to configure health penalty                                                                                                                                                                                                                                                                     --------------------------------"

author = 'BEKKITT'
version = '1.2.6.2'

dont_starve_compatible = true
dst_compatible = true
reign_of_giants_compatible = true

client_only_mod = false
all_clients_require_mod = false

forumthread = ''

api_version = 10

server_filter_tags = {'bekkitt', 'resurrection', 'skeleton',}

icon_atlas = 'modicon.xml'
icon = 'modicon.tex'

configuration_options =
{
	
	{
		name    = 'skeleton_player',
		label   = '',
		default = true,
		options = {
            {description = '', data = true},
		},
    },

	{
		name    = 'bekkitt_skeleton_pen',
		label   = 'Blood sacrifice',
		default = 0,
		options = {
            {description = '0%',data = 0, hover = "No health pentalty"},
            {description = '5%',              data = 0.05, hover = "5% health pentalty"},
            {description = '10%',              data = 0.1, hover = "10% health pentalty"},
            {description = '25%',              data = 0.25, hover = "Default in DST 25% health pentalty"},
            {description = '30%',              data = 0.3, hover = "30% health pentalty"},
            {description = '40%',              data = 0.4, hover = "40% health pentalty"},
            {description = '50%',              data = 0.5, hover = "50% health pentalty"},
            {description = '60%',              data = 0.6, hover = "60% health pentalty"},
            {description = '70%',              data = 0.7, hover = "70% health pentalty"},
            {description = '75%', data = 0.75, hover = "75% Max in DST health pentalty"},
        },
	},

	
	{
		name    = 'null_option',
		label   = '',
		default = true,
		options = {
            {description = '', data = true},
        },
    },
	
  
}