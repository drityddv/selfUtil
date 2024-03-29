local _G = GLOBAL
local SpawnPrefab = _G.SpawnPrefab
local TheNet = _G.TheNet

local Dingyi_Boss = { --以下定义为Boss，出现的时候会公告以及坐标，可添加其他怪物为Boss
    "minotaur",         --守护者1  12
    "deerclops",        --雪巨鹿2  8
    "bearger",          --比尔熊3  12
    "dragonfly",        --龙蜻蜓4  15
    "moose",            --鹿角鹅5  6
    "klaus",            --克劳斯6
    "toadstool",        --毒蟾蜍7
    "beequeen",         --蜂王后8
    "antlion",          --夏蚁狮9
    "malbatross",       --邪天翁10
}

local GongGao_Shang = { --以下对应mod配置，位置不可随意更改
    "minotaur",         --守护者1  12
    "deerclops",        --雪巨鹿2  8
    "bearger",          --比尔熊3  12
    "dragonfly",        --龙蜻蜓4  15
    "moose",            --鹿角鹅5  6
    "klaus",            --克劳斯6
    "toadstool",        --毒蟾蜍7
    "beequeen",         --蜂王后8
    "glommer",          --格罗姆9  .15
    "koalefant_summer", --考拉夏10 10
    "koalefant_winter", --考拉冬11 10
    "beefalo",          --弗洛牛12 10
    "little_walrus",    --小海象13 2
    "walrus",           --海象爹14 5
    "spiderqueen",      --蜘蛛王15 5
    "warg",             --座狼王16 5
    "spat",             --口水羊17 5
    "lightninggoat",    --闪电羊18 5

    "antlion",          --夏蚁狮19
    "malbatross",       --邪天翁20
    -- "",--9
    -- "",--0
} --"willow",           --薇洛
local GongGao2_Shang = {}

local function patch(name)
    if not name then return false end
    return GetModConfigData(name)
end

for k,v in pairs(GongGao_Shang) do
    local patch = patch("Mod_Boss_"..k)
    if not patch then 
        table.insert(GongGao2_Shang, v)
    end
end

local function GetInstName(inst)
    return inst and inst:GetDisplayName() or "*无名*"
end

local function GetAttacker(data)
    return data and data.attacker and data.attacker:GetDisplayName() or "*无名*"
end

for k,v in pairs(GongGao2_Shang) do
    AddPrefabPostInit(v, function (inst)
        if not _G.TheWorld.ismastersim then
            return inst
        end

        local function siwangongao(inst, data)
            local AnnNR = v == "glommer" and ("可怜的〖 "..GetInstName(inst).." 〗被可恶的【 "..GetAttacker(data).." 】杀死了") or
                          v == "klaus" and (inst.kaimiao or 0)==1 and ("【 "..GetAttacker(data).." 】解开了〖 "..GetInstName(inst).." 〗锁链") or
                          ("【 "..GetAttacker(data).." 】给了〖 "..GetInstName(inst).." 〗最后一击")
            if (v=="klaus" and (inst.kaimiao or 0) ~= 2) or not inst.kaimiao then TheNet:Announce(AnnNR) end
            if v=="klaus" and inst.kaimiao and inst.kaimiao == 1 then inst.kaimiao = inst.kaimiao + 1 end
        end

        local function siwang(inst)
            if v == "klaus" then if not inst.kaimiao then inst.kaimiao = 0 end inst.kaimiao = inst.kaimiao + 1 end
            if (v=="klaus" and (inst.kaimiao or 0) ~= 3) or not inst.kaimiao then inst:ListenForEvent("attacked", siwangongao) end
        end

        local function shanchu(inst)
            local x,y,z=inst.Transform:GetWorldPosition()
            local XianZuoBiao = patch("XianZuoBiao") and ("，坐标："..(math.floor(x))..", "..(math.floor(z))) or ""
            TheNet:Announce("〖 "..GetInstName(inst).." 〗消失"..XianZuoBiao)
        end

        local function spawnchest(inst)
            inst:DoTaskInTime(.16, dospawnchest)
        end

        inst:ListenForEvent("onremove", shanchu)
        inst:ListenForEvent("death", siwang)

        if table.contains(Dingyi_Boss, v) then
            inst:DoTaskInTime(.5, function(inst)
                local x,y,z=inst.Transform:GetWorldPosition()
                local XianZuoBiao = not patch("XianZuoBiao") and ("，坐标："..(math.floor(x))..", "..(math.floor(z))) or ""
                TheNet:Announce("BOSS【 "..GetInstName(inst).." 】出现！"..XianZuoBiao)
            end)
        end

        if v == "glommer" then
            local function beigongji(inst, data)
                TheNet:Announce("〖 "..GetInstName(inst).." 〗正在惨遭【 "..GetAttacker(data).." 】的攻击")
            end
            --local OldOnSpawnFuel = OnSpawnFuel
            local function OnSpawnFuel(inst, fuel)
                --if OldOnSpawnFuel ~= nil then OldOnSpawnFuel(inst, fuel) end
                inst.sg:GoToState("goo", fuel)
                TheNet:Announce("【 "..GetInstName(inst).." 】正在生产粘液")
            end
            inst:DoTaskInTime(.5, function(inst)
                local x,y,z=inst.Transform:GetWorldPosition()
                local XianZuoBiao = patch("XianZuoBiao") and ("，坐标："..(math.floor(x))..", "..(math.floor(z))) or ""
                TheNet:Announce("【 "..GetInstName(inst).." 】出现了，快去领回家！"..XianZuoBiao)
            end)

            if not patch("GlommerXue") then inst.components.health:StartRegen((math.random()*2+.5), .16) end --格罗姆回血

            inst:ListenForEvent("onspawnfuel", shengchan)
            inst:ListenForEvent("startfollowing", chumo)
            inst:ListenForEvent("attacked", beigongji)
            inst.components.periodicspawner:SetOnSpawnFn(OnSpawnFuel)
        end
    end)
end

if not patch("Klaus_sack") then
    AddPrefabPostInit("klaus_sack", function (inst)
        local function shanchu(inst)
            local x,y,z=inst.Transform:GetWorldPosition()
            local XianZuoBiao = patch("XianZuoBiao") and ("，坐标："..(math.floor(x))..", "..(math.floor(z))) or ""
            TheNet:Announce("〖 "..GetInstName(inst).." 〗被打开"..XianZuoBiao)
        end

        inst:DoTaskInTime(.5, function(inst)
            local x,y,z=inst.Transform:GetWorldPosition()
            local XianZuoBiao = patch("XianZuoBiao") and ("，坐标："..(math.floor(x))..", "..(math.floor(z))) or ""
            TheNet:Announce("克劳斯的【 "..GetInstName(inst).." 】出现了！"..XianZuoBiao)
        end)
        inst:ListenForEvent("onremove", shanchu)
    end)
end


----人物 薇洛
if patch("WillowShao") then
    AddPrefabPostInit("willow", function (inst)
        if not _G.TheWorld.ismastersim then
            return inst
        end

        local function beigongji(inst, data)
            if data.attacker ~= nil and data.attacker.components.burnable ~= nil and math.random() < TUNING.TORCH_ATTACK_IGNITE_PERCENT * data.attacker.components.burnable.flammability then
                data.attacker.components.burnable:Ignite(nil, inst)
            end
        end

        inst:ListenForEvent("attacked", beigongji)
    end)
end
----格罗姆花采集
AddPrefabPostInit("statueglommer", function (inst)
    if not _G.TheWorld.ismastersim then
        return inst
    end

    local function OnPicked(inst, picker, loot)
        local glommer = TheSim:FindFirstEntityWithTag("glommer")
        if glommer ~= nil and glommer.components.follower.leader ~= loot then
            glommer.components.follower:StopFollowing()
            glommer.components.follower:SetLeader(loot)
        end
        TheNet:Announce("【 "..GetInstName(picker).." 】从".."〖 "..GetInstName(inst).." 〗上采摘了".."【 "..GetInstName(glommer).." 】的花")
        inst:DoTaskInTime(2,function() if math.random()<.33 then TheNet:Announce("【 "..GetInstName(glommer).." 】貌似蛮喜欢".."【 "..GetInstName(picker).." 】呢！") end end)
    end

    inst.components.pickable.onpickedfn = OnPicked
end)