local BANNED_TAGS =
{ 
	"campfire",
	"spiderden",
	"tent",
	"wall"
}

local BANNED_PREFABS =
{ 
	"pighouse",
	"rabbithouse",
	"slow_farmplot",
	"fast_farmplot"
}

local PACKABLE =
{
	{"beebox", GetModConfigData("beebox") or false},
	{"birdcage", GetModConfigData("birdcage") or false},
	{"cartographydesk", GetModConfigData("cartographydesk") or false},
	{"cookpot", GetModConfigData("cookpot") or false},
	{"dragonflychest", GetModConfigData("dragonflychest") or false},
	{"dragonflyfurnace", GetModConfigData("dragonflyfurnace") or false},
	{"endtable", GetModConfigData("endtable") or false},
	{"firesuppressor", GetModConfigData("firesuppressor") or false},
	{"icebox", GetModConfigData("icebox") or false},
	{"lightning_rod", GetModConfigData("lightning_rod") or false},
	{"meatrack", GetModConfigData("meatrack") or false},
	{"moondial", GetModConfigData("moondial") or false},
	{"mushroom_farm", GetModConfigData("mushroom_farm") or false},
	{"mushroom_light", GetModConfigData("mushroom_light") or false},
	{"nightlight", GetModConfigData("nightlight") or false},
	{"perdshrine", GetModConfigData("perdshrine") or false},	
	{"pottedfern", GetModConfigData("pottedfern") or false},
	{"rainometer", GetModConfigData("rainometer") or false},
	{"researchlab", GetModConfigData("researchlab") or false},
	{"researchlab2", GetModConfigData("researchlab2") or false},
	{"researchlab3", GetModConfigData("researchlab3") or false},
	{"researchlab4", GetModConfigData("researchlab4") or false},
	{"resurrectionstatue", GetModConfigData("resurrectionstatue") or false},	
	{"saltlick", GetModConfigData("saltlick") or false},
	{"scarecrow", GetModConfigData("scarecrow") or false},
	{"sculptingtable", GetModConfigData("sculptingtable") or false},	
	{"succulent_potted", GetModConfigData("succulent_potted") or false},
	{"townportal", GetModConfigData("townportal") or false},
	{"treasurechest", GetModConfigData("treasurechest") or false},
	{"wardrobe", GetModConfigData("wardrobe") or false},
	{"winterometer", GetModConfigData("winterometer") or false},
}

----------
-- Main --
----------

PrefabFiles =
{
	"moving_box"
}

GLOBAL.STRINGS.NAMES.MOVING_BOX = "Moving Box"
GLOBAL.STRINGS.NAMES.MOVING_BOX_FULL = "Moving Box (Full)"
GLOBAL.STRINGS.RECIPE_DESC.MOVING_BOX = "You can use it to move structures."

GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.MOVING_BOX = "It's a box I can move things with."
GLOBAL.STRINGS.CHARACTERS.WEBBER.DESCRIBE.MOVING_BOX = "It's a big box for us to move things with."

GLOBAL.STRINGS.CHARACTERS.GENERIC.ACTIONFAIL.UNPACK =
{
	GENERIC = "I can't unpack that now!",
	NOROOM = "There is not enough room to unpack that here."
}

AddRecipe("moving_box",
{GLOBAL.Ingredient("papyrus", 3), GLOBAL.Ingredient("silk", 1)},
GLOBAL.RECIPETABS.TOOLS,
GLOBAL.TECH.SCIENCE_ONE,
nil, -- placer
nil, -- min_spacing
nil, -- nounlock
nil, -- numtogive
nil, -- builder_tag
"images/inventoryimages/box.xml", -- atlas
"box.tex")

----------
-- PACK --
----------

local PACK = AddAction("PACK", "Pack", function(act)
	if act.doer.components.inventory then	
		if act.target.components.burnable ~= nil then
			if act.target.components.burnable:IsBurning() or act.target.components.burnable:IsSmoldering() then
				return false
			end
		end
	
		local item = act.doer.components.inventory:RemoveItem(act.invobject)
        if item then
			item:Remove()
			local inst = GLOBAL.SpawnPrefab("moving_box_full")
			inst.Transform:SetPosition(act.target.Transform:GetWorldPosition())
			inst.components.package:Pack(act.target)
			return true
        end
    end
end)
PACK.priority = 10

AddComponentAction("USEITEM", "package", function(inst, doer, target, actions)
	if target:HasTag("packable") then
		table.insert(actions, GLOBAL.ACTIONS.PACK)
	end
end)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(PACK, "dolongaction"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(PACK, "dolongaction"))

------------
-- UNPACK --
------------

local UNPACK = AddAction("UNPACK", "Unpack", function(act)
	if act.target.components.package.content ~= nil then
		if act.target.components.burnable ~= nil then
			if act.target.components.burnable:IsBurning() or act.target.components.burnable:IsSmoldering() then
				return false
			end
		end

		-- check space
		local recipe = GLOBAL.GetValidRecipe(act.target.components.package.content.prefab)
		if recipe ~= nil then 
			local x, y, z = act.target.Transform:GetWorldPosition()
			local ents = TheSim:FindEntities(x, y, z, recipe.min_spacing, nil, 0, {"structure"})
			if GLOBAL.next(ents) ~= nil then
				return false, "NOROOM"
			end
		end
	
		act.target.components.package:Unpack(act.doer)
		return true
	end
end)

AddComponentAction("SCENE", "package", function(inst, doer, actions, right)
	if not right and inst:HasTag("full") then
		table.insert(actions, GLOBAL.ACTIONS.UNPACK)
	end
end)

AddStategraphActionHandler("wilson", GLOBAL.ActionHandler(UNPACK, "dolongaction"))
AddStategraphActionHandler("wilson_client", GLOBAL.ActionHandler(UNPACK, "dolongaction"))

-----------
-- SETUP --
-----------

AddPrefabPostInitAny(function(inst)
	if not GLOBAL.TheWorld.ismastersim then
		return
	end
	
	if inst:HasTag("packable") then
		return
	end
	
	for index, item in pairs(PACKABLE) do		
		if inst.prefab == item[1] then
			if item[2] then
				inst:AddTag("packable")
			end
			
			return
		end
	end
	
	-- unknown prefab
	
	if GetModConfigData("modsupport") then
		if inst:HasTag("structure") then
			for index, tag in ipairs(BANNED_TAGS) do
				if inst:HasTag(tag) then
					return
				end
			end
		
			for index, prefab in ipairs(BANNED_PREFABS) do
				if inst.prefab == prefab then
					return
				end
			end

			inst:AddTag("packable")
		end
	end
end)