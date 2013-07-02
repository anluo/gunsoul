local TmxMap = require("tmx/TmxMap")
local TmxLayer = {}

TmxLayer.new = function(tmxMap)
   local obj = {}
   obj.tmxMap = tmxMap
   obj.type = "tilelayer"
   obj.name = ""
   obj.x = 0
   obj.y = 0
   obj.width = 0
   obj.height = 0
   obj.opacity = 0
   obj.visible = 1
   obj.properties = {}
   obj.tiles = {}
   return obj
end

TmxLayer.getProperty = function(layer, key)
   return layer.properties[key]
end

TmxLayer.getTileProperty = function(layer, x, y, key)
   local gid = getGid(layer, x, y)
   return TmxMap.getTileProperty(layer.tmxMap, gid,key)
end

TmxLayer.getTileProperties = function(layer, x, y)
   local gid = getGid(layer, x, y)
   return TmxMap.getTileProperties(layer.tmxMap, gid)
end

local getGid = function(layer, x, y)
   if not checkBounds(layer, x, y) then
      return nil
   end
   return layer.tiles[(y - 1) * layer.width + x]
end

local setGid = function(layer, x, y, gid)
   if not checkBounds(layer, x, y) then
      print("index out of bounds!")
   end
   layer.tiles[(y - 1) * layer.width + x] = gid
end

local checkBounds = function(layer, x, y)
   if x < 1 or layer.width < x then
      return false
   end
   if y < 1 or layer.height < y then
      return false
   end
   return true
end

return TmxLayer
