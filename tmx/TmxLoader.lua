local table = require("table")
local TmxMap = require("tmx/TmxMap")
local TmxTileSet = require("tmx/TmxTileSet")
local TmxLayer = require("tmx/TmxLayer")
local TmxObject = require("tmx/TmxObject")
local TmxObjectGroup = require("tmx/TmxObjectGroup")

local ENCODING_CSV = "csv"
local ENCODING_BASE64 = "base64"
local NodeParserNames = {
	 map = "parseNodeMap",
	 tileset = "parseNodeTileset",
	 layer = "parseNodeLayer",
	 objectgroup = "parseNodeObjectGroup"
}

-----------------------------------------------------------------------------
local parseNodeAttributes = function(node,dest)
   for key, value in pairs(node.attributes) do
      if tonumber(value) ~= nil then
	 dest[key] = tonumber(value)
      else
	 dest[key] = value
      end
   end
end

local parseNodeProperties = function(node, dest)
   if not node.children then
      return
   end
   if not node.children.properties then
      return
   end
   for _, prop in ipairs(node.children.properties) do
      for _, pprop in ipairs(prop.children.property) do
	 dest[pprop.attributes.name] = pprop.attributes.value
      end
   end
end

local parseNodeImage = function(node, tileset)
   if not node.children.image then
      return
   end
   for _, _image in pairs(node.children.image) do
      for _key, _attr in pairs(_image.attributes) do
	 tileset.image[_key] = _attr
      end
   end
end

local parseNodeTile = function(node, tileset)
   if not node.children.tile then
      return
   end
   for _, tile in pairs(node.children.tile) do
      local id = tonumber(tile.attributes.id) + 1
      if tileset.tiles[id] == nil then
	 tileset.tiles[id] = {properties = {}}
      end
      parseNodeProperties(tile, tileset.tiles[id].properties)
   end
end

local parseNodeDataForPlane
local parseNodeDataForCsv
local parseNodeDataForBase64

local parseNodeData = function(node, layer)
   if node.children.data == nil or #node.children.data < 1 then
      return
   end
   
   local data = node.children.data[1]
   if not data.attributes or not data.attributes.encoding then
      parseNodeDataForPlane(node, layer, data)
   elseif data.attributes.encoding == ENCODING_BASE64 then
      parseNodeDataForBase64(node, layer, data)
   elseif data.attributes.encoding == ENCODING_CSV then
      parseNodeDataForCsv(node, layer, data)
   else
      print("not support encoding!")
   end
end

parseNodeDataForPlane = function(node, layer, data)
   for j, tile in ipairs(data.children.tile) do
      layer.tiles[j] = tonumber(tile.attributes.gid)
   end
end

parseNodeDataForBase64 = function(node, layer, data)
   local decodedData = MOAIDataBuffer.base64Decode(data.value)
   if data.attributes.compression then
      decodedData = MOAIDataBuffer.inflate(decodedData, 47)
   end

   local tileSize = #decodedData / 4
   for i = 1, tileSize do
      local start = (i - 1) * 4 + 1
      local a0, a1, a2, a3 = string.byte(decodedData, start, start + 3)
      local gid = a3 * 256 * 3 + a2 * 256 * 2 + a1 * 256 + a0
      layer.tiles[i] = gid
   end
end

parseNodeDataForCsv = function(node, layer, data)
   layer.tiles = assert(loadstring("return {" .. data.value .."}"))()
end

local parseNodeObject = function(node, group)
   if node.children == nil or node.children.object == nil then
      return
   end

   for i, obj in ipairs(node.children.object) do
      local object = TmxObject.new(group)
      parseNodeAttributes(obj, object)
      parseNodeProperties(obj, object.properties)
      TmxObjectGroup.addObject(group, object)
   end
end
-----------------------------------------------------------------

local Parser_Tbl = {}

Parser_Tbl.parseNodeMap = function(map, node)
   parseNodeAttributes(node, map)
   parseNodeProperties(node, map.properties)
end

Parser_Tbl.parseNodeTileset = function(map, node)
   local tileset = TmxTileSet.new(map)
   TmxMap.addTileset(map, tileset)

   parseNodeAttributes(node, tileset)
   parseNodeImage(node, tileset)
   parseNodeTile(node, tileset)
   parseNodeProperties(node, tileset.properties)
end

Parser_Tbl.parseNodeLayer = function(map, node)
   local layer = TmxLayer.new(map)
   TmxMap.addLayer(map, layer)

   parseNodeAttributes(node, layer)
   parseNodeData(node, layer)
   parseNodeProperties(node, layer.properties)
end

Parser_Tbl.parseNodeObjectGroup = function(map, node)
   local group = TmxObjectGroup.new(map)
   TmxMap.addObjectGroup(map, group)

   parseNodeAttributes(node, group)
   parseNodeObject(node, group)
   parseNodeProperties(node, group.properties)
end

local parseNode
parseNode = function(map, node)
   local parser = NodeParserNames[node.type]
   if parser then
      Parser_Tbl[parser](map, node)
   else
      return
   end
   if not node.children then
     return
   end
   for _, _child in pairs(node.children) do
      for _, _node in pairs(_child) do
	 if type(_node) == "table" then
	    parseNode(map, _node)
	 end
      end
   end
end

local TmxLoader = {}
TmxLoader.loadTmxFile = function(fileName)
   print("loadTmxFile------>"..fileName)
   --[[
   if MOAIFileSystem.checkFileExists(fileName)then
      local input = io.input(fileName)
      local data = input:read("*a")
      input:close()
      local xml = MOAIXmlParser.parseString(data)
      --lua table = {type="map",attributes={...},childrend={...}}
      local map = TmxMap.new()
      parseNode(map, xml)
      return map
   else
      print("不存在的文件:"..fileName)
   end
   --]]
   local xml = MOAIXmlParser.parseFile(fileName)
   local map = TmxMap.new()
   parseNode(map, xml)
   return map
end

return  TmxLoader
