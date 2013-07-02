local TmxObject = {}

TmxObject.new = function()
   local obj  = {}
   obj.name = ""
   obj.type = ""
   obj.x = 0
   obj.y = 0
   obj.width = 0
   obj.height = 0
   obj.gid = nil
   obj.properties = {}
   return obj
end

return TmxObject
