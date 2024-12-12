local config = require 'data.config'
if not config.enableCreator then return end

local savedCoords = '{\t\n'

lib.addKeybind({
    name = 'garage_coords',
    description = 'save location to clipboard',
    defaultKey = 'E',
    onPressed = function()
        local coords = GetEntityCoords(cache.vehicle)

        savedCoords = savedCoords .. ('vec4(%s, %s, %s, %s),\t\n'):format(coords.x, coords.y, coords.z, GetEntityHeading(cache.vehicle))

        lib.setClipboard(savedCoords .. '\t\n}')
    end
})
