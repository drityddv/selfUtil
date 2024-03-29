local interaction_list = {
	'wall_hay',
	'wall_wood',
	'wall_stone',
	'wall_ruins',
	'wall_moonrock',
	
	"rock1",
	"rock_moon",
	"rock_flintless",
	"rock_flintless_med",
	"rock_flintless_low",
	"pond",
	"pond_mos",
	"pond_cave",
	"lava_pond",
	
	"evergreen",
	"evergreen_sparse",
	"deciduoustree",
	"livingtree",
	
	"pighouse",
	"rabbithouse",
	"catcoonden",
	"spiderden",
	
	"pigman",
	"bunnyman",
	"perd",
	"spider",
	"frog",
	"hound",
	"firehound",
	"icehound",
	"walrus",
	"merm",
	"knight",
	"bishop",
	"krampus",
	"mossling",
	"chester",
	"tallbird",
	"babybeefalo",
	
	"molehill",
	"mound",
	"skeleton",
	"skeleton_player",
	
	"twigs"
}

for k, v in pairs(interaction_list) do
	AddPrefabPostInit(v,function(inst)
		if GLOBAL.TheWorld.ismastersim then
			inst:AddComponent("interactions")
		end
	end)
end

AddPlayerPostInit(function(inst)
	if GLOBAL.TheWorld.ismastersim then
		inst:AddComponent("interactions")
		inst:DoPeriodicTask(0.25,function()
			if inst.Transform and inst.Transform.GetRotation then
				inst.old_rotation = inst.Transform:GetRotation()
			end
		end)
	end
end)

-- Actions ------------------------------

AddAction("WALLJUMP", "Jump", function(act)
	if act.doer ~= nil and act.target ~= nil and act.doer:HasTag('player') and act.target.components.interactions and act.target:HasTag("wall") and (act.target.components.health == nil or not act.target.components.health:IsDead()) then
		act.target.components.interactions:WallJump(act.doer)
		return true
	else
		return false
	end
end)

AddAction("JUMPOVER", "Jump", function(act)
	if act.doer ~= nil and act.target ~= nil and act.doer:HasTag('player') and act.target.components.interactions and (act.target:HasTag("boulder") or act.target:HasTag("watersource") or act.target:HasTag("lava") or act.doer == act.target or act.target:HasTag("cattoy")) then
		act.target.components.interactions:Jump(act.doer)
		return true
	else
		act.doer.sg:GoToState("idle")
		return false
	end
end)

AddAction("TREEHIDE", "Hide (-3)", function(act)
	if act.doer ~= nil and act.target ~= nil and act.doer:HasTag('player') and act.target.components.interactions and act.target:HasTag("tree") and not act.target:HasTag("burnt") and not act.target:HasTag("fire") and not act.target:HasTag("stump") then
		act.target.components.interactions:Hide(act.doer)
		return true
	else
		return false
	end
end)

AddAction("TAKEREFUGE", "Take refuge (-3)", function(act)
	if act.doer ~= nil and act.target ~= nil and act.doer:HasTag('player') and act.target.components.interactions and act.target:HasTag("structure") and not act.target:HasTag("burnt") and not act.target:HasTag("fire")then
		act.target.components.interactions:TakeRefuge(act.doer)
		return true
	else
		return false
	end
end)

AddAction("PUSH", "Push", function(act)
	if act.doer ~= nil and act.target ~= nil and act.target ~= act.doer and act.doer:HasTag('player') and act.doer.components.interactions and act.target:HasTag("player") and act.target ~= act.doer then
		act.doer.components.interactions:Push(act.target)
		return true
	else
		return false
	end
end)

AddAction("SHOVE", "Shove", function(act)
	if act.doer ~= nil and act.target ~= nil and act.target ~= act.doer and act.doer:HasTag('player') and act.doer.components.interactions and (act.target:HasTag("character") or act.target:HasTag("monster") or act.target:HasTag("animal") or act.target:HasTag("beefalo")) and act.target ~= act.doer then
		act.doer.components.interactions:Push(act.target)
		return true
	else
		return false
	end
end)

AddAction("SEARCH", "Search (-2)", function(act)
	if act.doer ~= nil and act.target ~= nil and act.doer:HasTag('player') and act.target.components.interactions and act.target.prefab and ((act.target.prefab == "molehill" and not GLOBAL.TheWorld.state.isday) or act.target.prefab == "mound" or act.target.prefab == "skeleton" or act.target.prefab == "skeleton_player") then
		act.target.components.interactions:Search(act.doer)
		return true
	else
		return false
	end
end)

-- Component actions ---------------------

AddComponentAction("SCENE", "interactions", function(inst, doer, actions, right)
	if right then
		if inst:HasTag("wall") and (inst.components.health == nil or not inst.components.health:IsDead()) then
			table.insert(actions, GLOBAL.ACTIONS.WALLJUMP)
		elseif inst:HasTag("boulder") or inst:HasTag("watersource") or inst:HasTag("lava") or inst == doer or inst:HasTag("cattoy") then
			table.insert(actions, GLOBAL.ACTIONS.JUMPOVER)
		elseif inst:HasTag("tree") and not inst:HasTag("burnt") and not inst:HasTag("fire") and not inst:HasTag("stump") then
			table.insert(actions, GLOBAL.ACTIONS.TREEHIDE)
		elseif inst:HasTag("structure") and not inst:HasTag("burnt") and not inst:HasTag("fire") then
			table.insert(actions, GLOBAL.ACTIONS.TAKEREFUGE)
		elseif inst:HasTag("player") and inst ~= doer then
			table.insert(actions, GLOBAL.ACTIONS.PUSH)
		elseif (inst:HasTag("character") or inst:HasTag("monster") or inst:HasTag("animal") or inst:HasTag("beefalo")) and inst ~= doer then
			table.insert(actions, GLOBAL.ACTIONS.SHOVE)
		elseif inst.prefab and ((inst.prefab == "molehill" and not GLOBAL.TheWorld.state.isday) or inst.prefab == "mound" or inst.prefab == "skeleton" or inst.prefab == "skeleton_player") then
			table.insert(actions, GLOBAL.ACTIONS.SEARCH)
		end
	end
end)

-- Stategraph ----------------------------

local state_walljump = GLOBAL.State{ name = "walljump",
	tags = { "doing", "busy" },

	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("jump_pre")
		inst.AnimState:PlayAnimation("jumpout")
		inst.Physics:SetMotorVel(0, 0, 0)
		
		inst.sg.statemem.action = inst.bufferedaction
		inst.sg:SetTimeout(2)
		if not GLOBAL.TheWorld.ismastersim then
			inst:PerformPreviewBufferedAction()
		end
	end,

	timeline =
	{
		GLOBAL.TimeEvent(4 * GLOBAL.FRAMES, function(inst)
			inst.sg:RemoveStateTag("busy")
		end),
		GLOBAL.TimeEvent(9 * GLOBAL.FRAMES, function(inst)
			if GLOBAL.TheWorld.ismastersim then
				inst:PerformBufferedAction()
			end
			inst.Physics:SetMotorVel(1.5, 0, 0)
		end),
		GLOBAL.TimeEvent(15 * GLOBAL.FRAMES, function(inst)
			inst.Physics:SetMotorVel(1, 0, 0)
		end),
		GLOBAL.TimeEvent(15.2 * GLOBAL.FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
		end),
		GLOBAL.TimeEvent(17 * GLOBAL.FRAMES, function(inst)
			inst.Physics:SetMotorVel(0.5, 0, 0)
		end),
		GLOBAL.TimeEvent(18 * GLOBAL.FRAMES, function(inst)
			inst.Physics:Stop()
		end),
	},
	
	onupdate = function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			if inst:HasTag("doing") then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.sg:GoToState("idle", true)
			end
		end
	end,
	
	ontimeout = function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			inst:ClearBufferedAction()  -- client
		end
		inst.sg:GoToState("idle")
	end,
	
	onexit = function(inst)
		if inst.bufferedaction == inst.sg.statemem.action then
			inst:ClearBufferedAction()
		end
		inst.sg.statemem.action = nil
	end,
}
AddStategraphState("wilson", state_walljump)
AddStategraphState("wilson_client", state_walljump)

local state_freejump_pre = GLOBAL.State{ name = "freejump_pre",
	tags = { "doing", "busy", "canrotate", "nomorph" },

	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("jump_pre")
		inst.sg:SetTimeout(GLOBAL.FRAMES*18)
		
		if not GLOBAL.TheWorld.ismastersim then
			inst:PerformPreviewBufferedAction()
		end
	end,

	timeline =
	{
		GLOBAL.TimeEvent(1 * GLOBAL.FRAMES, function(inst)
			if GLOBAL.TheWorld.ismastersim then
				inst:PerformBufferedAction()
			end
		end),
	},
	
	events =
	{
		GLOBAL.EventHandler("animover", function(inst)
			inst.sg:GoToState("freejump")
		end),
	},
	
	onupdate = function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			if inst:HasTag("doing") then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.sg:GoToState("idle", true)
			end
		end
	end,

	ontimeout = function(inst)
		if not GLOBAL.TheWorld.ismastersim then  -- client
			inst:ClearBufferedAction()
		end
		inst.sg:GoToState("idle")
	end,

	onexit = function(inst)
		if inst.bufferedaction == inst.sg.statemem.action then
			inst:ClearBufferedAction()
		end
		inst.sg.statemem.action = nil
	end,
}
AddStategraphState("wilson", state_freejump_pre)
AddStategraphState("wilson_client", state_freejump_pre)

AddStategraphState("wilson", GLOBAL.State{ name = "freejump",
	tags = { "doing", "busy" },

	onenter = function(inst)
		inst.components.locomotor:Stop()
		--GLOBAL.ChangeToGhostPhysics(inst)
		inst.Physics:ClearCollisionMask()
		inst.Physics:CollidesWith(GLOBAL.COLLISION.GROUND)
		inst.Physics:CollidesWith(GLOBAL.COLLISION.CHARACTERS)
		inst.Physics:CollidesWith(GLOBAL.COLLISION.GIANTS)
	
		inst.AnimState:PlayAnimation("jumpout")
		inst.Physics:SetMotorVel(9.3, 0, 0)
		
		inst.sg.statemem.action = inst.bufferedaction
		inst.sg:SetTimeout(30 * GLOBAL.FRAMES)
	end,

	timeline =
	{
		GLOBAL.TimeEvent(4.5 * GLOBAL.FRAMES, function(inst)
			inst.Physics:SetMotorVel(8.4, 0, 0)
		end),
		GLOBAL.TimeEvent(9 * GLOBAL.FRAMES, function(inst)
			inst.Physics:SetMotorVel(7.7, 0, 0)
		end),
		GLOBAL.TimeEvent(13.5 * GLOBAL.FRAMES, function(inst)
			inst.Physics:SetMotorVel(7.1, 0, 0)
		end),
		GLOBAL.TimeEvent(15.2 * GLOBAL.FRAMES, function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/movement/bodyfall_dirt")
		end),
		GLOBAL.TimeEvent(16 * GLOBAL.FRAMES, function(inst)
			inst.Physics:SetMotorVel(2, 0, 0)
		end),
		GLOBAL.TimeEvent(18 * GLOBAL.FRAMES, function(inst)
			inst.Physics:Stop()
		end),
	},

	events =
	{
		GLOBAL.EventHandler("animqueueover", function(inst)
			local x,y,z = inst.Transform:GetWorldPosition()
			if inst.AnimState:AnimDone() then
				GLOBAL.ChangeToCharacterPhysics(inst)
				inst.Transform:SetPosition(x,0,z)
				inst.sg:GoToState("idle")
			end
		end),
	},
	
	ontimeout = function(inst)
		if not GLOBAL.TheWorld.ismastersim then  -- client
			inst:ClearBufferedAction()
		end
		GLOBAL.ChangeToCharacterPhysics(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		inst.Transform:SetPosition(x,0,z)
		inst.sg:GoToState("idle")
	end,
	
	onexit = function(inst)
		GLOBAL.ChangeToCharacterPhysics(inst)
		local x,y,z = inst.Transform:GetWorldPosition()
		inst.Transform:SetPosition(x,0,z)
		if inst.bufferedaction == inst.sg.statemem.action then
			inst:ClearBufferedAction()
		end
		inst.sg.statemem.action = nil
	end,
})

local function DoTalkSound(inst)
    if inst.talksoundoverride ~= nil then
        inst.SoundEmitter:PlaySound(inst.talksoundoverride, "talk")
        return true
    elseif not inst:HasTag("mime") then
        inst.SoundEmitter:PlaySound((inst.talker_path_override or "dontstarve/characters/")..(inst.soundsname or inst.prefab).."/talk_LP", "talk")
        return true
    end
end

local function IsNearDanger(inst)
    local hounded = GLOBAL.TheWorld.components.hounded
    if hounded ~= nil and (hounded:GetWarning() or hounded:GetAttacking()) then
        return true
    end
    local burnable = inst.components.burnable
    if burnable ~= nil and (burnable:IsBurning() or burnable:IsSmoldering()) then
        return true
    end
    if inst:HasTag("spiderwhisperer") then
        return GLOBAL.FindEntity(inst, 10,
                function(target)
                    return (target.components.combat ~= nil and target.components.combat.target == inst)
                        or (not (target:HasTag("player") or target:HasTag("spider"))
                            and (target:HasTag("monster") or target:HasTag("pig")))
                end,
                nil, nil, { "monster", "pig", "_combat" }) ~= nil
    end
    return GLOBAL.FindEntity(inst, 14,
            function(target)
                return (target.components.combat ~= nil and target.components.combat.target == inst)
                    or (target:HasTag("monster") and not target:HasTag("player"))
            end,
            nil, nil, { "monster", "_combat" }) ~= nil
end

AddStategraphState("wilson", GLOBAL.State{ name = "treehide",
	tags = { "hiding", "notalking", "notarget", "nomorph", "busy", "nopredict" },

	onenter = function(inst)
		if IsNearDanger(inst) then
			if inst.components.talker then
				inst.components.talker:Say("They can still see me!")
			end
			inst.sg:GoToState("idle", true)
		end
		inst.components.locomotor:Stop()
		inst.SoundEmitter:PlaySound("dontstarve/movement/foley/hidebush")
		
		inst.sg.statemem.action = inst.bufferedaction
		inst.sg:SetTimeout(20)
		
		if not GLOBAL.TheWorld.ismastersim then
			inst:PerformPreviewBufferedAction()
		end
	end,

	timeline =
	{
		GLOBAL.TimeEvent(6 * GLOBAL.FRAMES, function(inst)
			if GLOBAL.TheWorld.ismastersim then
				inst:PerformBufferedAction()
			end
			inst:Hide()
			inst.DynamicShadow:Enable(false)
			inst.sg:RemoveStateTag("busy")
		end),
		GLOBAL.TimeEvent(24 * GLOBAL.FRAMES, function(inst)
			inst.sg:RemoveStateTag("nopredict")
			inst.sg:AddStateTag("idle")
		end),
	},

	events =
	{
		GLOBAL.EventHandler("ontalk", function(inst)
			inst.AnimState:PushAnimation("hide_idle", false)

			if inst.sg.statemem.talktask ~= nil then
				inst.sg.statemem.talktask:Cancel()
				inst.sg.statemem.talktask = nil
				inst.SoundEmitter:KillSound("talk")
			end
			if DoTalkSound(inst) then
				inst.sg.statemem.talktask =
					inst:DoTaskInTime(1.5 + math.random() * .5,
						function()
							inst.SoundEmitter:KillSound("talk")
							inst.sg.statemem.talktask = nil
						end)
			end
		end),
		GLOBAL.EventHandler("donetalking", function(inst)
			if inst.sg.statemem.talktalk ~= nil then
				inst.sg.statemem.talktask:Cancel()
				inst.sg.statemem.talktask = nil
				inst.SoundEmitter:KillSound("talk")
			end
		end),
	},

	onexit = function(inst)
        inst:Show()
		inst.DynamicShadow:Enable(true)
        inst.AnimState:PlayAnimation("run_pst")
		inst.SoundEmitter:PlaySound("dontstarve/movement/foley/hidebush")
		if inst.sg.statemem.talktask ~= nil then
			inst.sg.statemem.talktask:Cancel()
			inst.sg.statemem.talktask = nil
			inst.SoundEmitter:KillSound("talk")
		end
		
		if inst.bufferedaction == inst.sg.statemem.action then
			inst:ClearBufferedAction()
		end
		inst.sg.statemem.action = nil
	end,
	
	ontimeout = function(inst)
        inst:Show()
		inst.DynamicShadow:Enable(true)
        inst.AnimState:PlayAnimation("run_pst")
		inst.SoundEmitter:PlaySound("dontstarve/movement/foley/hidebush")
		if not GLOBAL.TheWorld.ismastersim then  -- client
			inst:ClearBufferedAction()
		end
		inst.sg:GoToState("idle")
	end,
})

AddStategraphState("wilson", GLOBAL.State{ name = "take_refuge",
	tags = { "nomorph", "busy", "refugee" },

	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
		
		inst.sg.statemem.action = inst.bufferedaction
		inst.sg:SetTimeout(15)
		
		if not GLOBAL.TheWorld.ismastersim then
			inst:PerformPreviewBufferedAction()
		end
	end,

	timeline =
	{
		GLOBAL.TimeEvent(15 * GLOBAL.FRAMES, function(inst)
			if GLOBAL.TheWorld.ismastersim then
				inst:PerformBufferedAction()
			end
			--inst.AnimState:PlayAnimation(anim_space_holder)
			inst.sg:RemoveStateTag("busy")
		end),
		GLOBAL.TimeEvent(1.5, function(inst)
			inst:Hide()
			inst.DynamicShadow:Enable(false)
		end),
	},

	onexit = function(inst)
        inst:Show()
		inst.DynamicShadow:Enable(true)
		if inst.components.health then
			inst.components.health:SetInvincible(false)
		end
        inst.AnimState:PlayAnimation("run_pst")
		inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
		
		if inst.bufferedaction == inst.sg.statemem.action then
			inst:ClearBufferedAction()
		end
		inst.sg.statemem.action = nil
	end,
	
	ontimeout = function(inst)
        inst:Show()
		inst.DynamicShadow:Enable(true)
		if inst.components.health then
			inst.components.health:SetInvincible(false)
		end
        inst.AnimState:PlayAnimation("run_pst")
		inst.SoundEmitter:PlaySound("dontstarve/common/pighouse_door")
		if not GLOBAL.TheWorld.ismastersim then  -- client
			inst:ClearBufferedAction()
		end
		inst.sg:GoToState("idle")
	end,
})

local state_sawbone = GLOBAL.State{ name = "healbonesaw",
	tags = { "doing", "busy" },

	onenter = function(inst)
		inst.components.locomotor:Stop()
		inst.AnimState:PlayAnimation("emoteXL_bonesaw")

		inst.sg.statemem.action = inst.bufferedaction
		inst.sg:SetTimeout(1.7)
		
		if not GLOBAL.TheWorld.ismastersim then
			inst:PerformPreviewBufferedAction()
		end
	end,

	timeline =
	{
		GLOBAL.TimeEvent(4 * GLOBAL.FRAMES, function(inst)
			inst.sg:RemoveStateTag("busy")
		end),
		GLOBAL.TimeEvent(12 * GLOBAL.FRAMES, function(inst)
			if GLOBAL.TheWorld.ismastersim then
				inst:PerformBufferedAction()
			end
		end),
	},
	
	onupdate = function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			if inst:HasTag("doing") then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.sg:GoToState("idle", true)
			end
		end
	end,
--[[
	events =
	{
		GLOBAL.EventHandler("animqueueover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("idle")
			end
		end),
	},
]]
	ontimeout = function(inst)
		if not GLOBAL.TheWorld.ismastersim then  -- client
			inst:ClearBufferedAction()
		end
		inst.sg:GoToState("idle")
	end,

	onexit = function(inst)
		if inst.bufferedaction == inst.sg.statemem.action then
			inst:ClearBufferedAction()
		end
		inst.sg.statemem.action = nil
	end,
}
AddStategraphState("wilson",state_sawbone)
AddStategraphState("wilson_client",state_sawbone)

local state_push = GLOBAL.State{ name = "push",
	tags = { "doing", "busy" },

	onenter = function(inst)
		inst.components.locomotor:Stop()
		
		local handitem = nil
		if inst.components.inventory then
			handitem = inst.components.inventory.equipslots[GLOBAL.EQUIPSLOTS.HANDS]
		elseif inst.replica.inventory then
			handitem = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
		end
		if handitem then
			inst.AnimState:Hide("ARM_carry")
			inst.AnimState:Show("ARM_normal")
		end
		
		inst.AnimState:PlayAnimation("punch")
		inst.SoundEmitter:PlaySound("dontstarve/wilson/attack_whoosh", nil, nil, true)
		
		inst.sg.statemem.action = inst.bufferedaction
		inst.sg:SetTimeout(2)
		
		if not GLOBAL.TheWorld.ismastersim then
			inst:PerformPreviewBufferedAction()
		end
	end,

	timeline =
	{
		GLOBAL.TimeEvent(8 * GLOBAL.FRAMES, function(inst)
			if GLOBAL.TheWorld.ismastersim then
				inst:PerformBufferedAction()
			end
		end),
		GLOBAL.TimeEvent(15 * GLOBAL.FRAMES, function(inst)
			inst.sg:RemoveStateTag("busy")
		end),
	},
	
	onupdate = function(inst)
		if not GLOBAL.TheWorld.ismastersim then
			if inst:HasTag("doing") then
				if inst.entity:FlattenMovementPrediction() then
					inst.sg:GoToState("idle", "noanim")
				end
			elseif inst.bufferedaction == nil then
				inst.sg:GoToState("idle", true)
			end
		end
	end,
--[[
	events =
	{
		GLOBAL.EventHandler("animqueueover", function(inst)
			if inst.AnimState:AnimDone() then
				inst.sg:GoToState("idle")
			end
		end),
	},
]]
	ontimeout = function(inst)
		local handitem = nil
		if inst.components.inventory then
			handitem = inst.components.inventory.equipslots[GLOBAL.EQUIPSLOTS.HANDS]
		elseif inst.replica.inventory then
			handitem = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
		end
		if handitem then
			inst.AnimState:Show("ARM_carry")
			inst.AnimState:Hide("ARM_normal")
		end
		
		if not GLOBAL.TheWorld.ismastersim then
			inst:ClearBufferedAction()  -- client
		end
		inst.sg:GoToState("idle")
	end,
	
	onexit = function(inst)
		local handitem = nil
		if inst.components.inventory then
			handitem = inst.components.inventory.equipslots[GLOBAL.EQUIPSLOTS.HANDS]
		elseif inst.replica.inventory then
			handitem = inst.replica.inventory:GetEquippedItem(GLOBAL.EQUIPSLOTS.HANDS)
		end
		if handitem then
			inst.AnimState:Show("ARM_carry")
			inst.AnimState:Hide("ARM_normal")
		end
		
		if inst.bufferedaction == inst.sg.statemem.action then
			inst:ClearBufferedAction()
		end
		inst.sg.statemem.action = nil
	end,
}
AddStategraphState("wilson", state_push)
AddStategraphState("wilson_client", state_push)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.WALLJUMP, "walljump"))
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.JUMPOVER, "freejump_pre"))
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.TREEHIDE, "treehide"))
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.TAKEREFUGE, "take_refuge"))
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.HEAL, "healbonesaw"))
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.PUSH, "push"))
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.SHOVE, "push"))
AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(GLOBAL.ACTIONS.SEARCH, "dolongaction"))

AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.WALLJUMP, "walljump"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.JUMPOVER, "freejump_pre"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.HEAL, "healbonesaw"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.PUSH, "push"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.SHOVE, "push"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(GLOBAL.ACTIONS.SEARCH, "dolongaction"))