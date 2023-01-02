if Config.Menu == "ox_lib" then
    if lib then
        Config.mainMenu = "x-visual_main_menu"
        Config.fpsMenu = "x-visual_fps_menu"
        Config.visualMenu = "x-visual_visual_menu"
        Config.lightsMenu = "x-visual_light_menu"
        Config.dayLightsMenu = "x-visual_day_light_menu"
        Config.nightLightsMenu = "x-visual_night_light_menu"

        local function goBack(keyPressed, menuToGoBack)
            if keyPressed and keyPressed == "Backspace" then
                if not menuToGoBack then menuToGoBack = Config.mainMenu end
                lib.showMenu(menuToGoBack)
            end
        end
        -- Main Menu
        lib.registerMenu({
            id = Config.mainMenu,
            title = "X-VISUAL",
            position = "top-right",
            options = {
                { label = "🆙 FPS Booster Menu", args = { menu = Config.fpsMenu } },
                { label = "👓 Visual Modifier Menu", args = { menu = Config.visualMenu } },
                { label = "💡 Vehicle Lights Menu", args = { menu = Config.lightsMenu } }
            }
        },
        function(_, _, args)
            if args.menu then
                lib.showMenu(args.menu)
            end
        end)
        
        -- FPS Booster Menu
        local function setUpFpsBoosterButtons()
            local options = {}
            for index = 1, #Config.fpsBoosterTypes do
                table.insert(options,{
                    label = (Config.fpsBoosterTypes[index].icon or "❇").." "..Config.fpsBoosterTypes[index].name,
                    description = Config.fpsBoosterTypes[index].description,
                    args = { onClick = function()
                        BoostFPS(index)
                    end },
                    close = false
                })
            end
            table.insert(options,{
                label = "🔁 Reset",
                args = { onClick = function()
                    BoostFPS()
                end },
                close = false
            })
            return options
        end
        lib.registerMenu({
            id = Config.fpsMenu,
            title = "FPS Booster Menu",
            position = "top-right",
            options = setUpFpsBoosterButtons(),
            onClose = goBack
        },
        function(_, _, args)
            if args.onClick then
                args.onClick()
            end
        end)

        -- Visual Modifier Menu
        local function setUpVisualTimecycleMenuButtons()
            local options = {}
            for index = 1, #Config.visualTimecycles do
                table.insert(options, {
                    label = (Config.visualTimecycles[index].icon or "❇").." "..Config.visualTimecycles[index].name,
                    args = { onClick = function()
                        ModifyVisuals(index)
                    end },
                    close = false
                })
            end
            table.insert(options, {
                label = "🔁 Reset",
                args = { onClick = function()
                    ModifyVisuals()
                end },
                close = false
            })
            return options
        end
        lib.registerMenu({
            id = Config.visualMenu,
            title = "Visual Modifier Menu",
            position = "top-right",
            options = setUpVisualTimecycleMenuButtons(),
            onClose = goBack,
        },
        function(_, _, args)
            if args.onClick then
                args.onClick()
            end
        end)

        -- Vehicle Lights Menu
        Config.multiplier = 1
        local onLightSettingChanged -- forward declaration of local function to be known to generateLightButton function
        local registerDayLightMenu, registerNightLightMenu -- forward declaration of local function to be known to other functions
        local function calculateLightProgress(light)
            local max = light.max / Config.multiplier
            local value = (light.modifiedValue or light.defaultValue) / Config.multiplier
            return (value * 100) / max
        end
        local function generateLightButton(light, settingName, time)
            return {
                label = "💡 "..light.name,
                progress = calculateLightProgress(light),
                args = { onClick = function(selected)
                    Config.openMenu = lib.getOpenMenu()
                    lib.hideMenu()
                    local input = lib.inputDialog("X-VISUAL", {
                        { type = "slider", label = light.name, default = (light.modifiedValue or light.defaultValue) / Config.multiplier, min = light.min, max = light.max / Config.multiplier }
                    })
                    if input then
                        onLightSettingChanged(light, input[1], settingName, time, selected, Config.openMenu)
                    end
                    lib.showMenu(Config.openMenu)
                    Config.openMenu = nil
                    input = nil
                end },
                close = false
            }
        end
        function onLightSettingChanged(light, newValue, settingName, time, selectedOption, menuToSet)
            light.modifiedValue = newValue * Config.multiplier
            SetVisualSettingFloat(("car.%s.%s.emissive.on"):format(settingName, time), light.modifiedValue + 0.0)
            lib.setMenuOptions(menuToSet, generateLightButton(light, settingName, time), selectedOption)
        end
        local function setUpLightMenuButtons(timeToSet)
            local options = {}
            for name, v in pairs(Config.vehicleLightsSetting) do
                for time, light in pairs(v) do
                    if time == timeToSet then
                        table.insert(options, generateLightButton(light, name, time))
                    end
                end
            end
            return options
        end
        lib.registerMenu({
            id = Config.lightsMenu,
            title = "Vehicle Lights Menu",
            position = "top-right",
            options = {
                { label = "💡 Vehicle Lights Menu (DAY)", args = { menu = Config.dayLightsMenu } },
                { label = "💡 Vehicle Lights Menu (NIGHT)", args = { menu = Config.nightLightsMenu } },
                { label = "Ⓜ Multiplier", values = { "1x", "10x", "100x", "1000x" }, defaultIndex = Config.multiplier, close = false },
                { label = "💾 Apply Saved Lights Settings", args = { onClick = function()
                    ApplySavedLightConfigurations()
                    registerDayLightMenu()
                    registerNightLightMenu()
                end }, close = false },
                { label = "💾 Save Lights Settings", args = { onClick = function() SaveLightConfigurations() end }, close = false },
            },
            onClose = goBack,
            onSideScroll = function(selected, scrollIndex, _)
                if scrollIndex == 1 then
                    Config.multiplier = 1
                elseif scrollIndex == 2 then
                    Config.multiplier = 10
                elseif scrollIndex == 3 then
                    Config.multiplier = 100
                elseif scrollIndex == 4 then
                    Config.multiplier = 1000
                end
                lib.setMenuOptions(Config.lightsMenu, { label = "Ⓜ Multiplier", values = { "1x", "10x", "100x", "1000x" }, defaultIndex = scrollIndex, close = false }, selected)
            end,
        },
        function(_, _, args)
            if args then
                if args.menu then
                    lib.showMenu(args.menu)
                elseif args.onClick then
                    args.onClick()
                end
            end
        end)
        function registerDayLightMenu()
            lib.registerMenu({
                id = Config.dayLightsMenu,
                title = "Vehicle Lights Menu (DAY)",
                position = "top-right",
                options = setUpLightMenuButtons("day"),
                onClose = function(keyPressed)
                    goBack(keyPressed, Config.lightsMenu)
                end
            },
            function(selected, _, args)
                if args and args.onClick then
                    args.onClick(selected)
                end
            end)
        end
        do registerDayLightMenu() end
        function registerNightLightMenu()
            lib.registerMenu({
                id = Config.nightLightsMenu,
                title = "Vehicle Lights Menu (NIGHT)",
                position = "top-right",
                options = setUpLightMenuButtons("night"),
                onClose = function(keyPressed)
                    goBack(keyPressed, Config.lightsMenu)
                end
            },
            function(selected, _, args)
                if args and args.onClick then
                    args.onClick(selected)
                end
            end)
        end
        do registerNightLightMenu() end
    else
        error("Error: ox_lib resource is not properly loaded inside x-visual!")
    end
end