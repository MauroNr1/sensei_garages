local garages = require 'data.garages'

function StoreVehicle(vehicle, garageId)
    if not vehicle then
        return lib.notify({
            id = 'garage_store_error',
            title = locale('garage_label'),
            description = locale('not_in_vehicle'),
            type = 'error'
        })
    end

    local garage = garages[garageId]

    if garage.type == 'impound' then
        return lib.notify({
            id = 'garage_store_error',
            title = locale('garage_label'),
            description = locale('no_storing_in_impound'),
            type = 'error'
        })
    end

    TaskLeaveVehicle(cache.ped, vehicle, 0)

    lib.waitFor(function()
        if GetVehiclePedIsIn(cache.ped, false) == 0 then return true end
    end, 'Player did not leave vehicle in time', 10000)

    local vehicleProperties = lib.getVehicleProperties(vehicle)

    local success, error = lib.callback.await('sensei_garages:storeVehicle', 5000, VehToNet(vehicle), garageId, {
        bodyHealth = vehicleProperties.bodyHealth,
        engineHealth = vehicleProperties.engineHealth,
        tankHealth = vehicleProperties.tankHealth,
        fuelLevel = vehicleProperties.fuelLevel,
        oilLevel = vehicleProperties.oilLevel,
        dirtLevel = vehicleProperties.dirtLevel,
        windows = vehicleProperties.windows,
        doors = vehicleProperties.doors,
        tyres = vehicleProperties.tyres
    })

    if success then
        lib.notify({
            id = 'garage_store_success',
            title = locale('garage_label'),
            description = locale('store_success'),
            type = 'success'
        })
    else
        lib.notify({
            id = 'garage_store_error',
            title = locale('garage_label'),
            description = locale(error) or locale('timeout'),
            type = 'error'
        })
    end
end
