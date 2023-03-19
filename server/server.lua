local savedFileName = "playersConfigurations"

local function getPlayerIdentifier(source)
    local identifiers = GetPlayerIdentifiers(source)
    for i = 1, #identifiers do
        local identifier = identifiers[i]
        if identifier:find("license") then
            return identifier
        end
    end
end

local function getPlayerConfigurations(identifier)
    local savedConfigurations = LoadResourceFile(Shared.currentResourceName, ("./%s.json"):format(savedFileName))
    savedConfigurations = savedConfigurations and json.decode(savedConfigurations) or {}
    return savedConfigurations[identifier] or {}
end

local function savePlayerConfigurations(source, configurations)
    local identifier = getPlayerIdentifier(source)
    if not identifier then return false end
    local savedConfigurations = LoadResourceFile(Shared.currentResourceName, ("./%s.json"):format(savedFileName))
    savedConfigurations = savedConfigurations and json.decode(savedConfigurations) or {}
    savedConfigurations[identifier] = configurations
    Player(tonumber(source)).state:set(Shared.stateBagName, configurations, true)
    return SaveResourceFile(Shared.currentResourceName, ("%s.json"):format(savedFileName), json.encode(savedConfigurations), -1)
end

local function init(source)
    local players = source and { source } or GetPlayers()
    for i = 1, #players do
        local src = tonumber(players[i])
        local identifier = getPlayerIdentifier(src)
        if not identifier then return end
        local savedConfigurations = getPlayerConfigurations(identifier)
        Player(src).state:set(Shared.stateBagName, savedConfigurations, true)
    end
end

local function finit(source)
    local players = source and { source } or GetPlayers()
    for i = 1, #players do
        local src = tonumber(players[i])
        Player(src).state:set(Shared.stateBagName, nil, true)
    end
end

RegisterNetEvent(Shared.netEventName, function(configurations)
    if not source then return end
    savePlayerConfigurations(source, configurations)
end)

AddEventHandler("playerJoining", function()
    init(source)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource ~= Shared.currentResourceName then return end
    init()
end)

AddEventHandler('playerDropped', function()
    finit(source)
end)

AddEventHandler('onResourceStop', function(resource)
    if resource ~= Shared.currentResourceName then return end
    finit()
end)