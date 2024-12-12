local garages = require 'data.garages'
local utils = require 'client.utils'

function RetrieveVehicle(data)
    local garage = garages[data.garageId]

    local spawnIndex = utils.getClosestVacantCoord(garage.spots)
    if not spawnIndex then return lib.notify({
        id = 'garage_retrieve_error',
        title = 'Garage',
        description = 'There are no available parking spots.',
        type = 'error'
    }) end

    local success, error = lib.callback.await('sensei_garages:spawnVehicle', 5000, {
        dbId = data.dbId,
        garageId = data.garageId,
        spawnIndex = spawnIndex
    })

    if success then
        lib.notify({
            id = 'garage_retrieve_success',
            title = 'Garage',
            description = 'Your vehicle has been retrieved.',
            type = 'success'
        })
    else
        lib.notify({
            id = 'garage_retrieve_error',
            title = 'Garage',
            description = error or 'Please wait a few seconds before trying to retrieve another vehicle.',
            type = 'error'
        })
    end
end

local function generateOptions(vehicles, garageId)
    local options = {}

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        local vehicleData = Ox.GetVehicleData(vehicle.model)

        options[#options+1] = {
            title = utils.getVehicleFullName(vehicleData.name, vehicleData.make),
            description = ('Plate: %s'):format(vehicle.plate),
            icon = ('https://docs.fivem.net/vehicles/%s.webp'):format(vehicle.model),
            onSelect = RetrieveVehicle,
            args = {
                dbId = vehicle.id,
                garageId = garageId
            },
            arrow = true,
            metadata = {
                {
                    label = 'Doors',
                    value = vehicleData.doors
                },
                {
                    label = 'Seats',
                    value = vehicleData.seats
                }
            }
        }
    end

    return options
end

function OpenRetrieveMenu(garageId)
    local success, data = lib.callback.await('sensei_garages:getVehiclesInGarage', 2000, garageId, {
        owner = true
    })

    if success then
        local garage = garages[garageId]

        if #data == 0 then return lib.notify({
            id = 'garage_retrieve_info',
            title = 'Garage',
            description = 'There are no owned vehicles in this garage.',
            type = 'inform'
        }) end

        lib.registerContext({
            id = 'garage_menu',
            title = garage.label,
            options = generateOptions(data, garageId)
        })
        lib.showContext('garage_menu')
    else
        lib.notify({
            id = 'garage_retrieve_error',
            title = 'Garage',
            description = data or 'Please wait a few seconds before trying to retrieve another vehicle.',
            type = 'error'
        })
    end
end