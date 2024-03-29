require("stategraphs/commonstates")

local actionhandlers = {
	ActionHandler(ACTIONS.EAT, "eat"),
	ActionHandler(ACTIONS.CHOP, "chop")
}

local attacks_til_groundpound = 4

local function onattackfn(inst)
    if inst.components.health ~= nil and
        not inst.components.health:IsDead() and
        (inst.sg:HasStateTag("hit") or not inst.sg:HasStateTag("busy")) then

        if (attacks_til_groundpound - 1) <= 0 then

        	inst.cangroundpound = true

        else

        	attacks_til_groundpound = attacks_til_groundpound - 1

        end

		if inst.cangroundpound then
            inst.sg:GoToState("pound")
        else
            inst.sg:GoToState("attack")
        end
    end
end

local events = {
	CommonHandlers.OnStep(),
	CommonHandlers.OnLocomote(true, false),
	CommonHandlers.OnDeath(),
	EventHandler("attacked", function(inst)
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("attack") then
			inst.sg:GoToState("hit")
		end
	end),
	EventHandler("doattack", onattackfn),
	EventHandler("doaction", function(inst, data) 
		if not inst.components.health:IsDead() and not inst.sg:HasStateTag("busy") then
			if data.action == ACTIONS.CHOP then
				inst.sg:GoToState("chop", data.target)
			end
		end
	end)
}

local function ShakeIfClose(inst)
	for i, v in ipairs(AllPlayers) do
		v:ShakeCamera(CAMERASHAKE.FULL, .7, .02, .3, inst, 40)
	end
end

local states = {
	State {
		name= "idle",
		tags = {"idle"},
		onenter = function(inst)
			inst.Physics:Stop()
		end,
		events = {
			EventHandler("animover", function(inst)
				inst.sg:GoToState("idle")
			end)
		}     
	},
    State {
		name = "death",
		tags = {"busy"},
		onenter = function(inst)
			inst.SoundEmitter:PlaySound("dontstarve/wilson/death") 
			inst.AnimState:PlayAnimation("death")
			inst.Physics:Stop()
			RemovePhysicsColliders(inst)            
			inst.components.lootdropper:DropLoot(Vector3(inst.Transform:GetWorldPosition()))            
		end
    },
	State {
		name = "run_start",
		tags = {"moving", "running", "canrotate"},
		onenter = function(inst)
			inst.components.locomotor:RunForward()
			inst.AnimState:PlayAnimation("run_pre")
			inst.sg.mem.foosteps = 0
		end,
		events = {   
			EventHandler("animover", function(inst)
				inst.sg:GoToState("run")
			end)       
		},
		timeline = {
			TimeEvent(4*FRAMES, function(inst)
				PlayFootstep(inst)
				DoFoleySounds(inst)
			end)
		}
	},
    State {
		name = "run",
		tags = {"moving", "running", "canrotate"},
		onenter = function(inst) 
			inst.components.locomotor:RunForward()
			inst.AnimState:PlayAnimation("run_loop")
		end,
		timeline = {
			TimeEvent(7*FRAMES, function(inst)
				inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
				PlayFootstep(inst, inst.sg.mem.foosteps < 5 and 1 or .6)
				DoFoleySounds(inst)
			end),
			TimeEvent(15*FRAMES, function(inst)
				inst.sg.mem.foosteps = inst.sg.mem.foosteps + 1
				PlayFootstep(inst, inst.sg.mem.foosteps < 5 and 1 or .6)
				DoFoleySounds(inst)
			end)
		},
		events = {   
			EventHandler("animover", function(inst)
				inst.sg:GoToState("run")
			end)  
		}
	},
	State {
		name = "run_stop",
		tags = {"canrotate", "idle"},
		onenter = function(inst) 
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("run_pst")
		end,
		events = {   
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle") 
			end),        
		},
	},
	State {
		name = "attack",
		tags = {"attack"},
		onenter = function(inst)
			--inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")
			inst.components.combat:StartAttack()
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk")
		end,
		timeline = {
			TimeEvent(13*FRAMES, function(inst) 
				inst.components.combat:DoAttack() 
			end),
		},
		events = {
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle") 
			end),
		},
	},
	State{
		name = "pound",
		tags = {"attack", "busy"},

		onenter = function(inst)
			--if GoToStandState(inst, "bi") then
			inst.components.inventory:Unequip( EQUIPSLOTS.HANDS )
				if inst.components.locomotor then
					inst.components.locomotor:StopMoving()
				end
				inst.AnimState:PlayAnimation("emoteXL_angry")
			inst:DoTaskInTime(1, function (inst) inst.components.inventory:Equip( inst.sword ) end )
			--end
		end,

		timeline=
		{
			TimeEvent(17*FRAMES, function(inst) inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/swhoosh") end),
			TimeEvent(20*FRAMES, function(inst)
				ShakeIfClose(inst)
				inst.components.groundpounder2:GroundPound()
				inst.cangroundpound = false
				attacks_til_groundpound = 4
				inst.SoundEmitter:PlaySound("dontstarve_DLC001/creatures/bearger/groundpound")
			end),
		},

		events=
		{
			EventHandler("animover", function(inst)
				inst.AnimState:PlayAnimation("idle")
				inst.sg:GoToState("idle")
			end),
		},
	},
	State {
		name = "chop",
		tags = {"chopping"},
		onenter = function(inst)
			inst.Physics:Stop()
			inst.AnimState:PlayAnimation("atk")
			inst.components.combat:StartAttack()
			print ("chopped once!")
		end,
		timeline = {
			TimeEvent(13*FRAMES, function(inst) 
				inst:PerformBufferedAction() 
			end),
		},
		events = {
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle") 
			end),
		},
	},
	State {
		name = "eat",
		tags = {"busy"},
		onenter = function(inst)
			inst.Physics:Stop()            
			inst.AnimState:PlayAnimation("eat")
		end,
		events = {
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle") 
			end),
		},
	},
	State {
		name = "hit",
		tags = {"busy"},
		onenter = function(inst)
			inst:InterruptBufferedAction()
			inst.SoundEmitter:PlaySound("dontstarve/wilson/hit")        
			inst.AnimState:PlayAnimation("hit")    
			inst.Physics:Stop()            
		end,
		events = {
			EventHandler("animover", function(inst) 
				inst.sg:GoToState("idle") 
			end),
		},
		timeline = {
			TimeEvent(3*FRAMES, function(inst)
				inst.sg:RemoveStateTag("busy")
			end),
		},
	}
}

CommonStates.AddWalkStates(states, {
	walktimeline = {
		TimeEvent(0*FRAMES, PlayFootstep),
		TimeEvent(12*FRAMES, PlayFootstep),
	},
})

CommonStates.AddRunStates(states, {
	runtimeline = {
		TimeEvent(0*FRAMES, PlayFootstep),
		TimeEvent(10*FRAMES, PlayFootstep),
	},
})

CommonStates.AddSimpleState(states, "refuse", "emoteXL_angry", {"busy"})

--CommonStates.AddIdle(states,"idle2")
--CommonStates.AddSimpleState(states,"hit", "hit", {"busy"})
--CommonStates.AddFrozenStates(states)
--CommonStates.AddSimpleActionState(states,"pickup", "pig_pickup", 10*FRAMES, {"busy"})
--CommonStates.AddSimpleActionState(states, "gohome", "pig_pickup", 4*FRAMES, {"busy"})

return StateGraph("summontibber", states, events, "idle", actionhandlers)