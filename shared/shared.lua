Shared = {}

Shared.currentResourceName = GetCurrentResourceName()

Shared.stateBagName = ("%s:savedConfigurations"):format(Shared.currentResourceName)

Shared.netEventName = ("%s:savePlayerConfigurations"):format(Shared.currentResourceName)

Shared.isDuplicityVersion = IsDuplicityVersion()

if not Shared.isDuplicityVersion then -- client
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

function Shared.notification(source, message, type, duration)
    local data = {
        title = Shared.currentResourceName:upper(),
        description = message,
        type = type or "inform",
        duration = duration or 5000,
        position = "center-right"
    }
    if not Shared.isDuplicityVersion then
        return TriggerEvent("ox_lib:notify", data)
        -- return TriggerEvent("t-notify:client:Custom", {title = data.title, message = message, style = type or "info", duration = data.duration})
        -- return TriggerEvent("esx:showNotification", message, type or "info", data.duration)
        -- return TriggerEvent("QBCore:Notify", message, type or "primary", data.duration)
        -- return TriggerEvent("okokNotify:Alert", message, nil, data.duration, type or "info")
    else
        return TriggerClientEvent("ox_lib:notify", source, data)
        -- return TriggerClientEvent("t-notify:client:Custom", source, {title = data.title, message = message, style = type or "info", duration = data.duration})
        -- return TriggerClientEvent("esx:showNotification", source, message, type or "info", data.duration)
        -- return TriggerClientEvent("QBCore:Notify", source, message, type or "primary", data.duration)
        -- return TriggerClientEvent("okokNotify:Alert", source, message, nil, data.duration, type or "info")
    end
end

function stringsplit(inputString, separator)
    if not separator then
        separator = "%s"
    end
    local t, i = {}, 1
    for str in string.gmatch(inputString, "([^"..separator.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

function starts_with(inputString, start)
    return inputString:sub(1, #start) == start
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