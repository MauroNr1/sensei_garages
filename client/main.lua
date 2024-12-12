local garages = require 'data.garages'
local utils = require 'modules.utils'

local inZone = nil

local function updateTextUI(vehicle)
    if not inZone then return end

    lib.showTextUI((vehicle and '**Store vehicle**  \nInteract with [%s]' or '**Retrieve vehicle**  \nInteract with [%s]'):format(utils.getKeyNameForCommand(`+ox_lib-radial`)), {
        icon = 'fa-square-parking'
    })
end

local function onEnter(zone)
    inZone = zone.zoneId
    updateTextUI(cache.vehicle)
    lib.addRadialItem({
        id = 'garage_item',
        icon = 'square-parking',
        label = 'Garage',
        onSelect = function()
            if cache.vehicle then
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