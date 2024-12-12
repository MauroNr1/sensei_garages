local module = {}

function module.getClosestVacantCoord(coordsArray)
    local playerCoords = GetEntityCoords(cache.ped)

    local closest = {
        distance = 1000,
        index = nil
    }

    for i = 1, #coordsArray do
        local tempCoords = coordsArray[i].xyz
        local tempDistance = #(playerCoords - tempCoords)

        if closest.distance > tempDistance and #lib.getNearbyVehicles(tempCoords, 4.0, true) == 0 and #lib.getNearbyPlayers(tempCoords, 4.0, true) == 0 then
            closest.distance = tempDistance
            closest.index = i
        end
    end

    return closest.index or false
end

function module.getKeyNameForCommand(command)
    local key = GetControlInstructionalButton(0, command | 0x80000000, true)

    if string.find(key, 't_') then
        local label = string.gsub(key, 't_', '')
        return label
    else
        return '?'
    end
end

function module.getVehicleFullName(name, make)
    if name and make then
        return ('%s %s'):format(make, name)
    elseif name then
        return name
    elseif make then
        return make
    end
    return locale('unknown_vehicle')
end

return module
