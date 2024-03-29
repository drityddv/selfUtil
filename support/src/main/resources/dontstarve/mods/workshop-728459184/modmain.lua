Assets = {
  Asset("ATLAS", "images/container.xml"),
  Asset("ATLAS", "images/container_x20.xml"),
  Asset("ATLAS", "images/krampus_sack_bg.xml"),
}
--Make Global
local require = GLOBAL.require
local Vector3 = GLOBAL.Vector3
local net_entity = GLOBAL.net_entity
--Require                     
local containers = require("containers")

--------------------------

--[[Assets = {
    Asset("ANIM", "anim/ui_backpack_2x4.zip"), -- The anim file for the backpack widget
}]]

local params = {}

params.icepack = -- I've kept the name as "spicepack"
{
	widget =
    {
        slotpos = {
			Vector3(-162, -75 * 0 + 114, 0), -- You have to do it this way since you can't really use a "for" loop outside of a function
			Vector3(-162, -75 * 1 + 114, 0), -- Each one represents one slot
			Vector3(-162, -75 * 2 + 114, 0),
			Vector3(-162, -75 * 3 + 114, 0),
			Vector3(-162 + 75, -75 * 0 + 114, 0),
			Vector3(-162 + 75, -75 * 1 + 114, 0),
			Vector3(-162 + 75, -75 * 2 + 114, 0),
			Vector3(-162 + 75, -75 * 3 + 114, 0),
		},
        animbank = "ui_backpack_2x4", -- Setting the bank
        animbuild = "ui_backpack_2x4", -- And the build
        pos = Vector3(-5, -70, 0),
    },
    issidewidget = true,
    type = "pack",
}

containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, params.icepack.widget.slotpos ~= nil and #params.icepack.widget.slotpos or 0)

local containers_widgetsetup_base = containers.widgetsetup
function containers.widgetsetup(container, prefab, data)
    local t = params[prefab or container.inst.prefab]
    if t ~= nil then
        for k, v in pairs(t) do
            container[k] = v
        end
        container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
    else
        containers_widgetsetup_base(container, prefab, data)
    end
end

--------------------------

--containers.MAXITEMSLOTS = 24
containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, 24)
local INCREASEBACKPACKSIZES_BACKPACK = GetModConfigData("INCREASEBACKPACKSIZES_BACKPACK") 
local INCREASEBACKPACKSIZES_PIGGYBACK = GetModConfigData("INCREASEBACKPACKSIZES_PIGGYBACK")  
local INCREASEBACKPACKSIZES_KRAMPUSSACK = GetModConfigData("INCREASEBACKPACKSIZES_KRAMPUSSACK") 
local INCREASEBACKPACKSIZES_ICEPACK = GetModConfigData("INCREASEBACKPACKSIZES_ICEPACK") 
local largericebox = GetModConfigData("largericebox") 
local largertreasurechest = GetModConfigData("largertreasurechest")    
local largerdragonflychest = GetModConfigData("largerdragonflychest")
local largerbundlecontainer = GetModConfigData("largerbundlecontainer")
local largerchester = GetModConfigData("largerchester")  

--Define functions
  local function addItemSlotNetvarsInContainer(inst)
     if(#inst._itemspool < containers.MAXITEMSLOTS) then
        for i = #inst._itemspool+1, containers.MAXITEMSLOTS do
            table.insert(inst._itemspool, net_entity(inst.GUID, "container._items["..tostring(i).."]", "items["..tostring(i).."]dirty"))
        end
     end
  end
  AddPrefabPostInit("container_classified", addItemSlotNetvarsInContainer)

--Change size of Backpacks, Chests, Bundles, and Chester
  local widgetsetup_Base = containers.widgetsetup or function() return true end
  function containers.widgetsetup(container, prefab, data, ...)
    -- print("test1")
  	local updated = false
  	local tempPrefab = prefab or container.inst.prefab
  	local result = widgetsetup_Base(container, prefab, data, ...)
   
--Back Pack   
  	if(tempPrefab == "backpack" and INCREASEBACKPACKSIZES_BACKPACK ~= 8) then
  		container.widget.slotpos = {}
      if INCREASEBACKPACKSIZES_BACKPACK == 10 then 
        container.widget.animbank = "ui_krampusbag_2x5"
        container.widget.animbuild = "ui_krampusbag_2x5"
        container.widget.pos = Vector3(-5, -70, 0)
        for y = 0, 4 do
            table.insert(container.widget.slotpos, Vector3(-162, -75 * y + 115, 0))
            table.insert(container.widget.slotpos, Vector3(-162 + 75, -75 * y + 115, 0))
        end
      elseif INCREASEBACKPACKSIZES_BACKPACK == 12 then 
        container.widget.animbank = "ui_piggyback_2x6"
        container.widget.animbuild = "ui_piggyback_2x6"
        container.widget.pos = Vector3(-5, -50, 0)
        for y = 0, 5 do
            table.insert(container.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
            table.insert(container.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
        end
      elseif INCREASEBACKPACKSIZES_BACKPACK == 14 then 
        container.widget.animbank = "ui_krampusbag_2x8"
        container.widget.animbuild = "ui_krampusbag_2x8"
        container.widget.pos = Vector3(-5, -120, 0)
        for y = 0, 6 do
            table.insert(container.widget.slotpos, Vector3(-162, -y*75 + 240 ,0))
            table.insert(container.widget.slotpos, Vector3(-162 +75, -y*75 + 240 ,0))
        end
      elseif INCREASEBACKPACKSIZES_BACKPACK == 16 then 
        container.widget.animbank = "ui_krampusbag_2x8"
        container.widget.animbuild = "ui_krampusbag_2x8"
        container.widget.pos = Vector3(-5, -50, 0)
        for y = 0, 7 do
            table.insert(container.widget.slotpos, Vector3(-162, -65 * y + 245, 0))
            table.insert(container.widget.slotpos, Vector3(-162 + 75, -65 * y + 245, 0))
        end
      elseif INCREASEBACKPACKSIZES_BACKPACK == 18 then 
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/krampus_sack_bg.xml"
        container.widget.bgimage = "krampus_sack_bg.tex"
        container.widget.pos = Vector3(-76,-70,0)
        for y = 0, 8 do
            table.insert(container.widget.slotpos, Vector3(-37, -y*75 + 300 ,0))
            table.insert(container.widget.slotpos, Vector3(-37 +75, -y*75 + 300 ,0))
        end
      end
  	  updated = true
--Piggy Back
	elseif(tempPrefab == "piggyback" and INCREASEBACKPACKSIZES_PIGGYBACK ~= 12) then
  		container.widget.slotpos = {}
  	  if INCREASEBACKPACKSIZES_PIGGYBACK == 14 then 
        container.widget.animbank = "ui_krampusbag_2x8"
        container.widget.animbuild = "ui_krampusbag_2x8"
        container.widget.pos = Vector3(-5, -120, 0)
        for y = 0, 6 do
          table.insert(container.widget.slotpos, Vector3(-162, -y*75 + 240 ,0))
          table.insert(container.widget.slotpos, Vector3(-162 +75, -y*75 + 240 ,0))
        end	
      elseif INCREASEBACKPACKSIZES_PIGGYBACK == 16 then 
        container.widget.animbank = "ui_krampusbag_2x8"
        container.widget.animbuild = "ui_krampusbag_2x8"
        container.widget.pos = Vector3(-5, -50, 0)
        for y = 0, 7 do
            table.insert(container.widget.slotpos, Vector3(-162, -65 * y + 245, 0))
            table.insert(container.widget.slotpos, Vector3(-162 + 75, -65 * y + 245, 0))
        end
      elseif INCREASEBACKPACKSIZES_PIGGYBACK == 18 then 
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/krampus_sack_bg.xml"
        container.widget.bgimage = "krampus_sack_bg.tex"
        container.widget.pos = Vector3(-76,-70,0)
        for y = 0, 8 do
            table.insert(container.widget.slotpos, Vector3(-37, -y*75 + 300 ,0))
            table.insert(container.widget.slotpos, Vector3(-37 +75, -y*75 + 300 ,0))
        end
      end
      updated = true
--Krampus Sack	  
  	elseif(tempPrefab == "krampus_sack" and INCREASEBACKPACKSIZES_KRAMPUSSACK ~= 14) then
  		container.widget.slotpos = {}
      if INCREASEBACKPACKSIZES_KRAMPUSSACK == 16 then 
        container.widget.animbank = "ui_krampusbag_2x8"
        container.widget.animbuild = "ui_krampusbag_2x8"
        container.widget.pos = Vector3(-5, -50, 0)
        for y = 0, 7 do
            table.insert(container.widget.slotpos, Vector3(-162, -65 * y + 245, 0))
            table.insert(container.widget.slotpos, Vector3(-162 + 75, -65 * y + 245, 0))
        end  
      elseif INCREASEBACKPACKSIZES_KRAMPUSSACK == 18 then
	    container.widget.animbank = nil
  		container.widget.animbuild = nil
  		container.widget.bgatlas = "images/krampus_sack_bg.xml"
  		container.widget.bgimage = "krampus_sack_bg.tex"
  		container.widget.pos = Vector3(-76,-70,0)
  		for y = 0, 8 do
  		    table.insert(container.widget.slotpos, Vector3(-37, -y*75 + 300 ,0))
  		    table.insert(container.widget.slotpos, Vector3(-37 +75, -y*75 + 300 ,0))
  		end
	  end
  	  updated = true
--IcePack	  
  	elseif(tempPrefab == "icepack" and INCREASEBACKPACKSIZES_ICEPACK ~= 8) then
  		container.widget.slotpos = {}	
        if INCREASEBACKPACKSIZES_ICEPACK == 10 then
        container.widget.animbank = "ui_krampusbag_2x5"
        container.widget.animbuild = "ui_krampusbag_2x5"
        container.widget.pos = Vector3(-5, -70, 0)
        for y = 0, 4 do
          table.insert(container.widget.slotpos, Vector3(-162, -75 * y + 115, 0))
          table.insert(container.widget.slotpos, Vector3(-162 + 75, -75 * y + 115, 0))
        end
      elseif INCREASEBACKPACKSIZES_ICEPACK == 12 then 
        container.widget.animbank = "ui_piggyback_2x6"
        container.widget.animbuild = "ui_piggyback_2x6"
        container.widget.pos = Vector3(-5, -50, 0)
        for y = 0, 5 do
            table.insert(container.widget.slotpos, Vector3(-162, -75 * y + 170, 0))
            table.insert(container.widget.slotpos, Vector3(-162 + 75, -75 * y + 170, 0))
	    end
      elseif INCREASEBACKPACKSIZES_ICEPACK == 14 then 
        container.widget.animbank = "ui_krampusbag_2x8"
        container.widget.animbuild = "ui_krampusbag_2x8"
        container.widget.pos = Vector3(-5, -120, 0)
        for y = 0, 6 do
          table.insert(container.widget.slotpos, Vector3(-162, -y*75 + 240 ,0))
          table.insert(container.widget.slotpos, Vector3(-162 +75, -y*75 + 240 ,0))
        end
      elseif INCREASEBACKPACKSIZES_ICEPACK == 16 then 
        container.widget.animbank = "ui_krampusbag_2x8"
        container.widget.animbuild = "ui_krampusbag_2x8"
        container.widget.pos = Vector3(-5, -50, 0)
        for y = 0, 7 do
            table.insert(container.widget.slotpos, Vector3(-162, -65 * y + 245, 0))
            table.insert(container.widget.slotpos, Vector3(-162 + 75, -65 * y + 245, 0))
        end		
      elseif INCREASEBACKPACKSIZES_ICEPACK == 18 then 
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/krampus_sack_bg.xml"
        container.widget.bgimage = "krampus_sack_bg.tex"
        container.widget.pos = Vector3(-76,-70,0)
        for y = 0, 8 do
          table.insert(container.widget.slotpos, Vector3(-37, -y*75 + 300 ,0))
          table.insert(container.widget.slotpos, Vector3(-37 +75, -y*75 + 300 ,0))
        end		
      end		
      updated = true
--Ice Box
    elseif(tempPrefab == "icebox" and largericebox ~= 9) then
      container.widget.slotpos = {}
	  if largericebox == 12 then
	    for y = 2.5, -0.5, -1 do
          for x = 0, 2 do
		    table.insert(container.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
		  end     
        end	
        container.widget.animbank = "ui_chester_shadow_3x4"
        container.widget.animbuild = "ui_chester_shadow_3x4"
      elseif largericebox == 16 then 
        for y = 3, 0, -1 do
          for x = 0, 3 do
            table.insert(container.widget.slotpos, Vector3(80*x-80*2+40, 80*y-80*2+40,0))
          end
        end
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/container.xml"
        container.widget.bgimage = "container.tex"
        container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      elseif largericebox == 20 then 
        for y = 3, 0, -1 do
          for x = 0, 4 do
            table.insert(container.widget.slotpos, Vector3(75*x-75*2+0, 75*y-75*2+40,0))
          end
        end
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/container_x20.xml"
        container.widget.bgimage = "container_x20.tex"
        container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      elseif largericebox == 24 then 
        for y = 3, 0, -1 do
          for x = 0, 5 do
            table.insert(container.widget.slotpos, Vector3(65*x-65*2-33, 80*y-80*2+38,0))
          end
        end
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/container_x20.xml"
        container.widget.bgimage = "container_x20.tex"
        container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      end
      updated = true	
--Chest	  
    elseif(tempPrefab == "treasurechest" and largertreasurechest ~= 9) then
      container.widget.slotpos = {}
	  if largertreasurechest == 12 then
	    for y = 2.5, -0.5, -1 do
          for x = 0, 2 do
		    table.insert(container.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
		  end     
        end	
        container.widget.animbank = "ui_chester_shadow_3x4"
        container.widget.animbuild = "ui_chester_shadow_3x4"
	  elseif largertreasurechest == 16 then 
    	for y = 3, 0, -1 do
    	  for x = 0, 3 do
    	    table.insert(container.widget.slotpos, Vector3(80*x-80*2+40, 80*y-80*2+40,0))
    	  end
    	end
       	container.widget.animbank = nil
    	container.widget.animbuild = nil
    	container.widget.bgatlas = "images/container.xml"
    	container.widget.bgimage = "container.tex"
    	container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      elseif largertreasurechest == 20 then 
        for y = 3, 0, -1 do
          for x = 0, 4 do
            table.insert(container.widget.slotpos, Vector3(75*x-75*2+0, 75*y-75*2+40,0))
          end
        end
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/container_x20.xml"
        container.widget.bgimage = "container_x20.tex"
        container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      elseif largertreasurechest == 24 then 
        for y = 3, 0, -1 do
          for x = 0, 5 do
            table.insert(container.widget.slotpos, Vector3(65*x-65*2-33, 80*y-80*2+38,0))
          end
        end
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/container_x20.xml"
        container.widget.bgimage = "container_x20.tex"
        container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      end
  	  updated = true
--Scaled Chest
    elseif(tempPrefab == "dragonflychest" and largerdragonflychest ~= 12) then
      container.widget.slotpos = {}
      if largerdragonflychest == 16 then 
        for y = 3, 0, -1 do
          for x = 0, 3 do
            table.insert(container.widget.slotpos, Vector3(80*x-80*2+40, 80*y-80*2+40,0))
          end
        end
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/container.xml"
        container.widget.bgimage = "container.tex"
        container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      elseif largerdragonflychest == 20 then 
        for y = 3, 0, -1 do
          for x = 0, 4 do
            table.insert(container.widget.slotpos, Vector3(75*x-75*2+0, 75*y-75*2+40,0))
          end
        end
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/container_x20.xml"
        container.widget.bgimage = "container_x20.tex"
        container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      elseif largerdragonflychest == 24 then 
        for y = 3, 0, -1 do
          for x = 0, 5 do
            table.insert(container.widget.slotpos, Vector3(65*x-65*2-33, 80*y-80*2+38,0))
          end
        end
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/container_x20.xml"
        container.widget.bgimage = "container_x20.tex"
        container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      end
      updated = true
--Bundle Wrap
	elseif (tempPrefab == "bundle_container" and largerbundlecontainer ~= 4) then
	  container.widget.slotpos = {}
      if largerbundlecontainer == 9 then
		for y = 2, 0, -1 do
		  for x = 0, 2 do
			table.insert(container.widget.slotpos, Vector3(80 * x - 80 * 2 + 80, 80 * y - 80 * 2 + 80, 0))
		  end
		end	 
		container.widget.buttoninfo.position = Vector3(0,-141,0)		
        container.widget.animbank = "ui_chest_3x3"
        container.widget.animbuild = "ui_chest_3x3"
	elseif largerbundlecontainer == 12 then
	    for y = 2.5, -0.5, -1 do
          for x = 0, 2 do
		    table.insert(container.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
		  end     
        end	
		container.widget.buttoninfo.position = Vector3(0,-177,0)
        container.widget.animbank = "ui_chester_shadow_3x4"
        container.widget.animbuild = "ui_chester_shadow_3x4"
	  elseif largerbundlecontainer == 16 then 
    	for y = 3, 0, -1 do
    	  for x = 0, 3 do
    	    table.insert(container.widget.slotpos, Vector3(80*x-80*2+40, 80*y-80*2+40,0))
    	  end
    	end
		container.widget.buttoninfo.position = Vector3(0,-185,0)		
       	container.widget.animbank = nil
    	container.widget.animbuild = nil
    	container.widget.bgatlas = "images/container.xml"
    	container.widget.bgimage = "container.tex"
    	container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      elseif largerbundlecontainer == 20 then 
        for y = 3, 0, -1 do
          for x = 0, 4 do
            table.insert(container.widget.slotpos, Vector3(75*x-75*2+0, 75*y-75*2+40,0))
          end
        end
		container.widget.buttoninfo.position = Vector3(5,-184,0)		
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/container_x20.xml"
        container.widget.bgimage = "container_x20.tex"
        container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      elseif largerbundlecontainer == 24 then 
        for y = 3, 0, -1 do
          for x = 0, 5 do
            table.insert(container.widget.slotpos, Vector3(65*x-65*2-33, 80*y-80*2+38,0))
          end
        end
		container.widget.buttoninfo.position = Vector3(5,-184,0)				
        container.widget.animbank = nil
        container.widget.animbuild = nil
        container.widget.bgatlas = "images/container_x20.xml"
        container.widget.bgimage = "container_x20.tex"
        container.widget.bgimagetint = {r=.82,g=.77,b=.7,a=1}
      end
  	  updated = true	
--Chester	  
	elseif(tempPrefab == "chester" and largerchester ~= 9) then
      container.widget.slotpos = {}
	  if largerchester == 12 then
	    for y = 2.5, -0.5, -1 do
          for x = 0, 2 do
		    table.insert(container.widget.slotpos, Vector3(75 * x - 75 * 2 + 75, 75 * y - 75 * 2 + 75, 0))
		  end     
        end	
        container.widget.animbank = "ui_chester_shadow_3x4"
        container.widget.animbuild = "ui_chester_shadow_3x4"
      end
  	  updated = true
  	end 
  
  	if updated then
  		container:SetNumSlots(container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
  		--containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, container.widget.slotpos ~= nil and #container.widget.slotpos or 0)
  	end
   return result
  end