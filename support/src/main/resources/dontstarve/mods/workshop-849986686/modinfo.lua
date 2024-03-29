-- This information tells other players more about the mod
name = "Better pet"
description = "Strengthen these useless pet.\n"--[[..
"KittyKit: Feed KittyKit will get a ×1.2 speed buff which continues 0.5 day.\n"..
"Vargling: Feed Vargling will get a ×1.2 damage buff which continues 0.5 day.\n"..
"Ewelet: Bring a 3×3 chest, to open it, you need to put something in it.\n"..
"Broodling: Have a forever light.\n"..
"Glomglom: Have a sanityaura like glommer.\n\n"..
"强化了那些只会卖萌的小宠物。\n"..
"小猫：喂食可获得一个持续半天的速度×1.2的BUFF。\n"..
"小狗：喂食可获得一个持续半天的伤害×1.2的BUFF。\n"..
"小羊：自带一个3×3的箱子，需要试图往里面放东西来打开。\n"..
"小蜻蜓：自带光源。\n"..
"小格格姆：自带回精神光环。\n"]]--
author = "宵征"
version = "1.1" -- This is the version of the template. Change it to your own number.

-- This is the URL name of the mod's thread on the forum; the part after the ? and before the first & in the url
forumthread = ""


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
server_filter_tags = {"pet"}