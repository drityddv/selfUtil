local assets =
{
	Asset( "ANIM", "anim/saber.zip" ),
	Asset( "ANIM", "anim/ghost_saber_build.zip" ),
}

local skins =
{
	normal_skin = "saber",
	ghost_skin = "ghost_saber_build",
}

local base_prefab = "saber"

local tags = {"SABER", "CHARACTER"}

return CreatePrefabSkin("saber_none",
{
	base_prefab = base_prefab, 
	skins = skins, 
	assets = assets,
	tags = tags,
	
	skip_item_gen = true,
	skip_giftable_gen = true,
})