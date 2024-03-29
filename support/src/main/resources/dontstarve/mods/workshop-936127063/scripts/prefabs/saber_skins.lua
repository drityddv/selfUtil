local skins = {}
for k,v in pairs(SABERSKINS.saber) do
	local assets = {}
	for skin,anim in pairs(v.builds) do
		table.insert(assets, anim)
	end
	if SKIN_RARITY_COLORS.ModMade ~= nil then table.insert(skins, AddModCharacterSkin("saber", k, v.builds, assets, {"SABER", "CHARACTER"}, v.options)) end
end

return CreatePrefabSkin("saber_none", {
	base_prefab = "saber",
	skins = {
		normal_skin = "saber",
		ghost_skin = "ghost_saber_build",
	},
	assets = {
		Asset( "ANIM", "anim/saber.zip" ),
		Asset( "ANIM", "anim/ghost_saber_build.zip" ),
	},
	tags = {"SABER", "CHARACTER"},
	skip_item_gen = true,
	skip_giftable_gen = true,
}), unpack(skins)