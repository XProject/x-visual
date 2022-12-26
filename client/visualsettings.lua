CreateThread(function()
	local settingsFile = LoadResourceFile(GetCurrentResourceName(), "files/visualsettings.dat")
    print("here", settingsFile)
	local lines = stringsplit(settingsFile, "\n")
	for k, v in ipairs(lines) do
		if not starts_with(v, '#') and not starts_with(v, '//') and (v ~= "" or v ~= " ") and #v > 1 then
			v = v:gsub("%s+", " ")
			local setting = stringsplit(v, " ")
			if setting[1] and setting[2] and tonumber(setting[2]) ~= nil then
				if setting[1] ~= 'weather.CycleDuration' then
                    SetVisualSettingFloat(setting[1], tonumber(setting[2]) + 0.0)
				end
			end
		end
	end
end)