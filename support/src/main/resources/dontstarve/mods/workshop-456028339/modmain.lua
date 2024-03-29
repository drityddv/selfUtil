STRINGS = GLOBAL.STRINGS
RECIPETABS = GLOBAL.RECIPETABS
Recipe = GLOBAL.Recipe
Ingredient = GLOBAL.Ingredient
TECH = GLOBAL.TECH

local living_log = GLOBAL.Recipe("livinglog", {Ingredient("log", 1),Ingredient("nightmarefuel", 1) }, RECIPETABS.REFINE, TECH.MAGIC_TWO )
STRINGS.RECIPE_DESC.LIVINGLOG = "Shove your inner demons into this wood."