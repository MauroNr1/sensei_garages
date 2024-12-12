local garages = require 'data.garages'
local db = require 'server.db'

local function isPlayerInGroup(player, group)
    -- Todo: add support for ox_core group permissions here.
    return player.getGroup(group)
end

local function hasVehiclePermission(player, vehicle)
    if vehicle.owner and player.charId == vehicle.owner then
        return true
    end
    if vehicle.group and isPlayerInGroup(player, vehicle.group) then
        return true
    end
    return false
end

local function hasGaragePermission(player, garage)
    if garage.group and not isPlayerInGroup(player, garage.group) then
        return false
    end
    return true
end

local function hasPermission(player, vehicle, garage)
    return hasVehiclePermission(player, vehicle) and hasGaragePermission(player, garage)
end

lib.callback.register('sensei_garages:getVehiclesInGarage', function(source, garageId, params)
    local player = Ox.GetPlayer(source)
    local garage = garages[garageId]
    if not player or not garage then return false, 'wrong_args' end

    if not hasGaragePermission(player, garage) then return false, 'no_permission' end

    local response = db.getVehiclesStored(garage.type == 'impound' and 'impound' or garageId, params.owner and player.charId, params.group and garage.group)
    if not response then return false, 'db_error' end

    return true, response
end)

lib.callback.register('sensei_garages:storeVehicle', function(source, netId, garageId, vehicleProperties)
    local player = Ox.GetPlayer(source)
    local vehicle = Ox.GetVehicleFromNetId(netId)
    local garage = garages[garageId]
    if not player or not vehicle or not garage then return false, 'wrong_args' end

    if not hasPermission(player, vehicle, garage) then return false, 'no_permission' end

    local properties = vehicle.getProperties()
    properties.bodyHealth = vehicleProperties.bodyHealth
    properties.engineHealth = vehicleProperties.engineHealth
    properties.tankHealth = vehicleProperties.tankHealth
    properties.fuelLevel = vehicleProperties.fuelLevel
    properties.oilLevel = vehicleProperties.oilLevel
    properties.dirtLevel = vehicleProperties.dirtLevel
    properties.windows = vehicleProperties.windows
    properties.doors = vehicleProperties.doors
    properties.tyres = vehicleProperties.tyres

    vehicle.setProperties(properties, false)
    vehicle.setStored(garageId, true)
    return true
end)

lib.callback.register('sensei_garages:spawnVehicle', function(source, data)
    local player = Ox.GetPlayer(source)
    local garage = garages[data.garageId]
    local spawnCoords = garage?.spots[data.spawnIndex]
    if not player or not garage or not spawnCoords then return false, 'wrong_args' end

    local response = db.getVehicleOwnerAndGroup(data.dbId)
    if not response then return false, 'vehicle_not_found' end
    if not hasPermission(player, response, garage) then return false, 'no_permission' end

    local vehicle = Ox.SpawnVehicle(data.dbId, spawnCoords.xyz, spawnCoords.w)
    if not vehicle then return false, 'spawn_error' end

    return true
end)
