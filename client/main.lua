local garages = require 'data.garages'
local utils = require 'client.utils'

local inZone = nil

local function updateTextUI(vehicle)
    if not inZone then return end

    local garage = garages[inZone]

    if vehicle and garage.type ~= 'impound' then
        lib.showTextUI(('**Store vehicle**  \nInteract with [%s]'):format(utils.getKeyNameForCommand(`+ox_lib-radial`)), {
            icon = 'fa-square-parking'
        })
    else
        lib.showTextUI(('**Retrieve vehicle**  \nInteract with [%s]'):format(utils.getKeyNameForCommand(`+ox_lib-radial`)), {
            icon = 'fa-square-parking'
        })
    end
end

local function onEnter(zone)
    inZone = zone.zoneId
    updateTextUI(cache.vehicle)
    lib.addRadialItem({
        id = 'garage_item',
        icon = 'square-parking',
        label = 'Garage',
        onSelect = function()
            local garage = garages[inZone]

            if cache.vehicle and garage.type ~= 'impound' then
                StoreVehicle(cache.vehicle, inZone)
            else
                OpenRetrieveMenu(inZone)
            end
        end
    })
end

local function onExit()
    inZone = nil
    lib.hideTextUI()
    lib.removeRadialItem('garage_item')
end

for i, v in pairs(garages) do
    lib.zones.poly({
        points = v.zone.points,
        thickness = v.zone.thickness,
        debug = false,
        zoneId = i,
        onEnter = onEnter,
        onExit = onExit
    })
end

lib.onCache('vehicle', updateTextUI)
