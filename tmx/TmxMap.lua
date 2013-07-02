local table = require('table')
local TmxMap = {}

local ATTRIBUTE_NAMES = {
   "version", "orientation", "width", "height", "tilewidth", "tileheight"
}

TmxMap.new = function()
   local obj = {}
   obj.version = 0
   obj.orientation = ""
   obj.width = 0
   obj.height = 0
   obj.tilewidth = 0
   obj.tileheight = 0
   obj.allLayers = {}  --°üº¬ÁËlayerºÍobjectgroup
   obj.layers = {}     --"layer"
   obj.tilesets = {}   --"tilesets"
   obj.objectGroups = {} --"objectgroup"
   obj.properties = {}
   return obj
end

TmxMap.printDebug = function(map)
   print("<TmxMap>")
   for i, attr in ipairs(ATTRIBUTE_NAMES) do
      local value = map[attr]
      value = value and value or ""
      print(attr.. " = " .. value)
   end
   print("</TmxMap>")
end

TmxMap.addLayer = function(map, layer)
   table.insert(map.allLayers, layer)
   table.insert(map.layers, layer)
end

TmxMap.removeLayer = function(map, layer)
   removeElement(map.allLayers, layer)
   return removeElement(map.layers, layer)
end

TmxMap.removeLayerAt = function(map, index)
   removeElement(map.allLayers, map.layers[index])
   return table.remove(map.layers, index)
end

TmxMap.findLayerByName = function(map, name)
   for i, v in ipairs(map.layers) do
      if v.name == name then
	 return v
      end
   end
   return nil
end

TmxMap.addTileset = function(map, tileset)
   table.insert(map.tilesets, tileset)
end

TmxMap.removeTileset = function(map, tileset)
   removeElement(map.tilesets, tileset)
end

TmxMap.removeTilesetAt = function(map, index)
   return table.remove(map.tilesets, index)
end

TmxMap.findTilesetByGid = function(map, gid)
   local matchTileset = nil
   for i, tileset in ipairs(map.tilesets) do
      if gid >= tileset.firstgid then
	 matchTileset = tileset
      end
   end
   return matchTileset
end

TmxMap.addObjectGroup = function(map, objectGroup)
   table.insert(map.allLayers, objectGroup)
   table.insert(map.objectGroups, objectGroup)
end

TmxMap.removeObjectGroup = function(map, objectGroup)
   removeElement(map.allLayers, objectGroup)
   return removeElement(map.objectGroups, objectGroup)
end

TmxMap.removeObjectGroupAt = function(map, index)
   removeElement(map.allLayers, map.objectGroups[index])
   return table.remove(map.objectGroups, index)
end

TmxMap.getProperty = function(map, key)
   return map.properties[key]
end

TmxMap.getTileProperty = function(map, gid, key)
   local properties = TmxMap.getTileProperties(map, gid)
   return properties[key]
end

TmxMap.getTileProperties = function(map, gid)
   for i, tileset in ipairs(map.tilesets) do
      local tileId = TmxTileSet.getTileIndexByGid(tileset, gid)
      if tileset.tiles[tileId] then
	 return tileset.tiles[tileId].properties
      end
   end
end


return TmxMap


