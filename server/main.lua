local garages = require 'data.garages'
local db = require 'server.db'

local function isPlayerInGroup(player, group)
    -- Todo: add support for ox_core group permissions here.
    return player.getGroup(group)
end

local function hasVehiclePermission(player, vehicle)
    if vehicle.owner and player.charId ~= vehicle.owner then
        return false
    end
    if vehicle.group and not isPlayerInGroup(player, vehicle.group) then
        return false
    end
    return true
end

lib.callback.register('sensei_garages:getVehiclesInGarage', function(source, garageId, params)
    local player = Ox.GetPlayer(source)
    local garage = garages[garageId]
    if not player or not garage then return false, 'wrong_args' end

    if params.group and not isPlayerInGroup(player, params.group) then return false, 'no_permission' end

    local response = db.getVehiclesStored(garageId, params.owner and player.charId)
    if not response then return false, 'db_error' end

    return true, response
end)

lib.callback.register('sensei_garages:storeVehicle', function(source, netId, garageId)
    local player = Ox.GetPlayer(source)
    local vehicle = Ox.GetVehicleFromNetId(netId)
    local garage = garages[garageId]
    if not player or not vehicle or not garage then return false, 'wrong_args' end

    if not hasVehiclePermission(player, vehicle) then return false, 'no_permission' end

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
    if not hasVehiclePermission(player, response) then return false, 'no_permission' end

    local vehicle = Ox.SpawnVehicle(data.dbId, spawnCoords.xyz, spawnCoords.w)
    if not vehicle then return false, 'spawn_error' end

    return true
end)