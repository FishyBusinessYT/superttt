WINHEIGHT = 900
WINWIDTH = 900

function love.load()
    love.window.setMode(WINHEIGHT, WINWIDTH, { fullscreen = false })
end

local cell_size = 60
local tiles = { 1, 2, 1, 1, 1, 1, 0, 0, 0, 2, 0, 0, 2, 1, 2, 2, 2, 1 }

function love.draw()
    local tile = 1
    for y = 0, 9 do
        for x = 0, 9 do
            local color = (tiles[tile] == 1 and { 1, 0, 0 })
                or (tiles[tile] == 2 and { 0, 1, 0 })
                or { 0, 0, 1 }
            love.graphics.setColor(color)
            love.graphics.rectangle(
                'fill',
                x * cell_size,
                y * cell_size,
                cell_size,
                cell_size
            )
            tile = tile + 1
        end
    end
end
