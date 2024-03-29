local assets =
{
	Asset( "ANIM", "anim/annie.zip" ),
	Asset( "ANIM", "anim/ghost_annie_build.zip" ),
}

local skins =
{
	normal_skin = "annie",
	ghost_skin = "ghost_annie_build",
}

local base_prefab = "annie"

local tags = {"ANNIE", "CHARACTER"}

return CreatePrefabSkin("annie_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})