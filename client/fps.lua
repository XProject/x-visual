local Client = {
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

if Config.Menu == "ox_lib" then
    if lib then
        Config.fpsMenu = "x-fps_main_menu"
    else
        error("Error: ox_lib resource is not properly loaded inside x-fps!")
    end
elseif Config.Menu == "menuv" then
    if MenuV then
        local multiplier = 1
        Config.fpsMenu = MenuV:CreateMenu("X-FPS", "FPS Menu", "centerright", 31, 255, 34, "size-150", "default", "menuv", "X-FPS_main_menu", "default")
        Config.lightsMenu = MenuV:CreateMenu("X-FPS", "Vehicle Lights Menu", "centerright", 31, 255, 34, "size-150", "default", "menuv", "X-FPS_light_menu", "default")
        Config.dayLightsMenu = MenuV:CreateMenu("X-FPS", "Vehicle Lights Menu (DAY)", "centerright", 31, 255, 34, "size-150", "default", "menuv", "X-FPS_day_light_menu", "default")
        Config.nightLightsMenu = MenuV:CreateMenu("X-FPS", "Vehicle Lights Menu (NIGHT)", "centerright", 31, 255, 34, "size-150", "default", "menuv", "X-FPS_night_light_menu", "default")

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
        Config.lightsMenu:On("open", function(menu)
            menu:ClearItems()
            multiplier = 1
            Config.lightsMenu:AddButton({ icon = "💡", label = "Vehicle Lights Menu (DAY)", value = Config.dayLightsMenu })
            Config.lightsMenu:AddButton({ icon = "💡", label = "Vehicle Lights Menu (NIGHT)", value = Config.nightLightsMenu })
            Config.multiplierSlider = Config.lightsMenu:AddSlider({ icon = 'Ⓜ', label = 'Multiplier', value = multiplier, values = {
                { label = '1x', value = 1 },
                { label = '10x', value = 10 },
                { label = '100x', value = 100 },
                { label = '1000x', value = 1000 }
            }})
            Config.multiplierSlider:On('change', function(item, newValue, _) multiplier = item.Values[newValue].Value end)
        end)

        local function setUpLightMenuButtons(menuToSet, timeToSet)
            for name, v in pairs(Client) do
                for time, light in pairs(v) do
                    if time == timeToSet then
                        light.handler = menuToSet:AddRange({ icon = "💡", label = light.name, min = light.min, max = light.max / multiplier, value = (light.modifiedValue or light.defaultValue) / multiplier, saveOnUpdate = false })
                        light.handler:On("change", function(_, newValue, _)
                            light.modifiedValue = newValue * multiplier
                            SetVisualSettingFloat(("car.%s.%s.emissive.on"):format(name, time), light.modifiedValue + 0.0)
                        end)
                    end
                end
            end
        end

        Config.dayLightsMenu:On("open", function(menu)
            menu:ClearItems()
            setUpLightMenuButtons(Config.dayLightsMenu, "day")
        end)
        Config.nightLightsMenu:On("open", function(menu)
            menu:ClearItems()
            setUpLightMenuButtons(Config.nightLightsMenu, "night")
        end)
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