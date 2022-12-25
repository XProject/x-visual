if not IsDuplicityVersion() then -- client
    if Config.Menu == "ox_lib" then
        if GetResourceState("ox_lib"):find("start") then
            local file = 'init.lua'
            local import = LoadResourceFile('ox_lib', file)
            local chunk = assert(load(import, ('@@ox_lib/%s'):format(file)))
            chunk()
        end
    elseif Config.Menu == "menuv" then
        if GetResourceState("menuv"):find("start") then
            local file = 'menuv.lua'
            local import = LoadResourceFile('menuv', file)
            local chunk = assert(load(import, ('@@menuv/%s'):format(file)))
            chunk()
        end
    end
end