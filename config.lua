package.path = package.path .. ';../../sdk/moai-sdk-1.4p0/include/lua-modules/?.lua'
g_baseResourcePath = "release"
g_mapResourcePath = "release/map/"
g_resourceCache = {}
setmetatable(g_resourceCache, {__mode = "v"})
