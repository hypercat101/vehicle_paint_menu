lib = lib or exports.ox_lib

local chameleonPresets = {
    { label = "Sunrise Glow",    r = 255, g = 94,  b = 77  },
    { label = "Minty Fresh",     r = 102, g = 255, b = 178 },
    { label = "Electric Purple", r = 179, g = 0,   b = 255 },
    { label = "Ocean Breeze",    r = 0,   g = 204, b = 255 },
    { label = "Galaxy Blue",     r = 25,  g = 25,  b = 112 },
    { label = "Sunset Orange",   r = 255, g = 140, b = 0   },
    { label = "Green Flip",      r = 50,  g = 205, b = 50  },
    { label = "Purple Haze",     r = 138, g = 43,  b = 226 },
}

local function openPaintMenu(vehicle)
    lib.registerContext({
        id    = 'paint_menu',
        title = '🎨 Paint Vehicle',
        options = {
            {
                title = 'Custom RGB Color',
                icon  = '🎨',
                onSelect = function()
                    local color = lib.inputDialog('Choose Color', {
                        { type = 'color', label = 'Custom Color', default = '#ffffff' }
                    })
                    if color and color[1] then
                        local r = tonumber('0x'..color[1]:sub(2,3))
                        local g = tonumber('0x'..color[1]:sub(4,5))
                        local b = tonumber('0x'..color[1]:sub(6,7))
                        SetVehicleCustomPrimaryColour(vehicle, r, g, b)
                        SetVehicleCustomSecondaryColour(vehicle, r, g, b)
                        TriggerServerEvent('paint:syncColor', VehToNet(vehicle), r, g, b)
                    end
                end
            },
            {
                title = 'Preset Colors',
                icon  = '🌈',
                description = 'Choose from custom presets',
                onSelect = function()
                    local options = {}
                    for _, preset in ipairs(chameleonPresets) do
                        options[#options+1] = {
                            title = preset.label,
                            onSelect = function()
                                SetVehicleCustomPrimaryColour(vehicle, preset.r, preset.g, preset.b)
                                SetVehicleCustomSecondaryColour(vehicle, preset.r, preset.g, preset.b)
                                TriggerServerEvent('paint:syncColor', VehToNet(vehicle), preset.r, preset.g, preset.b)
                            end
                        }
                    end

                    lib.registerContext({
                        id      = 'preset_menu',
                        title   = 'Preset Colors',
                        menu    = 'paint_menu',
                        options = options
                    })
                    lib.showContext('preset_menu')
                end
            }
        }
    })
    lib.showContext('paint_menu')
end

local function setupPaintTarget()
    exports.ox_target:addGlobalVehicle({
        {
            label = 'Paint Vehicle',
            icon  = 'fa-solid fa-spray-can',
            canInteract = function(entity)
                return DoesEntityExist(entity) and GetVehiclePedIsIn(cache.ped, false) == 0
            end,
            onSelect = function(data)
                openPaintMenu(data.entity)
            end
        }
    })
end

CreateThread(setupPaintTarget)

RegisterNetEvent('paint:applyColor', function(netId, r, g, b)
    local veh = NetToVeh(netId)
    if DoesEntityExist(veh) then
        SetVehicleCustomPrimaryColour(veh, r, g, b)
        SetVehicleCustomSecondaryColour(veh, r, g, b)
    end
end)
