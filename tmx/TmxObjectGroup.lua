local TmxObjectGroup = {}

TmxObjectGroup.new = function(tmxMap)
   local obj = {}
   obj.type = "objectgroup"
   obj.name = ""
   obj.width = 0
   obj.height = 0
   obj.tmxMap = tmxMap
   obj.objects = {}
   obj.properties = {}
   return obj
end

TmxObjectGroup.addObject = function(objgroup, object)
   return table.insert(objgroup.objects, object)
end

TmxObjectGroup.removeObject = function(objgroup, object)
   return table.remove(objgroup.objects,object)
end

TmxObjectGroup.getProperty = function(objgroup, key)
   return objgroup.properties[key]
end

return TmxObjectGroup

