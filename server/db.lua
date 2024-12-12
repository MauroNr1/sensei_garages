local module = {}

function module.getVehiclesStored(stored, owner, group)
    if not stored then return end

    local query = 'SELECT `id`, `plate`, `model` FROM `vehicles` WHERE `stored` = ?'
    local params

    if owner and group then
        query = query .. ' AND `owner` = ? AND `group` = ?'
        params = {
            stored,
            owner,
            group
        }
    elseif owner then
        query = query .. ' AND `owner` = ?'
        params = {
            stored,
            owner
        }
    elseif group then
        query = query .. ' AND `group` = ?'
        params = {
            stored,
            group
        }
    else
        return
    end

    return MySQL.query.await(query, params)
end

function module.getVehicleOwnerAndGroup(dbId)
    if not dbId then return end

    return MySQL.single.await('SELECT `owner`, `group` FROM `vehicles` WHERE `id` = ? LIMIT 1', {
        dbId
    })
end

return module
