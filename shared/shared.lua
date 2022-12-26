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

function dumpTable(table, nb)
    if nb == nil then
        nb = 0
    end

    if type(table) == 'table' then
        local s = ''
        for i = 1, nb + 1, 1 do
            s = s .. "    "
        end

        s = '{\n'
        for k,v in pairs(table) do
            if type(k) ~= 'number' then k = '"'..k..'"' end
            for i = 1, nb, 1 do
                s = s .. "    "
            end
            s = s .. '['..k..'] = ' .. dumpTable(v, nb + 1) .. ',\n'
        end

        for i = 1, nb, 1 do
            s = s .. "    "
        end

        return s .. '}'
    else
        return tostring(table)
    end
end