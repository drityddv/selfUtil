local assets =
{
	Asset( "ANIM", "anim/sakura.zip" ),
	Asset( "ANIM", "anim/ghost_sakura_build.zip" ),
}

local skins =
{
	normal_skin = "sakura",
	ghost_skin = "ghost_sakura_build",
}

local base_prefab = "sakura"

local tags = {"SAKURA", "CHARACTER"}

return CreatePrefabSkin("sakura_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})