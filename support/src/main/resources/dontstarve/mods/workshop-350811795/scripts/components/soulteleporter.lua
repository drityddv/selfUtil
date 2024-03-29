local SoulTeleporter = Class(function(self, inst)
    self.inst = inst
	self.boundTo = nil
end)

--Maybe in the future add sanity gameplay to this mod
--function SoulTeleporter:OnUpdate(dt)
	--pickuper.components.sanity:DoDelta( -TUNING.REVIVER_CRAFT_SANITY_PENALTY )
--end

function SoulTeleporter:OnSave()
	--print("SoulTeleporter:OnSave")
	return {boundToUserid = self.boundToUserid}
end

function SoulTeleporter:OnLoad(data)
	if data.boundToUserid ~= nil then
        self.boundToUserid = data.boundToUserid
    end
end


function SoulTeleporter:OnPickup(pickuper)
	if self.boundToUserid == nil then
		--print("SoulTeleporter created")
		self.boundToUserid = pickuper.Network:GetUserID()
	end
end

local tp_sayings = {
	GENERIC = { "Shazam!", "Poof!", "Alakazam!", "Presto-Teleporto!"},
	wilson = { "It works!"},
	willow = { "Like a wayward spark!"},
	wolfgang = { "Wolfgang is mighty! And fast!"},
	wx78 = { "RELOCATION SUCCESSFUL."},
	wendy = { "I have returned to you." },
	wickerbottom = { "Faster than the strongest winds!"},
	woodie = { "Woah! Not sure if I want to do that again, eh?" },
	maxwell = { "Alakazam!" },
}

function LookupPlayerInstByUserID( userid )
	for _, v in ipairs(AllPlayers) do
		if v.userid == userid then
			return v
		end
	end
	return nil
end

function SoulTeleporter:TeleportAction(doer)	
	if self.boundToUserid ~= nil then
		if self.boundToUserid ~= doer.Network:GetUserID() then
			
			local bound_to_inst = LookupPlayerInstByUserID( self.boundToUserid )
			if bound_to_inst ~= nil then
				--print("Teleport ", doer.Network:GetUserID(), " to ", self.boundToUserid)
				
				local tp_pos
				local attempts = 100 --try multiple times to get a spot on ground before giving up so we don't infinite loop
				while attempts > 0 do
					local angle = math.random() * 2 * PI
					local distance = math.random() * 30
					tp_pos = bound_to_inst:GetPosition() + Vector3( GetRandomWithVariance(0,2), 0.0, GetRandomWithVariance(0,2) )
					if TheWorld.Map:IsAboveGroundAtPoint(tp_pos:Get()) then
						break
					end
					attempts = attempts - 1
				end
				doer.Physics:Teleport(tp_pos:Get())
				
				local char_accounce_table = tp_sayings[doer.prefab] or tp_sayings["GENERIC"]
				local say_index = math.floor(GetRandomMinMax(0,#char_accounce_table)) + 1
				doer.components.talker:Say( char_accounce_table[say_index] )

				local puff = SpawnPrefab("small_puff")
				puff.Transform:SetPosition(tp_pos:Get())
				
				return true
			else
				return false
			end
		end
	end
	return false
end

return SoulTeleporter