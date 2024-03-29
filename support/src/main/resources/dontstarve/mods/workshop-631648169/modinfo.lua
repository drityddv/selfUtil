name = "  [DST]怪物击杀公告-Shang"
Old_ver = "2019-03-16_22:26"
version = "02:13 2019-10-29"
description = "当前版本: "..version.."    上一版本："..Old_ver..
	"\n这是最近优化的版本，如果您遇到Bugs请提交\n作者QQ：646469067，作者粉丝群：154768151"..
	"\n\n为了回应评论里的要求，本Mod已将怪物增强功能删除"..
	"\n\n本Mod修改内容如下："..
	"\n1.海象、座狼、钢羊、电羊、蜘蛛女王和各大Boss的击杀公告。"..
	"\n2.各大Boss、赃物袋、格罗姆出现公告坐标，格罗姆自然回血。"..
	"\n3.威洛遭受攻击，攻击者会燃烧，不可被点燃者除外。"..
	"\n温馨提示：以上皆可以在mod配置里随意关闭"

author = "Shang"

forumthread = ""

api_version = 10
dst_compatible = true
dont_starve_compatible = true
reign_of_giants_compatible = true
all_clients_require_mod = false
client_only_mod = false
server_only_mod = true
icon_atlas = "diybicon.xml"
icon = "diybicon.tex"

configuration_options = {}
local on_off_options = {
	{description = "On", data = false},
	{description = "Off", data = true},
}

local opt_Empty = {{description = "", data = 0}}
local function AddTitle(title,hover)
	configuration_options[#configuration_options + 1] = {
		name=title,
		--label=title,
		hover=hover,
		options=opt_Empty,
		default=0,
	}
end
-- local SEPARATOR = Title("")

-- Title(russian and "ОПЦИИ ДОБЫЧИ" or "战利品的几率"),

local function AddPatch(name, label)
	configuration_options[#configuration_options + 1] = {
		name = name,
		label = label,
		options = on_off_options,
		default = false,
		hover = "默认为开启以下指定怪物的击杀公告",
	}
end

AddTitle("基本配置")
AddPatch("XianZuoBiao", "display Boss Pos 显示Boss坐标")
AddPatch("GlommerXue",  "Glommer HP Regen 格罗姆回血")
AddPatch("WillowShao",  "Willow fire 攻击薇洛者不会FFF")
AddPatch("Klaus_sack",  "Klaus sack 赃物袋出现时公告坐标")
AddTitle("")
AddTitle("Boss公告")
AddPatch("Mod_Boss_9",  "Glommer 格罗姆")
AddPatch("Mod_Boss_6",  "Klaus 克劳斯")
AddPatch("Mod_Boss_1",  "Minotaur 守护者")
AddPatch("Mod_Boss_2",  "Deerclops 雪巨鹿")
AddPatch("Mod_Boss_3",  "Bearger 比尔熊")
AddPatch("Mod_Boss_4",  "Dragonfly 龙蜻蜓")
AddPatch("Mod_Boss_5",  "Moose 鹿角鹅")
AddPatch("Mod_Boss_7",  "Toadstool 毒蟾蜍")
AddPatch("Mod_Boss_8",  "Beequeen 蜂王后")
AddPatch("Mod_Boss_19",  "antlion 夏蚁狮")
AddPatch("Mod_Boss_20",  "malbatross 邪天翁")
AddTitle("")
AddTitle("中Boss击杀公告")
AddPatch("Mod_Boss_10", "Koalefant summer 考拉夏")
AddPatch("Mod_Boss_11", "Koalefant winter 考拉冬")
AddPatch("Mod_Boss_12", "Beefalo 弗洛牛")
AddPatch("Mod_Boss_13", "Little walrus 小海象")
AddPatch("Mod_Boss_14", "Walrus 海象爹")
AddPatch("Mod_Boss_15", "Spiderqueen 蜘蛛王")
AddPatch("Mod_Boss_16", "Warg 座狼王")
AddPatch("Mod_Boss_17", "Spat goat 口水羊")
AddPatch("Mod_Boss_18", "Lightning goat 闪电羊")