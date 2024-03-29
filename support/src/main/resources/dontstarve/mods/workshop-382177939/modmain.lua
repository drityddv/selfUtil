    PrefabFiles = 
{
	"cellar",
}

    Assets = 
{
    Asset( "IMAGE", "minimap/cellar.tex" ),
    Asset( "ATLAS", "minimap/cellar.xml" ),
    Asset("ATLAS", "images/inventoryimages/ui_chest_3x4.xml"),
	Asset("ATLAS", "images/inventoryimages/cellar.xml"),
}

    AddMinimapAtlas("minimap/cellar.xml")

    STRINGS = GLOBAL.STRINGS
    RECIPETABS = GLOBAL.RECIPETABS
    Recipe = GLOBAL.Recipe
    Ingredient = GLOBAL.Ingredient
    TECH = GLOBAL.TECH

    GLOBAL.STRINGS.NAMES.CELLAR = "Storm Cellar"
    STRINGS.RECIPE_DESC.CELLAR = "Just like my basement at home,full of junk"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.CELLAR = "I like it"

    local Spot = GetModConfigData("Spot")
    local eightxten = (GetModConfigData("eightxten")=="8x10")
    GLOBAL.yep = (GetModConfigData("workit")=="yep")
    GLOBAL.chillit = (GetModConfigData("chillit")=="yep")

    local cellar = GLOBAL.Recipe("cellar",
{   Ingredient("cutstone", 20),
    Ingredient("goldenshovel", 1),
    Ingredient("turf_woodfloor", 20),
},                     
    RECIPETABS.TOWN, TECH.NONE, "cellar_placer" )
    cellar.atlas = "images/inventoryimages/cellar.xml"
    
    if eightxten then
    _G = GLOBAL
    local params={} 
    params.cellar =
{
    widget =
    {
    slotpos = {},
    pos = _G.Vector3(0, 220, 0),
    side_align_tip = 160,
    },
    type = "chest",
}
    for y = 6.5, -0.5, -1 do
    for x = 0, 9 do
    table.insert(params.cellar.widget.slotpos, _G.Vector3(75 * x - 75 * 12 + 75, 75 * y - 75 * 6 + 75, 0))
    end
end
    local containers = _G.require "containers"
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.cellar.widget.slotpos ~= nil and #params.cellar.widget.slotpos or 0)
    local old_widgetsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data)
    local pref = prefab or container.inst.prefab
    if pref == "cellar" then
    local t = params[pref]
    if t ~= nil then
    for k, v in pairs(t) do
    container[k] = v
end
    container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
end
    else
    return old_widgetsetup(container, prefab)
    end
end
    else
    _G = GLOBAL
    local params={} 
    params.cellar =
{
    widget =
    {
    slotpos = {},
    pos = _G.Vector3(0, 220, 0),
    side_align_tip = 160,
    },
    type = "chest",
}

    for y = 3.5, -0.5, -1 do
    for x = 0, 15 do
    table.insert(params.cellar.widget.slotpos, _G.Vector3(75 * x - 75 * 16 + 75, 75 * y - 75 * 3 + 75, 0))
    end
end

    local containers = _G.require "containers"
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.cellar.widget.slotpos ~= nil and #params.cellar.widget.slotpos or 0)
    local old_widgetsetup = containers.widgetsetup

function containers.widgetsetup(container, prefab, data)
    local pref = prefab or container.inst.prefab
    if pref == "cellar" then
    local t = params[pref]
    if t ~= nil then
    for k, v in pairs(t) do
    container[k] = v
end
    container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
end
    else
    return old_widgetsetup(container, prefab)
        end
    end
end

    

 