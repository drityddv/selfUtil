local Easy = (GetModConfigData("Mode")=="easy")
local Normal = (GetModConfigData("Mode")=="normal")
local Hard = (GetModConfigData("Mode")=="hard")
GLOBAL.ShelterUses = (GetModConfigData("ShelterUses"))
GLOBAL.ShelterLight = (GetModConfigData("ShelterLight")=="yes")

PrefabFiles = 
{
        "r_shelter",
}

        Assets = 
{
	Asset("ATLAS", "images/inventoryimages/r_shelter.xml"),
        Asset( "IMAGE", "minimap/r_shelter.tex" ),
        Asset( "ATLAS", "minimap/r_shelter.xml" ),	
}

        AddMinimapAtlas("minimap/r_shelter.xml")

        STRINGS = GLOBAL.STRINGS
        RECIPETABS = GLOBAL.RECIPETABS
        Recipe = GLOBAL.Recipe
        Ingredient = GLOBAL.Ingredient
        TECH = GLOBAL.TECH
        GLOBAL.STRINGS.CHARACTERS.GENERIC.ANNOUNCE_SHELTER = "Poor bastard!"
        GLOBAL.STRINGS.NAMES.R_SHELTER = "Resurrection Shelter"
        STRINGS.RECIPE_DESC.R_SHELTER = "Insurance for the unknown!"
        GLOBAL.STRINGS.CHARACTERS.GENERIC.DESCRIBE.R_SHELTER = "Poor bastard! Haunt the bones to add your flesh!"

        if Easy then 
local r_shelter = GLOBAL.Recipe("r_shelter",
{ 
        Ingredient("log", 5),
        Ingredient("pigskin", 4),
        Ingredient("rope", 4),
},
        RECIPETABS.TOWN, TECH.NONE,"r_shelter_placer" )
        r_shelter.atlas = "images/inventoryimages/r_shelter.xml"
        else
        if Normal then 
local r_shelter = GLOBAL.Recipe("r_shelter",
{ 
        Ingredient("beardhair", 4),
        Ingredient("nightmarefuel", 2),
        Ingredient("log", 10),
},
        RECIPETABS.TOWN, TECH.SCIENCE_ONE,"r_shelter_placer" )
        r_shelter.atlas = "images/inventoryimages/r_shelter.xml"
        else
        if Hard then
local r_shelter = GLOBAL.Recipe("r_shelter",
{ 
        Ingredient("amulet", 1),
        Ingredient("nightmarefuel", 5),
        Ingredient("boards", 10),
},
        RECIPETABS.TOWN, TECH.SCIENCE_TWO,"r_shelter_placer" )
        r_shelter.atlas = "images/inventoryimages/r_shelter.xml"
        end
    end
end
