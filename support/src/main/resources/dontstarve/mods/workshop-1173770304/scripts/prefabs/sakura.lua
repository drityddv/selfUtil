 local MakePlayerCharacter = require "prefabs/player_common"   local assets = {          Asset( "ANIM", "anim/player_basic.zip" ),         Asset( "ANIM", "anim/player_idles_shiver.zip" ),         Asset( "ANIM", "anim/player_actions.zip" ),         Asset( "ANIM", "anim/player_actions_axe.zip" ),         Asset( "ANIM", "anim/player_actions_pickaxe.zip" ),         Asset( "ANIM", "anim/player_actions_shovel.zip" ),         Asset( "ANIM", "anim/player_actions_blowdart.zip" ),         Asset( "ANIM", "anim/player_actions_eat.zip" ),         Asset( "ANIM", "anim/player_actions_item.zip" ),         Asset( "ANIM", "anim/player_actions_uniqueitem.zip" ),         Asset( "ANIM", "anim/player_actions_bugnet.zip" ),         Asset( "ANIM", "anim/player_actions_fishing.zip" ),         Asset( "ANIM", "anim/player_actions_boomerang.zip" ),         Asset( "ANIM", "anim/player_bush_hat.zip" ),         Asset( "ANIM", "anim/player_attacks.zip" ),         Asset( "ANIM", "anim/player_idles.zip" ),         Asset( "ANIM", "anim/player_rebirth.zip" ),         Asset( "ANIM", "anim/player_jump.zip" ),         Asset( "ANIM", "anim/player_amulet_resurrect.zip" ),         Asset( "ANIM", "anim/player_teleport.zip" ),         Asset( "ANIM", "anim/wilson_fx.zip" ),         Asset( "ANIM", "anim/player_one_man_band.zip" ),         Asset( "ANIM", "anim/shadow_hands.zip" ),         Asset( "SOUND", "sound/sfx.fsb" ),         Asset( "SOUND", "sound/wilson.fsb" ),         Asset( "ANIM", "anim/beard.zip" ),          Asset( "ANIM", "anim/sakura.zip" ),         Asset( "ANIM", "anim/ghost_sakura_build.zip" ),         Asset( "IMAGE", "images/saveslot_portraits/sakura.tex" ),         Asset( "ATLAS", "images/saveslot_portraits/sakura.xml" ),          Asset( "IMAGE", "images/selectscreen_portraits/sakura.tex" ),         Asset( "ATLAS", "images/selectscreen_portraits/sakura.xml" ),                  Asset( "IMAGE", "images/selectscreen_portraits/sakura_silho.tex" ),         Asset( "ATLAS", "images/selectscreen_portraits/sakura_silho.xml" ),          Asset( "IMAGE", "bigportraits/sakura.tex" ),         Asset( "ATLAS", "bigportraits/sakura.xml" ),                  Asset( "IMAGE", "images/map_icons/sakura.tex" ),         Asset( "ATLAS", "images/map_icons/sakura.xml" ),                  Asset( "IMAGE", "images/avatars/avatar_sakura.tex" ),         Asset( "ATLAS", "images/avatars/avatar_sakura.xml" ),                  Asset( "IMAGE", "images/avatars/avatar_ghost_sakura.tex" ),         Asset( "ATLAS", "images/avatars/avatar_ghost_sakura.xml" ), } local prefabs = {} local start_inv = {     "sakurasword", }  STRINGS.CHARACTERS.GENERIC.DESCRIBE.SAKURA =  {         GENERIC = "It's Yae Sakura!",         ATTACKER = "That Yae Sakura looks shifty...",         MURDERER = "Murderer!",         REVIVER = "Yae Sakura, friend of ghosts.",         GHOST = "Yae Sakura could use a heart.", }  local function onattack(inst, data)     local victim = data.target     if victim.sakurafx ~= nil then return end     if victim.sakuranum == nil then         victim.sakuranum = TUNING.SAKURA_ATTACK_DELTA     else         victim.sakuranum = victim.sakuranum + TUNING.SAKURA_ATTACK_DELTA     end     if victim.sakuranum >= 6 then         victim.sakuranum = 0         victim.sakurafx = SpawnPrefab("sakuramark")         victim.sakurafx.entity:SetParent(victim.entity)         victim.sakurafx.Transform:SetPosition(0,1,0)     end end  local common_postinit = function(inst)  inst.MiniMapEntity:SetIcon( "sakura.tex" )     inst:AddTag("sakura") end  local master_postinit = function(inst) inst.soundsname = "willow" inst.components.health:SetMaxHealth(150) inst.components.hunger:SetMax(150) inst.components.sanity:SetMax(150) inst.components.combat.damagemultiplier = 1     inst:ListenForEvent("onattackother", onattack) end  return MakePlayerCharacter("sakura", prefabs, assets, common_postinit, master_postinit, start_inv)