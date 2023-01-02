function ModifyVisuals(index)
    if index then
        ClearTimecycleModifier()
        ClearExtraTimecycleModifier()
        SetTimecycleModifier(Config.visualTimecycles[index].modifier)
        if Config.visualTimecycles[index].extraModifier then SetExtraTimecycleModifier(Config.visualTimecycles[index].extraModifier) end
    else
        ClearTimecycleModifier()
        ClearExtraTimecycleModifier()
        SetTimecycleModifier()
        ClearTimecycleModifier()
        ClearExtraTimecycleModifier()
    end
end