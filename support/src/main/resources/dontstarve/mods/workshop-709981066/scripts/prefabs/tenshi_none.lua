local assets =
{
	Asset( "ANIM", "anim/tenshi.zip" ),
	Asset( "ANIM", "anim/ghost_tenshi_build.zip" ),
}

local skins =
{
	normal_skin = "tenshi",
	ghost_skin = "ghost_tenshi_build",
}

local base_prefab = "tenshi"

local tags = {"TENSHI", "CHARACTER"}

return CreatePrefabSkin("tenshi_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})

--Current Mod Version: [1.2.8]
--DST Character Mod created by: Senshimi [https://steamcommunity.com/id/Senshimi/]
--Touhou Project Collection: [http://steamcommunity.com/sharedfiles/filedetails/?id=701414094]
