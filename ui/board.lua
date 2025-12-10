---@return Board
return function()
    ---@class Board
    ---@field cell_size number Size of each cell
    local self = {}

    self.cell_size = 60

    ---Takes an X and Y value and returns the corresponding CellPos
    ---@param x integer
    ---@param y integer
    ---@return [integer, integer]
    local function XYtoCellPos(x, y)
        local b = math.ceil(x / 3) + 3 * (math.ceil(y / 3) - 1)
        local c = ((x - 1) % 3) + 1 + 3 * (y - 1) % 3
        return { b, c }
    end

    ---Draw this board to the screen
    ---@param gameState GameState
    self.draw = function(gameState)
        for y = 0, 8 do
            for x = 0, 8 do
                local cellPos = XYtoCellPos(x + 1, y + 1)
                local owner = gameState.getCellOwner(cellPos)
                local color = owner == 1 and { 1, 0, 0 }
                    or (owner == 2 and { 0, 1, 0 })
                    or { 0, 0, 1 }
                love.graphics.setColor(color)
                love.graphics.rectangle(
                    'fill',
                    x * self.cell_size,
                    y * self.cell_size,
                    self.cell_size,
                    self.cell_size
                )
            end
        end
    end
    return self
end
