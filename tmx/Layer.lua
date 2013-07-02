local Layer = {}

--MOAILayer, MOAIPartition
Layer.new = function(viewport, layer)
   local obj = {}
   obj.layer = layer    --TmxLayer
   obj.tilesetRenderers = {}
   obj.moai_layer = MOAILayer.new()
   obj.moai_partion = MOAIPartition.new()
   obj.viewport = viewport

   obj.moai_layer:setPartition(obj.moai_partion)
   obj.moai_layer:setViewport(viewport)
   return obj
end

Layer.setCamera = function(layer, camera)
   layer.moai_layer:setCamera(camera)
end

return Layer
