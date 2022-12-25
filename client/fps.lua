Client = {
    defaultlight = {
        day = { name = "Vehicle Default Lights (Day)", defaultValue = 2, min = 0, max = 10000 },
        night = { name = "Vehicle Default Lights (Night)", defaultValue = 2, min = 0, max = 10000 }
    },
    headlight = {
        day = { name = "Vehicle Headlights (Day)", defaultValue = 10, min = 0, max = 10000 },
        night = { name = "Vehicle Headlights (Night)", defaultValue = 10, min = 0, max = 10000 }
    },
    taillight = {
        day = { name = "Vehicle Taillights (Day)", defaultValue = 25, min = 0, max = 10000 },
        night = { name = "Vehicle Taillights (Night)", defaultValue = 25, min = 0, max = 10000 }
    },
    indicator = {
        day = { name = "Vehicle Indicators (Day)", defaultValue = 10, min = 0, max = 10000 },
        night = { name = "Vehicle Indicators (Night)", defaultValue = 10, min = 0, max = 10000 }
    },
    reversinglight = {
        day = { name = "Vehicle Reverse Lights (Day)", defaultValue = 20, min = 0, max = 10000 },
        night = { name = "Vehicle Reverse Lights (Night)", defaultValue = 3, min = 0, max = 10000 }
    },
    brakelight = {
        day = { name = "Vehicle Brake Lights (Day)", defaultValue = 30, min = 0, max = 10000 },
        night = { name = "Vehicle Brake Lights (Night)", defaultValue = 30, min = 0, max = 10000 }
    },
    middlebrakelight = {
        day = { name = "Vehicle Middle Brake Lights (Day)", defaultValue = 30, min = 0, max = 10000 },
        night = { name = "Vehicle Middle Brake Lights (Night)", defaultValue = 30, min = 0, max = 10000 }
    },
    extralight = {
        day = { name = "Vehicle Extra Lights (Day)", defaultValue = 9, min = 0, max = 10000 },
        night = { name = "Vehicle Extra Lights (Night)", defaultValue = 9, min = 0, max = 10000 }
    }
}
if Config.Menu == "ox_lib" then
    if lib then
        Config.fpsMenu = "x-fps_main_menu"
    else
        error("Error: ox_lib resource is not properly loaded inside x-fps!")
    end
elseif Config.Menu == "menuv" then
    if MenuV then
        Config.fpsMenu = MenuV:CreateMenu("X-FPS", "FPS Menu", "centerright", 31, 255, 34, "size-125", "x-fps", "menuv", "FPS-Menu", "x-fps_namespace")
        Config.lightsMenu = MenuV:CreateMenu("X-FPS", "Vehicle Lights Menu", "centerright", 31, 255, 34, "size-125", "x-fps", "menuv", "FPS-Menu", "x-fps_namespace")

        Config.fpsMenu:AddButton({ icon = "✅", label = "FPS Boost", value = "", select = function()
            ClearTimecycleModifier()
            ClearExtraTimecycleModifier()
            SetTimecycleModifier("yell_tunnel_nodirect")
        end })

        Config.fpsMenu:AddButton({ icon = "✅", label = "Cinema Mode", value = "", select = function()
            ClearTimecycleModifier()
            ClearExtraTimecycleModifier()
            SetTimecycleModifier("cinema")
        end })

        Config.fpsMenu:AddButton({ icon = "✅", label = "Reset", value = "", select = function()
            ClearTimecycleModifier()
            ClearExtraTimecycleModifier()
            SetTimecycleModifier()
            ClearTimecycleModifier()
            ClearExtraTimecycleModifier()
        end })
        
        Config.fpsMenu:AddButton({ icon = "💡", label = "Vehicle Lights Menu", value = Config.lightsMenu })

        for name, v in pairs(Client) do
            for time, light in pairs(v) do
                light.handler = Config.lightsMenu:AddRange({ icon = "💡", label = light.name, min = light.min, max = light.max, value = light.defaultValue, saveOnUpdate = true })
                light.handler:On("change", function(_, newValue, _)
                    SetVisualSettingFloat(("car.%s.%s.emissive.on"):format(name, time), newValue + 0.0)
                end)
            end
        end
    else
        error("Error: MenuV resource is not properly loaded inside x-fps!")
    end
end

TriggerEvent("chat:addSuggestion", "/"..Config.Command, "helps players to increase their fps by modifying visuals")

RegisterCommand(Config.Command, function()
    if Config.Menu == "ox_lib" and lib then
        lib.showMenu(Config.fpsMenu)
    elseif Config.Menu == "menuv" and MenuV then
        MenuV:OpenMenu(Config.fpsMenu)
    end
end)