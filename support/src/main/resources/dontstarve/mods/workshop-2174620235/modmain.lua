local require = GLOBAL.require
local Vector3 = GLOBAL.Vector3

Assets = {
--	Asset("ATLAS", "images/inventoryimages/hydroponics_reservoir.xml"),
--    Asset( "IMAGE", "minimap/hydroponics_farm.tex" ),
    Asset("ANIM", "anim/ui_chest_3x3.zip"),
	Asset("ATLAS", "images/inventoryimages/poop_flingomatic.xml"),
    Asset( "ATLAS", "minimap/poop_flingomatic.xml" ),
}

PrefabFiles =
{
	"poop_flingomatic",
	"fertilizer_projectile",
}


local fertilizer_list={ ["fertilizer"]=true,
                        ["glommerfuel"]=true,
                        ["rottenegg"]=true,
                        ["spoiled_food"]=true,
                        ["guano"]=true,
                        ["poop"]=true,
                        ["compostwrap"]=true,
                        }
                        

GLOBAL.STRINGS.NAMES.POOP_FLINGOMATIC = "Poop Flingomatic"
GLOBAL.STRINGS.RECIPE_DESC.POOP_FLINGOMATIC = "Fertilize plants and farms."

GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.POOP_FLINGOMATIC = "It stinks, but it\'s useful."


AddMinimapAtlas("minimap/poop_flingomatic.xml")


AddRecipe("poop_flingomatic",
{GLOBAL.Ingredient("transistor", 2), GLOBAL.Ingredient("poop", 5),
GLOBAL.Ingredient("boards", 4)},
GLOBAL.RECIPETABS.SCIENCE,
GLOBAL.TECH.SCIENCE_TWO,
"poop_flingomatic_placer", -- placer
2, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages/poop_flingomatic.xml", -- atlas
"poop_flingomatic.tex")


local containers = require "containers"

local params = {}

-- used the same script of the mod "Large Chest" (workshop-396026892) to make this container setup
-- More like a "Copy and Paste" of the function... I've learned a lot reading the scripts from your mod, so, thanks!

local containers_widgetsetup_pf = containers.widgetsetup  
function containers.widgetsetup(container, prefab, data, ...)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    else
        containers_widgetsetup_pf(container, prefab, data, ...)
    end
end

params.poop_flingomatic =
{
    widget =
    {
        slotpos = {},
        animbank = "ui_chest_3x3",
        animbuild = "ui_chest_3x3",
        pos = Vector3(0, 200, 0),
        side_align_tip = 160,
    },
    type = "chest",
}

for k,v in pairs(fertilizer_list) do
    AddPrefabPostInit(k, function(inst)
        inst:AddTag("poop_flingomatic_fertilizer")
    end)
end

function params.poop_flingomatic.itemtestfn(container, item, slot)
    if item:HasTag("poop_flingomatic_fertilizer") then
        return true
    end
    return false
end

for y = 2, 0, -1 do
    for x = 0, 2 do
        table.insert(params.poop_flingomatic.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
    end
end

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.poop_flingomatic.widget.slotpos ~= nil and #params.poop_flingomatic.widget.slotpos or 0)

