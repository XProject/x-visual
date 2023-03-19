Config.fpsBoosterTypes = {
    [1] = { type = "ulow", name = "Ultra Low", distance = { world = 90, ped = 60, vehicle = 120 }, alpha = { world = 210, ped = 245, vehicle = 255 } },
    [2] = { type = "low", name = "Low", distance = { world = 130, ped = 100, vehicle = 160 }, alpha = { world = 210, ped = 250, vehicle = 255 } },
    [3] = { type = "medium", name = "Medium", distance = { world = 200, ped = 150, vehicle = 250 }, alpha = { world = 245, ped = 255, vehicle = 255 } }
}

Config.visualTimecycles = {
    [1] = { name = "Tunnel (FPS Boost)", modifier = "yell_tunnel_nodirect", icon = "💯" },
    [2] = { name = "Cinema (FPS Boost)", modifier = "cinema", icon = "🎥" },
    [3] = { name = "Life (FPS Boost)", modifier = "LifeInvaderLOD" },
    [4] = { name = "Reduce Distance (FPS Boost)", modifier = "ReduceDrawDistanceMission", icon = "⬇" },
    [5] = { name = "Color Saturation", modifier = "rply_saturation", icon = "✨" },
    [6] = { name = "Graphic Changer", modifier = "MP_Powerplay_blend", extraModifier = "reflection_correct_ambient" },
    [7] = { name = "Improved Lights", modifier = "tunnel" }
}

Config.vehicleLightsSetting = {
    defaultlight = {
        day = { name = "Default Lights (Day)", defaultValue = 2, min = 0, max = 10000 },
        night = { name = "Default Lights (Night)", defaultValue = 2, min = 0, max = 10000 }
    },
    headlight = {
        day = { name = "Headlights (Day)", defaultValue = 10, min = 0, max = 10000 },
        night = { name = "Headlights (Night)", defaultValue = 10, min = 0, max = 10000 }
    },
    taillight = {
        day = { name = "Taillights (Day)", defaultValue = 25, min = 0, max = 10000 },
        night = { name = "Taillights (Night)", defaultValue = 25, min = 0, max = 10000 }
    },
    indicator = {
        day = { name = "Indicators (Day)", defaultValue = 10, min = 0, max = 10000 },
        night = { name = "Indicators (Night)", defaultValue = 10, min = 0, max = 10000 }
    },
    reversinglight = {
        day = { name = "Reverse Lights (Day)", defaultValue = 20, min = 0, max = 10000 },
        night = { name = "Reverse Lights (Night)", defaultValue = 3, min = 0, max = 10000 }
    },
    brakelight = {
        day = { name = "Brake Lights (Day)", defaultValue = 30, min = 0, max = 10000 },
        night = { name = "Brake Lights (Night)", defaultValue = 30, min = 0, max = 10000 }
    },
    middlebrakelight = {
        day = { name = "Middle Brake Lights (Day)", defaultValue = 30, min = 0, max = 10000 },
        night = { name = "Middle Brake Lights (Night)", defaultValue = 30, min = 0, max = 10000 }
    },
    extralight = {
        day = { name = "Extra Lights (Day)", defaultValue = 9, min = 0, max = 10000 },
        night = { name = "Extra Lights (Night)", defaultValue = 9, min = 0, max = 10000 }
    }
}

TriggerEvent("chat:addSuggestion", "/"..Config.Command, "helps players to modify their visuals and fps")

RegisterCommand(Config.Command, function()
    if Config.Menu == "ox_lib" and lib then
        lib.showMenu(Config.mainMenu)
    elseif Config.Menu == "menuv" and MenuV then
        MenuV:OpenMenu(Config.mainMenu)
    end
end, false)