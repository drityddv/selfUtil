
local delay=5

local radius=GetModConfigData("CONNECTION_RANGE")

local CONNECTION_FUEL=GetModConfigData("CONNECTION_FUEL")
local CONNECTION_NEEDON=GetModConfigData("CONNECTION_NEEDON")
local CONNECTION_TURNON=GetModConfigData("CONNECTION_TURNON")
local CONNECTION_TURNOFF=GetModConfigData("CONNECTION_TURNOFF")

local function LookForFlingomatics(inst, adjust)
    local pos=inst:GetPosition()
    local flingo={}
    if radius < 0 then
        for k,v in pairs(GLOBAL.Ents) do 
            if v.prefab=="firesuppressor" and (adjust==false or 
            (v.components.machine and (CONNECTION_NEEDON == false or v.components.machine:IsOn() ) ) ) then
                table.insert(flingo,v)
            end
        end
    else
        local ent=GLOBAL.TheSim:FindEntities(pos.x,pos.y,pos.z,radius,{"structure"},{"INLIMBO"})
        for k,v in ipairs(ent) do 
            if v.prefab=="firesuppressor" and (adjust==false or 
            (v.components.machine and (CONNECTION_NEEDON == false or v.components.machine:IsOn() ) ) ) then
                table.insert(flingo,v)
            end
        end
    end
    
    return flingo
end

local function AdjustFuel(inst, ignore)
    if CONNECTION_FUEL == false then
        return
    end
    if inst.fuelshare_delay==true and ignore == nil then
        inst.fuelshare_delay=false
        return
    end
    local total_fuel=0
    local frac_fuel
    local delta
    local flingo=LookForFlingomatics(inst, true)
    
    if #flingo < 2 then
        return
    end

    for k,v in ipairs(flingo) do
        if v.components.fueled then
            total_fuel=total_fuel+v.components.fueled.currentfuel
        end
    end
    
    frac_fuel=total_fuel/#flingo
    
    for k,v in ipairs(flingo) do
         if v.components.fueled then
            delta=frac_fuel-v.components.fueled.currentfuel
            v.components.fueled:DoDelta(delta)
            v.fuelshare_delay=true
         end
    end
    inst.fuelshare_delay=false
end

local function TurnOn_Share(inst)
    inst.old_turnonfn(inst)

    local flingo=LookForFlingomatics(inst, false)
    
    inst:DoTaskInTime(0, function()
        for k,v in ipairs(flingo) do
            if inst ~= v then
                if  v ~= nil and v:IsValid()
                and v.components.machine and not v.components.machine:IsOn() 
                and not v:HasTag("fueldepleted") then
                    v.components.machine:TurnOn()
                end
            end
        end
    end)
  
end

local function TurnOff_Share(inst)
    inst.old_turnofffn(inst)
    
    if inst:HasTag("fueldepleted") then
        return
    end

    local flingo=LookForFlingomatics(inst, false)
    
    inst:DoTaskInTime(0, function()
        if inst ~= v then
            for k,v in ipairs(flingo) do
                if  v ~= nil and v:IsValid()
                and v.components.machine and v.components.machine:IsOn() then
                    v.components.machine:TurnOff()
                end
            end
        end
    end)
  
end

local function OnAddFuel_Share(inst)
    inst.old_ontakefuelfn(inst)
    AdjustFuel(inst,true)
end


AddPrefabPostInit("firesuppressor", function(inst)

    if GLOBAL.TheWorld.ismastersim then -- This is a server-side only feature
        if CONNECTION_TURNON == true then
            inst.old_turnonfn=inst.components.machine.turnonfn
            inst.components.machine.turnonfn = TurnOn_Share
        end
        
        if CONNECTION_TURNOFF == true then
            inst.old_turnofffn=inst.components.machine.turnofffn
            inst.components.machine.turnofffn = TurnOff_Share
        end

        if CONNECTION_FUEL == true then 
            inst.fuelshare_delay=0
            inst:DoPeriodicTask(delay, AdjustFuel, delay*math.random())
            
            inst.old_ontakefuelfn=inst.components.fueled.ontakefuelfn
            inst.components.fueled:SetTakeFuelFn(OnAddFuel_Share)
        end
    end
end)
