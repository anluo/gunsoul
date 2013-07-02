local TmxTileSet = {}

TmxTileSet.new = function(tmxMap)
   local obj = {}
   obj.tmxMap = tmxMap
   obj.name = ""
   obj.firstgid = 0
   obj.tilewidth = 0
   obj.tileheight = 0
   obj.spacing = 0
   obj.margin = 0
   obj.image = {source = "", width = 0, height = 0}
   obj.tiles = {}
   obj.properties = {}
   return obj
end

TmxTileSet.getTileIndexByGid = function(tileset, gid)
   return gid - tileset.firstgid + 1
end

return TmxTileSet
