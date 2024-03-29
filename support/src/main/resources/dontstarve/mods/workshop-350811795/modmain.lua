
PrefabFiles = {
	"bindingringprefabdef",
}

local tp_action = AddAction("SOULMATETP", "Teleport to Soulmate", function(act)
	if act.invobject and act.invobject.components.soulteleporter then
        return act.invobject.components.soulteleporter:TeleportAction(act.doer)
    end
end)
--tp_action.instant = true
	
function SetupTeleportActions(inst, doer, actions)
	--could add here the option to check if the soulmate is connected, if not, then don't offer the action
	table.insert(actions, GLOBAL.ACTIONS.SOULMATETP)
end
AddComponentAction("INVENTORY", "soulteleporter", SetupTeleportActions)

local ah = GLOBAL.ActionHandler( GLOBAL.ACTIONS.SOULMATETP, "quicktele" )
AddStategraphActionHandler("wilson", ah)
AddStategraphActionHandler("wilson_client", ah)

function gamepostinit()
end
--add a post init to the game starting up
AddGamePostInit(gamepostinit)

local Ingredient = GLOBAL.Ingredient
AddRecipe("bindingring", {Ingredient("goldnugget", 10), Ingredient("moonrocknugget", 1)}, GLOBAL.RECIPETABS.MAGIC, GLOBAL.TECH.NONE, nil, nil, nil, nil, nil, "images/inventoryimages/bindingring.xml", "bindingring.tex" )
