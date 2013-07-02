local TmxMap = require('tmx/TmxMap')
local TmxLoader = require('tmx/TmxLoader')
local Layer = require('tmx/Layer')
local Sprite = require('tmx/Sprite')

--local function
local createDisplayLayer
local createSprite
local loadTexture

local TmxView = {}
TmxView.new = function(tmxUrl, camera, viewport)
   local obj = {}
   obj.tmxmap = TmxLoader.loadTmxFile(tmxUrl)
   obj.mapLayers = {}
   obj.layers = {}
   obj.objectLayers = {}

   TmxMap.printDebug(obj.tmxmap)

   --[[map.allLayers包含了所有layer和objectgroup]]
   for i, layer in ipairs(obj.tmxmap.allLayers) do
      if layer.type == "tilelayer" then
	 if layer.visible ~= 0 and layer.properties.visible ~= "false" then
	    local displaylayer = createDisplayLayer(obj.tmxmap, layer, viewport)
	    table.insert(obj.mapLayers, displaylayer)
	    table.insert(obj.layers, displaylayer)
	 end
      else
	 
      end
   end

   --为每个layer设置镜头
   for i, layer in ipairs(obj.mapLayers) do
      Layer.setCamera(layer, camera)
   end

   return obj
end

createDisplayLayer = function(tmxmap, layer, viewport)
   print("-------layer.name->"..layer.name)
   --加载所有格子(layer.tiles)使用的贴图
   local tilesets = {}
   for i, gid in ipairs(layer.tiles) do
      local tileset = TmxMap.findTilesetByGid(tmxmap, gid)
      if tileset then
	 loadTexture(tileset)
	 tilesets[tileset.name] = tileset
      end
   end

   --为每个格子创建显示元件--MOAILayer, MOAIPartition
   local renderlayer = Layer.new(viewport, layer)
   for key, tileset in pairs(tilesets) do
      if tileset.texture then
	 local sprite = createSprite(tmxmap, renderlayer, tileset)
	 table.insert(renderlayer.tilesetRenderers, sprite)
      end
   end
   return renderlayer
end

--根据tile和tileset信息为layer创建显示元件
createSprite = function(tmxmap, renderlayer, tileset)
   local mapWidth, mapHeight = tmxmap.width, tmxmap.height
   local texture = tileset.texture
   local tmxlayer = renderlayer.layer
   --
   local tw, th = texture:getSize()
   local spacing, margin = tileset.spacing, tileset.margin
   local tileWidth, tileHeight = tileset.tilewidth, tileset.tileheight
   local tileCol = math.floor((tw + spacing) / tileWidth)
   local tileRow = math.floor((th + spacing) / tileHeight)
   local tileSize = tileCol * tileRow
   print("tileSize:"..tileSize)
   --Sprite相当于--MOAIProp, MOAIGfxQuadDeck2D, MOAIGrid
   local sprite = Sprite.new(texture, renderlayer)
   Sprite.setMapSize(sprite, mapWidth, mapHeight, tileWidth, tileHeight)
   Sprite.setMapSheets(sprite, tileWidth, tileHeight, tileCol, tileRow, spacing, margin)
   for y = 1, tmxlayer.height do
      local rowData = {}
      for x = 1, tmxlayer.width do
	 local gid = tmxlayer.tiles[(y - 1) * tmxlayer.width + x]
	 local tileNo = gid == 0 and gid or gid - tileset.firstgid + 1
	 tileNo = tileNo > tileSize and 0 or tileNo
	 table.insert(rowData, tileNo)
      end
      Sprite.setRow(sprite, y, rowData)
   end

   return sprite
end

loadTexture = function(tileset)
   if tileset and not tileset.texture then
      local path = g_mapResourcePath .. tileset.image.source
      print("load texture:"..path.."\n"..tileset.image.source)
      if g_resourceCache[path] == nil then
	 local texture = MOAITexture.new()
	 texture:load(path)
	 g_resourceCache[path] = texture
	 texture:setFilter(MOAITexture.GL_LINEAR)
      end
      tileset.texture = g_resourceCache[path];
   end
end

return TmxView
