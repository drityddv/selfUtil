local bekkitt_prefabs = {
        
    'skeleton_player', 
        
}



function apply_negative_effects(inst)
    if inst.LastResSource and inst.LastResSource:HasTag('bekkitt_skeleton_resp') then


        new_penalty = inst.components.health.penalty + GetModConfigData('bekkitt_skeleton_pen') 
        if new_penalty >= .75 then
            new_penalty = .75
        end
        inst.components.health.penalty = new_penalty
        inst.components.health:ForceUpdateHUD(false)
    end

end

function save_last_respawn_source(inst, data)
    if data then 
        inst.LastResSource = data.source
    end 
end


AddPlayerPostInit( 
    function(inst) 
        inst:ListenForEvent('respawnfromghost', save_last_respawn_source)  
        inst:ListenForEvent('ms_respawnedfromghost', apply_negative_effects)  
    end
)

local light_fire_on_haunt = function(inst, haunter)
    if ( inst.components.fueled ~= nil ) then
        inst.components.fueled:DoDelta( TUNING.LARGE_FUEL )


    end
    return true
end

for i, prefab_name in ipairs( bekkitt_prefabs ) do
    
    local allow_rez = GetModConfigData( prefab_name )

    if ( allow_rez ) then
        AddPrefabPostInit(
            prefab_name, 
            function(inst) 
                
                
                if ( inst.components.hauntable ~= nil ) then
                    inst:RemoveComponent('hauntable')
                end
                
                inst:AddComponent('hauntable')
            
                
                
                
                inst.components.hauntable:SetOnHauntFn( light_fire_on_haunt )

                
                inst.components.hauntable:SetHauntValue(TUNING.HAUNT_INSTANT_REZ)
                inst:AddTag('resurrector')
                inst:AddTag('bekkitt_skeleton_resp') 
            end
        )
    end
end

local function SkeletonRemove(inst)
	for k,ent in pairs(GLOBAL.Ents) do
		if ent.prefab == "skeleton_player" and ent.playername == inst.name then
			ent:Remove()
		end
	end
end

local function SkeletonRemoval(inst)
		inst:ListenForEvent("death", SkeletonRemove)
end

AddPlayerPostInit(SkeletonRemoval)

