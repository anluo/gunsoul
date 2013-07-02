local setSheets

--MOAIProp, MOAIGfxQuadDeck2D, MOAIGrid
local Sprite = {

}

Sprite.new = function(texture, renderlayer)
   local obj = {}
   obj.texture = texture
   obj.layer = renderlayer   --[Layer]

   obj.prop = MOAIProp.new()

   obj.deck = MOAIGfxQuadDeck2D.new()
   obj.deck:setTexture(texture)
   obj.prop:setDeck(obj.deck)

   obj.grid = MOAIGrid.new()
   obj.prop:setGrid(obj.grid)
   return obj
end


Sprite.setMapSheets = function(sprite, tileWidth, tileHeight, tileX, tileY, spacing, margin)
   spacing = spacing or 0
   margin = margin or 0
   local sheets = {}
   for y = 1, tileY do
      for x = 1, tileX do
	 local sx = (x - 1) * (tileWidth + spacing) + margin
	 local sy = (y - 1) * (tileHeight + spacing) + margin
	 table.insert(sheets, {x=sx, y=sy, width=tileWidth, height=tileHeight})
      end
   end
   setSheets(sprite, sheets)
end

setSheets = function(sprite, sheets)
   local tw, th = sprite.texture:getSize()
   print("tw:"..tw..",".."th:"..th)
   sprite.deck:reserve(#sheets) --·ÖÅä¿Õ¼ä
   for i, sheet in ipairs(sheets) do
      local xMin, yMin = sheet.x, sheet.y
      local xMax, yMax = sheet.x + sheet.width, sheet.y + sheet.height
      sprite.deck:setUVRect(i, xMin / tw, yMin / th, xMax / tw, yMax / th)
   end
end

Sprite.setMapSize = function(sprite, mapWidth, mapHeight, tileWidth, tileHeight)
   print("setMapSize--->"..mapWidth..","..mapHeight..","..tileWidth..","..tileHeight)
   sprite.grid:setSize(mapWidth, mapHeight, tileWidth, tileHeight)
end

Sprite.setRow = function(sprite,y, rowData)
   sprite.grid:setRow(y,unpack(rowData))
end

return Sprite
