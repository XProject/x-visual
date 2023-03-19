function SaveLightConfigurations()
    local savedConfigurations = {}
    for name, v in pairs(Config.vehicleLightsSetting) do
        savedConfigurations[name] = {}
        for time, light in pairs(v) do
            if light.modifiedValue then
                savedConfigurations[name][time] = light.modifiedValue
            end
        end
    end
    TriggerServerEvent(Shared.netEventName, savedConfigurations)
    Shared.notification(nil, "Lights Configurations Saved", "success")
end

function ApplySavedLightConfigurations()
    local savedConfigurations = LocalPlayer.state[Shared.stateBagName]
    if not savedConfigurations then return Shared.notification(nil, "No Saved Lights Configurations Exists!", "error") end
    for name, v in pairs(Config.vehicleLightsSetting) do
        if savedConfigurations[name] then
            for time, light in pairs(v) do
                light.modifiedValue = savedConfigurations[name][time]
                if light.modifiedValue then
                    SetVisualSettingFloat(("car.%s.%s.emissive.on"):format(name, time), light.modifiedValue + 0.0)
                end
            end
        end
    end
    Shared.notification(nil, "Saved Lights Configurations Applied", "success")
end