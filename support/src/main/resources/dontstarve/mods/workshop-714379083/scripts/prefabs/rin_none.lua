local assets =
{

	Asset( "ANIM", "anim/rin.zip" ),
	Asset( "ANIM", "anim/ghost_rin_build.zip" ),
	
}

local skins =
{

	normal_skin = "rin",
	ghost_skin = "ghost_rin_build",
	
}

local base_prefab = "rin"

local tags = {"RIN", "CHARACTER"}

return CreatePrefabSkin("rin_none",
{

	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
	
})

--Current Mod Version: [1.3.8]
--DST Character Mod created by: Senshimi [https://steamcommunity.com/id/Senshimi/]
--Touhou Project Collection: [http://steamcommunity.com/sharedfiles/filedetails/?id=701414094]
