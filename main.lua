require('common/common')
local TmxView = require('tmx/TmxView')

MOAISim.openWindow("test", 1000, 750)

g_camera = MOAICamera.new()
g_camera:setOrtho(true)
g_camera:setFarPlane(-1)
g_camera:setNearPlane(1)

g_viewport = MOAIViewport.new()
g_viewport:setSize(1000, 750)
g_viewport:setScale(1000, -750)
g_viewport:setOffset(-1, 1)

g_tmxview = TmxView.new("release/map/1.tmx", g_camera, g_viewport)
g_renderTbl = {}
local mapLayers = g_tmxview.mapLayers --´ýäÖÈ¾µÄ²ã
for _, layer in ipairs(mapLayers) do
   local moai_layer = layer.moai_layer
   for _, sprite in ipairs(layer.tilesetRenderers) do
      local prop = sprite.prop
      moai_layer:insertProp(prop)
   end
   table.insert(g_renderTbl, moai_layer)
end

print("layer count:"..#g_renderTbl)
MOAIRenderMgr.setRenderTable(g_renderTbl)

