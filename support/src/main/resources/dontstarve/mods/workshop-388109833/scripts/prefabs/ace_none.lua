local assets =
{
	Asset( "ANIM", "anim/ace.zip" ),
	Asset( "ANIM", "anim/ghost_ace_build.zip" ),
}

local skins =
{
	normal_skin = "ace",
	ghost_skin = "ghost_ace_build",
}

local base_prefab = "ace"

local tags = {"ACE", "CHARACTER"}

return CreatePrefabSkin("ace_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})