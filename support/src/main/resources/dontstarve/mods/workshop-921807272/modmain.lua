local require = GLOBAL.require
local STRINGS = GLOBAL.STRINGS
local Recipe = GLOBAL.Recipe
local Ingredient = GLOBAL.Ingredient
local RECIPETABS = GLOBAL.RECIPETABS
local TECH = GLOBAL.TECH

PrefabFiles = {
	"redcherry",
    }

Assets = {
	Asset("ATLAS", "images/inventoryimages/redcherry.xml"),
}

if GetModConfigData('Lan') then
	STRINGS.NAMES.REDCHERRY = "RedSakura"
	STRINGS.RECIPE_DESC.REDCHERRY = "Engrave the creed of blood"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.REDCHERRY = "I feel like something terrifying is on its way"
else
	STRINGS.NAMES.REDCHERRY = "妖刀红樱"
	STRINGS.RECIPE_DESC.REDCHERRY = "烙印着血的教诲"
	STRINGS.CHARACTERS.GENERIC.DESCRIBE.REDCHERRY = "感觉这东西有些不妙"
end

AddRecipe("redcherry", {Ingredient("moonrocknugget", 4), Ingredient("petals", 6), Ingredient(GLOBAL.CHARACTER_INGREDIENT.HEALTH, 40)},
RECIPETABS.WAR, TECH.SCIENCE_ONE, nil, nil, nil, nil, nil,
"images/inventoryimages/redcherry.xml", "redcherry.tex")

if GetModConfigData("Chop") == true then
    TUNING.redcherrychop = 1
end
if GetModConfigData("Mine") == true then
    TUNING.redcherrymine = 1
end
if GetModConfigData("Dig") == true then
    TUNING.redcherrydig = 1
end
if GetModConfigData("Hammer") == true then
    TUNING.redcherryhammer = 1
end
if GetModConfigData("Armor") == false then
    TUNING.redcherryarmor = 1
end