PrefabFiles = {
	"newicebox", "foodfactory",
}

Assets = 
{
	Asset("ATLAS", "images/minimap/newicebox.xml" ),
	Asset("ATLAS", "images/inventoryimages/newicebox.xml"),
}

AddMinimapAtlas("images/minimap/newicebox.xml")

STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH
_G = GLOBAL

local mod_debug = false

STRINGS.NAMES.NEWICEBOX = "双层冰箱"
STRINGS.RECIPE_DESC.NEWICEBOX = "上面保鲜+下面冰冻"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NEWICEBOX = "实用的双层冰箱！！"

STRINGS.NAMES.NEWICEBOXS = "豪华冰箱"
STRINGS.RECIPE_DESC.NEWICEBOXS = "更多保鲜+更多冰冻"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.NEWICEBOXS = "更大空间的双层冰箱！！"

STRINGS.NAMES.FOODFACTORY = "食物工厂"
STRINGS.RECIPE_DESC.FOODFACTORY = "腐烂食物or反鲜食物"
STRINGS.CHARACTERS.GENERIC.DESCRIBE.FOODFACTORY = "快速制作食物的工具！！"

------------------------------------------------------
----------------------- RECIPE -----------------------
------------------------------------------------------
Recipe("newicebox",{Ingredient("bluegem", 2),Ingredient("gears", 2),Ingredient("transistor", 1)}, RECIPETABS.FARM, TECH.SCIENCE_ONE, "newicebox_placer" ,nil,nil,nil,nil, "images/inventoryimages/newicebox.xml", "newicebox.tex")
Recipe("newiceboxs",{Ingredient("bluegem", 4),Ingredient("gears", 3),Ingredient("transistor", 3)}, RECIPETABS.FARM, TECH.SCIENCE_TWO, "newicebox_placer" ,nil,nil,nil,nil, "images/inventoryimages/newicebox.xml", "newicebox.tex")
Recipe("foodfactory",{Ingredient("bluegem", 4),Ingredient("gears", 3),Ingredient("transistor", 3)}, RECIPETABS.FARM, TECH.LOST, "newicebox_placer" ,nil,nil,nil,nil, "images/inventoryimages/newicebox.xml", "newicebox.tex")

---------------------- function ----------------------
local function widgetcreation(widgetanimbank, widgetpos, slot_x, slot_y, posslot_x, posslot_y)
	local params={}
	params.newicebox =
	{
		widget =
		{
			slotpos = {},
			animbank = "ui_chest_3x5",
			animbuild = "ui_chest_3x5",
			pos = _G.Vector3(-80, 220, 0),
			side_align_tip = 160,
		},
		type = "chest",
	}

	for y = 2, 0, -1 do
        for x = 0, 2 do
            table.insert(params.newicebox.widget.slotpos, _G.Vector3(85 * x - 80 , 80 * y - 20 , 0))
        end
    end
    for x = 0, 2 do
        table.insert(params.newicebox.widget.slotpos, _G.Vector3(85 * x - 80 , -150, 0))
    end

	function params.newicebox.itemtestfn(container, item, slot)
        if item:HasTag("icebox_valid") then
            return true
        end

        --Perishable
        if not (item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled")) then
            return false
        end

        --Edible
        for k, v in pairs(_G.FOODTYPE) do
            if item:HasTag("edible_"..v) then
                return true
            end
        end

        return false
    end

	params.newiceboxs =
	{
		widget =
		{
			slotpos = {},
			animbank = "ui_chest_4x6",
			animbuild = "ui_chest_4x6",
			pos = _G.Vector3(0, 220, 0),
			side_align_tip = 160,
		},
		type = "chest",
	}

	for y = 2, 0, -1 do
        for x = 0, 3 do
            table.insert(params.newiceboxs.widget.slotpos, _G.Vector3(75 * x - 115, 75 * y - 5  , 0))
        end
    end
    for y = -2, -3, -1 do
        for x = 0, 3 do
            table.insert(params.newiceboxs.widget.slotpos, _G.Vector3(75 * x - 115, 75 * y + 55 , 0))
        end
    end

	function params.newiceboxs.itemtestfn(container, item, slot)
        if item:HasTag("icebox_valid") then
            return true
        end

        --Perishable
        if not (item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled")) then
            return false
        end

        --Edible
        for k, v in pairs(_G.FOODTYPE) do
            if item:HasTag("edible_"..v) then
                return true
            end
        end

        return false
    end

    params.foodfactory =
	{
		widget =
		{
			slotpos = {},
			animbank = "ui_chest_3x5",
			animbuild = "ui_chest_3x5",
			pos = _G.Vector3(-80, 280, 0),
			side_align_tip = 160,
		},
		type = "chest",
	}

	for y = 1, 0, -1 do
        for x = 0, 2 do
            table.insert(params.foodfactory.widget.slotpos, _G.Vector3(85 * x - 20 + 80, 80 * y + 15 - 80  , 0))
        end
    end
    for y = 1, 0, -1 do
        for x = 0, 2 do
            table.insert(params.foodfactory.widget.slotpos, _G.Vector3(85 * x - 20 + 80, 80 * y + 15 - 80 * 4 , 0))
        end
    end

	function params.foodfactory.itemtestfn(container, item, slot)
        if item:HasTag("icebox_valid") then
            return true
        end

        --Perishable
        if not (item:HasTag("fresh") or item:HasTag("stale") or item:HasTag("spoiled")) then
            return false
        end

        --Edible
        for k, v in pairs(_G.FOODTYPE) do
            if item:HasTag("edible_"..v) then
                return true
            end
        end

        return false
    end

	local containers = _G.require "containers"
	--containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.newicebox.widget.slotpos ~= nil and #params.newicebox.widget.slotpos or 0)
	containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.newiceboxs.widget.slotpos ~= nil and #params.newiceboxs.widget.slotpos or 0)
	--containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.foodfactory.widget.slotpos ~= nil and #params.foodfactory.widget.slotpos or 0)

	local old_widgetsetup = containers.widgetsetup
	function containers.widgetsetup(container, prefab, data)
		local pref = prefab or container.inst.prefab
		if pref == "newicebox" or pref == "newiceboxs" or pref == "foodfactory" then
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

---------------------- call function ----------------------
widgetcreation()

---------------------------------------------------
-------------------- TRANSLATE --------------------
---------------------------------------------------

_G.Platform = GLOBAL.TheSim.RAILGetPlatform and GLOBAL.TheSim:RAILGetPlatform() 

--------------------- English ----------------------

---------------------------------------------------
---------------------- DEBUG ----------------------
---------------------------------------------------
if mod_debug then
	print("slots_debug ",mod_slots)
	print("recipe_debug ",cutstone_value, marble_value, boards_value)
	print("widget_debug = ",widgetanimbank, widgetpos, slot_x, slot_y, posslot_x, posslot_y)
end
if GLOBAL.TheSim.RAILGetPlatform and GLOBAL.TheSim:RAILGetPlatform() == "TGP" then
      for _, mod in ipairs(GLOBAL.ModManager.mods) do 
           if mod and mod.modinfo and mod.modinfo.id == "newicebox" then
                GLOBAL.KnownModIndex:Disable("newicebox")
          end
      end

     GLOBAL.Shutdown()
end
