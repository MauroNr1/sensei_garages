local garages = require 'data.garages'
local utils = require 'client.utils'

function RetrieveVehicle(data)
    local garage = garages[data.garageId]

    local spawnIndex = utils.getClosestVacantCoord(garage.spots)
    if not spawnIndex then
        return lib.notify({
            id = 'garage_retrieve_error',
            title = 'Garage',
            description = 'There are no available parking spots.',
            type = 'error'
        })
    end

    local success, error = lib.callback.await('sensei_garages:spawnVehicle', 5000, {
        dbId = data.dbId,
        garageId = data.garageId,
        spawnIndex = spawnIndex
    })

    if success then
        lib.notify({
            id = 'garage_retrieve_success',
            title = locale('garage_label'),
            description = locale('retrieve_success'),
            type = 'success'
        })
    else
        lib.notify({
            id = 'garage_retrieve_error',
            title = locale('garage_label'),
            description = locale(error) or locale('timeout'),
            type = 'error'
        })
    end
end

local function generateOptions(vehicles, garageId)
    local options = {}

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
        local vehicleData = Ox.GetVehicleData(vehicle.model)

        options[#options + 1] = {
            title = utils.getVehicleFullName(vehicleData.name, vehicleData.make),
            description = locale('vehicle_plate', vehicle.plate),
            icon = ('https://docs.fivem.net/vehicles/%s.webp'):format(vehicle.model),
            onSelect = RetrieveVehicle,
            args = {
                dbId = vehicle.id,
                garageId = garageId
            },
            arrow = true,
            metadata = {
                {
                    label = locale('vehicle_doors'),
                    value = vehicleData.doors
                },
                {
                    label = locale('vehicle_seats'),
                    value = vehicleData.seats
                }
            }
        }
    end

    return options
end

function OpenRetrieveMenu(garageId)
    local garage = garages[garageId]
    local params = {}
    params.owner = true

    local success, data = lib.callback.await('sensei_garages:getVehiclesInGarage', 2000, garageId, params)

    if success then
        if #data == 0 then
            return lib.notify({
                id = 'garage_retrieve_info',
                title = locale('garage_label'),
                description = locale("no_owned_vehicles"),
                type = 'inform'
            })
        end

        lib.registerContext({
            id = 'garage_menu',
            title = garage.label,
            options = generateOptions(data, garageId),
            menu = garage.group and 'garage_type'
        })
        lib.showContext('garage_menu')
    else
        lib.notify({
            id = 'garage_retrieve_error',
            title = locale('garage_label'),
            description = locale(data) or locale('timeout'),
            type = 'error'
        })
    end
end
