function StoreVehicle(vehicle, garageId)
    if not vehicle then
        return lib.notify({
            title = 'Garage',
            description = 'You are not in a vehicle.',
            type = 'error'
        })
    end

    TaskLeaveVehicle(cache.ped, vehicle, 0)

    lib.waitFor(function()
        if GetVehiclePedIsIn(cache.ped, false) == 0 then return true end
    end, 'Player did not leave vehicle', 10000)

    local success, error = lib.callback.await('sensei_garages:storeVehicle', 5000, VehToNet(vehicle), garageId)

    if success then
        lib.notify({
            id = 'garage_store_success',
            title = 'Garage',
            description = 'Your vehicle is now stored in this garage.',
            type = 'success'
        })
    else
        lib.notify({
            id = 'garage_store_error',
            title = 'Garage',
            description = error or 'Please wait a few second before trying to store another vehicle',
            type = 'error'
        })
    end
end
