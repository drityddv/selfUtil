require "behaviours/standstill"
require "behaviours/chattynode"
require "behaviours/chaseandattack"
require "behaviours/follow"
require "behaviours/faceentity"
require "behaviours/wander"

local RUN_AWAY_DIST = 1
local STOP_RUN_AWAY_DIST = 2
local MAX_CHASE_TIME = 10
local MIN_FOLLOW_CLOSE = 0
local TARGET_FOLLOW_CLOSE = 2
local MAX_FOLLOW_CLOSE = 3
local MIN_FOLLOW = 5
local TARGET_FOLLOW = 10
local MAX_FOLLOW = 15
local MAX_WANDER_DIST = 20
local GIVE_UP_DIST = 20
local MAX_CHARGE_DIST = 60

local function StayHere(inst)
	return inst.components.followersitcommand:IsCurrentlyStaying()
end

local function BeeHasBeeBox(inst)
	local target = inst.components.combat.target
	if target and target:HasTag("bee") and target.components.homeseeker then
		inst.components.combat:GiveUp()
		return true
	end
end

local function IsTakingFireDamage(inst)
	return inst.components.health.takingfiredamage
end

local function ReadyForAttack(inst)
	return inst.components.combat.target and inst.components.combat:InCooldown()
end

local function CombatTarget(inst)
	return inst.components.combat.target
end

local closeitem = {
	umbrella = true,
	grass_umbrella = true,
	torch = true
}

local function CheckForClosely(inst)
	local handitem = inst.components.inventory:GetEquippedItem(EQUIPSLOTS.HANDS)
	if handitem and closeitem[handitem.prefab] then
		return true
	end
end

local function GetLeader(inst)
	return inst.components.follower and inst.components.follower.leader
end

local function GetFaceTargetFn(inst)
	return inst.components.follower.leader
end

local function KeepFaceTargetFn(inst, target)
	return inst.components.follower.leader == target
end

local function CryForQt(inst)
	inst.components.talker:Say("...?")
	for k, v in pairs(AllPlayers) do
		if v.prefab == "annie" then
			if not v.components.leader then
				v:AddComponent("leader")
			end
			v.components.leader:AddFollower(inst, true)
			inst:DoTaskInTime(2, function()
				inst.components.talker:Say("...!")
			end)
			break
		end
	end
end

local function GetWanderPosition(inst)
	if inst.components.follower and inst.components.follower.leader then
		return Point(inst.components.follower.leader.Transform:GetWorldPosition())
	else
		CryForQt(inst)
	end
	return inst.components.followersitcommand.currentstaylocation
end

local SummonTibber = Class(Brain, function(self, inst)
	Brain._ctor(self, inst)
end)

function SummonTibber:OnStart()
	local root = PriorityNode({
		StandStill(self.inst, StayHere, StayHere),
		IfNode(function() return BeeHasBeeBox(self.inst) end, "Bee Panic",
			Panic(self.inst)),
		WhileNode(function() return IsTakingFireDamage(self.inst) end, "On Fire",
			ChattyNode(self.inst, STRINGS.SUMMONTibber_TALK_PANICFIRE, Panic(self.inst))),
		WhileNode(function() return ReadyForAttack(self.inst) end, "Dodge",
			RunAway(self.inst, function() return CombatTarget(self.inst) end, RUN_AWAY_DIST, STOP_RUN_AWAY_DIST)),
		ChaseAndAttack(self.inst, MAX_CHASE_TIME),
        WhileNode(function()
               return self.inst.CanGroundPound
                   and self.inst.components.combat.target ~= nil
                   and not self.inst.components.combat.target:HasTag("beehive")
                   and (self.inst.sg:HasStateTag("running") or
                       not self.inst:IsNear(self.inst.components.combat.target, 10))
           end,
           "Charge Behaviours", ChaseAndRam(self.inst, MAX_CHASE_TIME, GIVE_UP_DIST, MAX_CHARGE_DIST)),
		IfNode(function() return CheckForClosely(self.inst) end, "Follow Closely",
			Follow(self.inst, GetLeader, MIN_FOLLOW_CLOSE, TARGET_FOLLOW_CLOSE, MAX_FOLLOW_CLOSE, true)),
		IfNode(function() return not CheckForClosely(self.inst) end, "Follow from Distance",
			Follow(self.inst, GetLeader, MIN_FOLLOW, TARGET_FOLLOW, MAX_FOLLOW, true)),
		FaceEntity(self.inst, GetFaceTargetFn, KeepFaceTargetFn),
		Wander(self.inst, GetWanderPosition, MAX_WANDER_DIST)
	}, 1)

	self.bt = BT(self.inst, root)
end

return SummonTibber
