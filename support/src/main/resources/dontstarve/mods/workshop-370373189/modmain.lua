   
Assets=
{
    Asset("ATLAS", "images/inventoryimages/hybrid_banana.xml"),
    Asset("ATLAS", "images/inventoryimages/g_house.xml"),
	Asset( "IMAGE", "minimap/g_house.tex" ),
    Asset( "ATLAS", "minimap/g_house.xml" ),
}
    AddMinimapAtlas("minimap/g_house.xml")

PrefabFiles = 
{
	"g_house",
	"hybrid_banana_seeds",
	"hybrid_banana_tree",
	"hybrid_banana",
}

    STRINGS = GLOBAL.STRINGS
    RECIPETABS = GLOBAL.RECIPETABS
    Recipe = GLOBAL.Recipe
    Ingredient = GLOBAL.Ingredient
    TECH = GLOBAL.TECH

    GLOBAL.STRINGS.NAMES.G_HOUSE = "Advance Farm"
    STRINGS.RECIPE_DESC.G_HOUSE = " It's an agricultural breakthrough!"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.G_HOUSE = "I won't starve this winter!"

    GLOBAL.STRINGS.NAMES.HYBRID_BANANA_TREE = "Hybrid Banana Tree"
    STRINGS.RECIPE_DESC.HYBRID_BANANA_TREE = " It's a good thing!"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HYBRID_BANANA_TREE = "It's fruit is absolutely delicious!"

    STRINGS.RECIPE_DESC.HYBRID_BANANA_SEEDS = " It's a banana seed!"
    GLOBAL.STRINGS.NAMES.HYBRID_BANANA_SEEDS = "Hybrid Banana Seeds"
    GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HYBRID_BANANA_SEEDS = "These are worth their weight in gold!"

	GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HYBRID_BANANA = "Love these guys fresh!"
	GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.HYBRID_BANANA_COOKED = "Well now my mouth is watering!"
    GLOBAL.STRINGS.NAMES.HYBRID_BANANA = "Hybrid Bananas"
	GLOBAL.STRINGS.NAMES.HYBRID_BANANA_COOKED = "Cooked Hybrid Bananas"

    GLOBAL.Winter_Grow = (GetModConfigData("W_Grow")=="no")
    local b_seeds = (GetModConfigData("b_seeds")=="no")
    local easy = (GetModConfigData("greenhouserecipe")=="easy")
    local normal = (GetModConfigData("greenhouserecipe")=="normal")

    if easy then
	local g_houserecipe = GLOBAL.Recipe("g_house",
{ 
	Ingredient("boards", 3),
	Ingredient("silk", 3),
	Ingredient("rope", 1)
},
	RECIPETABS.FARM, TECH.NONE, "g_house_placer" )                     
    g_houserecipe.atlas = "images/inventoryimages/g_house.xml"

    else if normal then
    local g_houserecipe = GLOBAL.Recipe("g_house",
{ 
    Ingredient("boards", 3),
    Ingredient("silk", 3),
    Ingredient("rope", 2),
    Ingredient("poop", 10)
},
    RECIPETABS.FARM, TECH.SCIENCE_ONE, "g_house_placer" )                     
    g_houserecipe.atlas = "images/inventoryimages/g_house.xml"

    else
    local g_houserecipe = GLOBAL.Recipe("g_house",
{ 
    Ingredient("boards", 5),
    Ingredient("silk", 6),
    Ingredient("rope", 4),
    Ingredient("poop", 10)
},
    RECIPETABS.FARM, TECH.SCIENCE_TWO, "g_house_placer" )                     
    g_houserecipe.atlas = "images/inventoryimages/g_house.xml"

    end
end

    if b_seeds then local bananarecipe = nil
    else
	local bananarecipe = GLOBAL.Recipe("hybrid_banana_seeds",
{ 
	Ingredient("carrot_seeds", 1),
	Ingredient("dragonfruit_seeds", 1)
},
	RECIPETABS.REFINE, TECH.SCIENCE_ONE )
	bananarecipe.atlas = "images/inventoryimages/hybrid_banana_seeds.xml"
end

local fruits = {"pomegranate", "dragonfruit", "cave_banana", "hybrid_banana"}
AddIngredientValues(fruits, {fruit=1}, true)