local entityEnumerator = {
    __gc = function(enum)
        if enum.destructor and enum.handle then
            enum.destructor(enum.handle)
        end
        enum.destructor = nil
        enum.handle = nil
    end
}

local function EnumerateEntities(initFunc, moveFunc, disposeFunc)
    return coroutine.wrap(
        function()
            local iter, id = initFunc()
            if not id or id == 0 then
                disposeFunc(iter)
                return
            end

            local enum = {handle = iter, destructor = disposeFunc}
            setmetatable(enum, entityEnumerator)

            local next = true
            repeat
                coroutine.yield(id)
                next, id = moveFunc(iter)
            until not next

            enum.destructor, enum.handle = nil, nil
            disposeFunc(iter)
        end
    )
end

local function GetWorldObjects()
    return EnumerateEntities(FindFirstObject, FindNextObject, EndFindObject)
end

local function GetWorldPeds()
    return EnumerateEntities(FindFirstPed, FindNextPed, EndFindPed)
end

local function GetWorldVehicles()
    return EnumerateEntities(FindFirstVehicle, FindNextVehicle, EndFindVehicle)
end

local function modifyWorldObjects(alpha, distance)
    for obj in GetWorldObjects() do
        if not IsEntityOnScreen(obj) and #(Config.playerCoords - GetEntityCoords(obj)) > distance then
            SetEntityAlpha(obj, 0)
            if not IsEntityAMissionEntity(obj) then
                SetEntityAsNoLongerNeeded(obj)
            end
        else
            if GetEntityAlpha(obj) ~= alpha then
                SetEntityAlpha(obj, alpha)
            end
        end
        Wait(0)
    end
end

local function modifyWorldPeds(alpha, distance)
    for obj in GetWorldPeds() do
        if not IsEntityOnScreen(obj) and #(Config.playerCoords - GetEntityCoords(obj)) > distance then
            SetEntityAlpha(obj, 0)
            if not IsEntityAMissionEntity(obj) then
                SetEntityAsNoLongerNeeded(obj)
            end
        else
            if GetEntityAlpha(obj) ~= alpha then
                SetEntityAlpha(obj, alpha)
            end
        end
        SetPedAoBlobRendering(obj, false)
        Wait(0)
    end
end

local function modifyWorldVehicles(alpha, distance)
    for obj in GetWorldVehicles() do
        if not IsEntityOnScreen(obj) and #(Config.playerCoords - GetEntityCoords(obj)) > distance then
            SetEntityAlpha(obj, 0)
            if not IsEntityAMissionEntity(obj) then
                SetEntityAsNoLongerNeeded(obj)
            end
        else
            if GetEntityAlpha(obj) ~= alpha then
                SetEntityAlpha(obj, alpha)
            end
        end
        Wait(0)
    end
end

Config.fpsSettings = {
    ulow_alpha = { world = 210, ped = 245, vehicle = 255 },
    ulow_distance = { world = 40, ped = 40, vehicle = 40 },
    ulow = function()
        modifyWorldObjects(Config.fpsSettings.ulow_alpha.world, Config.fpsSettings.ulow_distance.world)
        modifyWorldPeds(Config.fpsSettings.ulow_alpha.ped, Config.fpsSettings.ulow_distance.ped)
        modifyWorldVehicles(Config.fpsSettings.ulow_alpha.vehicle, Config.fpsSettings.ulow_distance.vehicle)
        DisableOcclusionThisFrame()
        SetDisableDecalRenderingThisFrame()
        RemoveParticleFxInRange(Config.playerCoords, 10.0)
        OverrideLodscaleThisFrame(0.4)
    end,
    low_alpha = { world = 210, ped = 250, vehicle = 255 },
    low_distance = { world = 60, ped = 60, vehicle = 60 },
    low = function()
        modifyWorldObjects(Config.fpsSettings.low_alpha.world, Config.fpsSettings.low_distance.world)
        modifyWorldPeds(Config.fpsSettings.low_alpha.ped, Config.fpsSettings.low_distance.ped)
        modifyWorldVehicles(Config.fpsSettings.low_alpha.vehicle, Config.fpsSettings.low_distance.vehicle)
        SetDisableDecalRenderingThisFrame()
        RemoveParticleFxInRange(Config.playerCoords, 10.0)
        OverrideLodscaleThisFrame(0.6)
    end,
    medium_alpha = { world = 245, ped = 255, vehicle = 255 },
    medium_distance = { world = 85, ped = 85, vehicle = 85 },
    medium = function()
        modifyWorldObjects(Config.fpsSettings.medium_alpha.world, Config.fpsSettings.medium_distance.world)
        modifyWorldPeds(Config.fpsSettings.medium_alpha.ped, Config.fpsSettings.medium_distance.ped)
        modifyWorldVehicles(Config.fpsSettings.medium_alpha.vehicle, Config.fpsSettings.medium_distance.vehicle)
        OverrideLodscaleThisFrame(0.8)
    end,
    reset = function()
        for obj in GetWorldObjects() do
            if GetEntityAlpha(obj) ~= 255 then
                SetEntityAlpha(obj, 255)
            end
            Wait(0)
        end
        for obj in GetWorldPeds() do
            if GetEntityAlpha(obj) ~= 255 then
                SetEntityAlpha(obj, 255)
            end
            SetPedAoBlobRendering(obj, true)
            Wait(0)
        end
        for obj in GetWorldVehicles() do
            if GetEntityAlpha(obj) ~= 255 then
                SetEntityAlpha(obj, 255)
            end
            Wait(0)
        end
        OverrideLodscaleThisFrame(1.0)
        DisableVehicleDistantlights(false)
    end
}

local function runThreads(index)
    if Config.fpsBoosterTypes[index].isFpsThreadRunning then return end
    Config.fpsBoosterTypes[index].isFpsThreadRunning = true
    Config.fpsBoosterType = Config.fpsBoosterTypes[index].type
    CreateThread(function()
        local type = Config.fpsBoosterTypes[index].type
        while Config.fpsBoosterTypes[index].isFpsThreadRunning and Config.fpsBoosterType == type do
            Config.playerPedId = PlayerPedId()
            Config.playerCoords = GetEntityCoords(Config.playerPedId)
            Config.fpsSettings[type]()
            --Wait(0)
        end
        Config.fpsBoosterTypes[index].isFpsThreadRunning = false
    end)
    CreateThread(function()
        local type = Config.fpsBoosterTypes[index].type
        while Config.fpsBoosterTypes[index].isFpsThreadRunning and Config.fpsBoosterType == type do
            if type == "ulow" or type == "low" then
                ClearAllBrokenGlass()
                ClearAllHelpMessages()
                LeaderboardsReadClearAll()
                ClearBrief()
                ClearGpsFlags()
                ClearPrints()
                ClearSmallPrints()
                ClearReplayStats()
                LeaderboardsClearCacheData()
                ClearFocus()
                ClearHdArea()
                ClearPedBloodDamage(Config.playerPedId)
                ClearPedWetness(Config.playerPedId)
                ClearPedEnvDirt(Config.playerPedId)
                ResetPedVisibleDamage(Config.playerPedId)
                ClearOverrideWeather()
                ClearHdArea()
                DisableVehicleDistantlights(true)
                --DisableScreenblurFade()
                SetRainLevel(0.0)
                SetWindSpeed(0.0)
            elseif type == "medium" then
                ClearAllBrokenGlass()
                ClearAllHelpMessages()
                LeaderboardsReadClearAll()
                ClearBrief()
                ClearGpsFlags()
                ClearPrints()
                ClearSmallPrints()
                ClearReplayStats()
                LeaderboardsClearCacheData()
                ClearFocus()
                ClearHdArea()
                DisableVehicleDistantlights(false)
                SetWindSpeed(0.0)
            end
            Wait(2000)
        end
        Config.fpsBoosterTypes[index].isFpsThreadRunning = false
    end)
end

local function stopThreads()
    for index in pairs (Config.fpsBoosterTypes) do
        Config.fpsBoosterTypes[index].isFpsThreadRunning = false
    end
    Config.fpsBoosterType = nil
end

local function onFpsSettingChanged(shadow, air, entity, dynamic, tracker, depth, bounds, distance, tweak, sirens, lights)
    RopeDrawShadowEnabled(shadow)
    CascadeShadowsClearShadowSampleType()
    CascadeShadowsSetAircraftMode(air)
    CascadeShadowsEnableEntityTracker(entity)
    CascadeShadowsSetDynamicDepthMode(dynamic)
    CascadeShadowsSetEntityTrackerScale(tracker)
    CascadeShadowsSetDynamicDepthValue(depth)
    CascadeShadowsSetCascadeBoundsScale(bounds)
    SetFlashLightFadeDistance(distance)
    SetLightsCutoffDistanceTweak(tweak)
    DistantCopCarSirens(sirens)
    SetArtificialLightsState(lights)
end

function BoostFPS(index)
    if index then
        runThreads(index)
        if Config.fpsBoosterTypes[index].type == "ulow" then
            onFpsSettingChanged(false, false, true, false, 0.0, 0.0, 0.0, 0.0, 0.0, false, true)
        elseif Config.fpsBoosterTypes[index].type == "low" then
            onFpsSettingChanged(false, false, true, false, 0.0, 0.0, 0.0, 3.0, 3.0, false, true)
        elseif Config.fpsBoosterTypes[index].type == "medium" then
            onFpsSettingChanged(true, false, false, false, 5.0, 3.0, 5.0, 5.0, 5.0, false, false)
        end
    else -- Reset
        stopThreads()
        onFpsSettingChanged(true, true, false, true, 5.0, 5.0, 1.0, 10.0, 10.0, false, false)
        Config.fpsSettings["reset"]()
    end
end